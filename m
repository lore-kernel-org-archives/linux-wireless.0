Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3163 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab2FNKRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 06:17:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 5/5] brcmfmac: introduce checkdied debugfs
 functionality
Date: Thu, 14 Jun 2012 12:16:57 +0200
Message-ID: <1339669017-13388-1-git-send-email-arend@broadcom.com> (sfid-20120614_121715_136621_72DF2343)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The checkdied functionality provides useful information for analyzing
firmware crashes. By exposing this information to a debugfs file users
can easily provide its content in bug reports. The functionality is
available only when CONFIG_BRCMDBG is selected.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
This patch changes kzalloc() to vzalloc(). This replaces patch with
message-id <1339275105-3593-6-git-send-email-arend@broadcom.com>.

All 5 patches apply to latest wireless-next/master branch.
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  332 +++++++++++++++++++-
 1 file changed, 331 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a07fb01..9971e13 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -31,6 +31,7 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/bcma/bcma.h>
+#include <linux/debugfs.h>
 #include <asm/unaligned.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
@@ -48,6 +49,9 @@
 
 #define CBUF_LEN	(128)
 
+/* Device console log buffer state */
+#define CONSOLE_BUFFER_MAX	2024
+
 struct rte_log_le {
 	__le32 buf;		/* Can't be pointer on (64-bit) hosts */
 	__le32 buf_size;
@@ -281,7 +285,7 @@ struct rte_console {
  * Shared structure between dongle and the host.
  * The structure contains pointers to trap or assert information.
  */
-#define SDPCM_SHARED_VERSION       0x0002
+#define SDPCM_SHARED_VERSION       0x0003
 #define SDPCM_SHARED_VERSION_MASK  0x00FF
 #define SDPCM_SHARED_ASSERT_BUILT  0x0100
 #define SDPCM_SHARED_ASSERT        0x0200
@@ -428,6 +432,29 @@ struct brcmf_console {
 	u8 *buf;		/* Log buffer (host copy) */
 	uint last;		/* Last buffer read index */
 };
+
+struct brcmf_trap_info {
+	__le32		type;
+	__le32		epc;
+	__le32		cpsr;
+	__le32		spsr;
+	__le32		r0;	/* a1 */
+	__le32		r1;	/* a2 */
+	__le32		r2;	/* a3 */
+	__le32		r3;	/* a4 */
+	__le32		r4;	/* v1 */
+	__le32		r5;	/* v2 */
+	__le32		r6;	/* v3 */
+	__le32		r7;	/* v4 */
+	__le32		r8;	/* v5 */
+	__le32		r9;	/* sb/v6 */
+	__le32		r10;	/* sl/v7 */
+	__le32		r11;	/* fp/v8 */
+	__le32		r12;	/* ip */
+	__le32		r13;	/* sp */
+	__le32		r14;	/* lr */
+	__le32		pc;	/* r15 */
+};
 #endif				/* DEBUG */
 
 struct sdpcm_shared {
@@ -439,6 +466,7 @@ struct sdpcm_shared {
 	u32 console_addr;	/* Address of struct rte_console */
 	u32 msgtrace_addr;
 	u8 tag[32];
+	u32 brpt_addr;
 };
 
 struct sdpcm_shared_le {
@@ -450,6 +478,7 @@ struct sdpcm_shared_le {
 	__le32 console_addr;	/* Address of struct rte_console */
 	__le32 msgtrace_addr;
 	u8 tag[32];
+	__le32 brpt_addr;
 };
 
 
@@ -2953,13 +2982,311 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 }
 
 #ifdef DEBUG
+static inline bool brcmf_sdio_valid_shared_address(u32 addr)
+{
+	return !(addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff));
+}
+
+static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
+				 struct sdpcm_shared *sh)
+{
+	u32 addr;
+	int rv;
+	u32 shaddr = 0;
+	struct sdpcm_shared_le sh_le;
+	__le32 addr_le;
+
+	shaddr = bus->ramsize - 4;
+
+	/*
+	 * Read last word in socram to determine
+	 * address of sdpcm_shared structure
+	 */
+	rv = brcmf_sdbrcm_membytes(bus, false, shaddr,
+				   (u8 *)&addr_le, 4);
+	if (rv < 0)
+		return rv;
+
+	addr = le32_to_cpu(addr_le);
+
+	brcmf_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
+
+	/*
+	 * Check if addr is valid.
+	 * NVRAM length at the end of memory should have been overwritten.
+	 */
+	if (!brcmf_sdio_valid_shared_address(addr)) {
+			brcmf_dbg(ERROR, "invalid sdpcm_shared address 0x%08X\n",
+				  addr);
+			return -EINVAL;
+	}
+
+	/* Read hndrte_shared structure */
+	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&sh_le,
+				   sizeof(struct sdpcm_shared_le));
+	if (rv < 0)
+		return rv;
+
+	/* Endianness */
+	sh->flags = le32_to_cpu(sh_le.flags);
+	sh->trap_addr = le32_to_cpu(sh_le.trap_addr);
+	sh->assert_exp_addr = le32_to_cpu(sh_le.assert_exp_addr);
+	sh->assert_file_addr = le32_to_cpu(sh_le.assert_file_addr);
+	sh->assert_line = le32_to_cpu(sh_le.assert_line);
+	sh->console_addr = le32_to_cpu(sh_le.console_addr);
+	sh->msgtrace_addr = le32_to_cpu(sh_le.msgtrace_addr);
+
+	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
+		brcmf_dbg(ERROR,
+			  "sdpcm_shared version mismatch: dhd %d dongle %d\n",
+			  SDPCM_SHARED_VERSION,
+			  sh->flags & SDPCM_SHARED_VERSION_MASK);
+		return -EPROTO;
+	}
+
+	return 0;
+}
+
+static int brcmf_sdio_dump_console(struct brcmf_sdio *bus,
+				   struct sdpcm_shared *sh, char __user *data,
+				   size_t count)
+{
+	u32 addr, console_ptr, console_size, console_index;
+	char *conbuf = NULL;
+	__le32 sh_val;
+	int rv;
+	loff_t pos = 0;
+	int nbytes = 0;
+
+	/* obtain console information from device memory */
+	addr = sh->console_addr + offsetof(struct rte_console, log_le);
+	rv = brcmf_sdbrcm_membytes(bus, false, addr,
+			(u8 *)&sh_val, sizeof(u32));
+	if (rv < 0)
+		return rv;
+	console_ptr = le32_to_cpu(sh_val);
+
+	addr = sh->console_addr + offsetof(struct rte_console, log_le.buf_size);
+	rv = brcmf_sdbrcm_membytes(bus, false, addr,
+			(u8 *)&sh_val, sizeof(u32));
+	if (rv < 0)
+		return rv;
+	console_size = le32_to_cpu(sh_val);
+
+	addr = sh->console_addr + offsetof(struct rte_console, log_le.idx);
+	rv = brcmf_sdbrcm_membytes(bus, false, addr,
+			(u8 *)&sh_val, sizeof(u32));
+	if (rv < 0)
+		return rv;
+	console_index = le32_to_cpu(sh_val);
+
+	/* allocate buffer for console data */
+	if (console_size <= CONSOLE_BUFFER_MAX)
+		conbuf = vzalloc(console_size+1);
+
+	if (!conbuf)
+		return -ENOMEM;
+
+	/* obtain the console data from device */
+	conbuf[console_size] = '\0';
+	rv = brcmf_sdbrcm_membytes(bus, false, console_ptr, (u8 *)conbuf,
+				   console_size);
+	if (rv < 0)
+		goto done;
+
+	rv = simple_read_from_buffer(data, count, &pos,
+				     conbuf + console_index,
+				     console_size - console_index);
+	if (rv < 0)
+		goto done;
+
+	nbytes = rv;
+	if (console_index > 0) {
+		pos = 0;
+		rv = simple_read_from_buffer(data+nbytes, count, &pos,
+					     conbuf, console_index - 1);
+		if (rv < 0)
+			goto done;
+		rv += nbytes;
+	}
+done:
+	vfree(conbuf);
+	return rv;
+}
+
+static int brcmf_sdio_trap_info(struct brcmf_sdio *bus, struct sdpcm_shared *sh,
+				char __user *data, size_t count)
+{
+	int error, res;
+	char buf[350];
+	struct brcmf_trap_info tr;
+	int nbytes;
+	loff_t pos = 0;
+
+	if ((sh->flags & SDPCM_SHARED_TRAP) == 0)
+		return 0;
+
+	error = brcmf_sdbrcm_membytes(bus, false, sh->trap_addr, (u8 *)&tr,
+				      sizeof(struct brcmf_trap_info));
+	if (error < 0)
+		return error;
+
+	nbytes = brcmf_sdio_dump_console(bus, sh, data, count);
+	if (nbytes < 0)
+		return nbytes;
+
+	res = scnprintf(buf, sizeof(buf),
+			"dongle trap info: type 0x%x @ epc 0x%08x\n"
+			"  cpsr 0x%08x spsr 0x%08x sp 0x%08x\n"
+			"  lr   0x%08x pc   0x%08x offset 0x%x\n"
+			"  r0   0x%08x r1   0x%08x r2 0x%08x r3 0x%08x\n"
+			"  r4   0x%08x r5   0x%08x r6 0x%08x r7 0x%08x\n",
+			le32_to_cpu(tr.type), le32_to_cpu(tr.epc),
+			le32_to_cpu(tr.cpsr), le32_to_cpu(tr.spsr),
+			le32_to_cpu(tr.r13), le32_to_cpu(tr.r14),
+			le32_to_cpu(tr.pc), le32_to_cpu(sh->trap_addr),
+			le32_to_cpu(tr.r0), le32_to_cpu(tr.r1),
+			le32_to_cpu(tr.r2), le32_to_cpu(tr.r3),
+			le32_to_cpu(tr.r4), le32_to_cpu(tr.r5),
+			le32_to_cpu(tr.r6), le32_to_cpu(tr.r7));
+
+	error = simple_read_from_buffer(data+nbytes, count, &pos, buf, res);
+	if (error < 0)
+		return error;
+
+	nbytes += error;
+	return nbytes;
+}
+
+static int brcmf_sdio_assert_info(struct brcmf_sdio *bus,
+				  struct sdpcm_shared *sh, char __user *data,
+				  size_t count)
+{
+	int error = 0;
+	char buf[200];
+	char file[80] = "?";
+	char expr[80] = "<???>";
+	int res;
+	loff_t pos = 0;
+
+	if ((sh->flags & SDPCM_SHARED_ASSERT_BUILT) == 0) {
+		brcmf_dbg(INFO, "firmware not built with -assert\n");
+		return 0;
+	} else if ((sh->flags & SDPCM_SHARED_ASSERT) == 0) {
+		brcmf_dbg(INFO, "no assert in dongle\n");
+		return 0;
+	}
+
+	if (sh->assert_file_addr != 0) {
+		error = brcmf_sdbrcm_membytes(bus, false, sh->assert_file_addr,
+					      (u8 *)file, 80);
+		if (error < 0)
+			return error;
+	}
+	if (sh->assert_exp_addr != 0) {
+		error = brcmf_sdbrcm_membytes(bus, false, sh->assert_exp_addr,
+					      (u8 *)expr, 80);
+		if (error < 0)
+			return error;
+	}
+
+	res = scnprintf(buf, sizeof(buf),
+			"dongle assert: %s:%d: assert(%s)\n",
+			file, sh->assert_line, expr);
+	return simple_read_from_buffer(data, count, &pos, buf, res);
+}
+
+static int brcmf_sdbrcm_checkdied(struct brcmf_sdio *bus)
+{
+	int error;
+	struct sdpcm_shared sh;
+
+	down(&bus->sdsem);
+	error = brcmf_sdio_readshared(bus, &sh);
+	up(&bus->sdsem);
+
+	if (error < 0)
+		return error;
+
+	if ((sh.flags & SDPCM_SHARED_ASSERT_BUILT) == 0)
+		brcmf_dbg(INFO, "firmware not built with -assert\n");
+	else if (sh.flags & SDPCM_SHARED_ASSERT)
+		brcmf_dbg(ERROR, "assertion in dongle\n");
+
+	if (sh.flags & SDPCM_SHARED_TRAP)
+		brcmf_dbg(ERROR, "firmware trap in dongle\n");
+
+	return 0;
+}
+
+static int brcmf_sdbrcm_died_dump(struct brcmf_sdio *bus, char __user *data,
+				  size_t count, loff_t *ppos)
+{
+	int error = 0;
+	struct sdpcm_shared sh;
+	int nbytes = 0;
+	loff_t pos = *ppos;
+
+	if (pos != 0)
+		return 0;
+
+	down(&bus->sdsem);
+	error = brcmf_sdio_readshared(bus, &sh);
+	if (error < 0)
+		goto done;
+
+	error = brcmf_sdio_assert_info(bus, &sh, data, count);
+	if (error < 0)
+		goto done;
+
+	nbytes = error;
+	error = brcmf_sdio_trap_info(bus, &sh, data, count);
+	if (error < 0)
+		goto done;
+
+	error += nbytes;
+	*ppos += error;
+done:
+	up(&bus->sdsem);
+	return error;
+}
+
+static ssize_t brcmf_sdio_forensic_read(struct file *f, char __user *data,
+					size_t count, loff_t *ppos)
+{
+	struct brcmf_sdio *bus = f->private_data;
+	int res;
+
+	res = brcmf_sdbrcm_died_dump(bus, data, count, ppos);
+	if (res > 0)
+		*ppos += res;
+	return (ssize_t)res;
+}
+
+static const struct file_operations brcmf_sdio_forensic_ops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = brcmf_sdio_forensic_read
+};
+
 static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
 {
 	struct brcmf_pub *drvr = bus->sdiodev->bus_if->drvr;
+	struct dentry *dentry = brcmf_debugfs_get_devdir(drvr);
 
+	if (IS_ERR_OR_NULL(dentry))
+		return;
+
+	debugfs_create_file("forensics", S_IRUGO, dentry, bus,
+			    &brcmf_sdio_forensic_ops);
 	brcmf_debugfs_create_sdio_count(drvr, &bus->sdcnt);
 }
 #else
+static int brcmf_sdbrcm_checkdied(struct brcmf_sdio *bus)
+{
+	return 0;
+}
+
 static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
 {
 }
@@ -2991,11 +3318,13 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 			  rxlen, msglen);
 	} else if (timeleft == 0) {
 		brcmf_dbg(ERROR, "resumed on timeout\n");
+		brcmf_sdbrcm_checkdied(bus);
 	} else if (pending) {
 		brcmf_dbg(CTL, "cancelled\n");
 		return -ERESTARTSYS;
 	} else {
 		brcmf_dbg(CTL, "resumed for unknown reason?\n");
+		brcmf_sdbrcm_checkdied(bus);
 	}
 
 	if (rxlen)
@@ -3817,6 +4146,7 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_sdio *bus)
 static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
+
 	if (bus) {
 		/* De-register interrupt handler */
 		brcmf_sdio_intr_unregister(bus->sdiodev);
-- 
1.7.9.5



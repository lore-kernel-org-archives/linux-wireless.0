Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:23732 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaAMVUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 16:20:35 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/8] brcmfmac: Create common nvram parsing routines.
Date: Mon, 13 Jan 2014 22:20:22 +0100
Message-ID: <1389648029-23560-2-git-send-email-arend@broadcom.com> (sfid-20140113_222040_524842_B19BC325)
In-Reply-To: <1389648029-23560-1-git-send-email-arend@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

New bus layers like pcie require nvram parsing routines which are
the same routines as being used by sdio. Make these routines common
in the new file nvram.c. Update sdio to use these routines and
simplify the nvram upload process. Also add memory validation check
for downloaded firmware and nvram in debug mode.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  166 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/nvram.c    |   94 +++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/nvram.h    |   24 +++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  110 +------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    3 +-
 6 files changed, 208 insertions(+), 190 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/nvram.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/nvram.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 5681b98..57cddee 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -32,6 +32,7 @@ brcmfmac-objs += \
 		bcdc.o \
 		dhd_common.o \
 		dhd_linux.o \
+		nvram.o \
 		btcoex.o
 brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
 		dhd_sdio.o \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 9c7f08a..4f936c6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -41,6 +41,7 @@
 #include <soc.h>
 #include "sdio_host.h"
 #include "sdio_chip.h"
+#include "nvram.h"
 
 #define DCMD_RESP_TIMEOUT  2000	/* In milli second */
 
@@ -369,8 +370,6 @@ struct brcmf_sdio_hdrinfo {
 struct brcmf_sdio {
 	struct brcmf_sdio_dev *sdiodev;	/* sdio device handler */
 	struct chip_info *ci;	/* Chip info struct */
-	char *vars;		/* Variables (from CIS and/or other) */
-	uint varsz;		/* Size of variables buffer */
 
 	u32 ramsize;		/* Size of RAM in SOCRAM (bytes) */
 
@@ -3207,8 +3206,7 @@ static bool brcmf_sdio_download_state(struct brcmf_sdio *bus, bool enter)
 
 		brcmf_sdio_chip_enter_download(bus->sdiodev, ci);
 	} else {
-		if (!brcmf_sdio_chip_exit_download(bus->sdiodev, ci, bus->vars,
-						   bus->varsz))
+		if (!brcmf_sdio_chip_exit_download(bus->sdiodev, ci))
 			return false;
 
 		/* Allow HT Clock now that the ARM is running. */
@@ -3220,6 +3218,60 @@ static bool brcmf_sdio_download_state(struct brcmf_sdio *bus, bool enter)
 	return true;
 }
 
+#ifdef DEBUG
+static bool
+brcmf_sdio_verifymemory(struct brcmf_sdio_dev *sdiodev, u32 ram_addr,
+			u8 *ram_data, uint ram_sz)
+{
+	char *ram_cmp;
+	int err;
+	bool ret = true;
+	int address;
+	int offset;
+	int len;
+
+	/* read back and verify */
+	brcmf_dbg(INFO, "Compare RAM dl & ul at 0x%08x; size=%d\n", ram_addr,
+		  ram_sz);
+	ram_cmp = kmalloc(MEMBLOCK, GFP_KERNEL);
+	/* do not proceed while no memory but  */
+	if (!ram_cmp)
+		return true;
+
+	address = ram_addr;
+	offset = 0;
+	while (offset < ram_sz) {
+		len = ((offset + MEMBLOCK) < ram_sz) ? MEMBLOCK :
+		      ram_sz - offset;
+		err = brcmf_sdiod_ramrw(sdiodev, false, address, ram_cmp, len);
+		if (err) {
+			brcmf_err("error %d on reading %d membytes at 0x%08x\n",
+				  err, len, address);
+			ret = false;
+			break;
+		} else if (memcmp(ram_cmp, &ram_data[offset], len)) {
+			brcmf_err("Downloaded RAM image is corrupted, block offset is %d, len is %d\n",
+				  offset, len);
+			ret = false;
+			break;
+		}
+		offset += len;
+		address += len;
+	}
+
+	kfree(ram_cmp);
+
+	return ret;
+}
+#else	/* DEBUG */
+static bool
+brcmf_sdio_verifymemory(struct brcmf_sdio_dev *sdiodev, u32 ram_addr,
+			u8 *ram_data, uint ram_sz)
+{
+	return true;
+}
+#endif	/* DEBUG */
+
 static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus)
 {
 	const struct firmware *fw;
@@ -3228,6 +3280,8 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus)
 	int address;
 	int len;
 
+	brcmf_dbg(TRACE, "Enter\n");
+
 	fw = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_BIN);
 	if (fw == NULL)
 		return -ENOENT;
@@ -3252,6 +3306,10 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus)
 		offset += len;
 		address += len;
 	}
+	if (!err)
+		if (!brcmf_sdio_verifymemory(bus->sdiodev, bus->ci->rambase,
+					     (u8 *)fw->data, fw->size))
+			err = -EIO;
 
 failure:
 	release_firmware(fw);
@@ -3259,94 +3317,37 @@ failure:
 	return err;
 }
 
-/*
- * ProcessVars:Takes a buffer of "<var>=<value>\n" lines read from a file
- * and ending in a NUL.
- * Removes carriage returns, empty lines, comment lines, and converts
- * newlines to NULs.
- * Shortens buffer as needed and pads with NULs.  End of buffer is marked
- * by two NULs.
-*/
-
-static int brcmf_sdio_strip_nvram(struct brcmf_sdio *bus,
-				  const struct firmware *nv)
-{
-	char *varbuf;
-	char *dp;
-	bool findNewline;
-	int column;
-	int ret = 0;
-	uint buf_len, n, len;
-
-	len = nv->size;
-	varbuf = vmalloc(len);
-	if (!varbuf)
-		return -ENOMEM;
-
-	memcpy(varbuf, nv->data, len);
-	dp = varbuf;
-
-	findNewline = false;
-	column = 0;
-
-	for (n = 0; n < len; n++) {
-		if (varbuf[n] == 0)
-			break;
-		if (varbuf[n] == '\r')
-			continue;
-		if (findNewline && varbuf[n] != '\n')
-			continue;
-		findNewline = false;
-		if (varbuf[n] == '#') {
-			findNewline = true;
-			continue;
-		}
-		if (varbuf[n] == '\n') {
-			if (column == 0)
-				continue;
-			*dp++ = 0;
-			column = 0;
-			continue;
-		}
-		*dp++ = varbuf[n];
-		column++;
-	}
-	buf_len = dp - varbuf;
-	while (dp < varbuf + n)
-		*dp++ = 0;
-
-	kfree(bus->vars);
-	/* roundup needed for download to device */
-	bus->varsz = roundup(buf_len + 1, 4);
-	bus->vars = kmalloc(bus->varsz, GFP_KERNEL);
-	if (bus->vars == NULL) {
-		bus->varsz = 0;
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	/* copy the processed variables and add null termination */
-	memcpy(bus->vars, varbuf, buf_len);
-	bus->vars[buf_len] = 0;
-err:
-	vfree(varbuf);
-	return ret;
-}
-
 static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus)
 {
 	const struct firmware *nv;
-	int ret;
+	void *vars;
+	u32 varsz;
+	int address;
+	int err;
+
+	brcmf_dbg(TRACE, "Enter\n");
 
 	nv = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_NVRAM);
 	if (nv == NULL)
 		return -ENOENT;
 
-	ret = brcmf_sdio_strip_nvram(bus, nv);
-
+	vars = brcmf_nvram_strip(nv, &varsz);
 	release_firmware(nv);
 
-	return ret;
+	if (vars == NULL)
+		return -EINVAL;
+
+	address = bus->ci->ramsize - varsz + bus->ci->rambase;
+	err = brcmf_sdiod_ramrw(bus->sdiodev, true, address, vars, varsz);
+	if (err)
+		brcmf_err("error %d on writing %d nvram bytes at 0x%08x\n",
+			  err, varsz, address);
+	else if (!brcmf_sdio_verifymemory(bus->sdiodev, address, vars, varsz))
+		err = -EIO;
+
+	brcmf_nvram_free(vars);
+
+	return err;
 }
 
 static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus)
@@ -4092,7 +4093,6 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		brcmu_pkt_buf_free_skb(bus->txglom_sgpad);
 		kfree(bus->rxbuf);
 		kfree(bus->hdrbuf);
-		kfree(bus->vars);
 		kfree(bus);
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/nvram.c b/drivers/net/wireless/brcm80211/brcmfmac/nvram.c
new file mode 100644
index 0000000..d5ef86d
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/nvram.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/firmware.h>
+
+#include "nvram.h"
+
+/* brcmf_nvram_strip :Takes a buffer of "<var>=<value>\n" lines read from a file
+ * and ending in a NUL. Removes carriage returns, empty lines, comment lines,
+ * and converts newlines to NULs. Shortens buffer as needed and pads with NULs.
+ * End of buffer is completed with token identifying length of buffer.
+ */
+void *brcmf_nvram_strip(const struct firmware *nv, u32 *new_length)
+{
+	u8 *nvram;
+	u32 i;
+	u32 len;
+	u32 column;
+	u8 val;
+	bool comment;
+	u32 token;
+	__le32 token_le;
+
+	/* Alloc for extra 0 byte + roundup by 4 + length field */
+	nvram = kmalloc(nv->size + 1 + 3 + sizeof(token_le), GFP_KERNEL);
+	if (!nvram)
+		return NULL;
+
+	len = 0;
+	column = 0;
+	comment = false;
+	for (i = 0; i < nv->size; i++) {
+		val = nv->data[i];
+		if (val == 0)
+			break;
+		if (val == '\r')
+			continue;
+		if (comment && (val != '\n'))
+			continue;
+		comment = false;
+		if (val == '#') {
+			comment = true;
+			continue;
+		}
+		if (val == '\n') {
+			if (column == 0)
+				continue;
+			nvram[len] = 0;
+			len++;
+			column = 0;
+			continue;
+		}
+		nvram[len] = val;
+		len++;
+		column++;
+	}
+	column = len;
+	*new_length = roundup(len + 1, 4);
+	while (column != *new_length) {
+		nvram[column] = 0;
+		column++;
+	}
+
+	token = *new_length / 4;
+	token = (~token << 16) | (token & 0x0000FFFF);
+	token_le = cpu_to_le32(token);
+
+	memcpy(&nvram[*new_length], &token_le, sizeof(token_le));
+	*new_length += sizeof(token_le);
+
+	return nvram;
+}
+
+void brcmf_nvram_free(void *nvram)
+{
+	kfree(nvram);
+}
+
+
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/nvram.h b/drivers/net/wireless/brcm80211/brcmfmac/nvram.h
new file mode 100644
index 0000000..d454580
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/nvram.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef BRCMFMAC_NVRAM_H
+#define BRCMFMAC_NVRAM_H
+
+
+void *brcmf_nvram_strip(const struct firmware *nv, u32 *new_length);
+void brcmf_nvram_free(void *nvram);
+
+
+#endif /* BRCMFMAC_NVRAM_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 9fd4067..a74a3d1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -842,107 +842,16 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 	}
 }
 
-#ifdef DEBUG
-static bool
-brcmf_sdio_chip_verifynvram(struct brcmf_sdio_dev *sdiodev, u32 nvram_addr,
-			    char *nvram_dat, uint nvram_sz)
-{
-	char *nvram_ularray;
-	int err;
-	bool ret = true;
-
-	/* read back and verify */
-	brcmf_dbg(INFO, "Compare NVRAM dl & ul; size=%d\n", nvram_sz);
-	nvram_ularray = kmalloc(nvram_sz, GFP_KERNEL);
-	/* do not proceed while no memory but  */
-	if (!nvram_ularray)
-		return true;
-
-	/* Upload image to verify downloaded contents. */
-	memset(nvram_ularray, 0xaa, nvram_sz);
-
-	/* Read the vars list to temp buffer for comparison */
-	err = brcmf_sdiod_ramrw(sdiodev, false, nvram_addr, nvram_ularray,
-				nvram_sz);
-	if (err) {
-		brcmf_err("error %d on reading %d nvram bytes at 0x%08x\n",
-			  err, nvram_sz, nvram_addr);
-	} else if (memcmp(nvram_dat, nvram_ularray, nvram_sz)) {
-		brcmf_err("Downloaded NVRAM image is corrupted\n");
-		ret = false;
-	}
-	kfree(nvram_ularray);
-
-	return ret;
-}
-#else	/* DEBUG */
-static inline bool
-brcmf_sdio_chip_verifynvram(struct brcmf_sdio_dev *sdiodev, u32 nvram_addr,
-			    char *nvram_dat, uint nvram_sz)
-{
-	return true;
-}
-#endif	/* DEBUG */
-
-static bool brcmf_sdio_chip_writenvram(struct brcmf_sdio_dev *sdiodev,
-				       struct chip_info *ci,
-				       char *nvram_dat, uint nvram_sz)
-{
-	int err;
-	u32 nvram_addr;
-	u32 token;
-	__le32 token_le;
-
-	nvram_addr = (ci->ramsize - 4) - nvram_sz + ci->rambase;
-
-	/* Write the vars list */
-	err = brcmf_sdiod_ramrw(sdiodev, true, nvram_addr, nvram_dat, nvram_sz);
-	if (err) {
-		brcmf_err("error %d on writing %d nvram bytes at 0x%08x\n",
-			  err, nvram_sz, nvram_addr);
-		return false;
-	}
-
-	if (!brcmf_sdio_chip_verifynvram(sdiodev, nvram_addr,
-					 nvram_dat, nvram_sz))
-		return false;
-
-	/* generate token:
-	 * nvram size, converted to words, in lower 16-bits, checksum
-	 * in upper 16-bits.
-	 */
-	token = nvram_sz / 4;
-	token = (~token << 16) | (token & 0x0000FFFF);
-	token_le = cpu_to_le32(token);
-
-	brcmf_dbg(INFO, "RAM size: %d\n", ci->ramsize);
-	brcmf_dbg(INFO, "nvram is placed at %d, size %d, token=0x%08x\n",
-		  nvram_addr, nvram_sz, token);
-
-	/* Write the length token to the last word */
-	if (brcmf_sdiod_ramrw(sdiodev, true, (ci->ramsize - 4 + ci->rambase),
-			      (u8 *)&token_le, 4))
-		return false;
-
-	return true;
-}
-
 static void
 brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
 			    struct chip_info *ci)
 {
-	u32 zeros = 0;
-
 	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0);
 	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM, 0);
-
-	/* clear length token */
-	brcmf_sdiod_ramrw(sdiodev, true, ci->ramsize - 4, (u8 *)&zeros, 4);
 }
 
 static bool
-brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
-			   char *nvram_dat, uint nvram_sz)
+brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci)
 {
 	u8 core_idx;
 	u32 reg_addr;
@@ -952,9 +861,6 @@ brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 		return false;
 	}
 
-	if (!brcmf_sdio_chip_writenvram(sdiodev, ci, nvram_dat, nvram_sz))
-		return false;
-
 	/* clear all interrupts */
 	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_SDIO_DEV);
 	reg_addr = ci->c_inf[core_idx].base;
@@ -975,15 +881,11 @@ brcmf_sdio_chip_cr4_enterdl(struct brcmf_sdio_dev *sdiodev,
 }
 
 static bool
-brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
-			   char *nvram_dat, uint nvram_sz)
+brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci)
 {
 	u8 core_idx;
 	u32 reg_addr;
 
-	if (!brcmf_sdio_chip_writenvram(sdiodev, ci, nvram_dat, nvram_sz))
-		return false;
-
 	/* clear all interrupts */
 	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_SDIO_DEV);
 	reg_addr = ci->c_inf[core_idx].base;
@@ -1015,15 +917,13 @@ void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
 }
 
 bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
-				   struct chip_info *ci, char *nvram_dat,
-				   uint nvram_sz)
+				   struct chip_info *ci)
 {
 	u8 arm_core_idx;
 
 	arm_core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
 	if (BRCMF_MAX_CORENUM != arm_core_idx)
-		return brcmf_sdio_chip_cm3_exitdl(sdiodev, ci, nvram_dat,
-						  nvram_sz);
+		return brcmf_sdio_chip_cm3_exitdl(sdiodev, ci);
 
-	return brcmf_sdio_chip_cr4_exitdl(sdiodev, ci, nvram_dat, nvram_sz);
+	return brcmf_sdio_chip_cr4_exitdl(sdiodev, ci);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 7ea424e..c7d0dbc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -224,7 +224,6 @@ u8 brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid);
 void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
 				    struct chip_info *ci);
 bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
-				   struct chip_info *ci, char *nvram_dat,
-				   uint nvram_sz);
+				   struct chip_info *ci);
 
 #endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
-- 
1.7.10.4


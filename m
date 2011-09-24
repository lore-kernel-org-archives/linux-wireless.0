Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4597 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab1IXCJU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 22:09:20 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 14/20] staging: brcm80211: remove dongle firmware
 related debug code
Date: Fri, 23 Sep 2011 19:09:02 -0700
Message-ID: <1316830148-28661-15-git-send-email-frankyl@broadcom.com> (sfid-20110924_041001_582824_018BAB77)
In-Reply-To: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

When the device dies the driver could extract cpu registers on
the device to analyze the trap handling on the dongle. As the
firmware with this driver is stable this code does not belong
in the brcmfmac driver.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  259 +------------------------
 1 files changed, 1 insertions(+), 258 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 9f8bcb3..4992d4d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -37,29 +37,7 @@
 
 #ifdef BCMDBG
 
-/* ARM trap handling */
-struct brcmf_trap {
-	u32 type;
-	u32 epc;
-	u32 cpsr;
-	u32 spsr;
-	u32 r0;
-	u32 r1;
-	u32 r2;
-	u32 r3;
-	u32 r4;
-	u32 r5;
-	u32 r6;
-	u32 r7;
-	u32 r8;
-	u32 r9;
-	u32 r10;
-	u32 r11;
-	u32 r12;
-	u32 r13;
-	u32 r14;
-	u32 pc;
-};
+#define BRCMF_TRAP_INFO_SIZE	80
 
 #define CBUF_LEN	(128)
 
@@ -2890,231 +2868,6 @@ xfer_done:
 }
 
 #ifdef BCMDBG
-static int
-brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
-{
-	u32 addr;
-	__le32 addr_le;
-	int rv;
-	struct sdpcm_shared_le sh_le;
-
-	/* Read last word in memory to determine address of
-			 sdpcm_shared structure */
-	rv = brcmf_sdbrcm_membytes(bus, false, bus->ramsize - 4, (u8 *)&addr_le,
-				   4);
-	if (rv < 0)
-		return rv;
-
-	addr = le32_to_cpu(addr_le);
-
-	brcmf_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
-
-	/*
-	 * Check if addr is valid.
-	 * NVRAM length at the end of memory should have been overwritten.
-	 */
-	if (addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff)) {
-		brcmf_dbg(ERROR, "address (0x%08x) of sdpcm_shared invalid\n",
-			  addr);
-		return -EBADE;
-	}
-
-	/* Read rte_shared structure */
-	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *) &sh_le,
-			      sizeof(struct sdpcm_shared_le));
-	if (rv < 0)
-		return rv;
-
-	/* Endianness */
-	sh->flags = le32_to_cpu(sh_le.flags);
-	sh->trap_addr = le32_to_cpu(sh_le.trap_addr);
-	sh->assert_exp_addr = le32_to_cpu(sh_le.assert_exp_addr);
-	sh->assert_file_addr = le32_to_cpu(sh_le.assert_file_addr);
-	sh->assert_line = le32_to_cpu(sh_le.assert_line);
-	sh->console_addr = le32_to_cpu(sh_le.console_addr);
-	sh->msgtrace_addr = le32_to_cpu(sh_le.msgtrace_addr);
-	memcpy(sh->tag, sh_le.tag, sizeof(sh->tag));
-
-	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
-		brcmf_dbg(ERROR, "sdpcm_shared version %d in brcmf is different than sdpcm_shared version %d in dongle\n",
-			  SDPCM_SHARED_VERSION,
-			  sh->flags & SDPCM_SHARED_VERSION_MASK);
-		return -EBADE;
-	}
-
-	return 0;
-}
-
-static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
-{
-	int ret = 0;
-	int size;		/* Full mem size */
-	int start = 0;		/* Start address */
-	int read_size = 0;	/* Read size of each iteration */
-	u8 *buf = NULL, *databuf = NULL;
-
-	/* Get full mem size */
-	size = bus->ramsize;
-	buf = kmalloc(size, GFP_ATOMIC);
-	if (!buf)
-		return -1;
-
-	/* Read mem content */
-	printk(KERN_DEBUG "Dump dongle memory");
-	databuf = buf;
-	while (size) {
-		read_size = min(MEMBLOCK, size);
-		ret = brcmf_sdbrcm_membytes(bus, false, start, databuf,
-					  read_size);
-		if (ret) {
-			brcmf_dbg(ERROR, "Error membytes %d\n", ret);
-			kfree(buf);
-			return -1;
-		}
-		printk(".");
-
-		/* Decrement size and increment start address */
-		size -= read_size;
-		start += read_size;
-		databuf += read_size;
-	}
-	printk(KERN_DEBUG "Done\n");
-
-	/* free buf before return !!! */
-	if (brcmf_write_to_file(bus->drvr, buf, bus->ramsize)) {
-		brcmf_dbg(ERROR, "Error writing to files\n");
-		return -1;
-	}
-
-	/* buf free handled in brcmf_write_to_file, not here */
-	return 0;
-}
-
-static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
-{
-	int bcmerror = 0;
-	uint msize = 512;
-	char *mbuffer = NULL;
-	uint maxstrlen = 256;
-	char *str = NULL;
-	struct brcmf_trap tr;
-	struct sdpcm_shared sdpcm_shared;
-	struct brcmu_strbuf strbuf;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (data == NULL) {
-		/*
-		 * Called after a rx ctrl timeout. "data" is NULL.
-		 * allocate memory to trace the trap or assert.
-		 */
-		size = msize;
-		mbuffer = data = kmalloc(msize, GFP_ATOMIC);
-		if (mbuffer == NULL) {
-			bcmerror = -ENOMEM;
-			goto done;
-		}
-	}
-
-	str = kmalloc(maxstrlen, GFP_ATOMIC);
-	if (str == NULL) {
-		bcmerror = -ENOMEM;
-		goto done;
-	}
-
-	bcmerror = brcmf_sdbrcm_readshared(bus, &sdpcm_shared);
-	if (bcmerror < 0)
-		goto done;
-
-	brcmu_binit(&strbuf, data, size);
-
-	brcmu_bprintf(&strbuf,
-		    "msgtrace address : 0x%08X\nconsole address  : 0x%08X\n",
-		    sdpcm_shared.msgtrace_addr, sdpcm_shared.console_addr);
-
-	if ((sdpcm_shared.flags & SDPCM_SHARED_ASSERT_BUILT) == 0)
-		/* NOTE: Misspelled assert is intentional - DO NOT FIX.
-		 * (Avoids conflict with real asserts for programmatic
-		 * parsing of output.)
-		 */
-		brcmu_bprintf(&strbuf, "Assrt not built in dongle\n");
-
-	if ((sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP)) ==
-	    0) {
-		/* NOTE: Misspelled assert is intentional - DO NOT FIX.
-		 * (Avoids conflict with real asserts for programmatic
-		 * parsing of output.)
-		 */
-		brcmu_bprintf(&strbuf, "No trap%s in dongle",
-			    (sdpcm_shared.flags & SDPCM_SHARED_ASSERT_BUILT)
-			    ? "/assrt" : "");
-	} else {
-		if (sdpcm_shared.flags & SDPCM_SHARED_ASSERT) {
-			/* Download assert */
-			brcmu_bprintf(&strbuf, "Dongle assert");
-			if (sdpcm_shared.assert_exp_addr != 0) {
-				str[0] = '\0';
-				bcmerror = brcmf_sdbrcm_membytes(bus, false,
-						sdpcm_shared.assert_exp_addr,
-						(u8 *) str, maxstrlen);
-				if (bcmerror < 0)
-					goto done;
-
-				str[maxstrlen - 1] = '\0';
-				brcmu_bprintf(&strbuf, " expr \"%s\"", str);
-			}
-
-			if (sdpcm_shared.assert_file_addr != 0) {
-				str[0] = '\0';
-				bcmerror = brcmf_sdbrcm_membytes(bus, false,
-						sdpcm_shared.assert_file_addr,
-						(u8 *) str, maxstrlen);
-				if (bcmerror < 0)
-					goto done;
-
-				str[maxstrlen - 1] = '\0';
-				brcmu_bprintf(&strbuf, " file \"%s\"", str);
-			}
-
-			brcmu_bprintf(&strbuf, " line %d ",
-				    sdpcm_shared.assert_line);
-		}
-
-		if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
-			bcmerror = brcmf_sdbrcm_membytes(bus, false,
-					sdpcm_shared.trap_addr, (u8 *)&tr,
-					sizeof(struct brcmf_trap));
-			if (bcmerror < 0)
-				goto done;
-
-			brcmu_bprintf(&strbuf,
-				    "Dongle trap type 0x%x @ epc 0x%x, cpsr 0x%x, spsr 0x%x, sp 0x%x,"
-				    "lp 0x%x, rpc 0x%x Trap offset 0x%x, "
-				    "r0 0x%x, r1 0x%x, r2 0x%x, r3 0x%x, r4 0x%x, r5 0x%x, r6 0x%x, r7 0x%x\n",
-				    tr.type, tr.epc, tr.cpsr, tr.spsr, tr.r13,
-				    tr.r14, tr.pc, sdpcm_shared.trap_addr,
-				    tr.r0, tr.r1, tr.r2, tr.r3, tr.r4, tr.r5,
-				    tr.r6, tr.r7);
-		}
-	}
-
-	if (sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP))
-		brcmf_dbg(ERROR, "%s\n", strbuf.origbuf);
-
-#ifdef BCMDBG
-	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP)
-		/* Mem dump to a file on device */
-		brcmf_sdbrcm_mem_dump(bus);
-
-#endif				/* BCMDBG */
-
-done:
-	kfree(mbuffer);
-	kfree(str);
-
-	return bcmerror;
-}
-
 #define CONSOLE_LINE_MAX	192
 
 static int brcmf_sdbrcm_readconsole(struct brcmf_bus *bus)
@@ -3377,21 +3130,11 @@ brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 			  rxlen, msglen);
 	} else if (timeleft == 0) {
 		brcmf_dbg(ERROR, "resumed on timeout\n");
-#ifdef BCMDBG
-		brcmf_sdbrcm_sdlock(bus);
-		brcmf_sdbrcm_checkdied(bus, NULL, 0);
-		brcmf_sdbrcm_sdunlock(bus);
-#endif				/* BCMDBG */
 	} else if (pending == true) {
 		brcmf_dbg(CTL, "cancelled\n");
 		return -ERESTARTSYS;
 	} else {
 		brcmf_dbg(CTL, "resumed for unknown reason?\n");
-#ifdef BCMDBG
-		brcmf_sdbrcm_sdlock(bus);
-		brcmf_sdbrcm_checkdied(bus, NULL, 0);
-		brcmf_sdbrcm_sdunlock(bus);
-#endif				/* BCMDBG */
 	}
 
 	if (rxlen)
-- 
1.7.1



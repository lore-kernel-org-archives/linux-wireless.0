Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4922 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 54/83] staging: brcm80211: combine sbsdpcmdev.h and
 sbsdio.h
Date: Wed, 1 Jun 2011 13:45:39 +0200
Message-ID: <1306928768-7501-54-git-send-email-rvossen@broadcom.com> (sfid-20110601_134914_514579_B04EBFB2)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Combine two head files both for sdio sb configuration in fullmac

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |   16 +-
 drivers/staging/brcm80211/brcmfmac/sbsdio.h     |  221 +++++++++++++++++++++
 drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h |  240 -----------------------
 3 files changed, 229 insertions(+), 248 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4847026..6653655 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -129,7 +129,6 @@ typedef struct {
 
 #include <sdio.h>
 #include <sbsdio.h>
-#include <sbsdpcmdev.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
@@ -379,7 +378,8 @@ extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
 
 /* Core reg address translation */
 #define CORE_CC_REG(base, field)	(base + offsetof(chipcregs_t, field))
-#define CORE_BUS_REG(base, field)	(base + offsetof(sdpcmd_regs_t, field))
+#define CORE_BUS_REG(base, field) \
+		(base + offsetof(struct sdpcmd_regs, field))
 #define CORE_SB(base, field) \
 		(base + SBCONFIGOFF + offsetof(sbconfig_t, field))
 
@@ -433,7 +433,7 @@ typedef struct dhd_bus {
 	uint varsz;		/* Size of variables buffer */
 	u32 sbaddr;		/* Current SB window pointer (-1, invalid) */
 
-	sdpcmd_regs_t *regs;	/* Registers for SDIO core */
+	struct sdpcmd_regs *regs;	/* SDIO core */
 	uint sdpcmrev;		/* SDIO core revision */
 	uint armrev;		/* CPU core revision */
 	uint ramrev;		/* SOCRAM core revision */
@@ -1013,7 +1013,7 @@ static int dhdsdio_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 {
 	bcmsdh_info_t *sdh = bus->sdh;
-	sdpcmd_regs_t *regs = bus->regs;
+	struct sdpcmd_regs *regs = bus->regs;
 	uint retries = 0;
 
 	DHD_INFO(("dhdsdio_bussleep: request %s (currently %s)\n",
@@ -1407,7 +1407,7 @@ static uint dhdsdio_sendfromq(dhd_bus_t *bus, uint maxframes)
 	u8 tx_prec_map;
 
 	dhd_pub_t *dhd = bus->dhd;
-	sdpcmd_regs_t *regs = bus->regs;
+	struct sdpcmd_regs *regs = bus->regs;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -3157,7 +3157,7 @@ exit:
 static void dhdsdio_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 {
 	bcmsdh_info_t *sdh = bus->sdh;
-	sdpcmd_regs_t *regs = bus->regs;
+	struct sdpcmd_regs *regs = bus->regs;
 	uint retries = 0;
 	u16 lastrbc;
 	u8 hi, lo;
@@ -4342,7 +4342,7 @@ deliver:
 
 static u32 dhdsdio_hostmail(dhd_bus_t *bus)
 {
-	sdpcmd_regs_t *regs = bus->regs;
+	struct sdpcmd_regs *regs = bus->regs;
 	u32 intstatus = 0;
 	u32 hmb_data;
 	u8 fcbits;
@@ -4417,7 +4417,7 @@ static u32 dhdsdio_hostmail(dhd_bus_t *bus)
 bool dhdsdio_dpc(dhd_bus_t *bus)
 {
 	bcmsdh_info_t *sdh = bus->sdh;
-	sdpcmd_regs_t *regs = bus->regs;
+	struct sdpcmd_regs *regs = bus->regs;
 	u32 intstatus, newstatus = 0;
 	uint retries = 0;
 	uint rxlimit = dhd_rxbound;	/* Rx frames to read before resched */
diff --git a/drivers/staging/brcm80211/brcmfmac/sbsdio.h b/drivers/staging/brcm80211/brcmfmac/sbsdio.h
index c7facd3..86b62b8 100644
--- a/drivers/staging/brcm80211/brcmfmac/sbsdio.h
+++ b/drivers/staging/brcm80211/brcmfmac/sbsdio.h
@@ -149,4 +149,225 @@
 
 #define SBSDIO_CORE_ADDR_MASK		0x1FFFF	/* sdio core function one address mask */
 
+/* corecontrol */
+#define CC_CISRDY		(1 << 0)	/* CIS Ready */
+#define CC_BPRESEN		(1 << 1)	/* CCCR RES signal */
+#define CC_F2RDY		(1 << 2)	/* set CCCR IOR2 bit */
+#define CC_CLRPADSISO		(1 << 3)	/* clear SDIO pads isolation */
+#define CC_XMTDATAAVAIL_MODE	(1 << 4)
+#define CC_XMTDATAAVAIL_CTRL	(1 << 5)
+
+/* corestatus */
+#define CS_PCMCIAMODE	(1 << 0)	/* Device Mode; 0=SDIO, 1=PCMCIA */
+#define CS_SMARTDEV	(1 << 1)	/* 1=smartDev enabled */
+#define CS_F2ENABLED	(1 << 2)	/* 1=host has enabled the device */
+
+#define PCMCIA_MES_PA_MASK	0x7fff	/* PCMCIA Message Portal Address Mask */
+#define PCMCIA_MES_PM_MASK	0x7fff	/* PCMCIA Message Portal Mask Mask */
+#define PCMCIA_WFBC_MASK	0xffff	/* PCMCIA Write Frame Byte Count Mask */
+#define PCMCIA_UT_MASK		0x07ff	/* PCMCIA Underflow Timer Mask */
+
+/* intstatus */
+#define I_SMB_SW0	(1 << 0)	/* To SB Mail S/W interrupt 0 */
+#define I_SMB_SW1	(1 << 1)	/* To SB Mail S/W interrupt 1 */
+#define I_SMB_SW2	(1 << 2)	/* To SB Mail S/W interrupt 2 */
+#define I_SMB_SW3	(1 << 3)	/* To SB Mail S/W interrupt 3 */
+#define I_SMB_SW_MASK	0x0000000f	/* To SB Mail S/W interrupts mask */
+#define I_SMB_SW_SHIFT	0	/* To SB Mail S/W interrupts shift */
+#define I_HMB_SW0	(1 << 4)	/* To Host Mail S/W interrupt 0 */
+#define I_HMB_SW1	(1 << 5)	/* To Host Mail S/W interrupt 1 */
+#define I_HMB_SW2	(1 << 6)	/* To Host Mail S/W interrupt 2 */
+#define I_HMB_SW3	(1 << 7)	/* To Host Mail S/W interrupt 3 */
+#define I_HMB_SW_MASK	0x000000f0	/* To Host Mail S/W interrupts mask */
+#define I_HMB_SW_SHIFT	4	/* To Host Mail S/W interrupts shift */
+#define I_WR_OOSYNC	(1 << 8)	/* Write Frame Out Of Sync */
+#define I_RD_OOSYNC	(1 << 9)	/* Read Frame Out Of Sync */
+#define	I_PC		(1 << 10)	/* descriptor error */
+#define	I_PD		(1 << 11)	/* data error */
+#define	I_DE		(1 << 12)	/* Descriptor protocol Error */
+#define	I_RU		(1 << 13)	/* Receive descriptor Underflow */
+#define	I_RO		(1 << 14)	/* Receive fifo Overflow */
+#define	I_XU		(1 << 15)	/* Transmit fifo Underflow */
+#define	I_RI		(1 << 16)	/* Receive Interrupt */
+#define I_BUSPWR	(1 << 17)	/* SDIO Bus Power Change (rev 9) */
+#define I_XMTDATA_AVAIL (1 << 23)	/* bits in fifo */
+#define	I_XI		(1 << 24)	/* Transmit Interrupt */
+#define I_RF_TERM	(1 << 25)	/* Read Frame Terminate */
+#define I_WF_TERM	(1 << 26)	/* Write Frame Terminate */
+#define I_PCMCIA_XU	(1 << 27)	/* PCMCIA Transmit FIFO Underflow */
+#define I_SBINT		(1 << 28)	/* sbintstatus Interrupt */
+#define I_CHIPACTIVE	(1 << 29)	/* chip from doze to active state */
+#define I_SRESET	(1 << 30)	/* CCCR RES interrupt */
+#define I_IOE2		(1U << 31)	/* CCCR IOE2 Bit Changed */
+#define	I_ERRORS	(I_PC | I_PD | I_DE | I_RU | I_RO | I_XU)
+#define I_DMA		(I_RI | I_XI | I_ERRORS)
+
+/* sbintstatus */
+#define I_SB_SERR	(1 << 8)	/* Backplane SError (write) */
+#define I_SB_RESPERR	(1 << 9)	/* Backplane Response Error (read) */
+#define I_SB_SPROMERR	(1 << 10)	/* Error accessing the sprom */
+
+/* sdioaccess */
+#define SDA_DATA_MASK	0x000000ff	/* Read/Write Data Mask */
+#define SDA_ADDR_MASK	0x000fff00	/* Read/Write Address Mask */
+#define SDA_ADDR_SHIFT	8	/* Read/Write Address Shift */
+#define SDA_WRITE	0x01000000	/* Write bit  */
+#define SDA_READ	0x00000000	/* Write bit cleared for Read */
+#define SDA_BUSY	0x80000000	/* Busy bit */
+
+/* sdioaccess-accessible register address spaces */
+#define SDA_CCCR_SPACE		0x000	/* CCCR register space */
+#define SDA_F1_FBR_SPACE	0x100	/* F1 FBR register space */
+#define SDA_F2_FBR_SPACE	0x200	/* F2 FBR register space */
+#define SDA_F1_REG_SPACE	0x300	/* F1 core-specific register space */
+
+/* SDA_F1_REG_SPACE sdioaccess-accessible F1 reg space register offsets */
+#define SDA_CHIPCONTROLDATA	0x006	/* ChipControlData */
+#define SDA_CHIPCONTROLENAB	0x007	/* ChipControlEnable */
+#define SDA_F2WATERMARK		0x008	/* Function 2 Watermark */
+#define SDA_DEVICECONTROL	0x009	/* DeviceControl */
+#define SDA_SBADDRLOW		0x00a	/* SbAddrLow */
+#define SDA_SBADDRMID		0x00b	/* SbAddrMid */
+#define SDA_SBADDRHIGH		0x00c	/* SbAddrHigh */
+#define SDA_FRAMECTRL		0x00d	/* FrameCtrl */
+#define SDA_CHIPCLOCKCSR	0x00e	/* ChipClockCSR */
+#define SDA_SDIOPULLUP		0x00f	/* SdioPullUp */
+#define SDA_SDIOWRFRAMEBCLOW	0x019	/* SdioWrFrameBCLow */
+#define SDA_SDIOWRFRAMEBCHIGH	0x01a	/* SdioWrFrameBCHigh */
+#define SDA_SDIORDFRAMEBCLOW	0x01b	/* SdioRdFrameBCLow */
+#define SDA_SDIORDFRAMEBCHIGH	0x01c	/* SdioRdFrameBCHigh */
+
+/* SDA_F2WATERMARK */
+#define SDA_F2WATERMARK_MASK	0x7f	/* F2Watermark Mask */
+
+/* SDA_SBADDRLOW */
+#define SDA_SBADDRLOW_MASK	0x80	/* SbAddrLow Mask */
+
+/* SDA_SBADDRMID */
+#define SDA_SBADDRMID_MASK	0xff	/* SbAddrMid Mask */
+
+/* SDA_SBADDRHIGH */
+#define SDA_SBADDRHIGH_MASK	0xff	/* SbAddrHigh Mask */
+
+/* SDA_FRAMECTRL */
+#define SFC_RF_TERM	(1 << 0)	/* Read Frame Terminate */
+#define SFC_WF_TERM	(1 << 1)	/* Write Frame Terminate */
+#define SFC_CRC4WOOS	(1 << 2)	/* CRC error for write out of sync */
+#define SFC_ABORTALL	(1 << 3)	/* Abort all in-progress frames */
+
+/* pcmciaframectrl */
+#define PFC_RF_TERM	(1 << 0)	/* Read Frame Terminate */
+#define PFC_WF_TERM	(1 << 1)	/* Write Frame Terminate */
+
+/* intrcvlazy */
+#define	IRL_TO_MASK	0x00ffffff	/* timeout */
+#define	IRL_FC_MASK	0xff000000	/* frame count */
+#define	IRL_FC_SHIFT	24	/* frame count */
+
+/* rx header flags */
+#define RXF_CRC		0x0001	/* CRC error detected */
+#define RXF_WOOS	0x0002	/* write frame out of sync */
+#define RXF_WF_TERM	0x0004	/* write frame terminated */
+#define RXF_ABORT	0x0008	/* write frame aborted */
+#define RXF_DISCARD	(RXF_CRC | RXF_WOOS | RXF_WF_TERM | RXF_ABORT)
+
+/* HW frame tag */
+#define SDPCM_FRAMETAG_LEN	4	/* 2 bytes len, 2 bytes check val */
+
+/* cpp contortions to concatenate w/arg prescan */
+#ifndef PAD
+#define	_PADLINE(line)	pad ## line
+#define	_XSTR(line)	_PADLINE(line)
+#define	PAD		_XSTR(__LINE__)
+#endif				/* PAD */
+
+/* core registers */
+struct sdpcmd_regs {
+	u32 corecontrol;		/* 0x00, rev8 */
+	u32 corestatus;			/* rev8 */
+	u32 PAD[1];
+	u32 biststatus;			/* rev8 */
+
+	/* PCMCIA access */
+	u16 pcmciamesportaladdr;	/* 0x010, rev8 */
+	u16 PAD[1];
+	u16 pcmciamesportalmask;	/* rev8 */
+	u16 PAD[1];
+	u16 pcmciawrframebc;		/* rev8 */
+	u16 PAD[1];
+	u16 pcmciaunderflowtimer;	/* rev8 */
+	u16 PAD[1];
+
+	/* interrupt */
+	u32 intstatus;			/* 0x020, rev8 */
+	u32 hostintmask;		/* rev8 */
+	u32 intmask;			/* rev8 */
+	u32 sbintstatus;		/* rev8 */
+	u32 sbintmask;			/* rev8 */
+	u32 funcintmask;		/* rev4 */
+	u32 PAD[2];
+	u32 tosbmailbox;		/* 0x040, rev8 */
+	u32 tohostmailbox;		/* rev8 */
+	u32 tosbmailboxdata;		/* rev8 */
+	u32 tohostmailboxdata;		/* rev8 */
+
+	/* synchronized access to registers in SDIO clock domain */
+	u32 sdioaccess;			/* 0x050, rev8 */
+	u32 PAD[3];
+
+	/* PCMCIA frame control */
+	u8 pcmciaframectrl;		/* 0x060, rev8 */
+	u8 PAD[3];
+	u8 pcmciawatermark;		/* rev8 */
+	u8 PAD[155];
+
+	/* interrupt batching control */
+	u32 intrcvlazy;			/* 0x100, rev8 */
+	u32 PAD[3];
+
+	/* counters */
+	u32 cmd52rd;			/* 0x110, rev8 */
+	u32 cmd52wr;			/* rev8 */
+	u32 cmd53rd;			/* rev8 */
+	u32 cmd53wr;			/* rev8 */
+	u32 abort;			/* rev8 */
+	u32 datacrcerror;		/* rev8 */
+	u32 rdoutofsync;		/* rev8 */
+	u32 wroutofsync;		/* rev8 */
+	u32 writebusy;			/* rev8 */
+	u32 readwait;			/* rev8 */
+	u32 readterm;			/* rev8 */
+	u32 writeterm;			/* rev8 */
+	u32 PAD[40];
+	u32 clockctlstatus;		/* rev8 */
+	u32 PAD[7];
+
+	u32 PAD[128];			/* DMA engines */
+
+	/* SDIO/PCMCIA CIS region */
+	char cis[512];			/* 0x400-0x5ff, rev6 */
+
+	/* PCMCIA function control registers */
+	char pcmciafcr[256];		/* 0x600-6ff, rev6 */
+	u16 PAD[55];
+
+	/* PCMCIA backplane access */
+	u16 backplanecsr;		/* 0x76E, rev6 */
+	u16 backplaneaddr0;		/* rev6 */
+	u16 backplaneaddr1;		/* rev6 */
+	u16 backplaneaddr2;		/* rev6 */
+	u16 backplaneaddr3;		/* rev6 */
+	u16 backplanedata0;		/* rev6 */
+	u16 backplanedata1;		/* rev6 */
+	u16 backplanedata2;		/* rev6 */
+	u16 backplanedata3;		/* rev6 */
+	u16 PAD[31];
+
+	/* sprom "size" & "blank" info */
+	u16 spromstatus;		/* 0x7BE, rev2 */
+	u32 PAD[464];
+
+	u16 PAD[0x80];
+};
+
 #endif				/* _SBSDIO_H */
diff --git a/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h b/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
deleted file mode 100644
index 3799d50..0000000
--- a/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
+++ /dev/null
@@ -1,240 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef	_sbsdpcmdev_h_
-#define	_sbsdpcmdev_h_
-
-/* core registers */
-typedef volatile struct {
-	u32 corecontrol;	/* CoreControl, 0x000, rev8 */
-	u32 corestatus;	/* CoreStatus, 0x004, rev8  */
-	u32 PAD[1];
-	u32 biststatus;	/* BistStatus, 0x00c, rev8  */
-
-	/* PCMCIA access */
-	u16 pcmciamesportaladdr;	/* PcmciaMesPortalAddr, 0x010, rev8   */
-	u16 PAD[1];
-	u16 pcmciamesportalmask;	/* PcmciaMesPortalMask, 0x014, rev8   */
-	u16 PAD[1];
-	u16 pcmciawrframebc;	/* PcmciaWrFrameBC, 0x018, rev8   */
-	u16 PAD[1];
-	u16 pcmciaunderflowtimer;	/* PcmciaUnderflowTimer, 0x01c, rev8   */
-	u16 PAD[1];
-
-	/* interrupt */
-	u32 intstatus;	/* IntStatus, 0x020, rev8   */
-	u32 hostintmask;	/* IntHostMask, 0x024, rev8   */
-	u32 intmask;		/* IntSbMask, 0x028, rev8   */
-	u32 sbintstatus;	/* SBIntStatus, 0x02c, rev8   */
-	u32 sbintmask;	/* SBIntMask, 0x030, rev8   */
-	u32 funcintmask;	/* SDIO Function Interrupt Mask, SDIO rev4 */
-	u32 PAD[2];
-	u32 tosbmailbox;	/* ToSBMailbox, 0x040, rev8   */
-	u32 tohostmailbox;	/* ToHostMailbox, 0x044, rev8   */
-	u32 tosbmailboxdata;	/* ToSbMailboxData, 0x048, rev8   */
-	u32 tohostmailboxdata;	/* ToHostMailboxData, 0x04c, rev8   */
-
-	/* synchronized access to registers in SDIO clock domain */
-	u32 sdioaccess;	/* SdioAccess, 0x050, rev8   */
-	u32 PAD[3];
-
-	/* PCMCIA frame control */
-	u8 pcmciaframectrl;	/* pcmciaFrameCtrl, 0x060, rev8   */
-	u8 PAD[3];
-	u8 pcmciawatermark;	/* pcmciaWaterMark, 0x064, rev8   */
-	u8 PAD[155];
-
-	/* interrupt batching control */
-	u32 intrcvlazy;	/* IntRcvLazy, 0x100, rev8 */
-	u32 PAD[3];
-
-	/* counters */
-	u32 cmd52rd;		/* Cmd52RdCount, 0x110, rev8, SDIO: cmd52 reads */
-	u32 cmd52wr;		/* Cmd52WrCount, 0x114, rev8, SDIO: cmd52 writes */
-	u32 cmd53rd;		/* Cmd53RdCount, 0x118, rev8, SDIO: cmd53 reads */
-	u32 cmd53wr;		/* Cmd53WrCount, 0x11c, rev8, SDIO: cmd53 writes */
-	u32 abort;		/* AbortCount, 0x120, rev8, SDIO: aborts */
-	u32 datacrcerror;	/* DataCrcErrorCount, 0x124, rev8, SDIO: frames w/bad CRC */
-	u32 rdoutofsync;	/* RdOutOfSyncCount, 0x128, rev8, SDIO/PCMCIA: Rd Frm OOS */
-	u32 wroutofsync;	/* RdOutOfSyncCount, 0x12c, rev8, SDIO/PCMCIA: Wr Frm OOS */
-	u32 writebusy;	/* WriteBusyCount, 0x130, rev8, SDIO: dev asserted "busy" */
-	u32 readwait;	/* ReadWaitCount, 0x134, rev8, SDIO: read: no data avail */
-	u32 readterm;	/* ReadTermCount, 0x138, rev8, SDIO: rd frm terminates */
-	u32 writeterm;	/* WriteTermCount, 0x13c, rev8, SDIO: wr frm terminates */
-	u32 PAD[40];
-	u32 clockctlstatus;	/* ClockCtlStatus, 0x1e0, rev8 */
-	u32 PAD[7];
-	u32 PAD[128];		/* DMA engines */
-
-	/* SDIO/PCMCIA CIS region */
-	char cis[512];		/* 512 byte CIS, 0x400-0x5ff, rev6 */
-
-	/* PCMCIA function control registers */
-	char pcmciafcr[256];	/* PCMCIA FCR, 0x600-6ff, rev6 */
-	u16 PAD[55];
-
-	/* PCMCIA backplane access */
-	u16 backplanecsr;	/* BackplaneCSR, 0x76E, rev6 */
-	u16 backplaneaddr0;	/* BackplaneAddr0, 0x770, rev6 */
-	u16 backplaneaddr1;	/* BackplaneAddr1, 0x772, rev6 */
-	u16 backplaneaddr2;	/* BackplaneAddr2, 0x774, rev6 */
-	u16 backplaneaddr3;	/* BackplaneAddr3, 0x776, rev6 */
-	u16 backplanedata0;	/* BackplaneData0, 0x778, rev6 */
-	u16 backplanedata1;	/* BackplaneData1, 0x77a, rev6 */
-	u16 backplanedata2;	/* BackplaneData2, 0x77c, rev6 */
-	u16 backplanedata3;	/* BackplaneData3, 0x77e, rev6 */
-	u16 PAD[31];
-
-	/* sprom "size" & "blank" info */
-	u16 spromstatus;	/* SPROMStatus, 0x7BE, rev2 */
-	u32 PAD[464];
-
-	/* Sonics SiliconBackplane registers */
-	u16 PAD[0x80];		/* SbConfig Regs, 0xf00-0xfff, rev8 */
-} sdpcmd_regs_t;
-
-/* corecontrol */
-#define CC_CISRDY		(1 << 0)	/* CIS Ready */
-#define CC_BPRESEN		(1 << 1)	/* CCCR RES signal causes backplane reset */
-#define CC_F2RDY		(1 << 2)	/* set CCCR IOR2 bit */
-#define CC_CLRPADSISO		(1 << 3)	/* clear SDIO pads isolation bit (rev 11) */
-#define CC_XMTDATAAVAIL_MODE	(1 << 4)	/* data avail generates an interrupt */
-#define CC_XMTDATAAVAIL_CTRL	(1 << 5)	/* data avail interrupt ctrl */
-
-/* corestatus */
-#define CS_PCMCIAMODE	(1 << 0)	/* Device Mode; 0=SDIO, 1=PCMCIA */
-#define CS_SMARTDEV	(1 << 1)	/* 1=smartDev enabled */
-#define CS_F2ENABLED	(1 << 2)	/* 1=host has enabled the device */
-
-#define PCMCIA_MES_PA_MASK	0x7fff	/* PCMCIA Message Portal Address Mask */
-#define PCMCIA_MES_PM_MASK	0x7fff	/* PCMCIA Message Portal Mask Mask */
-#define PCMCIA_WFBC_MASK	0xffff	/* PCMCIA Write Frame Byte Count Mask */
-#define PCMCIA_UT_MASK		0x07ff	/* PCMCIA Underflow Timer Mask */
-
-/* intstatus */
-#define I_SMB_SW0	(1 << 0)	/* To SB Mail S/W interrupt 0 */
-#define I_SMB_SW1	(1 << 1)	/* To SB Mail S/W interrupt 1 */
-#define I_SMB_SW2	(1 << 2)	/* To SB Mail S/W interrupt 2 */
-#define I_SMB_SW3	(1 << 3)	/* To SB Mail S/W interrupt 3 */
-#define I_SMB_SW_MASK	0x0000000f	/* To SB Mail S/W interrupts mask */
-#define I_SMB_SW_SHIFT	0	/* To SB Mail S/W interrupts shift */
-#define I_HMB_SW0	(1 << 4)	/* To Host Mail S/W interrupt 0 */
-#define I_HMB_SW1	(1 << 5)	/* To Host Mail S/W interrupt 1 */
-#define I_HMB_SW2	(1 << 6)	/* To Host Mail S/W interrupt 2 */
-#define I_HMB_SW3	(1 << 7)	/* To Host Mail S/W interrupt 3 */
-#define I_HMB_SW_MASK	0x000000f0	/* To Host Mail S/W interrupts mask */
-#define I_HMB_SW_SHIFT	4	/* To Host Mail S/W interrupts shift */
-#define I_WR_OOSYNC	(1 << 8)	/* Write Frame Out Of Sync */
-#define I_RD_OOSYNC	(1 << 9)	/* Read Frame Out Of Sync */
-#define	I_PC		(1 << 10)	/* descriptor error */
-#define	I_PD		(1 << 11)	/* data error */
-#define	I_DE		(1 << 12)	/* Descriptor protocol Error */
-#define	I_RU		(1 << 13)	/* Receive descriptor Underflow */
-#define	I_RO		(1 << 14)	/* Receive fifo Overflow */
-#define	I_XU		(1 << 15)	/* Transmit fifo Underflow */
-#define	I_RI		(1 << 16)	/* Receive Interrupt */
-#define I_BUSPWR	(1 << 17)	/* SDIO Bus Power Change (rev 9) */
-#define I_XMTDATA_AVAIL (1 << 23)	/* bits in fifo */
-#define	I_XI		(1 << 24)	/* Transmit Interrupt */
-#define I_RF_TERM	(1 << 25)	/* Read Frame Terminate */
-#define I_WF_TERM	(1 << 26)	/* Write Frame Terminate */
-#define I_PCMCIA_XU	(1 << 27)	/* PCMCIA Transmit FIFO Underflow */
-#define I_SBINT		(1 << 28)	/* sbintstatus Interrupt */
-#define I_CHIPACTIVE	(1 << 29)	/* chip transitioned from doze to active state */
-#define I_SRESET	(1 << 30)	/* CCCR RES interrupt */
-#define I_IOE2		(1U << 31)	/* CCCR IOE2 Bit Changed */
-#define	I_ERRORS	(I_PC | I_PD | I_DE | I_RU | I_RO | I_XU)	/* DMA Errors */
-#define I_DMA		(I_RI | I_XI | I_ERRORS)
-
-/* sbintstatus */
-#define I_SB_SERR	(1 << 8)	/* Backplane SError (write) */
-#define I_SB_RESPERR	(1 << 9)	/* Backplane Response Error (read) */
-#define I_SB_SPROMERR	(1 << 10)	/* Error accessing the sprom */
-
-/* sdioaccess */
-#define SDA_DATA_MASK	0x000000ff	/* Read/Write Data Mask */
-#define SDA_ADDR_MASK	0x000fff00	/* Read/Write Address Mask */
-#define SDA_ADDR_SHIFT	8	/* Read/Write Address Shift */
-#define SDA_WRITE	0x01000000	/* Write bit  */
-#define SDA_READ	0x00000000	/* Write bit cleared for Read */
-#define SDA_BUSY	0x80000000	/* Busy bit */
-
-/* sdioaccess-accessible register address spaces */
-#define SDA_CCCR_SPACE		0x000	/* sdioAccess CCCR register space */
-#define SDA_F1_FBR_SPACE	0x100	/* sdioAccess F1 FBR register space */
-#define SDA_F2_FBR_SPACE	0x200	/* sdioAccess F2 FBR register space */
-#define SDA_F1_REG_SPACE	0x300	/* sdioAccess F1 core-specific register space */
-
-/* SDA_F1_REG_SPACE sdioaccess-accessible F1 reg space register offsets */
-#define SDA_CHIPCONTROLDATA	0x006	/* ChipControlData */
-#define SDA_CHIPCONTROLENAB	0x007	/* ChipControlEnable */
-#define SDA_F2WATERMARK		0x008	/* Function 2 Watermark */
-#define SDA_DEVICECONTROL	0x009	/* DeviceControl */
-#define SDA_SBADDRLOW		0x00a	/* SbAddrLow */
-#define SDA_SBADDRMID		0x00b	/* SbAddrMid */
-#define SDA_SBADDRHIGH		0x00c	/* SbAddrHigh */
-#define SDA_FRAMECTRL		0x00d	/* FrameCtrl */
-#define SDA_CHIPCLOCKCSR	0x00e	/* ChipClockCSR */
-#define SDA_SDIOPULLUP		0x00f	/* SdioPullUp */
-#define SDA_SDIOWRFRAMEBCLOW	0x019	/* SdioWrFrameBCLow */
-#define SDA_SDIOWRFRAMEBCHIGH	0x01a	/* SdioWrFrameBCHigh */
-#define SDA_SDIORDFRAMEBCLOW	0x01b	/* SdioRdFrameBCLow */
-#define SDA_SDIORDFRAMEBCHIGH	0x01c	/* SdioRdFrameBCHigh */
-
-/* SDA_F2WATERMARK */
-#define SDA_F2WATERMARK_MASK	0x7f	/* F2Watermark Mask */
-
-/* SDA_SBADDRLOW */
-#define SDA_SBADDRLOW_MASK	0x80	/* SbAddrLow Mask */
-
-/* SDA_SBADDRMID */
-#define SDA_SBADDRMID_MASK	0xff	/* SbAddrMid Mask */
-
-/* SDA_SBADDRHIGH */
-#define SDA_SBADDRHIGH_MASK	0xff	/* SbAddrHigh Mask */
-
-/* SDA_FRAMECTRL */
-#define SFC_RF_TERM	(1 << 0)	/* Read Frame Terminate */
-#define SFC_WF_TERM	(1 << 1)	/* Write Frame Terminate */
-#define SFC_CRC4WOOS	(1 << 2)	/* HW reports CRC error for write out of sync */
-#define SFC_ABORTALL	(1 << 3)	/* Abort cancels all in-progress frames */
-
-/* pcmciaframectrl */
-#define PFC_RF_TERM	(1 << 0)	/* Read Frame Terminate */
-#define PFC_WF_TERM	(1 << 1)	/* Write Frame Terminate */
-
-/* intrcvlazy */
-#define	IRL_TO_MASK	0x00ffffff	/* timeout */
-#define	IRL_FC_MASK	0xff000000	/* frame count */
-#define	IRL_FC_SHIFT	24	/* frame count */
-
-/* rx header */
-typedef volatile struct {
-	u16 len;
-	u16 flags;
-} sdpcmd_rxh_t;
-
-/* rx header flags */
-#define RXF_CRC		0x0001	/* CRC error detected */
-#define RXF_WOOS	0x0002	/* write frame out of sync */
-#define RXF_WF_TERM	0x0004	/* write frame terminated */
-#define RXF_ABORT	0x0008	/* write frame aborted */
-#define RXF_DISCARD	(RXF_CRC | RXF_WOOS | RXF_WF_TERM | RXF_ABORT)	/* bad frame */
-
-/* HW frame tag */
-#define SDPCM_FRAMETAG_LEN	4	/* HW frametag: 2 bytes len, 2 bytes check val */
-
-#endif				/* _sbsdpcmdev_h_ */
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3872 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758855Ab1FALqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:35 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 52/83] staging: brcm80211: absorb bcmsdpcm.h in fullmac
Date: Wed, 1 Jun 2011 13:45:37 +0200
Message-ID: <1306928768-7501-52-git-send-email-rvossen@broadcom.com> (sfid-20110601_134735_369195_8EF35FEC)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Absorb bcmsdpcm.h into dhd_sdio.c

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdpcm.h |  208 -------------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  127 +++++++++++++++-
 2 files changed, 123 insertions(+), 212 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdpcm.h

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdpcm.h b/drivers/staging/brcm80211/brcmfmac/bcmsdpcm.h
deleted file mode 100644
index 21d6a3a..0000000
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdpcm.h
+++ /dev/null
@@ -1,208 +0,0 @@
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
-#ifndef	_bcmsdpcm_h_
-#define	_bcmsdpcm_h_
-
-/*
- * Software allocation of To SB Mailbox resources
- */
-
-/* intstatus bits */
-#define I_SMB_NAK	I_SMB_SW0	/* To SB Mailbox Frame NAK */
-#define I_SMB_INT_ACK	I_SMB_SW1	/* To SB Mailbox Host Interrupt ACK */
-#define I_SMB_USE_OOB	I_SMB_SW2	/* To SB Mailbox Use OOB Wakeup */
-#define I_SMB_DEV_INT	I_SMB_SW3	/* To SB Mailbox Miscellaneous Interrupt */
-
-#define I_TOSBMAIL      (I_SMB_NAK | I_SMB_INT_ACK | I_SMB_USE_OOB | I_SMB_DEV_INT)
-
-/* tosbmailbox bits corresponding to intstatus bits */
-#define SMB_NAK		(1 << 0)	/* To SB Mailbox Frame NAK */
-#define SMB_INT_ACK	(1 << 1)	/* To SB Mailbox Host Interrupt ACK */
-#define SMB_USE_OOB	(1 << 2)	/* To SB Mailbox Use OOB Wakeup */
-#define SMB_DEV_INT	(1 << 3)	/* To SB Mailbox Miscellaneous Interrupt */
-#define SMB_MASK	0x0000000f	/* To SB Mailbox Mask */
-
-/* tosbmailboxdata */
-#define SMB_DATA_VERSION_MASK	0x00ff0000	/* host protocol version (sent with F2 enable) */
-#define SMB_DATA_VERSION_SHIFT	16	/* host protocol version (sent with F2 enable) */
-
-/*
- * Software allocation of To Host Mailbox resources
- */
-
-/* intstatus bits */
-#define I_HMB_FC_STATE	I_HMB_SW0	/* To Host Mailbox Flow Control State */
-#define I_HMB_FC_CHANGE	I_HMB_SW1	/* To Host Mailbox Flow Control State Changed */
-#define I_HMB_FRAME_IND	I_HMB_SW2	/* To Host Mailbox Frame Indication */
-#define I_HMB_HOST_INT	I_HMB_SW3	/* To Host Mailbox Miscellaneous Interrupt */
-
-#define I_TOHOSTMAIL    (I_HMB_FC_CHANGE | I_HMB_FRAME_IND | I_HMB_HOST_INT)
-
-/* tohostmailbox bits corresponding to intstatus bits */
-#define HMB_FC_ON	(1 << 0)	/* To Host Mailbox Flow Control State */
-#define HMB_FC_CHANGE	(1 << 1)	/* To Host Mailbox Flow Control State Changed */
-#define HMB_FRAME_IND	(1 << 2)	/* To Host Mailbox Frame Indication */
-#define HMB_HOST_INT	(1 << 3)	/* To Host Mailbox Miscellaneous Interrupt */
-#define HMB_MASK	0x0000000f	/* To Host Mailbox Mask */
-
-/* tohostmailboxdata */
-#define HMB_DATA_NAKHANDLED	1	/* we're ready to retransmit NAK'd frame to host */
-#define HMB_DATA_DEVREADY	2	/* we're ready to to talk to host after enable */
-#define HMB_DATA_FC		4	/* per prio flowcontrol update flag to host */
-#define HMB_DATA_FWREADY	8	/* firmware is ready for protocol activity */
-
-#define HMB_DATA_FCDATA_MASK	0xff000000	/* per prio flowcontrol data */
-#define HMB_DATA_FCDATA_SHIFT	24	/* per prio flowcontrol data */
-
-#define HMB_DATA_VERSION_MASK	0x00ff0000	/* device protocol version (with devready) */
-#define HMB_DATA_VERSION_SHIFT	16	/* device protocol version (with devready) */
-
-/*
- * Software-defined protocol header
- */
-
-/* Current protocol version */
-#define SDPCM_PROT_VERSION	4
-
-/* SW frame header */
-#define SDPCM_SEQUENCE_MASK		0x000000ff	/* Sequence Number Mask */
-#define SDPCM_PACKET_SEQUENCE(p) (((u8 *)p)[0] & 0xff)	/* p starts w/SW Header */
-
-#define SDPCM_CHANNEL_MASK		0x00000f00	/* Channel Number Mask */
-#define SDPCM_CHANNEL_SHIFT		8	/* Channel Number Shift */
-#define SDPCM_PACKET_CHANNEL(p) (((u8 *)p)[1] & 0x0f)	/* p starts w/SW Header */
-
-#define SDPCM_FLAGS_MASK		0x0000f000	/* Mask of flag bits */
-#define SDPCM_FLAGS_SHIFT		12	/* Flag bits shift */
-#define SDPCM_PACKET_FLAGS(p) ((((u8 *)p)[1] & 0xf0) >> 4)	/* p starts w/SW Header */
-
-/* Next Read Len: lookahead length of next frame, in 16-byte units (rounded up) */
-#define SDPCM_NEXTLEN_MASK		0x00ff0000	/* Next Read Len Mask */
-#define SDPCM_NEXTLEN_SHIFT		16	/* Next Read Len Shift */
-#define SDPCM_NEXTLEN_VALUE(p) ((((u8 *)p)[2] & 0xff) << 4)	/* p starts w/SW Header */
-#define SDPCM_NEXTLEN_OFFSET		2
-
-/* Data Offset from SOF (HW Tag, SW Tag, Pad) */
-#define SDPCM_DOFFSET_OFFSET		3	/* Data Offset */
-#define SDPCM_DOFFSET_VALUE(p) 		(((u8 *)p)[SDPCM_DOFFSET_OFFSET] & 0xff)
-#define SDPCM_DOFFSET_MASK		0xff000000
-#define SDPCM_DOFFSET_SHIFT		24
-
-#define SDPCM_FCMASK_OFFSET		4	/* Flow control */
-#define SDPCM_FCMASK_VALUE(p)		(((u8 *)p)[SDPCM_FCMASK_OFFSET] & 0xff)
-#define SDPCM_WINDOW_OFFSET		5	/* Credit based fc */
-#define SDPCM_WINDOW_VALUE(p)		(((u8 *)p)[SDPCM_WINDOW_OFFSET] & 0xff)
-#define SDPCM_VERSION_OFFSET		6	/* Version # */
-#define SDPCM_VERSION_VALUE(p)		(((u8 *)p)[SDPCM_VERSION_OFFSET] & 0xff)
-#define SDPCM_UNUSED_OFFSET		7	/* Spare */
-#define SDPCM_UNUSED_VALUE(p)		(((u8 *)p)[SDPCM_UNUSED_OFFSET] & 0xff)
-
-#define SDPCM_SWHEADER_LEN	8	/* SW header is 64 bits */
-
-/* logical channel numbers */
-#define SDPCM_CONTROL_CHANNEL	0	/* Control Request/Response Channel Id */
-#define SDPCM_EVENT_CHANNEL	1	/* Asyc Event Indication Channel Id */
-#define SDPCM_DATA_CHANNEL	2	/* Data Xmit/Recv Channel Id */
-#define SDPCM_GLOM_CHANNEL	3	/* For coalesced packets (superframes) */
-#define SDPCM_TEST_CHANNEL	15	/* Reserved for test/debug packets */
-#define SDPCM_MAX_CHANNEL	15
-
-#define SDPCM_SEQUENCE_WRAP	256	/* wrap-around val for eight-bit frame seq number */
-
-#define SDPCM_FLAG_RESVD0	0x01
-#define SDPCM_FLAG_RESVD1	0x02
-#define SDPCM_FLAG_GSPI_TXENAB	0x04
-#define SDPCM_FLAG_GLOMDESC	0x08	/* Superframe descriptor mask */
-
-/* For GLOM_CHANNEL frames, use a flag to indicate descriptor frame */
-#define SDPCM_GLOMDESC_FLAG	(SDPCM_FLAG_GLOMDESC << SDPCM_FLAGS_SHIFT)
-
-#define SDPCM_GLOMDESC(p)	(((u8 *)p)[1] & 0x80)
-
-/* For TEST_CHANNEL packets, define another 4-byte header */
-#define SDPCM_TEST_HDRLEN	4	/* Generally: Cmd(1), Ext(1), Len(2);
-					 * Semantics of Ext byte depend on command.
-					 * Len is current or requested frame length, not
-					 * including test header; sent little-endian.
-					 */
-#define SDPCM_TEST_DISCARD	0x01	/* Receiver discards. Ext is a pattern id. */
-#define SDPCM_TEST_ECHOREQ	0x02	/* Echo request. Ext is a pattern id. */
-#define SDPCM_TEST_ECHORSP	0x03	/* Echo response. Ext is a pattern id. */
-#define SDPCM_TEST_BURST	0x04	/* Receiver to send a burst. Ext is a frame count */
-#define SDPCM_TEST_SEND		0x05	/* Receiver sets send mode. Ext is boolean on/off */
-
-/* Handy macro for filling in datagen packets with a pattern */
-#define SDPCM_TEST_FILL(byteno, id)	((u8)(id + byteno))
-
-/*
- * Software counters (first part matches hardware counters)
- */
-
-typedef volatile struct {
-	u32 cmd52rd;		/* Cmd52RdCount, SDIO: cmd52 reads */
-	u32 cmd52wr;		/* Cmd52WrCount, SDIO: cmd52 writes */
-	u32 cmd53rd;		/* Cmd53RdCount, SDIO: cmd53 reads */
-	u32 cmd53wr;		/* Cmd53WrCount, SDIO: cmd53 writes */
-	u32 abort;		/* AbortCount, SDIO: aborts */
-	u32 datacrcerror;	/* DataCrcErrorCount, SDIO: frames w/CRC error */
-	u32 rdoutofsync;	/* RdOutOfSyncCount, SDIO/PCMCIA: Rd Frm out of sync */
-	u32 wroutofsync;	/* RdOutOfSyncCount, SDIO/PCMCIA: Wr Frm out of sync */
-	u32 writebusy;	/* WriteBusyCount, SDIO: device asserted "busy" */
-	u32 readwait;	/* ReadWaitCount, SDIO: no data ready for a read cmd */
-	u32 readterm;	/* ReadTermCount, SDIO: read frame termination cmds */
-	u32 writeterm;	/* WriteTermCount, SDIO: write frames termination cmds */
-	u32 rxdescuflo;	/* receive descriptor underflows */
-	u32 rxfifooflo;	/* receive fifo overflows */
-	u32 txfifouflo;	/* transmit fifo underflows */
-	u32 runt;		/* runt (too short) frames recv'd from bus */
-	u32 badlen;		/* frame's rxh len does not match its hw tag len */
-	u32 badcksum;	/* frame's hw tag chksum doesn't agree with len value */
-	u32 seqbreak;	/* break in sequence # space from one rx frame to the next */
-	u32 rxfcrc;		/* frame rx header indicates crc error */
-	u32 rxfwoos;		/* frame rx header indicates write out of sync */
-	u32 rxfwft;		/* frame rx header indicates write frame termination */
-	u32 rxfabort;	/* frame rx header indicates frame aborted */
-	u32 woosint;		/* write out of sync interrupt */
-	u32 roosint;		/* read out of sync interrupt */
-	u32 rftermint;	/* read frame terminate interrupt */
-	u32 wftermint;	/* write frame terminate interrupt */
-} sdpcmd_cnt_t;
-
-/*
- * Shared structure between dongle and the host.
- * The structure contains pointers to trap or assert information.
- */
-#define SDPCM_SHARED_VERSION       0x0002
-#define SDPCM_SHARED_VERSION_MASK  0x00FF
-#define SDPCM_SHARED_ASSERT_BUILT  0x0100
-#define SDPCM_SHARED_ASSERT        0x0200
-#define SDPCM_SHARED_TRAP          0x0400
-
-typedef struct {
-	u32 flags;
-	u32 trap_addr;
-	u32 assert_exp_addr;
-	u32 assert_file_addr;
-	u32 assert_line;
-	u32 console_addr;	/* Address of rte_cons_t */
-	u32 msgtrace_addr;
-	u8 tag[32];
-} sdpcm_shared_t;
-
-extern sdpcm_shared_t sdpcm_shared;
-
-#endif				/* _bcmsdpcm_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index cd0ea4b..4847026 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -130,7 +130,6 @@ typedef struct {
 #include <sdio.h>
 #include <sbsdio.h>
 #include <sbsdpcmdev.h>
-#include <bcmsdpcm.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
@@ -192,6 +191,114 @@ typedef struct {
 #define SDPCM_RESERVE	(SDPCM_HDRLEN + DHD_SDALIGN)
 #endif
 
+/*
+ * Software allocation of To SB Mailbox resources
+ */
+
+/* tosbmailbox bits corresponding to intstatus bits */
+#define SMB_NAK		(1 << 0)	/* Frame NAK */
+#define SMB_INT_ACK	(1 << 1)	/* Host Interrupt ACK */
+#define SMB_USE_OOB	(1 << 2)	/* Use OOB Wakeup */
+#define SMB_DEV_INT	(1 << 3)	/* Miscellaneous Interrupt */
+
+/* tosbmailboxdata */
+#define SMB_DATA_VERSION_SHIFT	16	/* host protocol version */
+
+/*
+ * Software allocation of To Host Mailbox resources
+ */
+
+/* intstatus bits */
+#define I_HMB_FC_STATE	I_HMB_SW0	/* Flow Control State */
+#define I_HMB_FC_CHANGE	I_HMB_SW1	/* Flow Control State Changed */
+#define I_HMB_FRAME_IND	I_HMB_SW2	/* Frame Indication */
+#define I_HMB_HOST_INT	I_HMB_SW3	/* Miscellaneous Interrupt */
+
+/* tohostmailboxdata */
+#define HMB_DATA_NAKHANDLED	1	/* retransmit NAK'd frame */
+#define HMB_DATA_DEVREADY	2	/* talk to host after enable */
+#define HMB_DATA_FC		4	/* per prio flowcontrol update flag */
+#define HMB_DATA_FWREADY	8	/* fw ready for protocol activity */
+
+#define HMB_DATA_FCDATA_MASK	0xff000000
+#define HMB_DATA_FCDATA_SHIFT	24
+
+#define HMB_DATA_VERSION_MASK	0x00ff0000
+#define HMB_DATA_VERSION_SHIFT	16
+
+/*
+ * Software-defined protocol header
+ */
+
+/* Current protocol version */
+#define SDPCM_PROT_VERSION	4
+
+/* SW frame header */
+#define SDPCM_PACKET_SEQUENCE(p)	(((u8 *)p)[0] & 0xff)
+
+#define SDPCM_CHANNEL_MASK		0x00000f00
+#define SDPCM_CHANNEL_SHIFT		8
+#define SDPCM_PACKET_CHANNEL(p)		(((u8 *)p)[1] & 0x0f)
+
+#define SDPCM_NEXTLEN_OFFSET		2
+
+/* Data Offset from SOF (HW Tag, SW Tag, Pad) */
+#define SDPCM_DOFFSET_OFFSET		3	/* Data Offset */
+#define SDPCM_DOFFSET_VALUE(p)		(((u8 *)p)[SDPCM_DOFFSET_OFFSET] & 0xff)
+#define SDPCM_DOFFSET_MASK		0xff000000
+#define SDPCM_DOFFSET_SHIFT		24
+#define SDPCM_FCMASK_OFFSET		4	/* Flow control */
+#define SDPCM_FCMASK_VALUE(p)		(((u8 *)p)[SDPCM_FCMASK_OFFSET] & 0xff)
+#define SDPCM_WINDOW_OFFSET		5	/* Credit based fc */
+#define SDPCM_WINDOW_VALUE(p)		(((u8 *)p)[SDPCM_WINDOW_OFFSET] & 0xff)
+
+#define SDPCM_SWHEADER_LEN	8	/* SW header is 64 bits */
+
+/* logical channel numbers */
+#define SDPCM_CONTROL_CHANNEL	0	/* Control channel Id */
+#define SDPCM_EVENT_CHANNEL	1	/* Asyc Event Indication Channel Id */
+#define SDPCM_DATA_CHANNEL	2	/* Data Xmit/Recv Channel Id */
+#define SDPCM_GLOM_CHANNEL	3	/* For coalesced packets */
+#define SDPCM_TEST_CHANNEL	15	/* Reserved for test/debug packets */
+
+#define SDPCM_SEQUENCE_WRAP	256	/* wrap-around val for 8bit frame seq */
+
+#define SDPCM_GLOMDESC(p)	(((u8 *)p)[1] & 0x80)
+
+/* For TEST_CHANNEL packets, define another 4-byte header */
+#define SDPCM_TEST_HDRLEN	4	/*
+					 * Generally: Cmd(1), Ext(1), Len(2);
+					 * Semantics of Ext byte depend on
+					 * command. Len is current or requested
+					 * frame length, not including test
+					 * header; sent little-endian.
+					 */
+#define SDPCM_TEST_DISCARD	0x01	/* Receiver discards. Ext:pattern id. */
+#define SDPCM_TEST_ECHOREQ	0x02	/* Echo request. Ext:pattern id. */
+#define SDPCM_TEST_ECHORSP	0x03	/* Echo response. Ext:pattern id. */
+#define SDPCM_TEST_BURST	0x04	/*
+					 * Receiver to send a burst.
+					 * Ext is a frame count
+					 */
+#define SDPCM_TEST_SEND		0x05	/*
+					 * Receiver sets send mode.
+					 * Ext is boolean on/off
+					 */
+
+/* Handy macro for filling in datagen packets with a pattern */
+#define SDPCM_TEST_FILL(byteno, id)	((u8)(id + byteno))
+
+/*
+ * Shared structure between dongle and the host.
+ * The structure contains pointers to trap or assert information.
+ */
+#define SDPCM_SHARED_VERSION       0x0002
+#define SDPCM_SHARED_VERSION_MASK  0x00FF
+#define SDPCM_SHARED_ASSERT_BUILT  0x0100
+#define SDPCM_SHARED_ASSERT        0x0200
+#define SDPCM_SHARED_TRAP          0x0400
+
+
 /* Space for header read, limit for data packets */
 #ifndef MAX_HDR_READ
 #define MAX_HDR_READ	32
@@ -288,6 +395,18 @@ typedef struct dhd_console {
 } dhd_console_t;
 #endif				/* DHD_DEBUG */
 
+struct sdpcm_shared {
+	u32 flags;
+	u32 trap_addr;
+	u32 assert_exp_addr;
+	u32 assert_file_addr;
+	u32 assert_line;
+	u32 console_addr;	/* Address of rte_cons_t */
+	u32 msgtrace_addr;
+	u8 tag[32];
+};
+
+
 /* misc chip info needed by some of the routines */
 struct chip_info {
 	u32 chip;
@@ -1875,7 +1994,7 @@ xfer_done:
 }
 
 #ifdef DHD_DEBUG
-static int dhdsdio_readshared(dhd_bus_t *bus, sdpcm_shared_t *sh)
+static int dhdsdio_readshared(dhd_bus_t *bus, struct sdpcm_shared *sh)
 {
 	u32 addr;
 	int rv;
@@ -1902,7 +2021,7 @@ static int dhdsdio_readshared(dhd_bus_t *bus, sdpcm_shared_t *sh)
 
 	/* Read rte_shared structure */
 	rv = dhdsdio_membytes(bus, false, addr, (u8 *) sh,
-			      sizeof(sdpcm_shared_t));
+			      sizeof(struct sdpcm_shared));
 	if (rv < 0)
 		return rv;
 
@@ -1934,7 +2053,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 	uint maxstrlen = 256;
 	char *str = NULL;
 	trap_t tr;
-	sdpcm_shared_t sdpcm_shared;
+	struct sdpcm_shared sdpcm_shared;
 	struct bcmstrbuf strbuf;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
-- 
1.7.4.1



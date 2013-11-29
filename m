Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2256 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab3K2LZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/19] brcmfmac: Use consistent naming for BCDC.
Date: Fri, 29 Nov 2013 12:25:21 +0100
Message-ID: <1385724324-6361-17-git-send-email-arend@broadcom.com> (sfid-20131129_122557_166670_E6FA114B)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The BCDC protocol layer is using a mix of naming of CDC, BDC and
BCDC. Use the name BCDC consistenly over all functions, defines
and variables. This patch does not change code functionality.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |  195 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |    4 +-
 3 files changed, 95 insertions(+), 106 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index b5a2529..06848e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -33,7 +33,7 @@
 #include "proto.h"
 #include "bcdc.h"
 
-struct brcmf_proto_cdc_dcmd {
+struct brcmf_proto_bcdc_dcmd {
 	__le32 cmd;	/* dongle command value */
 	__le32 len;	/* lower 16: output buflen;
 			 * upper 16: input buflen (excludes header) */
@@ -42,47 +42,47 @@ struct brcmf_proto_cdc_dcmd {
 };
 
 /* Max valid buffer size that can be sent to the dongle */
-#define CDC_MAX_MSG_SIZE	(ETH_FRAME_LEN+ETH_FCS_LEN)
-
-/* CDC flag definitions */
-#define CDC_DCMD_ERROR		0x01	/* 1=cmd failed */
-#define CDC_DCMD_SET		0x02	/* 0=get, 1=set cmd */
-#define CDC_DCMD_IF_MASK	0xF000		/* I/F index */
-#define CDC_DCMD_IF_SHIFT	12
-#define CDC_DCMD_ID_MASK	0xFFFF0000	/* id an cmd pairing */
-#define CDC_DCMD_ID_SHIFT	16		/* ID Mask shift bits */
-#define CDC_DCMD_ID(flags)	\
-	(((flags) & CDC_DCMD_ID_MASK) >> CDC_DCMD_ID_SHIFT)
+#define BCDC_MAX_MSG_SIZE	(ETH_FRAME_LEN+ETH_FCS_LEN)
+
+/* BCDC flag definitions */
+#define BCDC_DCMD_ERROR		0x01		/* 1=cmd failed */
+#define BCDC_DCMD_SET		0x02		/* 0=get, 1=set cmd */
+#define BCDC_DCMD_IF_MASK	0xF000		/* I/F index */
+#define BCDC_DCMD_IF_SHIFT	12
+#define BCDC_DCMD_ID_MASK	0xFFFF0000	/* id an cmd pairing */
+#define BCDC_DCMD_ID_SHIFT	16		/* ID Mask shift bits */
+#define BCDC_DCMD_ID(flags)	\
+	(((flags) & BCDC_DCMD_ID_MASK) >> BCDC_DCMD_ID_SHIFT)
 
 /*
- * BDC header - Broadcom specific extension of CDC.
+ * BCDC header - Broadcom specific extension of CDC.
  * Used on data packets to convey priority across USB.
  */
-#define	BDC_HEADER_LEN		4
-#define BDC_PROTO_VER		2	/* Protocol version */
-#define BDC_FLAG_VER_MASK	0xf0	/* Protocol version mask */
-#define BDC_FLAG_VER_SHIFT	4	/* Protocol version shift */
-#define BDC_FLAG_SUM_GOOD	0x04	/* Good RX checksums */
-#define BDC_FLAG_SUM_NEEDED	0x08	/* Dongle needs to do TX checksums */
-#define BDC_PRIORITY_MASK	0x7
-#define BDC_FLAG2_IF_MASK	0x0f	/* packet rx interface in APSTA */
-#define BDC_FLAG2_IF_SHIFT	0
-
-#define BDC_GET_IF_IDX(hdr) \
-	((int)((((hdr)->flags2) & BDC_FLAG2_IF_MASK) >> BDC_FLAG2_IF_SHIFT))
-#define BDC_SET_IF_IDX(hdr, idx) \
-	((hdr)->flags2 = (((hdr)->flags2 & ~BDC_FLAG2_IF_MASK) | \
-	((idx) << BDC_FLAG2_IF_SHIFT)))
+#define	BCDC_HEADER_LEN		4
+#define BCDC_PROTO_VER		2	/* Protocol version */
+#define BCDC_FLAG_VER_MASK	0xf0	/* Protocol version mask */
+#define BCDC_FLAG_VER_SHIFT	4	/* Protocol version shift */
+#define BCDC_FLAG_SUM_GOOD	0x04	/* Good RX checksums */
+#define BCDC_FLAG_SUM_NEEDED	0x08	/* Dongle needs to do TX checksums */
+#define BCDC_PRIORITY_MASK	0x7
+#define BCDC_FLAG2_IF_MASK	0x0f	/* packet rx interface in APSTA */
+#define BCDC_FLAG2_IF_SHIFT	0
+
+#define BCDC_GET_IF_IDX(hdr) \
+	((int)((((hdr)->flags2) & BCDC_FLAG2_IF_MASK) >> BCDC_FLAG2_IF_SHIFT))
+#define BCDC_SET_IF_IDX(hdr, idx) \
+	((hdr)->flags2 = (((hdr)->flags2 & ~BCDC_FLAG2_IF_MASK) | \
+	((idx) << BCDC_FLAG2_IF_SHIFT)))
 
 /**
- * struct brcmf_proto_bdc_header - BDC header format
+ * struct brcmf_proto_bcdc_header - BCDC header format
  *
  * @flags: flags contain protocol and checksum info.
  * @priority: 802.1d priority and USB flow control info (bit 4:7).
  * @flags2: additional flags containing dongle interface index.
  * @data_offset: start of packet data. header is following by firmware signals.
  */
-struct brcmf_proto_bdc_header {
+struct brcmf_proto_bcdc_header {
 	u8 flags;
 	u8 priority;
 	u8 flags2;
@@ -91,7 +91,7 @@ struct brcmf_proto_bdc_header {
 
 /*
  * maximum length of firmware signal data between
- * the BDC header and packet data in the tx path.
+ * the BCDC header and packet data in the tx path.
  */
 #define BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES	12
 
@@ -109,42 +109,42 @@ struct brcmf_proto_bdc_header {
 struct brcmf_bcdc {
 	u16 reqid;
 	u8 bus_header[BUS_HEADER_LEN];
-	struct brcmf_proto_cdc_dcmd msg;
+	struct brcmf_proto_bcdc_dcmd msg;
 	unsigned char buf[BRCMF_DCMD_MAXLEN + ROUND_UP_MARGIN];
 };
 
-static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
+static int brcmf_proto_bcdc_msg(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 	int len = le32_to_cpu(bcdc->msg.len) +
-			sizeof(struct brcmf_proto_cdc_dcmd);
+			sizeof(struct brcmf_proto_bcdc_dcmd);
 
-	brcmf_dbg(CDC, "Enter\n");
+	brcmf_dbg(BCDC, "Enter\n");
 
-	/* NOTE : cdc->msg.len holds the desired length of the buffer to be
-	 *        returned. Only up to CDC_MAX_MSG_SIZE of this buffer area
+	/* NOTE : bcdc->msg.len holds the desired length of the buffer to be
+	 *        returned. Only up to BCDC_MAX_MSG_SIZE of this buffer area
 	 *        is actually sent to the dongle
 	 */
-	if (len > CDC_MAX_MSG_SIZE)
-		len = CDC_MAX_MSG_SIZE;
+	if (len > BCDC_MAX_MSG_SIZE)
+		len = BCDC_MAX_MSG_SIZE;
 
 	/* Send request */
 	return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&bcdc->msg, len);
 }
 
-static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
+static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 {
 	int ret;
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 
-	brcmf_dbg(CDC, "Enter\n");
-	len += sizeof(struct brcmf_proto_cdc_dcmd);
+	brcmf_dbg(BCDC, "Enter\n");
+	len += sizeof(struct brcmf_proto_bcdc_dcmd);
 	do {
 		ret = brcmf_bus_rxctl(drvr->bus_if, (unsigned char *)&bcdc->msg,
 				      len);
 		if (ret < 0)
 			break;
-	} while (CDC_DCMD_ID(le32_to_cpu(bcdc->msg.flags)) != id);
+	} while (BCDC_DCMD_ID(le32_to_cpu(bcdc->msg.flags)) != id);
 
 	return ret;
 }
@@ -154,40 +154,40 @@ brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 			    void *buf, uint len)
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
-	struct brcmf_proto_cdc_dcmd *msg = &bcdc->msg;
+	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
 	void *info;
 	int ret = 0, retries = 0;
 	u32 id, flags;
 
-	brcmf_dbg(CDC, "Enter, cmd %d len %d\n", cmd, len);
+	brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
 
-	memset(msg, 0, sizeof(struct brcmf_proto_cdc_dcmd));
+	memset(msg, 0, sizeof(struct brcmf_proto_bcdc_dcmd));
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
-	flags = (++bcdc->reqid << CDC_DCMD_ID_SHIFT);
-	flags = (flags & ~CDC_DCMD_IF_MASK) |
-		(ifidx << CDC_DCMD_IF_SHIFT);
+	flags = (++bcdc->reqid << BCDC_DCMD_ID_SHIFT);
+	flags = (flags & ~BCDC_DCMD_IF_MASK) |
+		(ifidx << BCDC_DCMD_IF_SHIFT);
 	msg->flags = cpu_to_le32(flags);
 
 	if (buf)
 		memcpy(bcdc->buf, buf, len);
 
-	ret = brcmf_proto_cdc_msg(drvr);
+	ret = brcmf_proto_bcdc_msg(drvr);
 	if (ret < 0) {
-		brcmf_err("brcmf_proto_cdc_msg failed w/status %d\n",
+		brcmf_err("brcmf_proto_bcdc_msg failed w/status %d\n",
 			  ret);
 		goto done;
 	}
 
 retry:
 	/* wait for interrupt and get first fragment */
-	ret = brcmf_proto_cdc_cmplt(drvr, bcdc->reqid, len);
+	ret = brcmf_proto_bcdc_cmplt(drvr, bcdc->reqid, len);
 	if (ret < 0)
 		goto done;
 
 	flags = le32_to_cpu(msg->flags);
-	id = (flags & CDC_DCMD_ID_MASK) >> CDC_DCMD_ID_SHIFT;
+	id = (flags & BCDC_DCMD_ID_MASK) >> BCDC_DCMD_ID_SHIFT;
 
 	if ((id < bcdc->reqid) && (++retries < RETRIES))
 		goto retry;
@@ -209,7 +209,7 @@ retry:
 	}
 
 	/* Check the ERROR flag */
-	if (flags & CDC_DCMD_ERROR)
+	if (flags & BCDC_DCMD_ERROR)
 		ret = le32_to_cpu(msg->status);
 
 done:
@@ -221,34 +221,34 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 			  void *buf, uint len)
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
-	struct brcmf_proto_cdc_dcmd *msg = &bcdc->msg;
+	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
 	int ret = 0;
 	u32 flags, id;
 
-	brcmf_dbg(CDC, "Enter, cmd %d len %d\n", cmd, len);
+	brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
 
-	memset(msg, 0, sizeof(struct brcmf_proto_cdc_dcmd));
+	memset(msg, 0, sizeof(struct brcmf_proto_bcdc_dcmd));
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
-	flags = (++bcdc->reqid << CDC_DCMD_ID_SHIFT) | CDC_DCMD_SET;
-	flags = (flags & ~CDC_DCMD_IF_MASK) |
-		(ifidx << CDC_DCMD_IF_SHIFT);
+	flags = (++bcdc->reqid << BCDC_DCMD_ID_SHIFT) | BCDC_DCMD_SET;
+	flags = (flags & ~BCDC_DCMD_IF_MASK) |
+		(ifidx << BCDC_DCMD_IF_SHIFT);
 	msg->flags = cpu_to_le32(flags);
 
 	if (buf)
 		memcpy(bcdc->buf, buf, len);
 
-	ret = brcmf_proto_cdc_msg(drvr);
+	ret = brcmf_proto_bcdc_msg(drvr);
 	if (ret < 0)
 		goto done;
 
-	ret = brcmf_proto_cdc_cmplt(drvr, bcdc->reqid, len);
+	ret = brcmf_proto_bcdc_cmplt(drvr, bcdc->reqid, len);
 	if (ret < 0)
 		goto done;
 
 	flags = le32_to_cpu(msg->flags);
-	id = (flags & CDC_DCMD_ID_MASK) >> CDC_DCMD_ID_SHIFT;
+	id = (flags & BCDC_DCMD_ID_MASK) >> BCDC_DCMD_ID_SHIFT;
 
 	if (id != bcdc->reqid) {
 		brcmf_err("%s: unexpected request id %d (expected %d)\n",
@@ -258,67 +258,56 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	}
 
 	/* Check the ERROR flag */
-	if (flags & CDC_DCMD_ERROR)
+	if (flags & BCDC_DCMD_ERROR)
 		ret = le32_to_cpu(msg->status);
 
 done:
 	return ret;
 }
 
-static bool pkt_sum_needed(struct sk_buff *skb)
-{
-	return skb->ip_summed == CHECKSUM_PARTIAL;
-}
-
-static void pkt_set_sum_good(struct sk_buff *skb, bool x)
-{
-	skb->ip_summed = (x ? CHECKSUM_UNNECESSARY : CHECKSUM_NONE);
-}
-
 static void
 brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
 			 struct sk_buff *pktbuf)
 {
-	struct brcmf_proto_bdc_header *h;
+	struct brcmf_proto_bcdc_header *h;
 
-	brcmf_dbg(CDC, "Enter\n");
+	brcmf_dbg(BCDC, "Enter\n");
 
 	/* Push BDC header used to convey priority for buses that don't */
-	skb_push(pktbuf, BDC_HEADER_LEN);
+	skb_push(pktbuf, BCDC_HEADER_LEN);
 
-	h = (struct brcmf_proto_bdc_header *)(pktbuf->data);
+	h = (struct brcmf_proto_bcdc_header *)(pktbuf->data);
 
-	h->flags = (BDC_PROTO_VER << BDC_FLAG_VER_SHIFT);
-	if (pkt_sum_needed(pktbuf))
-		h->flags |= BDC_FLAG_SUM_NEEDED;
+	h->flags = (BCDC_PROTO_VER << BCDC_FLAG_VER_SHIFT);
+	if (pktbuf->ip_summed == CHECKSUM_PARTIAL)
+		h->flags |= BCDC_FLAG_SUM_NEEDED;
 
-	h->priority = (pktbuf->priority & BDC_PRIORITY_MASK);
+	h->priority = (pktbuf->priority & BCDC_PRIORITY_MASK);
 	h->flags2 = 0;
 	h->data_offset = offset;
-	BDC_SET_IF_IDX(h, ifidx);
-	trace_brcmf_bdchdr(pktbuf->data);
+	BCDC_SET_IF_IDX(h, ifidx);
+	trace_brcmf_bcdchdr(pktbuf->data);
 }
 
 static int
 brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 			 struct sk_buff *pktbuf)
 {
-	struct brcmf_proto_bdc_header *h;
-
-	brcmf_dbg(CDC, "Enter\n");
+	struct brcmf_proto_bcdc_header *h;
 
-	/* Pop BDC header used to convey priority for buses that don't */
+	brcmf_dbg(BCDC, "Enter\n");
 
-	if (pktbuf->len <= BDC_HEADER_LEN) {
+	/* Pop BCDC header used to convey priority for buses that don't */
+	if (pktbuf->len <= BCDC_HEADER_LEN) {
 		brcmf_dbg(INFO, "rx data too short (%d <= %d)\n",
-			  pktbuf->len, BDC_HEADER_LEN);
+			  pktbuf->len, BCDC_HEADER_LEN);
 		return -EBADE;
 	}
 
-	trace_brcmf_bdchdr(pktbuf->data);
-	h = (struct brcmf_proto_bdc_header *)(pktbuf->data);
+	trace_brcmf_bcdchdr(pktbuf->data);
+	h = (struct brcmf_proto_bcdc_header *)(pktbuf->data);
 
-	*ifidx = BDC_GET_IF_IDX(h);
+	*ifidx = BCDC_GET_IF_IDX(h);
 	if (*ifidx >= BRCMF_MAX_IFS) {
 		brcmf_err("rx data ifnum out of range (%d)\n", *ifidx);
 		return -EBADE;
@@ -332,22 +321,22 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 	if (*ifidx)
 		(*ifidx)++;
 
-	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
-	    BDC_PROTO_VER) {
-		brcmf_err("%s: non-BDC packet received, flags 0x%x\n",
+	if (((h->flags & BCDC_FLAG_VER_MASK) >> BCDC_FLAG_VER_SHIFT) !=
+	    BCDC_PROTO_VER) {
+		brcmf_err("%s: non-BCDC packet received, flags 0x%x\n",
 			  brcmf_ifname(drvr, *ifidx), h->flags);
 		return -EBADE;
 	}
 
-	if (h->flags & BDC_FLAG_SUM_GOOD) {
-		brcmf_dbg(CDC, "%s: BDC rcv, good checksum, flags 0x%x\n",
+	if (h->flags & BCDC_FLAG_SUM_GOOD) {
+		brcmf_dbg(BCDC, "%s: BDC rcv, good checksum, flags 0x%x\n",
 			  brcmf_ifname(drvr, *ifidx), h->flags);
-		pkt_set_sum_good(pktbuf, true);
+		pktbuf->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
-	pktbuf->priority = h->priority & BDC_PRIORITY_MASK;
+	pktbuf->priority = h->priority & BCDC_PRIORITY_MASK;
 
-	skb_pull(pktbuf, BDC_HEADER_LEN);
+	skb_pull(pktbuf, BCDC_HEADER_LEN);
 	if (do_fws)
 		brcmf_fws_hdrpull(drvr, *ifidx, h->data_offset << 2, pktbuf);
 	else
@@ -378,9 +367,9 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 	drvr->proto->set_dcmd = brcmf_proto_bcdc_set_dcmd;
 	drvr->proto->pd = bcdc;
 
-	drvr->hdrlen += BDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
+	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
 	drvr->bus_if->maxctl = BRCMF_DCMD_MAXLEN +
-			sizeof(struct brcmf_proto_cdc_dcmd) + ROUND_UP_MARGIN;
+			sizeof(struct brcmf_proto_bcdc_dcmd) + ROUND_UP_MARGIN;
 	return 0;
 
 fail:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 0af1f5d..ef52ed7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -33,7 +33,7 @@
 #define BRCMF_USB_VAL	0x00002000
 #define BRCMF_SCAN_VAL	0x00004000
 #define BRCMF_CONN_VAL	0x00008000
-#define BRCMF_CDC_VAL	0x00010000
+#define BRCMF_BCDC_VAL	0x00010000
 #define BRCMF_SDIO_VAL	0x00020000
 
 /* set default print format */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
index d229cda..4d7d51f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
@@ -89,7 +89,7 @@ TRACE_EVENT(brcmf_hexdump,
 	TP_printk("hexdump [addr=%lx, length=%lu]", __entry->addr, __entry->len)
 );
 
-TRACE_EVENT(brcmf_bdchdr,
+TRACE_EVENT(brcmf_bcdchdr,
 	TP_PROTO(void *data),
 	TP_ARGS(data),
 	TP_STRUCT__entry(
@@ -107,7 +107,7 @@ TRACE_EVENT(brcmf_bdchdr,
 		memcpy(__get_dynamic_array(signal),
 		       (u8 *)data + 4, __entry->siglen);
 	),
-	TP_printk("bdc: prio=%d siglen=%d", __entry->prio, __entry->siglen)
+	TP_printk("bcdc: prio=%d siglen=%d", __entry->prio, __entry->siglen)
 );
 
 #ifndef SDPCM_RX
-- 
1.7.10.4



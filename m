Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:32343 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab3LLK7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:20 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 15/18] brcmfmac: Combine protocol push hdr and bus txdata.
Date: Thu, 12 Dec 2013 11:59:03 +0100
Message-ID: <1386845946-9859-16-git-send-email-arend@broadcom.com> (sfid-20131212_115930_140976_E379EA9F)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

For the transmission of data a protocol push hdr is performed
followed by a bus txdata call. For the new protocol msgbuf this
is not workable. Since they are already "loosely" coupled for
bcdc protocol they are combined. This means that txdata will
go "through" the protocol layer and a seperate protocol push
hdr will not be needed anymore.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |   11 +++++-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   37 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/proto.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    |   14 ++++----
 4 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index ee86142..12c27d1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -329,6 +329,15 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 	return 0;
 }
 
+static int
+brcmf_proto_bcdc_txdata(struct brcmf_pub *drvr, int ifidx, u8 offset,
+			struct sk_buff *pktbuf)
+{
+	brcmf_proto_bcdc_hdrpush(drvr, ifidx, offset, pktbuf);
+	return brcmf_bus_txdata(drvr->bus_if, pktbuf);
+}
+
+
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc;
@@ -343,10 +352,10 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 		goto fail;
 	}
 
-	drvr->proto->hdrpush = brcmf_proto_bcdc_hdrpush;
 	drvr->proto->hdrpull = brcmf_proto_bcdc_hdrpull;
 	drvr->proto->query_dcmd = brcmf_proto_bcdc_query_dcmd;
 	drvr->proto->set_dcmd = brcmf_proto_bcdc_set_dcmd;
+	drvr->proto->txdata = brcmf_proto_bcdc_txdata;
 	drvr->proto->pd = bcdc;
 
 	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index a593784..7918c10 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -838,7 +838,7 @@ static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 	brcmf_fws_hanger_cleanup(fws, matchfn, ifidx);
 }
 
-static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
+static u8 brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
 	u8 *wlh;
@@ -887,9 +887,7 @@ static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	if (fillers)
 		memset(wlh, BRCMF_FWS_TYPE_FILLER, fillers);
 
-	brcmf_proto_hdrpush(fws->drvr, brcmf_skb_if_flags_get_field(skb, INDEX),
-			    data_offset >> 2, skb);
-	return 0;
+	return (u8)(data_offset >> 2);
 }
 
 static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
@@ -897,10 +895,11 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 				 int fifo, bool send_immediately)
 {
 	struct sk_buff *skb;
-	struct brcmf_bus *bus;
 	struct brcmf_skbuff_cb *skcb;
 	s32 err;
 	u32 len;
+	u8 data_offset;
+	int ifidx;
 
 	/* check delayedQ and suppressQ in one call using bitmap */
 	if (brcmu_pktq_mlen(&entry->psq, 3 << (fifo * 2)) == 0)
@@ -928,13 +927,11 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 		skcb->state = BRCMF_FWS_SKBSTATE_TIM;
 		skcb->htod = 0;
 		skcb->htod_seq = 0;
-		bus = fws->drvr->bus_if;
-		err = brcmf_fws_hdrpush(fws, skb);
-		if (err == 0) {
-			brcmf_fws_unlock(fws);
-			err = brcmf_bus_txdata(bus, skb);
-			brcmf_fws_lock(fws);
-		}
+		data_offset = brcmf_fws_hdrpush(fws, skb);
+		ifidx = brcmf_skb_if_flags_get_field(skb, INDEX);
+		brcmf_fws_unlock(fws);
+		err = brcmf_proto_txdata(fws->drvr, ifidx, data_offset, skb);
+		brcmf_fws_lock(fws);
 		if (err)
 			brcmu_pkt_buf_free_skb(skb);
 		return true;
@@ -1719,7 +1716,7 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	return 0;
 }
 
-static void brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
+static u8 brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 				   struct sk_buff *p)
 {
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(p);
@@ -1737,7 +1734,7 @@ static void brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 		flags |= BRCMF_FWS_HTOD_FLAG_PKT_REQUESTED;
 	}
 	brcmf_skb_htod_tag_set_field(p, FLAGS, flags);
-	brcmf_fws_hdrpush(fws, p);
+	return brcmf_fws_hdrpush(fws, p);
 }
 
 static void brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
@@ -1805,20 +1802,21 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 {
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(skb);
 	struct brcmf_fws_mac_descriptor *entry;
-	struct brcmf_bus *bus = fws->drvr->bus_if;
 	int rc;
 	u8 ifidx;
+	u8 data_offset;
 
 	entry = skcb->mac;
 	if (IS_ERR(entry))
 		return PTR_ERR(entry);
 
-	brcmf_fws_precommit_skb(fws, fifo, skb);
+	data_offset = brcmf_fws_precommit_skb(fws, fifo, skb);
 	entry->transit_count++;
 	if (entry->suppressed)
 		entry->suppr_transit_count++;
+	ifidx = brcmf_skb_if_flags_get_field(skb, INDEX);
 	brcmf_fws_unlock(fws);
-	rc = brcmf_bus_txdata(bus, skb);
+	rc = brcmf_proto_txdata(fws->drvr, ifidx, data_offset, skb);
 	brcmf_fws_lock(fws);
 	brcmf_dbg(DATA, "%s flags %X htod %X bus_tx %d\n", entry->name,
 		  skcb->if_flags, skcb->htod, rc);
@@ -1979,10 +1977,9 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 							&skb, true);
 				ifidx = brcmf_skb_if_flags_get_field(skb,
 								     INDEX);
-				brcmf_proto_hdrpush(drvr, ifidx, 0, skb);
-				/* Use bus module to send data frame */
+				/* Use proto layer to send data frame */
 				brcmf_fws_unlock(fws);
-				ret = brcmf_bus_txdata(drvr->bus_if, skb);
+				ret = brcmf_proto_txdata(drvr, ifidx, 0, skb);
 				brcmf_fws_lock(fws);
 				if (ret < 0)
 					brcmf_txfinalize(drvr, skb, false);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
index 87eb2bd..b6b4641 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
@@ -39,7 +39,7 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 	if (brcmf_proto_bcdc_attach(drvr))
 		goto fail;
 
-	if ((proto->hdrpush == NULL) || (proto->hdrpull == NULL) ||
+	if ((proto->txdata == NULL) || (proto->hdrpull == NULL) ||
 	    (proto->query_dcmd == NULL) || (proto->set_dcmd == NULL)) {
 		brcmf_err("Not all proto handlers have been installed\n");
 		goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
index 8de1b3b..482fb0b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
@@ -17,14 +17,14 @@
 #define BRCMFMAC_PROTO_H
 
 struct brcmf_proto {
-	void (*hdrpush)(struct brcmf_pub *drvr, int ifidx, u8 offset,
-			struct sk_buff *skb);
 	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 		       struct sk_buff *skb);
 	int (*query_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
 			  void *buf, uint len);
 	int (*set_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
 			uint len);
+	int (*txdata)(struct brcmf_pub *drvr, int ifidx, u8 offset,
+		      struct sk_buff *skb);
 	void *pd;
 };
 
@@ -32,11 +32,6 @@ struct brcmf_proto {
 int brcmf_proto_attach(struct brcmf_pub *drvr);
 void brcmf_proto_detach(struct brcmf_pub *drvr);
 
-static inline void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
-				       u8 offset, struct sk_buff *skb)
-{
-	drvr->proto->hdrpush(drvr, ifidx, offset, skb);
-}
 static inline int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 				      u8 *ifidx, struct sk_buff *skb)
 {
@@ -52,6 +47,11 @@ static inline int brcmf_proto_set_dcmd(struct brcmf_pub *drvr, int ifidx,
 {
 	return drvr->proto->set_dcmd(drvr, ifidx, cmd, buf, len);
 }
+static inline int brcmf_proto_txdata(struct brcmf_pub *drvr, int ifidx,
+				       u8 offset, struct sk_buff *skb)
+{
+	return drvr->proto->txdata(drvr, ifidx, offset, skb);
+}
 
 
 #endif /* BRCMFMAC_PROTO_H */
-- 
1.7.10.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1792 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064Ab3FFLtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:49:45 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Dan Carpenter" <dan.carpenter@oracle.com>,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH V2 10/22] brcmfmac: Sent TIM information in case of data
 available.
Date: Thu, 6 Jun 2013 13:49:32 +0200
Message-ID: <1370519372-15559-1-git-send-email-arend@broadcom.com> (sfid-20130606_134950_980514_D8B8A562)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When data is available and fw signalling is enabled then TIM
information should be sent to firmware. If it can piggy back
on existing packet then do that otherwise create dummy packet
to get information out.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
This patch replaces:

Message-ID: <1370517487-14395-11-git-send-email-arend@broadcom.com>

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  167 ++++++++++++--------
 1 file changed, 103 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index abba7f7..758ddaf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -157,11 +157,13 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
  * @BRCMF_FWS_SKBSTATE_NEW: sk_buff is newly arrived in the driver.
  * @BRCMF_FWS_SKBSTATE_DELAYED: sk_buff had to wait on queue.
  * @BRCMF_FWS_SKBSTATE_SUPPRESSED: sk_buff has been suppressed by firmware.
+ * @BRCMF_FWS_SKBSTATE_TIM: allocated for TIM update info.
  */
 enum brcmf_fws_skb_state {
 	BRCMF_FWS_SKBSTATE_NEW,
 	BRCMF_FWS_SKBSTATE_DELAYED,
-	BRCMF_FWS_SKBSTATE_SUPPRESSED
+	BRCMF_FWS_SKBSTATE_SUPPRESSED,
+	BRCMF_FWS_SKBSTATE_TIM
 };
 
 /**
@@ -278,6 +280,7 @@ struct brcmf_skbuff_cb {
 /**
  * enum brcmf_fws_fifo - fifo indices used by dongle firmware.
  *
+ * @BRCMF_FWS_FIFO_FIRST: first fifo, ie. background.
  * @BRCMF_FWS_FIFO_AC_BK: fifo for background traffic.
  * @BRCMF_FWS_FIFO_AC_BE: fifo for best-effort traffic.
  * @BRCMF_FWS_FIFO_AC_VI: fifo for video traffic.
@@ -287,7 +290,8 @@ struct brcmf_skbuff_cb {
  * @BRCMF_FWS_FIFO_COUNT: number of fifos.
  */
 enum brcmf_fws_fifo {
-	BRCMF_FWS_FIFO_AC_BK,
+	BRCMF_FWS_FIFO_FIRST,
+	BRCMF_FWS_FIFO_AC_BK = BRCMF_FWS_FIFO_FIRST,
 	BRCMF_FWS_FIFO_AC_BE,
 	BRCMF_FWS_FIFO_AC_VI,
 	BRCMF_FWS_FIFO_AC_VO,
@@ -788,22 +792,95 @@ static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 	brcmf_fws_hanger_cleanup(fws, matchfn, ifidx);
 }
 
-static void brcmf_fws_tim_update(struct brcmf_fws_info *ctx,
-				 struct brcmf_fws_mac_descriptor *entry,
-				 int prec)
+static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
-	if (entry->state == BRCMF_FWS_STATE_CLOSE) {
-		/* check delayedQ and suppressQ in one call using bitmap */
-		if (brcmu_pktq_mlen(&entry->psq, 3 << (prec * 2)) == 0)
-			entry->traffic_pending_bmp =
-				entry->traffic_pending_bmp & ~NBITVAL(prec);
-		else
-			entry->traffic_pending_bmp =
-				entry->traffic_pending_bmp | NBITVAL(prec);
+	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
+	u8 *wlh;
+	u16 data_offset = 0;
+	u8 fillers;
+	__le32 pkttag = cpu_to_le32(brcmf_skbcb(skb)->htod);
+
+	brcmf_dbg(TRACE, "enter: ea=%pM, ifidx=%u (%u), pkttag=0x%08X, hslot=%d\n",
+		  entry->ea, entry->interface_id,
+		  brcmf_skb_if_flags_get_field(skb, INDEX),
+		  le32_to_cpu(pkttag), (le32_to_cpu(pkttag) >> 8) & 0xffff);
+	if (entry->send_tim_signal)
+		data_offset += 2 + BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
+
+	/* +2 is for Type[1] and Len[1] in TLV, plus TIM signal */
+	data_offset += 2 + BRCMF_FWS_TYPE_PKTTAG_LEN;
+	fillers = round_up(data_offset, 4) - data_offset;
+	data_offset += fillers;
+
+	skb_push(skb, data_offset);
+	wlh = skb->data;
+
+	wlh[0] = BRCMF_FWS_TYPE_PKTTAG;
+	wlh[1] = BRCMF_FWS_TYPE_PKTTAG_LEN;
+	memcpy(&wlh[2], &pkttag, sizeof(pkttag));
+	wlh += BRCMF_FWS_TYPE_PKTTAG_LEN + 2;
+
+	if (entry->send_tim_signal) {
+		entry->send_tim_signal = 0;
+		wlh[0] = BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP;
+		wlh[1] = BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
+		wlh[2] = entry->mac_handle;
+		wlh[3] = entry->traffic_pending_bmp;
+		brcmf_dbg(TRACE, "adding TIM info: %02X:%02X:%02X:%02X\n",
+			  wlh[0], wlh[1], wlh[2], wlh[3]);
+		wlh += BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2;
+		entry->traffic_lastreported_bmp = entry->traffic_pending_bmp;
 	}
-	/* request a TIM update to firmware at the next piggyback opportunity */
+	if (fillers)
+		memset(wlh, BRCMF_FWS_TYPE_FILLER, fillers);
+
+	brcmf_proto_hdrpush(fws->drvr, brcmf_skb_if_flags_get_field(skb, INDEX),
+			    data_offset >> 2, skb);
+	return 0;
+}
+
+static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
+				 struct brcmf_fws_mac_descriptor *entry,
+				 int prec, bool send_immediately)
+{
+	struct sk_buff *skb;
+	struct brcmf_bus *bus;
+	struct brcmf_skbuff_cb *skcb;
+	s32 err;
+	u32 len;
+
+	/* check delayedQ and suppressQ in one call using bitmap */
+	if (brcmu_pktq_mlen(&entry->psq, 3 << (prec * 2)) == 0)
+		entry->traffic_pending_bmp &= ~NBITVAL(prec);
+	else
+		entry->traffic_pending_bmp |= NBITVAL(prec);
+
+	entry->send_tim_signal = false;
 	if (entry->traffic_lastreported_bmp != entry->traffic_pending_bmp)
 		entry->send_tim_signal = true;
+	if (send_immediately && entry->send_tim_signal &&
+	    entry->state == BRCMF_FWS_STATE_CLOSE) {
+		/* create a dummy packet and sent that. The traffic          */
+		/* bitmap info will automatically be attached to that packet */
+		len = BRCMF_FWS_TYPE_PKTTAG_LEN + 2 +
+		      BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2 +
+		      4 + fws->drvr->hdrlen;
+		skb = brcmu_pkt_buf_get_skb(len);
+		if (skb == NULL)
+			return false;
+		skb_pull(skb, len);
+		skcb = brcmf_skbcb(skb);
+		skcb->mac = entry;
+		skcb->state = BRCMF_FWS_SKBSTATE_TIM;
+		bus = fws->drvr->bus_if;
+		err = brcmf_fws_hdrpush(fws, skb);
+		if (err == 0)
+			err = brcmf_bus_txdata(bus, skb);
+		if (err)
+			brcmu_pkt_buf_free_skb(skb);
+		return true;
+	}
+	return false;
 }
 
 static void
@@ -891,7 +968,6 @@ static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
 {
 	struct brcmf_fws_mac_descriptor *entry;
 	u8 mac_handle;
-	int i;
 
 	mac_handle = data[0];
 	entry = &fws->desc.nodes[mac_handle & 0x1F];
@@ -899,18 +975,18 @@ static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
 		fws->stats.mac_ps_update_failed++;
 		return -ESRCH;
 	}
-
-	brcmf_dbg(TRACE, "%s (%d): %s\n", brcmf_fws_get_tlv_name(type), type,
-		  entry->name);
-	/* a state update should wipe old credits? */
+	/* a state update should wipe old credits */
 	entry->requested_credit = 0;
+	entry->requested_packet = 0;
 	if (type == BRCMF_FWS_TYPE_MAC_OPEN) {
 		entry->state = BRCMF_FWS_STATE_OPEN;
 		return BRCMF_FWS_RET_OK_SCHEDULE;
 	} else {
 		entry->state = BRCMF_FWS_STATE_CLOSE;
-		for (i = BRCMF_FWS_FIFO_AC_BE; i < NL80211_NUM_ACS; i++)
-			brcmf_fws_tim_update(fws, entry, i);
+		brcmf_fws_tim_update(fws, entry, BRCMF_FWS_FIFO_AC_BK, false);
+		brcmf_fws_tim_update(fws, entry, BRCMF_FWS_FIFO_AC_BE, false);
+		brcmf_fws_tim_update(fws, entry, BRCMF_FWS_FIFO_AC_VI, false);
+		brcmf_fws_tim_update(fws, entry, BRCMF_FWS_FIFO_AC_VO, true);
 	}
 	return BRCMF_FWS_RET_OK_NOSCHEDULE;
 }
@@ -1111,7 +1187,7 @@ static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 	 * A packet has been pushed so update traffic
 	 * availability bitmap, if applicable
 	 */
-	brcmf_fws_tim_update(fws, entry, fifo);
+	brcmf_fws_tim_update(fws, entry, fifo, true);
 	brcmf_fws_flow_control_check(fws, &entry->psq,
 				     brcmf_skb_if_flags_get_field(p, INDEX));
 	return 0;
@@ -1168,7 +1244,7 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 		 * A packet has been picked up, update traffic
 		 * availability bitmap, if applicable
 		 */
-		brcmf_fws_tim_update(fws, entry, fifo);
+		brcmf_fws_tim_update(fws, entry, fifo, false);
 
 		/*
 		 * decrement total enqueued fifo packets and
@@ -1500,47 +1576,6 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	return 0;
 }
 
-static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
-{
-	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
-	u8 *wlh;
-	u16 data_offset = 0;
-	u8 fillers;
-	__le32 pkttag = cpu_to_le32(brcmf_skbcb(skb)->htod);
-
-	if (entry->send_tim_signal)
-		data_offset += 2 + BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
-
-	/* +2 is for Type[1] and Len[1] in TLV, plus TIM signal */
-	data_offset += 2 + BRCMF_FWS_TYPE_PKTTAG_LEN;
-	fillers = round_up(data_offset, 4) - data_offset;
-	data_offset += fillers;
-
-	skb_push(skb, data_offset);
-	wlh = skb->data;
-
-	wlh[0] = BRCMF_FWS_TYPE_PKTTAG;
-	wlh[1] = BRCMF_FWS_TYPE_PKTTAG_LEN;
-	memcpy(&wlh[2], &pkttag, sizeof(pkttag));
-	wlh += BRCMF_FWS_TYPE_PKTTAG_LEN + 2;
-
-	if (entry->send_tim_signal) {
-		entry->send_tim_signal = 0;
-		wlh[0] = BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP;
-		wlh[1] = BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
-		wlh[2] = entry->mac_handle;
-		wlh[3] = entry->traffic_pending_bmp;
-		wlh += BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2;
-		entry->traffic_lastreported_bmp = entry->traffic_pending_bmp;
-	}
-	if (fillers)
-		memset(wlh, BRCMF_FWS_TYPE_FILLER, fillers);
-
-	brcmf_proto_hdrpush(fws->drvr, brcmf_skb_if_flags_get_field(skb, INDEX),
-			    data_offset >> 2, skb);
-	return 0;
-}
-
 static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 				   struct sk_buff *p)
 {
@@ -2013,6 +2048,10 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	ulong flags;
 	int fifo;
 
+	if (brcmf_skbcb(skb)->state == BRCMF_FWS_SKBSTATE_TIM) {
+		brcmu_pkt_buf_free_skb(skb);
+		return;
+	}
 	brcmf_fws_lock(fws->drvr, flags);
 	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_FW_TOSSED,
 				   brcmf_skb_htod_tag_get_field(skb, HSLOT), 0);
-- 
1.7.10.4



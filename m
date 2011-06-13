Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:36452 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1FMWh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:37:58 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id D3FB7C7DBC
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:56 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id A3E502BD42
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:55 +0300 (EEST)
Subject: [PATCH v2 22/27] mac80211: rename ieee80211_sub_if_data_flags to
	mac80211_sub_if_data_flags
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:37:55 +0300
Message-ID: <20110613223754.10517.63706.stgit@localhost6.localdomain6> (sfid-20110614_005722_850718_F9415C46)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also convert enum sdata_queue_type at the same time.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/agg-tx.c     |    4 ++--
 net/mac80211/cfg.c        |    4 ++--
 net/mac80211/iface.c      |   20 ++++++++++----------
 net/mac80211/mac80211_i.h |   26 +++++++++++++-------------
 net/mac80211/mlme.c       |    4 ++--
 net/mac80211/rx.c         |    8 ++++----
 net/mac80211/tx.c         |    2 +-
 net/mac80211/util.c       |   12 ++++++------
 8 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index a725f8a..d45743b 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -586,7 +586,7 @@ void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 	memcpy(&ra_tid->ra, ra, ETH_ALEN);
 	ra_tid->tid = tid;
 
-	skb->pkt_type = IEEE80211_SDATA_QUEUE_AGG_START;
+	skb->pkt_type = MAC80211_SDATA_QUEUE_AGG_START;
 	skb_queue_tail(&sdata->skb_queue, skb);
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
@@ -739,7 +739,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 	memcpy(&ra_tid->ra, ra, ETH_ALEN);
 	ra_tid->tid = tid;
 
-	skb->pkt_type = IEEE80211_SDATA_QUEUE_AGG_STOP;
+	skb->pkt_type = MAC80211_SDATA_QUEUE_AGG_STOP;
 	skb_queue_tail(&sdata->skb_queue, skb);
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 71ae366..40ba6be 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1212,9 +1212,9 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 
 	if (params->ap_isolate >= 0) {
 		if (params->ap_isolate)
-			sdata->flags |= IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
+			sdata->flags |= MAC80211_SDATA_DONT_BRIDGE_PACKETS;
 		else
-			sdata->flags &= ~IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
+			sdata->flags &= ~MAC80211_SDATA_DONT_BRIDGE_PACKETS;
 	}
 
 	if (params->ht_opmode >= 0) {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f28f68d..ccdc564 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -316,10 +316,10 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	 * which will check whether any increments here were done in
 	 * error and sync them down to the hardware as filter flags.
 	 */
-	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
+	if (sdata->flags & MAC80211_SDATA_ALLMULTI)
 		atomic_inc(&local->iff_allmultis);
 
-	if (sdata->flags & IEEE80211_SDATA_PROMISC)
+	if (sdata->flags & MAC80211_SDATA_PROMISC)
 		atomic_inc(&local->iff_promiscs);
 
 	mutex_lock(&local->mtx);
@@ -421,10 +421,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	 * on the master interface which will sync these down to the
 	 * hardware as filter flags.
 	 */
-	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
+	if (sdata->flags & MAC80211_SDATA_ALLMULTI)
 		atomic_dec(&local->iff_allmultis);
 
-	if (sdata->flags & IEEE80211_SDATA_PROMISC)
+	if (sdata->flags & MAC80211_SDATA_PROMISC)
 		atomic_dec(&local->iff_promiscs);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
@@ -584,15 +584,15 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 
 	allmulti = !!(dev->flags & IFF_ALLMULTI);
 	promisc = !!(dev->flags & IFF_PROMISC);
-	sdata_allmulti = !!(sdata->flags & IEEE80211_SDATA_ALLMULTI);
-	sdata_promisc = !!(sdata->flags & IEEE80211_SDATA_PROMISC);
+	sdata_allmulti = !!(sdata->flags & MAC80211_SDATA_ALLMULTI);
+	sdata_promisc = !!(sdata->flags & MAC80211_SDATA_PROMISC);
 
 	if (allmulti != sdata_allmulti) {
 		if (dev->flags & IFF_ALLMULTI)
 			atomic_inc(&local->iff_allmultis);
 		else
 			atomic_dec(&local->iff_allmultis);
-		sdata->flags ^= IEEE80211_SDATA_ALLMULTI;
+		sdata->flags ^= MAC80211_SDATA_ALLMULTI;
 	}
 
 	if (promisc != sdata_promisc) {
@@ -600,7 +600,7 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 			atomic_inc(&local->iff_promiscs);
 		else
 			atomic_dec(&local->iff_promiscs);
-		sdata->flags ^= IEEE80211_SDATA_PROMISC;
+		sdata->flags ^= MAC80211_SDATA_PROMISC;
 	}
 	spin_lock_bh(&local->filter_lock);
 	__hw_addr_sync(&local->mc_list, &dev->mc, dev->addr_len);
@@ -730,11 +730,11 @@ static void ieee80211_iface_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
 		struct ieee80211_mgmt *mgmt = (void *)skb->data;
 
-		if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_START) {
+		if (skb->pkt_type == MAC80211_SDATA_QUEUE_AGG_START) {
 			ra_tid = (void *)&skb->cb;
 			ieee80211_start_tx_ba_cb(&sdata->vif, ra_tid->ra,
 						 ra_tid->tid);
-		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_STOP) {
+		} else if (skb->pkt_type == MAC80211_SDATA_QUEUE_AGG_STOP) {
 			ra_tid = (void *)&skb->cb;
 			ieee80211_stop_tx_ba_cb(&sdata->vif, ra_tid->ra,
 						ra_tid->tid);
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index cd80074..df53135 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -507,20 +507,20 @@ struct mac80211_if_mesh {
 #endif
 
 /**
- * enum ieee80211_sub_if_data_flags - virtual interface flags
+ * enum mac80211_sub_if_data_flags - virtual interface flags
  *
- * @IEEE80211_SDATA_ALLMULTI: interface wants all multicast packets
- * @IEEE80211_SDATA_PROMISC: interface is promisc
- * @IEEE80211_SDATA_OPERATING_GMODE: operating in G-only mode
- * @IEEE80211_SDATA_DONT_BRIDGE_PACKETS: bridge packets between
+ * @MAC80211_SDATA_ALLMULTI: interface wants all multicast packets
+ * @MAC80211_SDATA_PROMISC: interface is promisc
+ * @MAC80211_SDATA_OPERATING_GMODE: operating in G-only mode
+ * @MAC80211_SDATA_DONT_BRIDGE_PACKETS: bridge packets between
  *	associated stations and deliver multicast frames both
  *	back to wireless media and to the local net stack.
  */
-enum ieee80211_sub_if_data_flags {
-	IEEE80211_SDATA_ALLMULTI		= BIT(0),
-	IEEE80211_SDATA_PROMISC			= BIT(1),
-	IEEE80211_SDATA_OPERATING_GMODE		= BIT(2),
-	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
+enum mac80211_sub_if_data_flags {
+	MAC80211_SDATA_ALLMULTI		= BIT(0),
+	MAC80211_SDATA_PROMISC			= BIT(1),
+	MAC80211_SDATA_OPERATING_GMODE		= BIT(2),
+	MAC80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
 };
 
 /**
@@ -622,9 +622,9 @@ struct ieee80211_sub_if_data *vif_to_sdata(struct ieee80211_vif *p)
 }
 
 enum sdata_queue_type {
-	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
-	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
-	IEEE80211_SDATA_QUEUE_AGG_STOP		= 2,
+	MAC80211_SDATA_QUEUE_TYPE_FRAME	= 0,
+	MAC80211_SDATA_QUEUE_AGG_START		= 1,
+	MAC80211_SDATA_QUEUE_AGG_STOP		= 2,
 };
 
 enum {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6f99524..77fe8a7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1521,9 +1521,9 @@ static bool ieee80211_assoc_success(struct mac80211_work *wk,
 	/* cf. IEEE 802.11 9.2.12 */
 	if (wk->chan->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
-		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+		sdata->flags |= MAC80211_SDATA_OPERATING_GMODE;
 	else
-		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
+		sdata->flags &= ~MAC80211_SDATA_OPERATING_GMODE;
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & MAC80211_STA_DISABLE_11N))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3c55ec4..d4c83cb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -781,7 +781,7 @@ static void ieee80211_rx_reorder_ampdu(struct mac80211_rx_data *rx)
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
-		skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
+		skb->pkt_type = MAC80211_SDATA_QUEUE_TYPE_FRAME;
 		skb_queue_tail(&rx->sdata->skb_queue, skb);
 		ieee80211_queue_work(&local->hw, &rx->sdata->work);
 		return;
@@ -1674,7 +1674,7 @@ ieee80211_deliver_skb(struct mac80211_rx_data *rx)
 
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
-	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
+	    !(sdata->flags & MAC80211_SDATA_DONT_BRIDGE_PACKETS) &&
 	    (status->rx_flags & MAC80211_RX_RA_MATCH) &&
 	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->u.vlan.sta)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
@@ -2234,7 +2234,7 @@ ieee80211_rx_h_action(struct mac80211_rx_data *rx)
 	return RX_QUEUED;
 
  queue:
-	rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
+	rx->skb->pkt_type = MAC80211_SDATA_QUEUE_TYPE_FRAME;
 	skb_queue_tail(&sdata->skb_queue, rx->skb);
 	ieee80211_queue_work(&local->hw, &sdata->work);
 	if (rx->sta)
@@ -2364,7 +2364,7 @@ ieee80211_rx_h_mgmt(struct mac80211_rx_data *rx)
 	}
 
 	/* queue up frame and kick off work to process it */
-	rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
+	rx->skb->pkt_type = MAC80211_SDATA_QUEUE_TYPE_FRAME;
 	skb_queue_tail(&sdata->skb_queue, rx->skb);
 	ieee80211_queue_work(&rx->local->hw, &sdata->work);
 	if (rx->sta)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 151b9f8..ab8a71f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -126,7 +126,7 @@ static __le16 ieee80211_duration(struct mac80211_tx_data *tx, int group_addr,
 		switch (sband->band) {
 		case IEEE80211_BAND_2GHZ: {
 			u32 flag;
-			if (tx->sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+			if (tx->sdata->flags & MAC80211_SDATA_OPERATING_GMODE)
 				flag = IEEE80211_RATE_MANDATORY_G;
 			else
 				flag = IEEE80211_RATE_MANDATORY_B;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 40b0fbe..3766f2e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -174,7 +174,7 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 	if (vif) {
 		sdata = vif_to_sdata(vif);
 		short_preamble = sdata->vif.bss_conf.use_short_preamble;
-		if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+		if (sdata->flags & MAC80211_SDATA_OPERATING_GMODE)
 			erp = rate->flags & IEEE80211_RATE_ERP_G;
 	}
 
@@ -207,7 +207,7 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 	if (vif) {
 		sdata = vif_to_sdata(vif);
 		short_preamble = sdata->vif.bss_conf.use_short_preamble;
-		if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+		if (sdata->flags & MAC80211_SDATA_OPERATING_GMODE)
 			erp = rate->flags & IEEE80211_RATE_ERP_G;
 	}
 
@@ -247,7 +247,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 	if (vif) {
 		sdata = vif_to_sdata(vif);
 		short_preamble = sdata->vif.bss_conf.use_short_preamble;
-		if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+		if (sdata->flags & MAC80211_SDATA_OPERATING_GMODE)
 			erp = rate->flags & IEEE80211_RATE_ERP_G;
 	}
 
@@ -753,7 +753,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 	memset(&qparam, 0, sizeof(qparam));
 
 	use_11b = (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) &&
-		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
+		 !(sdata->flags & MAC80211_SDATA_OPERATING_GMODE);
 
 	for (queue = 0; queue < local_to_hw(local)->queues; queue++) {
 		/* Set defaults according to 802.11-2007 Table 7-37 */
@@ -826,9 +826,9 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 
 	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
-		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+		sdata->flags |= MAC80211_SDATA_OPERATING_GMODE;
 	else
-		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
+		sdata->flags &= ~MAC80211_SDATA_OPERATING_GMODE;
 
 	ieee80211_set_wmm_default(sdata);
 }


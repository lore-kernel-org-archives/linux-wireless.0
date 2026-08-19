Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB732EB856
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787144472; cv=none; b=YNPn1jWBQM5Tk3XNBS3F7/c/YnfTWR4DBBYkCkn+Qhl2Ca+IGYthp14M6sR6O+7wnDNYP/0CUCjfgn8SNBCUSH4HefkCeYIut0x3Z/zXGep0q+uSNxwk4x7R0Hlr1rPXLjZJs3u/bqjHvuBd7qWopI+2e6yvJXLZDWCzfr4LR8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787144472; c=relaxed/simple;
	bh=2dyIxUsqZm1vVmtYqF9L4idjdjgjIjjRi6sS6UuCfIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBSj1pwIWq7OXyJwpxzeIdG+rv01c/a2PyoN95Oo5/7BXzeuF15cjyFDYwfprjJDpImyK8b2ARpZ/cF4UdJkFbb56SlswMXlpRonjcXJv/PP3xi7u7jcnqOR7O4ZwcOX64Dl5KiBrRGcaS1jS3R5Au64Ewtb9CZ6QG5d97c4GlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=eLK1H8QO; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="eLK1H8QO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Bns12clAQ3XC0oDns07cw7yh6MAWFkZo/sx2ssRFbkI=;
	t=1787144470; x=1788354070; b=eLK1H8QOBBtlrZ3BkBYXEHaQmTfXIAPg/sT0vBlqEU8bEKx
	NM4ZRf2Wry1aLKKu++fq6gndbHSDNv3VziMk/dOp3hixxyp9LeSwH/UrCmbRKJbT+q8IV/tZ1DhPs
	7wkFFo6+l4r+YTvsRjMqRWC+Vqp2g6W+50XQYFJ84NFSUHwM3QBYZGWLQo/6byL1KJLwuEZyQ8Ttw
	MiOG8xD0V4gqKy3KJdCquaoRteXKH/h/zn/PFOsesbsYQQJB2g30EUcba92VZxbOQgdz3xOEr4dQm
	b7SLjpmJ6inEBKCQ2YDmqUIvJYRyg1OD8sxhdjU0CZLU/k0p+bSr936XvPyXl5qA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wwfbD-000000089Cs-31S8;
	Wed, 19 Aug 2026 14:40:56 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [wireless-next PATCH v2 3/8] wifi: mac80211: refactor RX link_id and station handling
Date: Wed, 19 Aug 2026 14:39:02 +0200
Message-ID: <20260819143858.7740fbad5412.I8abe3601d0335dca22d48bcee864817cfccf0de0@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819123858.4025935-10-benjamin@sipsolutions.net>
References: <20260819123858.4025935-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

The link ID for one frequency may be different between VIFs. As such,
the sensible thing is to set the link ID later in the flow once the SKB
is duplicated for each VIF. As the link ID is not passed in from outside
mac80211 it is always valid and the corresponding bit can be dropped.

Also switch a few more places to pass the link STA as that is a natural
way to pass the link information around.

This fixes the per-link statistics when frames are reordered.

Note that this patch deliberately leaves some places unchanged and even
incorrect as this will be addressed by further refactorings.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>

---

v2:
* Use deflink link_sta for non-MLO stations on MLD AP interface
---
 include/net/mac80211.h |   9 +-
 net/mac80211/ap.c      |   3 -
 net/mac80211/iface.c   |   7 +-
 net/mac80211/mlme.c    |  10 +-
 net/mac80211/rx.c      | 211 ++++++++++++++++++-----------------------
 net/mac80211/scan.c    |  10 +-
 6 files changed, 106 insertions(+), 144 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bc98fed6bc4c..7aae728e96d8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1770,10 +1770,9 @@ enum mac80211_rx_encoding {
  * @ampdu_reference: A-MPDU reference number, must be a different value for
  *	each A-MPDU but the same for each subframe within one A-MPDU
  * @zero_length_psdu_type: radiotap type of the 0-length PSDU
- * @link_valid: if the link which is identified by @link_id is valid. This flag
- *	is set only when connection is MLO.
- * @link_id: id of the link used to receive the packet. This is used along with
- *	@link_valid.
+ * @link_id: id of the link used to receive the packet. Set and used by
+ *	mac80211 internally, it uses @freq set by the driver to identify the
+ *	correct link per vif.
  */
 struct ieee80211_rx_status {
 	u64 mactime;
@@ -1813,7 +1812,7 @@ struct ieee80211_rx_status {
 	u8 chains;
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 	u8 zero_length_psdu_type;
-	u8 link_valid:1, link_id:4;
+	u8 link_id:4;
 };
 
 static_assert(sizeof(struct ieee80211_rx_status) <= sizeof_field(struct sk_buff, cb));
diff --git a/net/mac80211/ap.c b/net/mac80211/ap.c
index e7ac99c5a22e..fe255891c35f 100644
--- a/net/mac80211/ap.c
+++ b/net/mac80211/ap.c
@@ -82,9 +82,6 @@ ieee80211_rx_eml_op_mode_notif(struct ieee80211_sub_if_data *sdata,
 	if (!ift_ext_capa)
 		return;
 
-	if (!status->link_valid)
-		return;
-
 	sta = sta_info_get_bss(sdata, mgmt->sa);
 	if (!sta)
 		return;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 43460a705a6b..a0b214dbb8af 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1673,11 +1673,8 @@ static void ieee80211_iface_process_skb(struct ieee80211_local *local,
 				break;
 
 			status = IEEE80211_SKB_RXCB(skb);
-			if (!status->link_valid)
-				link_sta = &sta->deflink;
-			else
-				link_sta = rcu_dereference_protected(sta->link[status->link_id],
-							lockdep_is_held(&local->hw.wiphy->mtx));
+			link_sta = wiphy_dereference(local->hw.wiphy,
+						     sta->link[status->link_id]);
 			if (link_sta)
 				ieee80211_ht_handle_chanwidth_notif(local, sdata, sta,
 								    link_sta, chanwidth,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f51167f0fc46..361775fb931e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -11831,12 +11831,10 @@ void ieee80211_sta_rx_queued_frame(struct ieee80211_sub_if_data *sdata,
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
 	fc = le16_to_cpu(mgmt->frame_control);
 
-	if (rx_status->link_valid) {
-		link = sdata_dereference(sdata->link[rx_status->link_id],
-					 sdata);
-		if (!link)
-			return;
-	}
+	link = sdata_dereference(sdata->link[rx_status->link_id],
+				 sdata);
+	if (!link)
+		return;
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_BEACON:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index adb8fc1e20e1..b654b2d57f15 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -222,43 +222,21 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 }
 
 static void __ieee80211_queue_skb_to_iface(struct ieee80211_sub_if_data *sdata,
-					   int link_id,
-					   struct sta_info *sta,
+					   struct link_sta_info *link_sta,
 					   struct sk_buff *skb)
 {
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-
-	if (link_id >= 0) {
-		status->link_valid = 1;
-		status->link_id = link_id;
-	} else {
-		status->link_valid = 0;
-	}
-
 	skb_queue_tail(&sdata->skb_queue, skb);
 	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
-	if (sta) {
-		struct link_sta_info *link_sta_info;
-
-		if (link_id >= 0) {
-			link_sta_info = rcu_dereference(sta->link[link_id]);
-			if (!link_sta_info)
-				return;
-		} else {
-			link_sta_info = &sta->deflink;
-		}
-
-		link_sta_info->rx_stats.packets++;
-	}
+	if (link_sta)
+		link_sta->rx_stats.packets++;
 }
 
 static void ieee80211_queue_skb_to_iface(struct ieee80211_sub_if_data *sdata,
-					 int link_id,
-					 struct sta_info *sta,
+					 struct link_sta_info *link_sta,
 					 struct sk_buff *skb)
 {
 	skb->protocol = 0;
-	__ieee80211_queue_skb_to_iface(sdata, link_id, sta, skb);
+	__ieee80211_queue_skb_to_iface(sdata, link_sta, skb);
 }
 
 static void ieee80211_handle_mu_mimo_mon(struct ieee80211_sub_if_data *sdata,
@@ -301,7 +279,7 @@ static void ieee80211_handle_mu_mimo_mon(struct ieee80211_sub_if_data *sdata,
 	if (!skb)
 		return;
 
-	ieee80211_queue_skb_to_iface(sdata, -1, NULL, skb);
+	ieee80211_queue_skb_to_iface(sdata, NULL, skb);
 }
 
 /*
@@ -1498,7 +1476,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
-		ieee80211_queue_skb_to_iface(rx->sdata, rx->link_id, NULL, skb);
+		ieee80211_queue_skb_to_iface(rx->sdata, NULL, skb);
 		return;
 	}
 
@@ -2524,7 +2502,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
  out:
 	ieee80211_led_rx(rx->local);
-	if (rx->sta)
+	if (rx->link_sta)
 		rx->link_sta->rx_stats.packets++;
 	return RX_CONTINUE;
 }
@@ -3335,8 +3313,8 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 		    (tf->action_code == WLAN_TDLS_CHANNEL_SWITCH_REQUEST ||
 		     tf->action_code == WLAN_TDLS_CHANNEL_SWITCH_RESPONSE)) {
 			rx->skb->protocol = cpu_to_be16(ETH_P_TDLS);
-			__ieee80211_queue_skb_to_iface(sdata, rx->link_id,
-						       rx->sta, rx->skb);
+			__ieee80211_queue_skb_to_iface(sdata, rx->link_sta,
+						       rx->skb);
 			return RX_QUEUED;
 		}
 	}
@@ -3991,7 +3969,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 
  queue:
-	ieee80211_queue_skb_to_iface(sdata, rx->link_id, rx->sta, rx->skb);
+	ieee80211_queue_skb_to_iface(sdata, rx->link_sta, rx->skb);
 	return RX_QUEUED;
 }
 
@@ -4147,7 +4125,7 @@ ieee80211_rx_h_ext(struct ieee80211_rx_data *rx)
 		return RX_DROP_U_UNEXPECTED_EXT_FRAME;
 
 	/* for now only beacons are ext, so queue them */
-	ieee80211_queue_skb_to_iface(sdata, rx->link_id, rx->sta, rx->skb);
+	ieee80211_queue_skb_to_iface(sdata, rx->link_sta, rx->skb);
 
 	return RX_QUEUED;
 }
@@ -4204,7 +4182,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 		return RX_DROP_U_UNHANDLED_MGMT_STYPE;
 	}
 
-	ieee80211_queue_skb_to_iface(sdata, rx->link_id, rx->sta, rx->skb);
+	ieee80211_queue_skb_to_iface(sdata, rx->link_sta, rx->skb);
 
 	return RX_QUEUED;
 }
@@ -4248,12 +4226,28 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 	spin_lock_bh(&rx->local->rx_path_lock);
 
 	while ((skb = __skb_dequeue(frames))) {
+		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+
 		/*
-		 * all the other fields are valid across frames
-		 * that belong to an aMPDU since they are on the
-		 * same TID from the same station
+		 * Most fields are valid across frames. However,
+		 * in the case of reordering frames may have arrived
+		 * on different links, so adjust the link_id, link
+		 * and link_sta accordingly.
 		 */
 		rx->skb = skb;
+		if (ieee80211_vif_is_mld(&rx->sdata->vif) &&
+		    unlikely(rx->link_id != status->link_id)) {
+			if (rx->sta) {
+				rx->link_sta =
+					rcu_dereference(rx->sta->link[rx->link_id]);
+
+				/* Link got disabled, just use deflink */
+				if (!rx->link_sta)
+					rx->link_sta = &rx->sta->deflink;
+			}
+			rx->link_id = status->link_id;
+			rx->link = rcu_dereference(rx->sdata->link[status->link_id]);
+		}
 
 		if (WARN_ON_ONCE(!rx->link)) {
 			res = RX_DROP_U_NO_LINK;
@@ -4323,7 +4317,10 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 static bool
 ieee80211_rx_is_valid_sta_link_id(struct ieee80211_sta *sta, u8 link_id)
 {
-	return !!(sta->valid_links & BIT(link_id));
+	if (sta->mlo)
+		return !!(sta->valid_links & BIT(link_id));
+	else
+		return sta->deflink.link_id == link_id;
 }
 
 static bool ieee80211_rx_data_set_link(struct ieee80211_rx_data *rx,
@@ -4360,11 +4357,13 @@ static bool ieee80211_rx_data_set_sta(struct ieee80211_rx_data *rx,
 
 	if (link_id < 0) {
 		if (ieee80211_vif_is_mld(&rx->sdata->vif) &&
-		    sta && !sta->sta.valid_links)
+		    sta && !sta->sta.valid_links) {
 			rx->link =
 				rcu_dereference(rx->sdata->link[sta->deflink.link_id]);
-		else
+			rx->link_sta = &sta->deflink;
+		} else {
 			rx->link = &rx->sdata->deflink;
+		}
 	} else if (!ieee80211_rx_data_set_link(rx, link_id)) {
 		return false;
 	}
@@ -4387,7 +4386,7 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 	struct tid_ampdu_rx *tid_agg_rx;
 	int link_id = -1;
 
-	/* FIXME: statistics won't be right with this */
+	/* NOTE: the correct link STA for the frame is set later */
 	if (sta->sta.valid_links)
 		link_id = ffs(sta->sta.valid_links) - 1;
 
@@ -4914,20 +4913,14 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 {
 	struct ieee80211_sta_rx_stats *stats;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
-	struct sta_info *sta = rx->sta;
-	struct link_sta_info *link_sta;
+	struct link_sta_info *link_sta = rx->link_sta;
 	struct sk_buff *skb = rx->skb;
 	void *sa = skb->data + ETH_ALEN;
 	void *da = skb->data;
 
-	if (rx->link_id >= 0) {
-		link_sta = rcu_dereference(sta->link[rx->link_id]);
-		if (WARN_ON_ONCE(!link_sta)) {
-			dev_kfree_skb(rx->skb);
-			return;
-		}
-	} else {
-		link_sta = &sta->deflink;
+	if (WARN_ON_ONCE(!link_sta)) {
+		dev_kfree_skb(rx->skb);
+		return;
 	}
 
 	stats = &link_sta->rx_stats;
@@ -5154,6 +5147,9 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 		goto drop;
 	}
 
+	status = IEEE80211_SKB_RXCB(skb);
+	status->link_id = rx->link_id < 0 ? 0 : rx->link_id;
+
 	ieee80211_rx_8023(rx, fast_rx, orig_len);
 
 	return true;
@@ -5178,6 +5174,7 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct link_sta_info *link_sta = rx->link_sta;
 	struct ieee80211_link_data *link = rx->link;
+	struct ieee80211_rx_status *status;
 
 	rx->skb = skb;
 
@@ -5221,6 +5218,9 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 		hdr = (struct ieee80211_hdr *)rx->skb->data;
 	}
 
+	status = IEEE80211_SKB_RXCB(rx->skb);
+	status->link_id = rx->link_id < 0 ? 0 : rx->link_id;
+
 	if (ieee80211_is_s1g_beacon(hdr->frame_control)) {
 		ieee80211_invoke_rx_handlers(rx);
 		return true;
@@ -5256,22 +5256,19 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 }
 
 static void __ieee80211_rx_handle_8023(struct ieee80211_hw *hw,
-				       struct ieee80211_sta *pubsta,
+				       struct ieee80211_link_sta *link_pubsta,
 				       struct sk_buff *skb,
 				       struct list_head *list)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_fast_rx *fast_rx;
 	struct ieee80211_rx_data rx;
 	struct sta_info *sta;
-	int link_id = -1;
 
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
 	rx.local = local;
 	rx.list = list;
-	rx.link_id = -1;
 
 	I802_DEBUG_INC(local->dot11ReceivedFragmentCount);
 
@@ -5279,23 +5276,15 @@ static void __ieee80211_rx_handle_8023(struct ieee80211_hw *hw,
 	if (skb->len < sizeof(struct ethhdr))
 		goto drop;
 
-	if (!pubsta)
+	if (!link_pubsta)
 		goto drop;
 
-	if (status->link_valid)
-		link_id = status->link_id;
-
-	/*
-	 * TODO: Should the frame be dropped if the right link_id is not
-	 * available? Or may be it is fine in the current form to proceed with
-	 * the frame processing because with frame being in 802.3 format,
-	 * link_id is used only for stats purpose and updating the stats on
-	 * the deflink is fine?
-	 */
-	sta = container_of(pubsta, struct sta_info, sta);
-	if (!ieee80211_rx_data_set_sta(&rx, sta, link_id))
+	sta = container_of(link_pubsta->sta, struct sta_info, sta);
+	if (!ieee80211_rx_data_set_sta(&rx, sta, link_pubsta->link_id))
 		goto drop;
 
+	rx.link_id = link_pubsta->link_id;
+
 	fast_rx = rcu_dereference(rx.sta->fast_rx);
 	if (!fast_rx)
 		goto drop;
@@ -5323,6 +5312,9 @@ static bool ieee80211_rx_for_interface(struct ieee80211_rx_data *rx,
 	}
 
 	/*
+	 * FIXME: Here we can assume that link addresses have not
+	 * been translated.
+	 *
 	 * Look up link station first, in case there's a
 	 * chance that they might have a link address that
 	 * is identical to the MLD address, that way we'll
@@ -5336,10 +5328,8 @@ static bool ieee80211_rx_for_interface(struct ieee80211_rx_data *rx,
 		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
 		sta = sta_info_get_bss(rx->sdata, hdr->addr2);
-		if (status->link_valid) {
-			link_id = status->link_id;
-		} else if (ieee80211_vif_is_mld(&rx->sdata->vif) &&
-			   status->freq) {
+		if (ieee80211_vif_is_mld(&rx->sdata->vif) &&
+		    status->freq) {
 			struct ieee80211_link_data *link;
 			struct ieee80211_chanctx_conf *conf;
 
@@ -5367,12 +5357,11 @@ static bool ieee80211_rx_for_interface(struct ieee80211_rx_data *rx,
  * be called with rcu_read_lock protection.
  */
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
-					 struct ieee80211_sta *pubsta,
+					 struct ieee80211_link_sta *link_pubsta,
 					 struct sk_buff *skb,
 					 struct list_head *list)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
 	__le16 fc;
@@ -5386,7 +5375,6 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	rx.skb = skb;
 	rx.local = local;
 	rx.list = list;
-	rx.link_id = -1;
 
 	if (ieee80211_is_data(fc) || ieee80211_is_mgmt(fc))
 		I802_DEBUG_INC(local->dot11ReceivedFragmentCount);
@@ -5428,37 +5416,14 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 
 	if (ieee80211_is_data(fc)) {
 		struct sta_info *sta, *prev_sta;
-		int link_id = -1;
 
-		if (status->link_valid)
-			link_id = status->link_id;
-
-		if (pubsta) {
-			sta = container_of(pubsta, struct sta_info, sta);
-			if (!ieee80211_rx_data_set_sta(&rx, sta, link_id))
+		if (link_pubsta) {
+			sta = container_of(link_pubsta->sta,
+					   struct sta_info, sta);
+			if (!ieee80211_rx_data_set_sta(&rx, sta,
+						       link_pubsta->link_id))
 				goto out;
 
-			/*
-			 * In MLO connection, fetch the link_id using addr2
-			 * when the driver does not pass link_id in status.
-			 * When the address translation is already performed by
-			 * driver/hw, the valid link_id must be passed in
-			 * status.
-			 */
-
-			if (!status->link_valid && pubsta->mlo) {
-				struct link_sta_info *link_sta;
-
-				link_sta = link_sta_info_get_bss(rx.sdata,
-								 hdr->addr2);
-				if (!link_sta)
-					goto out;
-
-				if (!ieee80211_rx_data_set_link(&rx,
-								link_sta->link_id))
-					goto out;
-			}
-
 			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
 				return;
 			goto out;
@@ -5467,13 +5432,20 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		prev_sta = NULL;
 
 		for_each_sta_info(local, hdr->addr2, sta, tmp) {
+			int link_id;
+
 			if (!prev_sta) {
 				prev_sta = sta;
 				continue;
 			}
 
 			rx.sdata = prev_sta->sdata;
-			if (!status->link_valid && prev_sta->sta.mlo) {
+
+			/*
+			 * FIXME: This is not correct as the addr2 cannot be a
+			 * link address if the loop itself is iterated.
+			 */
+			if (prev_sta->sta.mlo) {
 				struct link_sta_info *link_sta;
 
 				link_sta = link_sta_info_get_bss(rx.sdata,
@@ -5482,6 +5454,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					continue;
 
 				link_id = link_sta->link_id;
+			} else {
+				link_id = sta->deflink.link_id;
 			}
 
 			if (!ieee80211_rx_data_set_sta(&rx, prev_sta, link_id))
@@ -5493,8 +5467,15 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		}
 
 		if (prev_sta) {
+			int link_id;
+
 			rx.sdata = prev_sta->sdata;
-			if (!status->link_valid && prev_sta->sta.mlo) {
+
+			/*
+			 * FIXME: This is not correct as the addr2 cannot be a
+			 * link address if the loop itself is iterated.
+			 */
+			if (prev_sta->sta.mlo) {
 				struct link_sta_info *link_sta;
 
 				link_sta = link_sta_info_get_bss(rx.sdata,
@@ -5503,6 +5484,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					goto out;
 
 				link_id = link_sta->link_id;
+			} else {
+				link_id = sta->deflink.link_id;
 			}
 
 			if (!ieee80211_rx_data_set_sta(&rx, prev_sta, link_id))
@@ -5565,7 +5548,6 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_sta *pubsta;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -5696,16 +5678,6 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 		}
 	}
 
-	/* FIXME: Emulate the old driver behaviour for now */
-	if (link_pubsta) {
-		status->link_valid = 1;
-		status->link_id = link_pubsta->link_id;
-		pubsta = link_pubsta->sta;
-	} else {
-		status->link_valid = 0;
-		pubsta = NULL;
-	}
-
 	status->rx_flags = 0;
 
 	kcov_remote_start_common(skb_get_kcov_handle(skb));
@@ -5724,9 +5696,10 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 			ieee80211_tpt_led_trig_rx(local, skb->len);
 
 		if (status->flag & RX_FLAG_8023)
-			__ieee80211_rx_handle_8023(hw, pubsta, skb, list);
+			__ieee80211_rx_handle_8023(hw, link_pubsta, skb, list);
 		else
-			__ieee80211_rx_handle_packet(hw, pubsta, skb, list);
+			__ieee80211_rx_handle_packet(hw, link_pubsta, skb,
+						     list);
 	}
 
 	kcov_remote_stop();
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index eeff230bd909..324c2b6d7ce1 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
  * Copyright 2016-2017  Intel Deutschland GmbH
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 
 #include <linux/if_arp.h>
@@ -204,12 +204,10 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		 * an indication on which of the links the frame was received
 		 */
 		if (ieee80211_vif_is_mld(&scan_sdata->vif)) {
-			if (rx_status->link_valid) {
-				s8 link_id = rx_status->link_id;
+			s8 link_id = rx_status->link_id;
 
-				link_conf =
-					rcu_dereference(scan_sdata->vif.link_conf[link_id]);
-			}
+			link_conf =
+				rcu_dereference(scan_sdata->vif.link_conf[link_id]);
 		} else {
 			link_conf = &scan_sdata->vif.bss_conf;
 		}
-- 
2.55.0


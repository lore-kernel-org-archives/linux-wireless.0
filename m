Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:4442 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYGBXa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 19:30:57 -0400
Received: by rv-out-0506.google.com with SMTP id k40so686600rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2008 16:30:56 -0700 (PDT)
Subject: [PATCH 1/4] mac80211: remove trivial rx_data->fc users
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 16:30:51 -0700
Message-Id: <1215041451.16647.5.camel@brick> (sfid-20080703_013102_093990_D1D96C72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/rx.c |  107 +++++++++++++++++++++++++---------------------------
 1 files changed, 51 insertions(+), 56 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a3a26e5..fab443d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -352,9 +352,10 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 static void ieee80211_verify_ip_alignment(struct ieee80211_rx_data *rx)
 {
 #ifdef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	int hdrlen;
 
-	if (!WLAN_FC_DATA_PRESENT(rx->fc))
+	if (!ieee80211_is_data_present(hdr->frame_control))
 		return;
 
 	/*
@@ -376,7 +377,7 @@ static void ieee80211_verify_ip_alignment(struct ieee80211_rx_data *rx)
 	 * header and the payload is not supported, the driver is required
 	 * to move the 802.11 header further back in that case.
 	 */
-	hdrlen = ieee80211_get_hdrlen(rx->fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (rx->flags & IEEE80211_RX_AMSDU)
 		hdrlen += ETH_HLEN;
 	WARN_ON_ONCE(((unsigned long)(rx->skb->data + hdrlen)) & 3);
@@ -415,14 +416,11 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result
 ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 {
-	int hdrlen = ieee80211_get_hdrlen(rx->fc);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
-
-#define msh_h_get(h, l) ((struct ieee80211s_hdr *) ((u8 *)h + l))
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) {
-		if (!((rx->fc & IEEE80211_FCTL_FROMDS) &&
-		      (rx->fc & IEEE80211_FCTL_TODS)))
+	if (ieee80211_is_data(hdr->frame_control)) {
+		if (!ieee80211_has_a4(hdr->frame_control))
 			return RX_DROP_MONITOR;
 		if (memcmp(hdr->addr4, rx->dev->dev_addr, ETH_ALEN) == 0)
 			return RX_DROP_MONITOR;
@@ -435,27 +433,30 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 	if (!rx->sta || sta_plink_state(rx->sta) != PLINK_ESTAB) {
 		struct ieee80211_mgmt *mgmt;
 
-		if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
+		if (!ieee80211_is_mgmt(hdr->frame_control))
 			return RX_DROP_MONITOR;
 
-		switch (rx->fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_ACTION:
+		if (ieee80211_is_action(hdr->frame_control)) {
 			mgmt = (struct ieee80211_mgmt *)hdr;
 			if (mgmt->u.action.category != PLINK_CATEGORY)
 				return RX_DROP_MONITOR;
-			/* fall through on else */
-		case IEEE80211_STYPE_PROBE_REQ:
-		case IEEE80211_STYPE_PROBE_RESP:
-		case IEEE80211_STYPE_BEACON:
 			return RX_CONTINUE;
-			break;
-		default:
-			return RX_DROP_MONITOR;
 		}
 
-	 } else if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-		    is_multicast_ether_addr(hdr->addr1) &&
-		    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->dev))
+		if (ieee80211_is_probe_req(hdr->frame_control) ||
+		    ieee80211_is_probe_resp(hdr->frame_control) ||
+		    ieee80211_is_beacon(hdr->frame_control))
+			return RX_CONTINUE;
+
+		return RX_DROP_MONITOR;
+
+	}
+
+#define msh_h_get(h, l) ((struct ieee80211s_hdr *) ((u8 *)h + l))
+
+	if (ieee80211_is_data(hdr->frame_control) &&
+	    is_multicast_ether_addr(hdr->addr1) &&
+	    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->dev))
 		return RX_DROP_MONITOR;
 #undef msh_h_get
 
@@ -466,13 +467,11 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_hdr *hdr;
-
-	hdr = (struct ieee80211_hdr *) rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
 	if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
-		if (unlikely(rx->fc & IEEE80211_FCTL_RETRY &&
+		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->queue] ==
 			     hdr->seq_ctrl)) {
 			if (rx->flags & IEEE80211_RX_RA_MATCH) {
@@ -501,15 +500,14 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 		return ieee80211_rx_mesh_check(rx);
 
-	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
-		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
-		       (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)) &&
+	if (unlikely((ieee80211_is_data(hdr->frame_control) ||
+		      ieee80211_is_pspoll(hdr->frame_control)) &&
 		     rx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
 		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
-		if ((!(rx->fc & IEEE80211_FCTL_FROMDS) &&
-		     !(rx->fc & IEEE80211_FCTL_TODS) &&
-		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)
-		    || !(rx->flags & IEEE80211_RX_RA_MATCH)) {
+		if ((!ieee80211_has_fromds(hdr->frame_control) &&
+		     !ieee80211_has_tods(hdr->frame_control) &&
+		     ieee80211_is_data(hdr->frame_control)) ||
+		    !(rx->flags & IEEE80211_RX_RA_MATCH)) {
 			/* Drop IBSS frames and frames for other hosts
 			 * silently. */
 			return RX_DROP_MONITOR;
@@ -525,7 +523,7 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	int keyidx;
 	int hdrlen;
 	ieee80211_rx_result result = RX_DROP_UNUSABLE;
@@ -557,7 +555,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	 * possible.
 	 */
 
-	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
+	if (!ieee80211_has_protected(hdr->frame_control))
 		return RX_CONTINUE;
 
 	/*
@@ -586,7 +584,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		    (rx->status->flag & RX_FLAG_IV_STRIPPED))
 			return RX_CONTINUE;
 
-		hdrlen = ieee80211_get_hdrlen(rx->fc);
+		hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 		if (rx->skb->len < 8 + hdrlen)
 			return RX_DROP_UNUSABLE; /* TODO: count this? */
@@ -618,7 +616,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
 	/* Check for weak IVs if possible */
 	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
-	    ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+	    ieee80211_is_data(hdr->frame_control) &&
 	    (!(rx->status->flag & RX_FLAG_IV_STRIPPED) ||
 	     !(rx->status->flag & RX_FLAG_DECRYPTED)) &&
 	    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
@@ -710,7 +708,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
 	struct sta_info *sta = rx->sta;
 	struct net_device *dev = rx->dev;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 
 	if (!sta)
 		return RX_CONTINUE;
@@ -744,21 +742,20 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	sta->last_qual = rx->status->qual;
 	sta->last_noise = rx->status->noise;
 
-	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		/* Change STA power saving mode only in the end of a frame
 		 * exchange sequence */
 		if (test_sta_flags(sta, WLAN_STA_PS) &&
-		    !(rx->fc & IEEE80211_FCTL_PM))
+		    !ieee80211_has_pm(hdr->frame_control))
 			rx->sent_ps_buffered += ap_sta_ps_end(dev, sta);
 		else if (!test_sta_flags(sta, WLAN_STA_PS) &&
-			 (rx->fc & IEEE80211_FCTL_PM))
+			 ieee80211_has_pm(hdr->frame_control))
 			ap_sta_ps_start(dev, sta);
 	}
 
 	/* Drop data::nullfunc frames silently, since they are used only to
 	 * control station power saving mode. */
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-	    (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_NULLFUNC) {
+	if (ieee80211_is_nullfunc(hdr->frame_control)) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_nullfunc);
 		/* Update counter and free packet here to avoid counting this
 		 * as a dropped packed. */
@@ -1465,15 +1462,15 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
 	struct sk_buff *skb = rx->skb;
-	struct ieee80211_bar *bar = (struct ieee80211_bar *) skb->data;
+	struct ieee80211_bar *bar = (struct ieee80211_bar *)skb->data;
 	struct tid_ampdu_rx *tid_agg_rx;
 	u16 start_seq_num;
 	u16 tid;
 
-	if (likely((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_CTL))
+	if (likely(!ieee80211_is_ctl(bar->frame_control)))
 		return RX_CONTINUE;
 
-	if ((rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BACK_REQ) {
+	if (ieee80211_is_back_req(bar->frame_control)) {
 		if (!rx->sta)
 			return RX_CONTINUE;
 		tid = le16_to_cpu(bar->control) >> 12;
@@ -1527,11 +1524,12 @@ static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 					    struct ieee80211_hdr *hdr,
 					    struct ieee80211_rx_data *rx)
 {
-	int keyidx, hdrlen;
+	int keyidx;
+	unsigned int hdrlen;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
-	hdrlen = ieee80211_get_hdrlen_from_skb(rx->skb);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (rx->skb->len >= hdrlen + 4)
 		keyidx = rx->skb->data[hdrlen + 3] >> 6;
 	else
@@ -1545,7 +1543,7 @@ static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 		goto ignore;
 	}
 
-	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
+	if (!ieee80211_has_protected(hdr->frame_control))
 		goto ignore;
 
 	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_AP && keyidx) {
@@ -1558,9 +1556,8 @@ static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 		goto ignore;
 	}
 
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
-	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH))
+	if (!ieee80211_is_data(hdr->frame_control) &&
+	    !ieee80211_is_auth(hdr->frame_control))
 		goto ignore;
 
 	mac80211_ev_michael_mic_failure(rx->dev, keyidx, hdr);
@@ -1731,8 +1728,7 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_IF_TYPE_IBSS:
 		if (!bssid)
 			return 0;
-		if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
-		    (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON) {
+		if (ieee80211_is_beacon(hdr->frame_control)) {
 			if (!rx->sta)
 				rx->sta = ieee80211_ibss_add_sta(sdata->dev,
 						rx->skb, bssid, hdr->addr2,
@@ -1783,8 +1779,7 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 			return 0;
 		break;
 	case IEEE80211_IF_TYPE_WDS:
-		if (bssid ||
-		    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+		if (bssid || !ieee80211_is_data(hdr->frame_control))
 			return 0;
 		if (compare_ether_addr(sdata->u.wds.remote_addr, hdr->addr2))
 			return 0;
-- 
1.5.6.1.242.g4f9d0



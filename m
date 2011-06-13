Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:40458 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1FMWhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:37:31 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id AFFEBEF664
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:29 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 694C41C6385
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:28 +0300 (EEST)
Subject: [PATCH v2 18/27] mac80211: rename ieee80211_sta_flags to
	mac80211_sta_flags
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:37:27 +0300
Message-ID: <20110613223727.10517.84802.stgit@localhost6.localdomain6> (sfid-20110614_005722_767485_3AB8410F)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |   20 +++++-----
 net/mac80211/mlme.c       |   94 +++++++++++++++++++++++----------------------
 net/mac80211/status.c     |    2 -
 net/mac80211/tx.c         |    4 +-
 4 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index a697921..d1efd25 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -337,16 +337,16 @@ struct mac80211_work {
 };
 
 /* flags used in struct ieee80211_if_managed.flags */
-enum ieee80211_sta_flags {
-	IEEE80211_STA_BEACON_POLL	= BIT(0),
-	IEEE80211_STA_CONNECTION_POLL	= BIT(1),
-	IEEE80211_STA_CONTROL_PORT	= BIT(2),
-	IEEE80211_STA_DISABLE_11N	= BIT(4),
-	IEEE80211_STA_CSA_RECEIVED	= BIT(5),
-	IEEE80211_STA_MFP_ENABLED	= BIT(6),
-	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
-	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
-	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
+enum mac80211_sta_flags {
+	MAC80211_STA_BEACON_POLL	= BIT(0),
+	MAC80211_STA_CONNECTION_POLL	= BIT(1),
+	MAC80211_STA_CONTROL_PORT	= BIT(2),
+	MAC80211_STA_DISABLE_11N	= BIT(4),
+	MAC80211_STA_CSA_RECEIVED	= BIT(5),
+	MAC80211_STA_MFP_ENABLED	= BIT(6),
+	MAC80211_STA_UAPSD_ENABLED	= BIT(7),
+	MAC80211_STA_NULLFUNC_ACKED	= BIT(8),
+	MAC80211_STA_RESET_SIGNAL_AVE	= BIT(9),
 };
 
 struct ieee80211_if_managed {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d695aa2..02b3778 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -298,7 +298,7 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 			__cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
 		else
 			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
-	if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
+	if (!(ifmgd->flags & MAC80211_STA_MFP_ENABLED))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
 	if (send_frame)
@@ -402,7 +402,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
  out:
-	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+	ifmgd->flags &= ~MAC80211_STA_CSA_RECEIVED;
 	mutex_unlock(&ifmgd->mtx);
 }
 
@@ -466,7 +466,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	/* Disregard subsequent beacons if we are already running a timer
 	   processing a CSA */
 
-	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
+	if (ifmgd->flags & MAC80211_STA_CSA_RECEIVED)
 		return;
 
 	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
@@ -487,7 +487,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		}
 		ch_switch.channel = new_ch;
 		ch_switch.count = sw_elem->count;
-		ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
+		ifmgd->flags |= MAC80211_STA_CSA_RECEIVED;
 		drv_channel_switch(sdata->local, &ch_switch);
 		return;
 	}
@@ -499,7 +499,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		if (sw_elem->mode)
 			ieee80211_stop_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
-		ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
+		ifmgd->flags |= MAC80211_STA_CSA_RECEIVED;
 		mod_timer(&ifmgd->chswitch_timer,
 			  jiffies +
 			  msecs_to_jiffies(sw_elem->count *
@@ -619,8 +619,8 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 	if (!mgd->associated->beacon_ies)
 		return false;
 
-	if (mgd->flags & (IEEE80211_STA_BEACON_POLL |
-			  IEEE80211_STA_CONNECTION_POLL))
+	if (mgd->flags & (MAC80211_STA_BEACON_POLL |
+			  MAC80211_STA_CONNECTION_POLL))
 		return false;
 
 	rcu_read_lock();
@@ -779,7 +779,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
+	    (!(ifmgd->flags & MAC80211_STA_NULLFUNC_ACKED))) {
 		netif_tx_stop_all_queues(sdata->dev);
 
 		if (drv_tx_frames_pending(local))
@@ -795,8 +795,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 
 	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
 	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
-	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
-		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+	    (ifmgd->flags & MAC80211_STA_NULLFUNC_ACKED)) {
+		ifmgd->flags &= ~MAC80211_STA_NULLFUNC_ACKED;
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
@@ -837,7 +837,7 @@ static void ieee80211_sta_wmm_params(struct mac80211_local *local,
 	if (wmm_param_len < 8 || wmm_param[5] /* version */ != 1)
 		return;
 
-	if (ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
+	if (ifmgd->flags & MAC80211_STA_UAPSD_ENABLED)
 		uapsd_queues = local->uapsd_queues;
 
 	count = wmm_param[6] & 0x0f;
@@ -976,11 +976,11 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	sdata->u.mgd.associated = cbss;
 	memcpy(sdata->u.mgd.bssid, cbss->bssid, ETH_ALEN);
 
-	sdata->u.mgd.flags |= IEEE80211_STA_RESET_SIGNAL_AVE;
+	sdata->u.mgd.flags |= MAC80211_STA_RESET_SIGNAL_AVE;
 
 	/* just to be sure */
-	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
-				IEEE80211_STA_BEACON_POLL);
+	sdata->u.mgd.flags &= ~(MAC80211_STA_CONNECTION_POLL |
+				MAC80211_STA_BEACON_POLL);
 
 	ieee80211_led_assoc(local, 1);
 
@@ -1133,12 +1133,12 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	if (!(ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
-			      IEEE80211_STA_CONNECTION_POLL)))
+	if (!(ifmgd->flags & (MAC80211_STA_BEACON_POLL |
+			      MAC80211_STA_CONNECTION_POLL)))
 	    return;
 
-	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
-			  IEEE80211_STA_BEACON_POLL);
+	ifmgd->flags &= ~(MAC80211_STA_CONNECTION_POLL |
+			  MAC80211_STA_BEACON_POLL);
 	mutex_lock(&sdata->local->iflist_mtx);
 	ieee80211_recalc_ps(sdata->local, -1);
 	mutex_unlock(&sdata->local->iflist_mtx);
@@ -1249,14 +1249,14 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	 * because otherwise we would reset the timer every time and
 	 * never check whether we received a probe response!
 	 */
-	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
-			    IEEE80211_STA_CONNECTION_POLL))
+	if (ifmgd->flags & (MAC80211_STA_BEACON_POLL |
+			    MAC80211_STA_CONNECTION_POLL))
 		already = true;
 
 	if (beacon)
-		ifmgd->flags |= IEEE80211_STA_BEACON_POLL;
+		ifmgd->flags |= MAC80211_STA_BEACON_POLL;
 	else
-		ifmgd->flags |= IEEE80211_STA_CONNECTION_POLL;
+		ifmgd->flags |= MAC80211_STA_CONNECTION_POLL;
 
 	if (already)
 		goto out;
@@ -1474,7 +1474,7 @@ static bool ieee80211_assoc_success(struct mac80211_work *wk,
 
 	set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC |
 			   WLAN_STA_ASSOC_AP);
-	if (!(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
+	if (!(ifmgd->flags & MAC80211_STA_CONTROL_PORT))
 		set_sta_flags(sta, WLAN_STA_AUTHORIZED);
 
 	rates = 0;
@@ -1525,7 +1525,7 @@ static bool ieee80211_assoc_success(struct mac80211_work *wk,
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
+	if (elems.ht_cap_elem && !(ifmgd->flags & MAC80211_STA_DISABLE_11N))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
@@ -1533,7 +1533,7 @@ static bool ieee80211_assoc_success(struct mac80211_work *wk,
 
 	rate_control_rate_init(sta);
 
-	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
+	if (ifmgd->flags & MAC80211_STA_MFP_ENABLED)
 		set_sta_flags(sta, WLAN_STA_MFP);
 
 	if (elems.wmm_param)
@@ -1565,7 +1565,7 @@ static bool ieee80211_assoc_success(struct mac80211_work *wk,
 
 	if (elems.ht_info_elem && elems.wmm_param &&
 	    (sdata->local->hw.queues >= 4) &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
+	    !(ifmgd->flags & MAC80211_STA_DISABLE_11N))
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
 					       cbss->bssid, ap_ht_cap_flags);
 
@@ -1743,8 +1743,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	/* Track average RSSI from the Beacon frames of the current AP */
 	ifmgd->last_beacon_signal = rx_status->signal;
-	if (ifmgd->flags & IEEE80211_STA_RESET_SIGNAL_AVE) {
-		ifmgd->flags &= ~IEEE80211_STA_RESET_SIGNAL_AVE;
+	if (ifmgd->flags & MAC80211_STA_RESET_SIGNAL_AVE) {
+		ifmgd->flags &= ~MAC80211_STA_RESET_SIGNAL_AVE;
 		ifmgd->ave_beacon_signal = rx_status->signal * 16;
 		ifmgd->last_cqm_event_signal = 0;
 		ifmgd->count_beacon_signal = 1;
@@ -1779,14 +1779,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
+	if (ifmgd->flags & MAC80211_STA_BEACON_POLL) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: cancelling probereq poll due "
 			       "to a received beacon\n", sdata->name);
 		}
 #endif
-		ifmgd->flags &= ~IEEE80211_STA_BEACON_POLL;
+		ifmgd->flags &= ~MAC80211_STA_BEACON_POLL;
 		mutex_lock(&local->iflist_mtx);
 		ieee80211_recalc_ps(local, -1);
 		mutex_unlock(&local->iflist_mtx);
@@ -1855,7 +1855,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 
 	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
+	    !(ifmgd->flags & MAC80211_STA_DISABLE_11N)) {
 		struct sta_info *sta;
 		struct ieee80211_supported_band *sband;
 		u16 ap_ht_cap_flags;
@@ -2019,8 +2019,8 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
-			  IEEE80211_STA_BEACON_POLL);
+	ifmgd->flags &= ~(MAC80211_STA_CONNECTION_POLL |
+			  MAC80211_STA_BEACON_POLL);
 
 	ieee80211_set_disassoc(sdata, true, true);
 	mutex_unlock(&ifmgd->mtx);
@@ -2046,8 +2046,8 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 	/* then process the rest of the work */
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
-			    IEEE80211_STA_CONNECTION_POLL) &&
+	if (ifmgd->flags & (MAC80211_STA_BEACON_POLL |
+			    MAC80211_STA_CONNECTION_POLL) &&
 	    ifmgd->associated) {
 		u8 bssid[ETH_ALEN];
 		int max_tries;
@@ -2158,8 +2158,8 @@ static void ieee80211_sta_monitor_work(struct work_struct *work)
 static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 {
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		sdata->u.mgd.flags &= ~(IEEE80211_STA_BEACON_POLL |
-					IEEE80211_STA_CONNECTION_POLL);
+		sdata->u.mgd.flags &= ~(MAC80211_STA_BEACON_POLL |
+					MAC80211_STA_CONNECTION_POLL);
 
 		/* let's probe the connection once */
 		ieee80211_queue_work(&sdata->local->hw,
@@ -2435,8 +2435,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (!wk)
 		return -ENOMEM;
 
-	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
-	ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+	ifmgd->flags &= ~MAC80211_STA_DISABLE_11N;
+	ifmgd->flags &= ~MAC80211_STA_NULLFUNC_ACKED;
 
 	ifmgd->beacon_crc_valid = false;
 
@@ -2444,7 +2444,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104)
-			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+			ifmgd->flags |= MAC80211_STA_DISABLE_11N;
 
 
 	if (req->ie && req->ie_len) {
@@ -2474,7 +2474,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	 * We can set this to true for non-11n hardware, that'll be checked
 	 * separately along with the peer capabilities.
 	 */
-	wk->assoc.use_11n = !(ifmgd->flags & IEEE80211_STA_DISABLE_11N);
+	wk->assoc.use_11n = !(ifmgd->flags & MAC80211_STA_DISABLE_11N);
 	wk->assoc.capability = req->bss->capability;
 	wk->assoc.wmm_used = bss->wmm_used;
 	wk->assoc.supp_rates = bss->supp_rates;
@@ -2485,10 +2485,10 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (bss->wmm_used && bss->uapsd_supported &&
 	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
 		wk->assoc.uapsd_used = true;
-		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
+		ifmgd->flags |= MAC80211_STA_UAPSD_ENABLED;
 	} else {
 		wk->assoc.uapsd_used = false;
-		ifmgd->flags &= ~IEEE80211_STA_UAPSD_ENABLED;
+		ifmgd->flags &= ~MAC80211_STA_UAPSD_ENABLED;
 	}
 
 	ssid = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
@@ -2510,16 +2510,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	if (req->use_mfp) {
 		ifmgd->mfp = IEEE80211_MFP_REQUIRED;
-		ifmgd->flags |= IEEE80211_STA_MFP_ENABLED;
+		ifmgd->flags |= MAC80211_STA_MFP_ENABLED;
 	} else {
 		ifmgd->mfp = IEEE80211_MFP_DISABLED;
-		ifmgd->flags &= ~IEEE80211_STA_MFP_ENABLED;
+		ifmgd->flags &= ~MAC80211_STA_MFP_ENABLED;
 	}
 
 	if (req->crypto.control_port)
-		ifmgd->flags |= IEEE80211_STA_CONTROL_PORT;
+		ifmgd->flags |= MAC80211_STA_CONTROL_PORT;
 	else
-		ifmgd->flags &= ~IEEE80211_STA_CONTROL_PORT;
+		ifmgd->flags &= ~MAC80211_STA_CONTROL_PORT;
 
 	sdata->control_port_protocol = req->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = req->crypto.control_port_no_encrypt;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 86d971b..464cec7 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -320,7 +320,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	    local->ps_sdata && !(local->scanning)) {
 		if (info->flags & IEEE80211_TX_STAT_ACK) {
 			local->ps_sdata->u.mgd.flags |=
-					IEEE80211_STA_NULLFUNC_ACKED;
+					MAC80211_STA_NULLFUNC_ACKED;
 		} else
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 					msecs_to_jiffies(10));
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index fa682fe..12ed372 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -224,7 +224,7 @@ ieee80211_tx_h_dynamic_ps(struct mac80211_tx_data *tx)
 	 * changed via debugfs, user needs to reassociate manually to have
 	 * everything in sync.
 	 */
-	if ((ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
+	if ((ifmgd->flags & MAC80211_STA_UAPSD_ENABLED)
 	    && (local->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
 	    && skb_get_queue_mapping(tx->skb) == 0)
 		return TX_CONTINUE;
@@ -232,7 +232,7 @@ ieee80211_tx_h_dynamic_ps(struct mac80211_tx_data *tx)
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		ieee80211_stop_queues_by_reason(&local->hw,
 						IEEE80211_QUEUE_STOP_REASON_PS);
-		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+		ifmgd->flags &= ~MAC80211_STA_NULLFUNC_ACKED;
 		ieee80211_queue_work(&local->hw,
 				     &local->dynamic_ps_disable_work);
 	}


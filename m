Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:35299 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZGWKN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:13:56 -0400
Received: by mail-bw0-f228.google.com with SMTP id 28so709536bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:13:56 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 4/7] mac80211: Replace {sw,
	hw}_scanning variables with a bitfield
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Thu, 23 Jul 2009 12:14:04 +0200
Message-ID: <20090723101403.5147.55273.stgit@localhost.localdomain>
In-Reply-To: <20090723100732.5147.73989.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a bitfield to store the current scan mode instead of two boolean
variables {sw,hw}_scanning. This patch does not introduce functional
changes but allows us to enhance the scan flags later (for example
for background scanning).
    
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 net/mac80211/ibss.c        |    2 +-
 net/mac80211/ieee80211_i.h |    7 ++++++-
 net/mac80211/iface.c       |    4 ++--
 net/mac80211/main.c        |    2 +-
 net/mac80211/mesh.c        |    2 +-
 net/mac80211/mlme.c        |    8 ++++----
 net/mac80211/rx.c          |    6 +++---
 net/mac80211/scan.c        |   23 ++++++++++-------------
 net/mac80211/tx.c          |    6 +++---
 9 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8e22200..6e3cca6 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -742,7 +742,7 @@ static void ieee80211_ibss_work(struct work_struct *work)
 	if (!netif_running(sdata->dev))
 		return;
 
-	if (local->sw_scanning || local->hw_scanning)
+	if (local->scanning)
 		return;
 
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_ADHOC))
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4166418..783a125 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -570,6 +570,11 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 };
 
+enum {
+	SCAN_SW_SCANNING,
+	SCAN_HW_SCANNING
+};
+
 struct ieee80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
@@ -668,7 +673,7 @@ struct ieee80211_local {
 
 	/* Scanning and BSS list */
 	struct mutex scan_mtx;
-	bool sw_scanning, hw_scanning;
+	unsigned long scanning;
 	struct cfg80211_ssid scan_ssid;
 	struct cfg80211_scan_request int_scan_req;
 	struct cfg80211_scan_request *scan_req;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2f797a8..ee9cede 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -515,7 +515,7 @@ static int ieee80211_stop(struct net_device *dev)
 			 * the scan_sdata is NULL already don't send out a
 			 * scan event to userspace -- the scan is incomplete.
 			 */
-			if (local->sw_scanning)
+			if (test_bit(SCAN_SW_SCANNING, &local->scanning))
 				ieee80211_scan_completed(&local->hw, true);
 		}
 
@@ -905,7 +905,7 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	int count = 0;
 
-	if (local->hw_scanning || local->sw_scanning)
+	if (local->scanning)
 		return ieee80211_idle_off(local, "scanning");
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 3234f37..6d7b4cd 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -198,7 +198,7 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (local->sw_scanning) {
+		if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
 			sdata->vif.bss_conf.enable_beacon = false;
 		} else {
 			/*
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8a97b14..9a38269 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -597,7 +597,7 @@ static void ieee80211_mesh_work(struct work_struct *work)
 	if (!netif_running(sdata->dev))
 		return;
 
-	if (local->sw_scanning || local->hw_scanning)
+	if (local->scanning)
 		return;
 
 	while ((skb = skb_dequeue(&ifmsh->skb_queue)))
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 523c0d9..52b6f83 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -581,7 +581,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (!ifmgd->associated)
 		return;
 
-	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
+	if (sdata->local->scanning)
 		return;
 
 	/* Disregard subsequent beacons if we are already running a timer
@@ -639,7 +639,7 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 	 * If we are scanning right now then the parameters will
 	 * take effect when scan finishes.
 	 */
-	if (local->hw_scanning || local->sw_scanning)
+	if (local->scanning)
 		return;
 
 	if (conf->dynamic_ps_timeout > 0 &&
@@ -2038,7 +2038,7 @@ static void ieee80211_sta_work(struct work_struct *work)
 	if (!netif_running(sdata->dev))
 		return;
 
-	if (local->sw_scanning || local->hw_scanning)
+	if (local->scanning)
 		return;
 
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
@@ -2213,7 +2213,7 @@ static void ieee80211_sta_monitor_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.monitor_work);
 
-	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
+	if (sdata->local->scanning)
 		return;
 
 	ieee80211_mgd_probe_ap(sdata, false);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 66c797c..b1bebc1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -418,10 +418,10 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb = rx->skb;
 
-	if (unlikely(local->hw_scanning))
+	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning)))
 		return ieee80211_scan_rx(rx->sdata, skb);
 
-	if (unlikely(local->sw_scanning)) {
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning))) {
 		/* drop all the other packets during a software scan anyway */
 		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
 			dev_kfree_skb(skb);
@@ -2136,7 +2136,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		return;
 	}
 
-	if (unlikely(local->sw_scanning || local->hw_scanning))
+	if (unlikely(local->scanning))
 		rx.flags |= IEEE80211_RX_IN_SCAN;
 
 	ieee80211_parse_qos(&rx);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 48f910a..4233c3d 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -265,7 +265,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 
 	mutex_lock(&local->scan_mtx);
 
-	if (WARN_ON(!local->hw_scanning && !local->sw_scanning)) {
+	if (WARN_ON(!local->scanning)) {
 		mutex_unlock(&local->scan_mtx);
 		return;
 	}
@@ -275,16 +275,15 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 		return;
 	}
 
-	if (local->hw_scanning)
+	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
 		ieee80211_restore_scan_ies(local);
 
 	if (local->scan_req != &local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
 
-	was_hw_scan = local->hw_scanning;
-	local->hw_scanning = false;
-	local->sw_scanning = false;
+	was_hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
+	local->scanning = 0;
 	local->scan_channel = NULL;
 
 	/* we only have to protect scan_req and hw/sw scan */
@@ -434,9 +433,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (local->ops->hw_scan)
-		local->hw_scanning = true;
+		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	else
-		local->sw_scanning = true;
+		__set_bit(SCAN_SW_SCANNING, &local->scanning);
 	/*
 	 * Kicking off the scan need not be protected,
 	 * only the scan variable stuff, since now
@@ -459,11 +458,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&local->scan_mtx);
 
 	if (rc) {
-		if (local->ops->hw_scan) {
-			local->hw_scanning = false;
+		if (local->ops->hw_scan)
 			ieee80211_restore_scan_ies(local);
-		} else
-			local->sw_scanning = false;
+		local->scanning = 0;
 
 		ieee80211_recalc_idle(local);
 
@@ -572,7 +569,7 @@ void ieee80211_scan_work(struct work_struct *work)
 		return;
 	}
 
-	if (local->scan_req && !(local->sw_scanning || local->hw_scanning)) {
+	if (local->scan_req && !local->scanning) {
 		struct cfg80211_scan_request *req = local->scan_req;
 		int rc;
 
@@ -663,7 +660,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	 * queued -- mostly at suspend under RTNL.
 	 */
 	mutex_lock(&local->scan_mtx);
-	swscan = local->sw_scanning;
+	swscan = test_bit(SCAN_SW_SCANNING, &local->scanning);
 	mutex_unlock(&local->scan_mtx);
 
 	if (swscan)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c11cbbd..61739ab 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -192,7 +192,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
 		return TX_CONTINUE;
 
-	if (unlikely(tx->local->sw_scanning) &&
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning)) &&
 	    !ieee80211_is_probe_req(hdr->frame_control) &&
 	    !ieee80211_is_nullfunc(hdr->frame_control))
 		/*
@@ -551,7 +551,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	 * Lets not bother rate control if we're associated and cannot
 	 * talk to the sta. This should not happen.
 	 */
-	if (WARN((tx->local->sw_scanning) &&
+	if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) &&
 		 (sta_flags & WLAN_STA_ASSOC) &&
 		 !rate_usable_index_exists(sband, &tx->sta->sta),
 		 "%s: Dropped data frame as no usable bitrate found while "
@@ -1396,7 +1396,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    local->hw.conf.dynamic_ps_timeout > 0 &&
-	    !local->sw_scanning && !local->hw_scanning && local->ps_sdata) {
+	    !(local->scanning) && local->ps_sdata) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_PS);


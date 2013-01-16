Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab3APUm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 15:42:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove ARP filter enable/disable logic
Date: Wed, 16 Jan 2013 21:43:21 +0100
Message-Id: <1358369001-19722-1-git-send-email-johannes@sipsolutions.net> (sfid-20130116_214305_761725_51CBFC89)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Depending on the driver, having ARP filtering for
some addresses may be possible. Remove the logic
that tracks whether ARP filter is enabled or not
and give the driver the total number of addresses
instead of the length of the list so it can make
its own decision.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |  5 ++---
 drivers/net/wireless/ti/wlcore/main.c                 |  3 +--
 include/net/mac80211.h                                | 11 ++++-------
 net/mac80211/ieee80211_i.h                            |  2 --
 net/mac80211/iface.c                                  |  3 ---
 net/mac80211/main.c                                   | 16 ++++------------
 net/mac80211/mlme.c                                   |  8 ++------
 net/mac80211/trace.h                                  | 13 +++++++++----
 8 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index f0fc8cd..e4b42f7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -539,9 +539,8 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
 		/* Hardware ARP filter address list or state changed */
-		brcms_err(core, "%s: arp filtering: enabled %s, count %d"
-			  " (implement)\n", __func__, info->arp_filter_enabled ?
-			  "true" : "false", info->arp_addr_cnt);
+		brcms_err(core, "%s: arp filtering: %d addresses"
+			  " (implement)\n", __func__, info->arp_addr_cnt);
 	}
 
 	if (changed & BSS_CHANGED_QOS) {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ce6e62a..919ad70 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4113,8 +4113,7 @@ sta_not_found:
 		wlvif->sta.qos = bss_conf->qos;
 		WARN_ON(wlvif->bss_type != BSS_TYPE_STA_BSS);
 
-		if (bss_conf->arp_addr_cnt == 1 &&
-		    bss_conf->arp_filter_enabled) {
+		if (bss_conf->arp_addr_cnt == 1 && bss_conf->assoc) {
 			wlvif->ip_addr = addr;
 			/*
 			 * The template should have been configured only upon
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3037f49..ef0aedb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -297,11 +297,9 @@ enum ieee80211_rssi_event {
  *	may filter ARP queries targeted for other addresses than listed here.
  *	The driver must allow ARP queries targeted for all address listed here
  *	to pass through. An empty list implies no ARP queries need to pass.
- * @arp_addr_cnt: Number of addresses currently on the list.
- * @arp_filter_enabled: Enable ARP filtering - if enabled, the hardware may
- *	filter ARP queries based on the @arp_addr_list, if disabled, the
- *	hardware must not perform any ARP filtering. Note, that the filter will
- *	be enabled also in promiscuous mode.
+ * @arp_addr_cnt: Number of addresses currently on the list. Note that this
+ *	may be larger than %IEEE80211_BSS_ARP_ADDR_LIST_LEN (the arp_addr_list
+ *	array size), it's up to the driver what to do in that case.
  * @qos: This is a QoS-enabled BSS.
  * @idle: This interface is idle. There's also a global idle flag in the
  *	hardware config which may be more appropriate depending on what
@@ -338,8 +336,7 @@ struct ieee80211_bss_conf {
 	u32 cqm_rssi_hyst;
 	struct cfg80211_chan_def chandef;
 	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
-	u8 arp_addr_cnt;
-	bool arp_filter_enabled;
+	int arp_addr_cnt;
 	bool qos;
 	bool idle;
 	bool ps;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0fa44a9..b1fed54 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -747,8 +747,6 @@ struct ieee80211_sub_if_data {
 	struct work_struct work;
 	struct sk_buff_head skb_queue;
 
-	bool arp_filter_state;
-
 	u8 needed_rx_chains;
 	enum ieee80211_smps_mode smps_mode;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 06fac29..0a36dc6 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1574,9 +1574,6 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	/* initialise type-independent data */
 	sdata->wdev.wiphy = local->hw.wiphy;
 	sdata->local = local;
-#ifdef CONFIG_INET
-	sdata->arp_filter_state = true;
-#endif
 
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
 		skb_queue_head_init(&sdata->fragments[i].skb_list);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 39cfe8f..baf9720 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -349,27 +349,19 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 
 	/* Copy the addresses to the bss_conf list */
 	ifa = idev->ifa_list;
-	while (c < IEEE80211_BSS_ARP_ADDR_LIST_LEN && ifa) {
-		bss_conf->arp_addr_list[c] = ifa->ifa_address;
+	while (ifa) {
+		if (c < IEEE80211_BSS_ARP_ADDR_LIST_LEN)
+			bss_conf->arp_addr_list[c] = ifa->ifa_address;
 		ifa = ifa->ifa_next;
 		c++;
 	}
 
-	/* If not all addresses fit the list, disable filtering */
-	if (ifa) {
-		sdata->arp_filter_state = false;
-		c = 0;
-	} else {
-		sdata->arp_filter_state = true;
-	}
 	bss_conf->arp_addr_cnt = c;
 
 	/* Configure driver only if associated (which also implies it is up) */
-	if (ifmgd->associated) {
-		bss_conf->arp_filter_enabled = sdata->arp_filter_state;
+	if (ifmgd->associated)
 		ieee80211_bss_info_change_notify(sdata,
 						 BSS_CHANGED_ARP_FILTER);
-	}
 
 	mutex_unlock(&ifmgd->mtx);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e930175..2d9ef20 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1465,10 +1465,8 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 		bss_info_changed |= BSS_CHANGED_CQM;
 
 	/* Enable ARP filtering */
-	if (bss_conf->arp_filter_enabled != sdata->arp_filter_state) {
-		bss_conf->arp_filter_enabled = sdata->arp_filter_state;
+	if (bss_conf->arp_addr_cnt)
 		bss_info_changed |= BSS_CHANGED_ARP_FILTER;
-	}
 
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
@@ -1582,10 +1580,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	/* Disable ARP filtering */
-	if (sdata->vif.bss_conf.arp_filter_enabled) {
-		sdata->vif.bss_conf.arp_filter_enabled = false;
+	if (sdata->vif.bss_conf.arp_addr_cnt)
 		changed |= BSS_CHANGED_ARP_FILTER;
-	}
 
 	sdata->vif.bss_conf.qos = false;
 	changed |= BSS_CHANGED_QOS;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a8270b4..eee3cdb 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -341,8 +341,11 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(s32, cqm_rssi_hyst);
 		__field(u32, channel_width);
 		__field(u32, channel_cfreq1);
-		__dynamic_array(u32, arp_addr_list, info->arp_addr_cnt);
-		__field(bool, arp_filter_enabled);
+		__dynamic_array(u32, arp_addr_list,
+				info->arp_addr_cnt > IEEE80211_BSS_ARP_ADDR_LIST_LEN ?
+					IEEE80211_BSS_ARP_ADDR_LIST_LEN :
+					info->arp_addr_cnt);
+		__field(int, arp_addr_cnt);
 		__field(bool, qos);
 		__field(bool, idle);
 		__field(bool, ps);
@@ -378,9 +381,11 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->cqm_rssi_hyst = info->cqm_rssi_hyst;
 		__entry->channel_width = info->chandef.width;
 		__entry->channel_cfreq1 = info->chandef.center_freq1;
+		__entry->arp_addr_cnt = info->arp_addr_cnt;
 		memcpy(__get_dynamic_array(arp_addr_list), info->arp_addr_list,
-		       sizeof(u32) * info->arp_addr_cnt);
-		__entry->arp_filter_enabled = info->arp_filter_enabled;
+		       sizeof(u32) * (info->arp_addr_cnt > IEEE80211_BSS_ARP_ADDR_LIST_LEN ?
+					IEEE80211_BSS_ARP_ADDR_LIST_LEN :
+					info->arp_addr_cnt));
 		__entry->qos = info->qos;
 		__entry->idle = info->idle;
 		__entry->ps = info->ps;
-- 
1.8.0


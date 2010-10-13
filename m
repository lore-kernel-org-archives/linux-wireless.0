Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:5188 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0JMWsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 18:48:54 -0400
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com [172.25.149.7])
	by smtp-out.google.com with ESMTP id o9DMmrAO013767
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:53 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by hpaq7.eem.corp.google.com with ESMTP id o9DMmqLx018514
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:52 -0700
From: Paul Stewart <pstew@google.com>
Date: Wed, 13 Oct 2010 15:17:55 -0700
Subject: [PATCH 4/6] Add a bitrate threshold config hook in mac80211
To: linux-wireless@vger.kernel.org
Message-Id: <20101013224851.D58252094C@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a hook in mac80211 to accept bitrate threshold configuration
calls from nl80211.  This assigns a couple new variables in the
bss and ifmgd structs.

Signed-off-by: Paul Stewart <pstew@google.com>

---
 include/net/mac80211.h     |    3 +++
 net/mac80211/cfg.c         |   17 +++++++++++++++++
 net/mac80211/ieee80211_i.h |   16 ++++++++++++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9fdf982..1c2473c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -215,6 +215,8 @@ enum ieee80211_bss_change {
  * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
  *	implies disabled
  * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
+ * @cqm_bitrate_thold: Connection quality monitor bitrate threshold, a zero
+ *	value implies disabled
  * @arp_addr_list: List of IPv4 addresses for hardware ARP filtering. The
  *	may filter ARP queries targeted for other addresses than listed here.
  *	The driver must allow ARP queries targeted for all address listed here
@@ -247,6 +249,7 @@ struct ieee80211_bss_conf {
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
+	u32 cqm_bitrate_thold;
 	enum nl80211_channel_type channel_type;
 	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
 	u8 arp_addr_cnt;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18bd0e5..520619c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1498,6 +1498,22 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_cqm_bitrate_config(struct wiphy *wiphy,
+					    struct net_device *dev,
+					    u32 bitrate_thold)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_vif *vif = &sdata->vif;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	bss_conf->cqm_bitrate_thold = bitrate_thold;
+	sdata->u.mgd.last_cqm_bitrate = 0;
+	memset(&sdata->u.mgd.last_cqm_tx_rate, 0,
+	       sizeof(sdata->u.mgd.last_cqm_tx_rate));
+
+	return 0;
+}
+
 static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 				      struct net_device *dev,
 				      const u8 *addr,
@@ -1672,5 +1688,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.mgmt_tx = ieee80211_mgmt_tx,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.set_cqm_bitrate_config = ieee80211_set_cqm_bitrate_config,
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b80c386..02bf0b7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -338,6 +338,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
+	IEEE80211_STA_TX_RATE_CHANGED	= BIT(10),
 };
 
 struct ieee80211_if_managed {
@@ -406,6 +407,18 @@ struct ieee80211_if_managed {
 	 * generated for the current association.
 	 */
 	int last_cqm_event_signal;
+
+	/*
+	 * Last bitrate value sent as an event to signal quality listeners.
+	 * This is a u32 in units of 1000 bits per second.
+	 */
+	u32 last_cqm_bitrate;
+
+	/*
+	 * Previous transmit rate.  Used to detect whether the transmit rate
+	 * for the previous packet is different from the one before it.
+	 */
+	struct ieee80211_tx_rate last_cqm_tx_rate;
 };
 
 struct ieee80211_if_ibss {
@@ -723,6 +736,9 @@ struct ieee80211_local {
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
 
+	/* used to notify listeners of changes to tx bitrate */
+	struct work_struct rate_notify;
+
 	/* aggregated multicast list */
 	struct netdev_hw_addr_list mc_list;
 
-- 
1.7.1


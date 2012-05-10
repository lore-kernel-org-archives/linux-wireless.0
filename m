Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44430 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab2EJNSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 09:18:32 -0400
Received: by bkcji2 with SMTP id ji2so1275090bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 06:18:31 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3] mac80211: allow low-level drivers to set netdev feature bits
Date: Thu, 10 May 2012 16:18:26 +0300
Message-Id: <1336655906-31960-1-git-send-email-arik@wizery.com> (sfid-20120510_151836_869906_090342BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Low level drivers can now set certain netdev feature bits in
netdev_features member of the ieee80211_hw struct. These will be
propagated to every netdev created from this HW.

The white-listed features currently include only ones related to HW
checksumming.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v2->3: fix accidental comment damage

include/net/mac80211.h |    5 +++++
 net/mac80211/iface.c   |    2 ++
 net/mac80211/main.c    |    7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4d6e6c6..decf6e3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1288,6 +1288,10 @@ enum ieee80211_hw_flags {
  *
  * @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX
  *	(if %IEEE80211_HW_QUEUE_CONTROL is set)
+ *
+ * @netdev_features: netdev features to be set in each netdev created
+ *	from this HW. Note only HW checksum features are currently
+ *	compatible with mac80211. Other feature bits will be rejected.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1309,6 +1313,7 @@ struct ieee80211_hw {
 	u8 max_rx_aggregation_subframes;
 	u8 max_tx_aggregation_subframes;
 	u8 offchannel_tx_hw_queue;
+	netdev_features_t netdev_features;
 };
 
 /**
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3e05a8b..c2ad78a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1350,6 +1350,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			sdata->u.mgd.use_4addr = params->use_4addr;
 	}
 
+	ndev->features |= local->hw.netdev_features;
+
 	ret = register_netdevice(ndev);
 	if (ret)
 		goto fail;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b70f7f0..5b3bb8c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -679,6 +679,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	enum ieee80211_band band;
 	int channels, max_bitrates;
 	bool supp_ht;
+	netdev_features_t feature_whitelist;
 	static const u32 cipher_suites[] = {
 		/* keep WEP first, it may be removed below */
 		WLAN_CIPHER_SUITE_WEP40,
@@ -705,6 +706,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if ((hw->flags & IEEE80211_HW_SCAN_WHILE_IDLE) && !local->ops->hw_scan)
 		return -EINVAL;
 
+	/* Only HW csum features are currently compatible with mac80211 */
+	feature_whitelist = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+			    NETIF_F_HW_CSUM;
+	if (WARN_ON(hw->netdev_features & ~feature_whitelist))
+		return -EINVAL;
+
 	if (hw->max_report_rates == 0)
 		hw->max_report_rates = hw->max_rates;
 
-- 
1.7.9.5


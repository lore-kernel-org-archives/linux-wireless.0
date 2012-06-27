Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab2F0J0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 05:26:45 -0400
Message-ID: <1340789200.11012.6.camel@jlt3.sipsolutions.net> (sfid-20120627_112649_214704_73AA47DA)
Subject: [PATCH] cfg80211: don't allow WoWLAN support without CONFIG_PM
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, Luciano Coelho <coelho@ti.com>
Date: Wed, 27 Jun 2012 11:26:40 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When CONFIG_PM is enabled, no device can possibly
support WoWLAN since it can't go to sleep to start
with. Due to this, mac80211 had even rejected the
hardware registration. By making all the code and
data for WoWLAN depend on CONFIG_PM we can promote
this runtime error to a compile-time error.

Add #ifdef around all WoWLAN code to remove it in
systems that don't need it as they never suspend.

Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Luciano Coelho <coelho@ti.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Will apply this soon :)

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 ++
 drivers/net/wireless/ti/wlcore/main.c      |    2 ++
 include/net/cfg80211.h                     |    2 ++
 net/mac80211/main.c                        |    7 +++----
 net/wireless/core.c                        |    4 ++++
 net/wireless/nl80211.c                     |    6 ++++++
 6 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a507b6e..2fca9ad 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3487,6 +3487,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	wiphy->cipher_suites = cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
+#ifdef CONFIG_PM
 	wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 			      WIPHY_WOWLAN_DISCONNECT |
 			      WIPHY_WOWLAN_GTK_REKEY_FAILURE  |
@@ -3496,6 +3497,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	wiphy->wowlan.n_patterns = WOW_MAX_FILTERS_PER_LIST;
 	wiphy->wowlan.pattern_min_len = 1;
 	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
+#endif
 
 	wiphy->max_sched_scan_ssids = MAX_PROBED_SSID_INDEX;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1156e3f..747a997 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5321,6 +5321,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 		goto out_free_hw;
 	}
 
+#ifdef CONFIG_PM
 	ret = enable_irq_wake(wl->irq);
 	if (!ret) {
 		wl->irq_wake_enabled = true;
@@ -5334,6 +5335,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 				WL1271_RX_FILTER_MAX_PATTERN_SIZE;
 		}
 	}
+#endif
 	disable_irq(wl->irq);
 
 	ret = wl12xx_get_hw_info(wl);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5fdf359..b2c18df 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2164,7 +2164,9 @@ struct wiphy {
 	char fw_version[ETHTOOL_BUSINFO_LEN];
 	u32 hw_version;
 
+#ifdef CONFIG_PM
 	struct wiphy_wowlan_support wowlan;
+#endif
 
 	u16 max_remain_on_channel_duration;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6e65ba95..24609aa 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -715,12 +715,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	     local->hw.offchannel_tx_hw_queue >= local->hw.queues))
 		return -EINVAL;
 
-	if ((hw->wiphy->wowlan.flags || hw->wiphy->wowlan.n_patterns)
 #ifdef CONFIG_PM
-	    && (!local->ops->suspend || !local->ops->resume)
-#endif
-	    )
+	if ((hw->wiphy->wowlan.flags || hw->wiphy->wowlan.n_patterns) &&
+	    (!local->ops->suspend || !local->ops->resume))
 		return -EINVAL;
+#endif
 
 	if ((hw->flags & IEEE80211_HW_SCAN_WHILE_IDLE) && !local->ops->hw_scan)
 		return -EINVAL;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index ddbb07c0..c3a6e7a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -446,9 +446,11 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
+#ifdef CONFIG_PM
 	if (WARN_ON((wiphy->wowlan.flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
 		    !(wiphy->wowlan.flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY)))
 		return -EINVAL;
+#endif
 
 	if (WARN_ON(wiphy->ap_sme_capa &&
 		    !(wiphy->flags & WIPHY_FLAG_HAVE_AP_SME)))
@@ -525,12 +527,14 @@ int wiphy_register(struct wiphy *wiphy)
 		return -EINVAL;
 	}
 
+#ifdef CONFIG_PM
 	if (rdev->wiphy.wowlan.n_patterns) {
 		if (WARN_ON(!rdev->wiphy.wowlan.pattern_min_len ||
 			    rdev->wiphy.wowlan.pattern_min_len >
 			    rdev->wiphy.wowlan.pattern_max_len))
 			return -EINVAL;
 	}
+#endif
 
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b0e31a2..ef36f2c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1173,6 +1173,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		nla_nest_end(msg, nl_ifs);
 	}
 
+#ifdef CONFIG_PM
 	if (dev->wiphy.wowlan.flags || dev->wiphy.wowlan.n_patterns) {
 		struct nlattr *nl_wowlan;
 
@@ -1213,6 +1214,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 
 		nla_nest_end(msg, nl_wowlan);
 	}
+#endif
 
 	if (nl80211_put_iftypes(msg, NL80211_ATTR_SOFTWARE_IFTYPES,
 				dev->wiphy.software_iftypes))
@@ -6395,6 +6397,7 @@ static int nl80211_leave_mesh(struct sk_buff *skb, struct genl_info *info)
 	return cfg80211_leave_mesh(rdev, dev);
 }
 
+#ifdef CONFIG_PM
 static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -6623,6 +6626,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 	kfree(new_triggers.patterns);
 	return err;
 }
+#endif
 
 static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 {
@@ -7383,6 +7387,7 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+#ifdef CONFIG_PM
 	{
 		.cmd = NL80211_CMD_GET_WOWLAN,
 		.doit = nl80211_get_wowlan,
@@ -7399,6 +7404,7 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+#endif
 	{
 		.cmd = NL80211_CMD_SET_REKEY_OFFLOAD,
 		.doit = nl80211_set_rekey_data,
-- 
1.7.10




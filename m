Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab3HFJMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:12:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 2/2] mac80211: add vif to testmode cmd
Date: Tue,  6 Aug 2013 11:12:27 +0200
Message-Id: <1375780347-1062-2-git-send-email-johannes@sipsolutions.net> (sfid-20130806_111237_866621_2EBA177E)
In-Reply-To: <1375780347-1062-1-git-send-email-johannes@sipsolutions.net>
References: <1375780347-1062-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Pass the wdev from cfg80211 on to the driver as the vif
if given and it's valid for the driver.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c     |  1 +
 drivers/net/wireless/ti/wlcore/testmode.c |  3 ++-
 drivers/net/wireless/ti/wlcore/testmode.h |  3 ++-
 include/net/mac80211.h                    |  7 ++++---
 net/mac80211/cfg.c                        | 11 ++++++++++-
 5 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7b2a622..a0d2aac 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1364,6 +1364,7 @@ static const struct nla_policy hwsim_testmode_policy[HWSIM_TM_ATTR_MAX + 1] = {
 static int hwsim_fops_ps_write(void *dat, u64 val);
 
 static int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
 				       void *data, int len)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index f344276..527590f 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -356,7 +356,8 @@ out:
 	return ret;
 }
 
-int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
+int wl1271_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  void *data, int len)
 {
 	struct wl1271 *wl = hw->priv;
 	struct nlattr *tb[WL1271_TM_ATTR_MAX + 1];
diff --git a/drivers/net/wireless/ti/wlcore/testmode.h b/drivers/net/wireless/ti/wlcore/testmode.h
index 8071654..61d8434 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.h
+++ b/drivers/net/wireless/ti/wlcore/testmode.h
@@ -26,6 +26,7 @@
 
 #include <net/mac80211.h>
 
-int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len);
+int wl1271_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  void *data, int len);
 
 #endif /* __WL1271_TESTMODE_H__ */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9cda372..839991a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2503,8 +2503,8 @@ enum ieee80211_roc_type {
  *	in IEEE 802.11-2007 section 17.3.8.6 and modify ACK timeout
  *	accordingly. This callback is not required and may sleep.
  *
- * @testmode_cmd: Implement a cfg80211 test mode command.
- *	The callback can sleep.
+ * @testmode_cmd: Implement a cfg80211 test mode command. The passed @vif may
+ *	be %NULL. The callback can sleep.
  * @testmode_dump: Implement a cfg80211 test mode dump. The callback can sleep.
  *
  * @flush: Flush all pending frames from the hardware queue, making sure
@@ -2765,7 +2765,8 @@ struct ieee80211_ops {
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
 	void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
 #ifdef CONFIG_NL80211_TESTMODE
-	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
+	int (*testmode_cmd)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    void *data, int len);
 	int (*testmode_dump)(struct ieee80211_hw *hw, struct sk_buff *skb,
 			     struct netlink_callback *cb,
 			     void *data, int len);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c77916f..7aa38ce 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2305,11 +2305,20 @@ static int ieee80211_testmode_cmd(struct wiphy *wiphy,
 				  void *data, int len)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_vif *vif = NULL;
 
 	if (!local->ops->testmode_cmd)
 		return -EOPNOTSUPP;
 
-	return local->ops->testmode_cmd(&local->hw, data, len);
+	if (wdev) {
+		struct ieee80211_sub_if_data *sdata;
+
+		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+		if (sdata->flags & IEEE80211_SDATA_IN_DRIVER)
+			vif = &sdata->vif;
+	}
+
+	return local->ops->testmode_cmd(&local->hw, vif, data, len);
 }
 
 static int ieee80211_testmode_dump(struct wiphy *wiphy,
-- 
1.8.0


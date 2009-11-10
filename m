Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:8763 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZKJQYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 11:24:22 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: sample survey implementation for mac80211_hwsim
Date: Tue, 10 Nov 2009 17:23:50 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911101723.50859.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the survey function to both mac80211 itself and to mac80211_hwsim.
For the latter driver, we simply invent some noise level.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

--- linux-wl.orig/include/net/mac80211.h
+++ linux-wl/include/net/mac80211.h
@@ -1507,7 +1507,8 @@
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    enum ieee80211_ampdu_mlme_action action,
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
-
+	int (*get_survey)(struct ieee80211_hw *hw, int idx,
+		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
 #ifdef CONFIG_NL80211_TESTMODE
 	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
--- linux-wl.orig/net/mac80211/cfg.c
+++ linux-wl/net/mac80211/cfg.c
@@ -395,6 +395,17 @@
 	return ret;
 }
 
+static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
+				 int idx, struct survey_info *survey)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+
+	if (!local->ops->get_survey)
+		return -EOPNOTSUPP;
+
+	return drv_get_survey(local, idx, survey);
+}
+
 static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac, struct station_info *sinfo)
 {
@@ -1375,6 +1386,7 @@
 	.change_station = ieee80211_change_station,
 	.get_station = ieee80211_get_station,
 	.dump_station = ieee80211_dump_station,
+	.dump_survey = ieee80211_dump_survey,
 #ifdef CONFIG_MAC80211_MESH
 	.add_mpath = ieee80211_add_mpath,
 	.del_mpath = ieee80211_del_mpath,
--- linux-wl.orig/net/mac80211/driver-ops.h
+++ linux-wl/net/mac80211/driver-ops.h
@@ -251,6 +251,15 @@
 	return ret;
 }
 
+static inline int drv_get_survey(struct ieee80211_local *local, int idx,
+				struct survey_info *survey)
+{
+	int ret = -EOPNOTSUPP;
+	if (local->ops->conf_tx)
+		ret = local->ops->get_survey(&local->hw, idx, survey);
+	/* trace_drv_get_survey(local, idx, survey, ret); */
+	return ret;
+}
 
 static inline void drv_rfkill_poll(struct ieee80211_local *local)
 {
--- linux-wl.orig/drivers/net/wireless/mac80211_hwsim.c
+++ linux-wl/drivers/net/wireless/mac80211_hwsim.c
@@ -759,6 +759,28 @@
 	return 0;
 }
 
+static int mac80211_hwsim_get_survey(
+	struct ieee80211_hw *hw, int idx,
+	struct survey_info *survey)
+{
+	struct ieee80211_conf *conf = &hw->conf;
+
+	printk(KERN_DEBUG "%s:%s (idx=%d)\n",
+	       wiphy_name(hw->wiphy), __func__, idx);
+
+	if (idx != 0)
+		return -ENOENT;
+
+	/* Current channel */
+	survey->channel = conf->channel;
+
+	/* Magically conjured noise level */
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = -92;
+
+	return 0;
+}
+
 #ifdef CONFIG_NL80211_TESTMODE
 /*
  * This section contains example code for using netlink
@@ -840,6 +862,7 @@
 	.sta_notify = mac80211_hwsim_sta_notify,
 	.set_tim = mac80211_hwsim_set_tim,
 	.conf_tx = mac80211_hwsim_conf_tx,
+	.get_survey = mac80211_hwsim_get_survey,
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)
 };
 

-- 
http://www.holgerschurig.de

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:47209 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0DSIXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 04:23:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 50B5E148023
	for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 10:23:39 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RxvSJLndu+6D for <linux-wireless@vger.kernel.org>;
	Mon, 19 Apr 2010 10:23:39 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F800E.dip0.t-ipconnect.de [217.95.128.14])
	by mx51.mymxserver.com (Postfix) with ESMTP id 345E5148027
	for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 10:23:37 +0200 (CEST)
Received: from mnz66.localnet (schurig.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id BFFD11E0036
	for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 10:23:36 +0200 (CEST)
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: sample survey implementation for mac80211 & hwsim
Date: Mon, 19 Apr 2010 10:23:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201004191023.57987.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the survey function to both mac80211 itself and to mac80211_hwsim.
For the latter driver, we simply invent some noise level.A real driver which
cannot determine the real channel noise MUST NOT report any noise, especially
not a magically conjured one :-)

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
 drivers/net/wireless/mac80211_hwsim.c |   28 ++++++++++++++++++++++++++++
 include/net/mac80211.h                |    3 ++-
 net/mac80211/cfg.c                    |   12 ++++++++++++
 net/mac80211/driver-ops.h             |    9 +++++++++
 4 files changed, 51 insertions(+), 1 deletion(-)

--- linux-wl.orig/include/net/mac80211.h
+++ linux-wl/include/net/mac80211.h
@@ -1673,7 +1673,8 @@ struct ieee80211_ops {
 			    struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
-
+	int (*get_survey)(struct ieee80211_hw *hw, int idx,
+		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
 	void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
 #ifdef CONFIG_NL80211_TESTMODE
--- linux-wl.orig/net/mac80211/cfg.c
+++ linux-wl/net/mac80211/cfg.c
@@ -411,6 +411,17 @@ static int ieee80211_dump_station(struct
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
@@ -1508,6 +1519,7 @@ struct cfg80211_ops mac80211_config_ops
 	.change_station = ieee80211_change_station,
 	.get_station = ieee80211_get_station,
 	.dump_station = ieee80211_dump_station,
+	.dump_survey = ieee80211_dump_survey,
 #ifdef CONFIG_MAC80211_MESH
 	.add_mpath = ieee80211_add_mpath,
 	.del_mpath = ieee80211_del_mpath,
--- linux-wl.orig/net/mac80211/driver-ops.h
+++ linux-wl/net/mac80211/driver-ops.h
@@ -346,6 +346,15 @@ static inline int drv_ampdu_action(struc
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
@@ -830,6 +830,33 @@ static int mac80211_hwsim_conf_tx(
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
+	/*
+	 * Magically conjured noise level --- this is only ok for simulated hardware.
+	 *
+	 * A real driver which cannot determine the real channel noise MUST NOT
+	 * report any noise, especially not a magically conjured one :-)
+	 */
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = -92;
+
+	return 0;
+}
+
 #ifdef CONFIG_NL80211_TESTMODE
 /*
  * This section contains example code for using netlink
@@ -1013,6 +1040,7 @@ static struct ieee80211_ops mac80211_hws
 	.sta_notify = mac80211_hwsim_sta_notify,
 	.set_tim = mac80211_hwsim_set_tim,
 	.conf_tx = mac80211_hwsim_conf_tx,
+	.get_survey = mac80211_hwsim_get_survey,
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)
 	.ampdu_action = mac80211_hwsim_ampdu_action,
 	.sw_scan_start = mac80211_hwsim_sw_scan,

-- 
DH3HS, http://www.holgerschurig.de

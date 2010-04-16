Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:39943 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0DPGrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:47:03 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: Anton Puolakka <Anton.Puolakka@7signal.com>
Subject: Re: Survey mode volunteers
Date: Fri, 16 Apr 2010 08:47:29 +0200
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <0290AB2F0A8E124B9FFC144088A1A95609D6029647@EX-MBS04.nbl.local> <201004140911.11459.holgerschurig@gmail.com> <0290AB2F0A8E124B9FFC144088A1A95609D6097401@EX-MBS04.nbl.local>
In-Reply-To: <0290AB2F0A8E124B9FFC144088A1A95609D6097401@EX-MBS04.nbl.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004160847.29368.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> We checked the most recent wireless-testing and saw no related patch on
> mac80211 yet. So, Holger, do You have one for that, too? Or anyone else on
> the mailing-list? Could You please share?

Sure. I thought I already posted that patch. This is a patch that
applied to compat-wireless 2010-03-23:

---------------
Subject: [PATCH] mac80211: sample survey implementation for mac80211_hwsim

This adds the survey function to both mac80211 itself and to mac80211_hwsim.
For the latter driver, we simply invent some noise level.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
 drivers/net/wireless/mac80211_hwsim.c |   28 ++++++++++++++++++++++++++++
 include/net/mac80211.h                |    3 ++-
 net/mac80211/cfg.c                    |   12 ++++++++++++
 net/mac80211/driver-ops.h             |    9 +++++++++
 4 files changed, 51 insertions(+), 1 deletion(-)

--- compat-wireless-2010-03-15.orig/include/net/mac80211.h
+++ compat-wireless-2010-03-15/include/net/mac80211.h
@@ -1646,7 +1646,8 @@ struct ieee80211_ops {
 			    struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
-
+	int (*get_survey)(struct ieee80211_hw *hw, int idx,
+		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
 	void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
 #ifdef CONFIG_NL80211_TESTMODE
--- compat-wireless-2010-03-15.orig/net/mac80211/cfg.c
+++ compat-wireless-2010-03-15/net/mac80211/cfg.c
@@ -412,6 +412,17 @@ static int ieee80211_dump_station(struct
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
@@ -1476,6 +1487,7 @@ struct cfg80211_ops mac80211_config_ops
 	.change_station = ieee80211_change_station,
 	.get_station = ieee80211_get_station,
 	.dump_station = ieee80211_dump_station,
+	.dump_survey = ieee80211_dump_survey,
 #ifdef CONFIG_MAC80211_MESH
 	.add_mpath = ieee80211_add_mpath,
 	.del_mpath = ieee80211_del_mpath,
--- compat-wireless-2010-03-15.orig/net/mac80211/driver-ops.h
+++ compat-wireless-2010-03-15/net/mac80211/driver-ops.h
@@ -346,6 +346,15 @@ static inline int drv_ampdu_action(struc
 	return ret;
 }
 
+static inline int drv_get_survey(struct ieee80211_local *local, int idx,
+				struct survey_info *survey)
+{
+	int ret = -EOPNOTSUPP;
+	if (local->ops->get_survey)
+		ret = local->ops->get_survey(&local->hw, idx, survey);
+	/* trace_drv_get_survey(local, idx, survey, ret); */
+	return ret;
+}
 
 static inline void drv_rfkill_poll(struct ieee80211_local *local)
 {
--- compat-wireless-2010-03-15.orig/drivers/net/wireless/mac80211_hwsim.c
+++ compat-wireless-2010-03-15/drivers/net/wireless/mac80211_hwsim.c
@@ -828,6 +828,33 @@ static int mac80211_hwsim_conf_tx(
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
@@ -981,6 +1008,7 @@ static struct ieee80211_ops mac80211_hws
 	.sta_notify = mac80211_hwsim_sta_notify,
 	.set_tim = mac80211_hwsim_set_tim,
 	.conf_tx = mac80211_hwsim_conf_tx,
+	.get_survey = mac80211_hwsim_get_survey,
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)
 	.ampdu_action = mac80211_hwsim_ampdu_action,
 	.flush = mac80211_hwsim_flush,

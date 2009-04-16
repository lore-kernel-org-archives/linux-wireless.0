Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZDPLXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 07:23:04 -0400
Message-Id: <20090416111928.072724791@sipsolutions.net> (sfid-20090416_132312_136058_DD0B8968)
References: <20090416111723.904720021@sipsolutions.net>
Date: Thu, 16 Apr 2009 13:17:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mac80211: enable PS by default
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable PS by default (depending on Kconfig) -- rely on drivers
to control the level using pm_qos. Due to the previous patch
we turn off PS when necessary due to latency requirements.

This has a Kconfig symbol so people can, if they really want,
configure the default in their kernels. We may want to keep it
at "default y" only in wireless-testing for a while.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Kconfig |   16 ++++++++++++++++
 net/mac80211/mlme.c  |    8 ++++++++
 2 files changed, 24 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-16 13:07:02.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-16 13:15:16.000000000 +0200
@@ -2181,6 +2181,7 @@ static void ieee80211_restart_sta_timer(
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd;
+	u32 hw_flags;
 
 	ifmgd = &sdata->u.mgd;
 	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
@@ -2200,6 +2201,13 @@ void ieee80211_sta_setup_sdata(struct ie
 		IEEE80211_STA_AUTO_CHANNEL_SEL;
 	if (sdata->local->hw.queues >= 4)
 		ifmgd->flags |= IEEE80211_STA_WMM_ENABLED;
+
+	hw_flags = sdata->local->hw.flags;
+
+	if (hw_flags & IEEE80211_HW_SUPPORTS_PS) {
+		ifmgd->powersave = CONFIG_MAC80211_DEFAULT_PS_VALUE;
+		local->hw.conf.dynamic_ps_timeout = 500;
+	}
 }
 
 /* configuration hooks */
--- wireless-testing.orig/net/mac80211/Kconfig	2009-04-16 13:06:59.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2009-04-16 13:07:02.000000000 +0200
@@ -11,6 +11,22 @@ config MAC80211
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.
 
+config MAC80211_DEFAULT_PS
+	bool "enable powersave by default"
+	depends on MAC80211
+	default y
+	help
+	  This option enables powersave mode by default.
+
+	  If this causes your applications to misbehave you should fix your
+	  applications instead -- they need to register their network
+	  latency requirement, see Documentation/power/pm_qos_interface.txt.
+
+config MAC80211_DEFAULT_PS_VALUE
+	int
+	default 1 if MAC80211_DEFAULT_PS
+	default 0
+
 menu "Rate control algorithm selection"
 	depends on MAC80211 != n
 

-- 


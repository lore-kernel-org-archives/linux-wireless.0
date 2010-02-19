Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab0BSSIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:08:20 -0500
Message-Id: <20100219180736.990884119@sipsolutions.net>
Date: Fri, 19 Feb 2010 19:06:55 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mac80211_hwsim: convert to new station add/remove
 callbacks
References: <20100219180652.409890561@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This converts mac80211_hwsim to use the new
station add/remove callbacks instead of using
the old sta_notify callback.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-02-19 18:55:53.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-02-19 18:57:57.000000000 +0100
@@ -771,23 +771,41 @@ static void mac80211_hwsim_bss_info_chan
 	}
 }
 
+static int mac80211_hwsim_sta_add(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_sta *sta)
+{
+	hwsim_check_magic(vif);
+	hwsim_set_sta_magic(sta);
+
+	return 0;
+}
+
+static int mac80211_hwsim_sta_remove(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_sta *sta)
+{
+	hwsim_check_magic(vif);
+	hwsim_clear_sta_magic(sta);
+
+	return 0;
+}
+
 static void mac80211_hwsim_sta_notify(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      enum sta_notify_cmd cmd,
 				      struct ieee80211_sta *sta)
 {
 	hwsim_check_magic(vif);
+
 	switch (cmd) {
-	case STA_NOTIFY_ADD:
-		hwsim_set_sta_magic(sta);
-		break;
-	case STA_NOTIFY_REMOVE:
-		hwsim_clear_sta_magic(sta);
-		break;
 	case STA_NOTIFY_SLEEP:
 	case STA_NOTIFY_AWAKE:
 		/* TODO: make good use of these flags */
 		break;
+	default:
+		WARN(1, "Invalid sta notify: %d\n", cmd);
+		break;
 	}
 }
 
@@ -958,6 +976,8 @@ static struct ieee80211_ops mac80211_hws
 	.config = mac80211_hwsim_config,
 	.configure_filter = mac80211_hwsim_configure_filter,
 	.bss_info_changed = mac80211_hwsim_bss_info_changed,
+	.sta_add = mac80211_hwsim_sta_add,
+	.sta_remove = mac80211_hwsim_sta_remove,
 	.sta_notify = mac80211_hwsim_sta_notify,
 	.set_tim = mac80211_hwsim_set_tim,
 	.conf_tx = mac80211_hwsim_conf_tx,



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760099AbXHUPMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:12:01 -0400
Message-Id: <20070821150045.089632000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 13/27] mac80211: remove IEEE80211_HW_DATA_NULLFUNC_ACK
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: Michael Wu <flamingice@sourmilk.net>

---
 include/net/mac80211.h         |    3 +--
 net/mac80211/hostapd_ioctl.h   |    2 --
 net/mac80211/ieee80211_ioctl.c |    2 --
 3 files changed, 1 insertion(+), 6 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-21 14:40:09.755923881 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-21 14:40:14.185923881 +0200
@@ -490,8 +490,7 @@ struct ieee80211_hw {
 
 #define IEEE80211_HW_WEP_INCLUDE_IV (1<<5)
 
-	/* will data nullfunc frames get proper TX status callback */
-#define IEEE80211_HW_DATA_NULLFUNC_ACK (1<<6)
+/* hole at 6 */
 
 	/* Force software encryption for TKIP packets if WMM is enabled. */
 #define IEEE80211_HW_NO_TKIP_WMM_HWACCEL (1<<7)
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-21 14:40:10.985923881 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-21 14:40:14.195923881 +0200
@@ -265,8 +265,6 @@ struct prism2_hostapd_param {
 #define HOSTAP_CRYPT_ERR_TX_KEY_SET_FAILED 6
 #define HOSTAP_CRYPT_ERR_CARD_CONF_FAILED 7
 
-#define HOSTAP_HW_FLAG_NULLFUNC_OK BIT(0)
-
 enum {
 	IEEE80211_KEY_MGMT_NONE = 0,
 	IEEE80211_KEY_MGMT_IEEE8021X = 1,
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-21 14:40:10.985923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-21 14:40:14.195923881 +0200
@@ -112,8 +112,6 @@ static int ieee80211_ioctl_get_hw_featur
 	struct ieee80211_hw_mode *mode;
 
 	param->u.hw_features.flags = 0;
-	if (local->hw.flags & IEEE80211_HW_DATA_NULLFUNC_ACK)
-		param->u.hw_features.flags |= HOSTAP_HW_FLAG_NULLFUNC_OK;
 
 	param->u.hw_features.num_modes = 0;
 	list_for_each_entry(mode, &local->modes_list, list) {

-- 


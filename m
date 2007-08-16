Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbXHPQa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 12:30:26 -0400
Message-Id: <20070816162933.352627000@sipsolutions.net>
References: <20070816162908.030659000@sipsolutions.net>
Date: Thu, 16 Aug 2007 18:29:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 4/4] mac80211: remove IEEE80211_HW_DATA_NULLFUNC_ACK
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag is only propagated to hostapd which doesn't use it.
If we ever add it back please do it in an inverted meaning so
drivers for good hardware don't need to set an ever-growing
list of flags.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: Michael Wu <flamingice@sourmilk.net>

---
 include/net/mac80211.h         |    3 ---
 net/mac80211/hostapd_ioctl.h   |    2 --
 net/mac80211/ieee80211_ioctl.c |    2 --
 3 files changed, 7 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-16 18:20:19.703468950 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-16 18:20:23.083468950 +0200
@@ -473,9 +473,6 @@ struct ieee80211_hw {
 
 #define IEEE80211_HW_WEP_INCLUDE_IV (1<<5)
 
-	/* will data nullfunc frames get proper TX status callback */
-#define IEEE80211_HW_DATA_NULLFUNC_ACK (1<<6)
-
 	/* Force software encryption for TKIP packets if WMM is enabled. */
 #define IEEE80211_HW_NO_TKIP_WMM_HWACCEL (1<<7)
 
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-16 18:20:42.023468950 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-16 18:20:47.063468950 +0200
@@ -171,8 +171,6 @@ struct prism2_hostapd_param {
 #define HOSTAP_CRYPT_FLAG_SET_TX_KEY BIT(0)
 #define HOSTAP_CRYPT_FLAG_PERMANENT BIT(1)
 
-#define HOSTAP_HW_FLAG_NULLFUNC_OK BIT(0)
-
 /* Data structures used for get_hw_features ioctl */
 struct hostapd_ioctl_hw_modes_hdr {
 	int mode;
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-16 18:20:29.553468950 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-16 18:20:38.833468950 +0200
@@ -111,8 +111,6 @@ static int ieee80211_ioctl_get_hw_featur
 	struct ieee80211_hw_mode *mode;
 
 	param->u.hw_features.flags = 0;
-	if (local->hw.flags & IEEE80211_HW_DATA_NULLFUNC_ACK)
-		param->u.hw_features.flags |= HOSTAP_HW_FLAG_NULLFUNC_OK;
 
 	param->u.hw_features.num_modes = 0;
 	list_for_each_entry(mode, &local->modes_list, list) {

-- 


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYJUH5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 03:57:46 -0400
Subject: [PATCH] wireless: remove cfg80211_reg_mutex
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 09:57:41 +0200
Message-Id: <1224575861.27899.99.camel@johannes.berg> (sfid-20081021_095750_093257_0DAC082E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This mutex is wrong, we use cfg80211_drv_mutex (which should
possibly be renamed to just cfg80211_mutex) everywhere except
in one place, fix that and get rid of the extra mutex.

Also get rid of a spurious regulatory_requests list definition.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |    6 ++----
 net/wireless/reg.c  |    3 ---
 net/wireless/reg.h  |    1 -
 3 files changed, 2 insertions(+), 8 deletions(-)

--- everything.orig/net/wireless/core.c	2008-10-21 09:54:48.000000000 +0200
+++ everything/net/wireless/core.c	2008-10-21 09:55:06.000000000 +0200
@@ -302,12 +302,10 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
+	mutex_lock(&cfg80211_drv_mutex);
+
 	/* set up regulatory info */
-	mutex_lock(&cfg80211_reg_mutex);
 	wiphy_update_regulatory(wiphy, REGDOM_SET_BY_CORE);
-	mutex_unlock(&cfg80211_reg_mutex);
-
-	mutex_lock(&cfg80211_drv_mutex);
 
 	res = device_add(&drv->wiphy.dev);
 	if (res)
--- everything.orig/net/wireless/reg.c	2008-10-21 09:52:13.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-21 09:54:54.000000000 +0200
@@ -52,7 +52,6 @@ struct regulatory_request {
 };
 
 static LIST_HEAD(regulatory_requests);
-DEFINE_MUTEX(cfg80211_reg_mutex);
 
 /* To trigger userspace events */
 static struct platform_device *reg_pdev;
@@ -63,8 +62,6 @@ static u32 supported_bandwidths[] = {
 	MHZ_TO_KHZ(20),
 };
 
-static struct list_head regulatory_requests;
-
 /* Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
  * information to give us an alpha2 */
--- everything.orig/net/wireless/reg.h	2008-10-21 09:54:48.000000000 +0200
+++ everything/net/wireless/reg.h	2008-10-21 09:54:51.000000000 +0200
@@ -1,7 +1,6 @@
 #ifndef __NET_WIRELESS_REG_H
 #define __NET_WIRELESS_REG_H
 
-extern struct mutex cfg80211_reg_mutex;
 bool is_world_regdom(const char *alpha2);
 bool reg_is_valid_request(const char *alpha2);
 



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761103AbXHUPQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:16:55 -0400
Message-Id: <20070821150051.202525000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 24/27] mac80211: remove PRISM2_PARAM_KEY_MGMT
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ioctl isn't used and wext has a replacement.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/hostapd_ioctl.h   |    1 -
 net/mac80211/ieee80211_ioctl.c |   13 -------------
 2 files changed, 14 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-21 15:58:25.445923881 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-21 15:58:28.215923881 +0200
@@ -45,7 +45,6 @@ enum {
 	PRISM2_PARAM_CREATE_IBSS = 1037,
 	PRISM2_PARAM_WMM_ENABLED = 1038,
 	PRISM2_PARAM_MIXED_CELL = 1039,
-	PRISM2_PARAM_KEY_MGMT = 1040,
 	PRISM2_PARAM_USER_SPACE_MLME = 1045,
 	PRISM2_PARAM_MGMT_IF = 1046,
 };
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-21 15:58:17.925923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-21 15:58:22.955923881 +0200
@@ -2033,13 +2033,6 @@ static int ieee80211_ioctl_prism2_param(
 			sdata->u.sta.mixed_cell = !!value;
 		break;
 
-	case PRISM2_PARAM_KEY_MGMT:
-		if (sdata->type != IEEE80211_IF_TYPE_STA)
-			ret = -EINVAL;
-		else
-			sdata->u.sta.key_mgmt = value;
-		break;
-
 	case PRISM2_PARAM_HW_MODES:
 		local->enabled_modes = value;
 		break;
@@ -2165,12 +2158,6 @@ static int ieee80211_ioctl_get_prism2_pa
 			*param = !!sdata->u.sta.mixed_cell;
 		break;
 
-	case PRISM2_PARAM_KEY_MGMT:
-		if (sdata->type != IEEE80211_IF_TYPE_STA)
-			ret = -EINVAL;
-		else
-			*param = sdata->u.sta.key_mgmt;
-		break;
 	case PRISM2_PARAM_WMM_ENABLED:
 		if (sdata->type != IEEE80211_IF_TYPE_STA &&
 		    sdata->type != IEEE80211_IF_TYPE_IBSS)

-- 


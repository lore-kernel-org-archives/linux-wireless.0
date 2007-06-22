Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbXFVIuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:50:44 -0400
Subject: [PATCH] mac80211: kill antenna select ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 10:10:20 +0200
Message-Id: <1182499821.21939.62.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not used anywhere.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/hostapd_ioctl.h   |    2 --
 net/mac80211/ieee80211_ioctl.c |   20 --------------------
 2 files changed, 22 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-06-22 10:08:24.558632620 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-06-22 10:08:56.158632620 +0200
@@ -31,8 +31,6 @@ enum {
 	PRISM2_PARAM_HOST_ENCRYPT = 17,
 	PRISM2_PARAM_HOST_DECRYPT = 18,
 	PRISM2_PARAM_IEEE_802_1X = 23,
-	PRISM2_PARAM_ANTSEL_TX = 24,
-	PRISM2_PARAM_ANTSEL_RX = 25,
 
 	/* Instant802 additions */
 	PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES = 1001,
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:08:59.318632620 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:09:10.418632620 +0200
@@ -2167,18 +2167,6 @@ static int ieee80211_ioctl_prism2_param(
 			sdata->ieee802_1x = value;
 		break;
 
-	case PRISM2_PARAM_ANTSEL_TX:
-		local->hw.conf.antenna_sel_tx = value;
-		if (ieee80211_hw_config(local))
-			ret = -EINVAL;
-		break;
-
-	case PRISM2_PARAM_ANTSEL_RX:
-		local->hw.conf.antenna_sel_rx = value;
-		if (ieee80211_hw_config(local))
-			ret = -EINVAL;
-		break;
-
 	case PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES:
 		local->cts_protect_erp_frames = value;
 		break;
@@ -2377,14 +2365,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = sdata->ieee802_1x;
 		break;
 
-	case PRISM2_PARAM_ANTSEL_TX:
-		*param = local->hw.conf.antenna_sel_tx;
-		break;
-
-	case PRISM2_PARAM_ANTSEL_RX:
-		*param = local->hw.conf.antenna_sel_rx;
-		break;
-
 	case PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES:
 		*param = local->cts_protect_erp_frames;
 		break;



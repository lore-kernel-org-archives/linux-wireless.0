Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbXFVIvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:51:31 -0400
Subject: [PATCH] remove PRISM2_PARAM_DROP_UNENCRYPTED ioctl
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 10:13:30 +0200
Message-Id: <1182500010.21939.64.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interestingly, wpa_supplicant doesn't use it, but uses the
currently unsupported IW_AUTH_DROP_UNENCRYPTED. So I guess
it doesn't matter anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/hostapd_ioctl.h   |    1 -
 net/mac80211/ieee80211_ioctl.c |    8 --------
 2 files changed, 9 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-06-22 10:10:28.658632620 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-06-22 10:11:24.588632620 +0200
@@ -34,7 +34,6 @@ enum {
 
 	/* Instant802 additions */
 	PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES = 1001,
-	PRISM2_PARAM_DROP_UNENCRYPTED = 1002,
 	PRISM2_PARAM_PREAMBLE = 1003,
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
 	PRISM2_PARAM_NEXT_MODE = 1008,
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:10:26.648632620 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:11:35.598632620 +0200
@@ -2171,10 +2171,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->cts_protect_erp_frames = value;
 		break;
 
-	case PRISM2_PARAM_DROP_UNENCRYPTED:
-		sdata->drop_unencrypted = value;
-		break;
-
 	case PRISM2_PARAM_PREAMBLE:
 		local->short_preamble = value;
 		break;
@@ -2369,10 +2365,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->cts_protect_erp_frames;
 		break;
 
-	case PRISM2_PARAM_DROP_UNENCRYPTED:
-		*param = sdata->drop_unencrypted;
-		break;
-
 	case PRISM2_PARAM_PREAMBLE:
 		*param = local->short_preamble;
 		break;



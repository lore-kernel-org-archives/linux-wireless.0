Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2CHODX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 09:03:23 -0500
Message-Id: <20120308140227.133587480@sipsolutions.net> (sfid-20120308_150328_058540_9FB5A49A)
Date: Thu, 08 Mar 2012 15:02:06 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] mac80211: remove spurious BSSID change flag
References: <20120308140202.751490800@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The BSSID has been set a lot earlier already and
didn't change again in ieee80211_set_associated().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/mac80211/mlme.c	2012-03-08 13:55:16.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-08 13:55:22.000000000 +0100
@@ -1351,9 +1351,6 @@ static void ieee80211_set_associated(str
 	 */
 	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
 
-	/* And the BSSID changed - we're associated now */
-	bss_info_changed |= BSS_CHANGED_BSSID;
-
 	/* Tell the driver to monitor connection quality (if supported) */
 	if (sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI &&
 	    bss_conf->cqm_rssi_thold)



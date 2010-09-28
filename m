Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:26939 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0I1Lj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 07:39:58 -0400
From: juuso.oikarinen@nokia.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix WMM driver queue configuration
Date: Tue, 28 Sep 2010 14:39:32 +0300
Message-Id: <1285673972-10502-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The WMM parameter configuration function (ieee80211_sta_wmm_params) only
configures the WMM parameters to the driver is the wmm_last_param_set
counter value is changed by the AP.

The wmm_last_param_set is initialized to -1 on association in order to ensure
the configuration is made to the driver at least once on association, but
currently this initialization is done *after* the WMM parameter configuration
function was called.

This leads to unreliability in the driver getting properly configured on first
association (depending on what counter value the AP happens to use.) When
disassociating (the wmm default parameters are configured to the driver) and
then reassociating, due to the above the WMM configuration is not set to the
driver at all.

On drivers without beacon filtering the problem is corrected by later beacons,
but on drivers with beacon filtering the WMM will remain permanently incorrectly
configured.

Fix this by moving the initialization of wmm_last_param_set to -1 before
ieee80211_sta_wmm_params is called on association.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/mlme.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8b733cf..77913a1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -880,14 +880,6 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 				IEEE80211_STA_BEACON_POLL);
 
-	/*
-	 * Always handle WMM once after association regardless
-	 * of the first value the AP uses. Setting -1 here has
-	 * that effect because the AP values is an unsigned
-	 * 4-bit value.
-	 */
-	sdata->u.mgd.wmm_last_param_set = -1;
-
 	ieee80211_led_assoc(local, 1);
 
 	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
@@ -1367,6 +1359,14 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 		return false;
 	}
 
+	/*
+	 * Always handle WMM once after association regardless
+	 * of the first value the AP uses. Setting -1 here has
+	 * that effect because the AP values is an unsigned
+	 * 4-bit value.
+	 */
+	ifmgd->wmm_last_param_set = -1;
+
 	if (elems.wmm_param)
 		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 					 elems.wmm_param_len);
-- 
1.6.3.3


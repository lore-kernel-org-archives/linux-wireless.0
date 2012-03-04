Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58905 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2CDIz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:55:59 -0500
Received: by mail-we0-f174.google.com with SMTP id x9so1794100wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:55:59 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/11] wl12xx: don't handle change_channel while associated
Date: Sun,  4 Mar 2012 10:55:51 +0200
Message-Id: <1330851355-24459-8-git-send-email-eliad@wizery.com> (sfid-20120304_095635_725669_BA6B4E18)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, CHANGE_CHANNEL indication while
associated is considered as roaming attempt.

However, with the new auth/assoc redesign,
we no longer have to handle this case,
so remove it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   43 ++++++++++++-----------------------
 1 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 65f91d7..85bbe7f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2515,35 +2515,22 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				wl1271_warning("rate policy for channel "
 					       "failed %d", ret);
 
-			if (test_bit(WLVIF_FLAG_STA_ASSOCIATED,
-				     &wlvif->flags)) {
-				if (wl12xx_dev_role_started(wlvif)) {
-					/* roaming */
-					ret = wl12xx_croc(wl,
-							  wlvif->dev_role_id);
-					if (ret < 0)
-						return ret;
-				}
-				ret = wl1271_join(wl, wlvif, false);
+			/*
+			 * change the ROC channel. do it only if we are
+			 * not idle. otherwise, CROC will be called
+			 * anyway.
+			 */
+			if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED,
+				      &wlvif->flags) &&
+			    wl12xx_dev_role_started(wlvif) &&
+			    !(conf->flags & IEEE80211_CONF_IDLE)) {
+				ret = wl12xx_stop_dev(wl, wlvif);
 				if (ret < 0)
-					wl1271_warning("cmd join on channel "
-						       "failed %d", ret);
-			} else {
-				/*
-				 * change the ROC channel. do it only if we are
-				 * not idle. otherwise, CROC will be called
-				 * anyway.
-				 */
-				if (wl12xx_dev_role_started(wlvif) &&
-				    !(conf->flags & IEEE80211_CONF_IDLE)) {
-					ret = wl12xx_stop_dev(wl, wlvif);
-					if (ret < 0)
-						return ret;
+					return ret;
 
-					ret = wl12xx_start_dev(wl, wlvif);
-					if (ret < 0)
-						return ret;
-				}
+				ret = wl12xx_start_dev(wl, wlvif);
+				if (ret < 0)
+					return ret;
 			}
 		}
 	}
-- 
1.7.6.401.g6a319


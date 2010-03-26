Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22221 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0CZKyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:37 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 20/24] wl1271: Disconnect if PSM entry fails
Date: Fri, 26 Mar 2010 12:53:29 +0200
Message-Id: <1269600813-32145-21-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

If PSM entry fails despite of retries, assume that the AP has been lost,
and indicate connection loss to the mac80211. This is much safer than
remaining in active mode.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 0e0808f..4fc212a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -82,15 +82,8 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 						 true);
 		} else {
 			wl1271_error("PSM entry failed, giving up.\n");
-			/* FIXME: this may need to be reconsidered. for now it
-			   is not possible to indicate to the mac80211
-			   afterwards that PSM entry failed. To maximize
-			   functionality (receiving data and remaining
-			   associated) make sure that we are in sync with the
-			   AP in regard of PSM mode. */
-			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
-						 false);
 			wl->psm_entry_retry = 0;
+			*beacon_loss = true;
 		}
 		break;
 	case EVENT_ENTER_POWER_SAVE_SUCCESS:
@@ -180,16 +173,8 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			return ret;
 	}
 
-	if (wl->vif && beacon_loss) {
-		/* Obviously, it's dangerous to release the mutex while
-		   we are holding many of the variables in the wl struct.
-		   That's why it's done last in the function, and care must
-		   be taken that nothing more is done after this function
-		   returns. */
-		mutex_unlock(&wl->mutex);
-		ieee80211_beacon_loss(wl->vif);
-		mutex_lock(&wl->mutex);
-	}
+	if (wl->vif && beacon_loss)
+		ieee80211_connection_loss(wl->vif);
 
 	return 0;
 }
-- 
1.6.3.3


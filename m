Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45537 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab3CLNpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:43 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 08/13] wlcore: don't attempt to roam in case of p2p
Date: Tue, 12 Mar 2013 15:44:19 +0200
Message-ID: <1363095864-24422-9-git-send-email-coelho@ti.com> (sfid-20130312_144553_316505_9963AA88)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

For STA we report beacon loss to higher levels so that wpa_s
can attempt to roam without disconnecting. In case of P2P CLI
we don't want to attempt roaming and instead disconnect immediately
upon beacon loss.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/event.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 70f289a..67f6168 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -237,6 +237,14 @@ void wlcore_event_beacon_loss(struct wl1271 *wl, unsigned long roles_bitmap)
 		    !test_bit(wlvif->role_id , &roles_bitmap))
 			continue;
 
+		vif = wl12xx_wlvif_to_vif(wlvif);
+
+		/* don't attempt roaming in case of p2p */
+		if (wlvif->p2p) {
+			ieee80211_connection_loss(vif);
+			continue;
+		}
+
 		/*
 		 * if the work is already queued, it should take place.
 		 * We don't want to delay the connection loss
@@ -246,7 +254,6 @@ void wlcore_event_beacon_loss(struct wl1271 *wl, unsigned long roles_bitmap)
 					     &wlvif->connection_loss_work,
 					     msecs_to_jiffies(delay));
 
-		vif = wl12xx_wlvif_to_vif(wlvif);
 		ieee80211_cqm_rssi_notify(
 				vif,
 				NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
-- 
1.7.10.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20522 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0BVGla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:30 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 21/22] wl1271: Disable host TX rate control
Date: Mon, 22 Feb 2010 08:38:41 +0200
Message-Id: <1266820722-20202-22-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable host TX rate control. The wl1271 firmware is already managing rate
control, so this eliminate unnecessary host processing.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index f10ba84..0a4ff7b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1973,7 +1973,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM |
 		IEEE80211_HW_BEACON_FILTER |
-		IEEE80211_HW_SUPPORTS_PS;
+		IEEE80211_HW_SUPPORTS_PS |
+		IEEE80211_HW_HAS_RATE_CONTROL;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 1b11e2c..6d109df 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -350,6 +350,8 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 		     result->id, skb, result->ack_failures,
 		     result->rate_class_index, result->status);
 
+	/* FIXME: do we need to tell the stack about the used rate? */
+
 	/* return the packet to the stack */
 	ieee80211_tx_status(wl->hw, skb);
 	wl->tx_frames[result->id] = NULL;
-- 
1.6.3.3


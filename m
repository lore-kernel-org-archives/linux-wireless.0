Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:31415 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZJULE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 07:04:28 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH] wl1271: use ieee80211_rx_ni()
Date: Wed, 21 Oct 2009 14:03:46 +0300
Message-Id: <1256123026-19963-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new ieee80211_rx_ni() function instead of ieee80211_rx().  Since we
use a workqueue to handle the RX path, we need to call the new function,
which disables bottom half handling.  This patch fixes the NOHZ:
local_softirq_pending messages.

CC: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index dbf07be..37d81ab 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -184,7 +184,7 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 		     beacon ? "beacon" : "");
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
-	ieee80211_rx(wl->hw, skb);
+	ieee80211_rx_ni(wl->hw, skb);
 }
 
 void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
-- 
1.5.6.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61703 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575AbZJHS6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:21 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/20] wl1271: remove unecessary qual parameter from rx status
Date: Thu,  8 Oct 2009 21:56:17 +0300
Message-Id: <1255028196-6565-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The qual element in ieee80211_rx_status is not used anymore, so we don't need
to set it in the wl1271_rx_status() function.  This saves a bit of time in
the RX path.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index ad8b690..5d8d401 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -91,12 +91,6 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	 */
 	status->signal = desc->rssi;
 
-	/* FIXME: Should this be optimized? */
-	status->qual = (desc->rssi - WL1271_RX_MIN_RSSI) * 100 /
-		(WL1271_RX_MAX_RSSI - WL1271_RX_MIN_RSSI);
-	status->qual = min(status->qual, 100);
-	status->qual = max(status->qual, 0);
-
 	/*
 	 * FIXME: In wl1251, the SNR should be divided by two.  In wl1271 we
 	 * need to divide by two for now, but TI has been discussing about
-- 
1.5.6.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54559 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1BBJUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 04:20:09 -0500
Received: by wyb28 with SMTP id 28so7639230wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 01:20:08 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: declare support for IEEE80211_HW_REPORTS_TX_ACK_STATUS
Date: Wed,  2 Feb 2011 11:20:05 +0200
Message-Id: <1296638405-28704-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl12xx fw supports ack status reporting for tx frames, so
add the IEEE80211_HW_REPORTS_TX_ACK_STATUS flag to our supported
features.

Since we do the rate control in the fw, we'll probably want
to adjust the STA_LOST_PKT_THRESHOLD heuristics in the future, to
account for retransmissions as well.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dfab21e..fa05149 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3215,7 +3215,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_SUPPORTS_UAPSD |
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_CONNECTION_MONITOR |
-		IEEE80211_HW_SUPPORTS_CQM_RSSI;
+		IEEE80211_HW_SUPPORTS_CQM_RSSI |
+		IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-- 
1.7.0.4


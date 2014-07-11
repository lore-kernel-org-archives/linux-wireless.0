Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37428 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaGKAB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:01:57 -0400
Received: by mail-wi0-f178.google.com with SMTP id f8so524367wiw.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:01:56 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/14] wl18xx: fix last tx rate calculation
Date: Fri, 11 Jul 2014 03:01:28 +0300
Message-Id: <1405036899-27396-4-git-send-email-eliad@wizery.com> (sfid-20140711_020202_289094_9CD53D91)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last tx rate calculation didn't take into account
the different indices of 11a and 11g rates tables.

Add the required alignment (count only from the first
11a rate in case of 11a)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/tx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/tx.c b/drivers/net/wireless/ti/wl18xx/tx.c
index be1ebd5..3406ffb 100644
--- a/drivers/net/wireless/ti/wl18xx/tx.c
+++ b/drivers/net/wireless/ti/wl18xx/tx.c
@@ -30,7 +30,7 @@
 
 static
 void wl18xx_get_last_tx_rate(struct wl1271 *wl, struct ieee80211_vif *vif,
-			     struct ieee80211_tx_rate *rate)
+			     u8 band, struct ieee80211_tx_rate *rate)
 {
 	u8 fw_rate = wl->fw_status->counters.tx_last_rate;
 
@@ -43,6 +43,8 @@ void wl18xx_get_last_tx_rate(struct wl1271 *wl, struct ieee80211_vif *vif,
 
 	if (fw_rate <= CONF_HW_RATE_INDEX_54MBPS) {
 		rate->idx = fw_rate;
+		if (band == IEEE80211_BAND_5GHZ)
+			rate->idx -= CONF_HW_RATE_INDEX_6MBPS;
 		rate->flags = 0;
 	} else {
 		rate->flags = IEEE80211_TX_RC_MCS;
@@ -102,7 +104,8 @@ static void wl18xx_tx_complete_packet(struct wl1271 *wl, u8 tx_stat_byte)
 	 * first pass info->control.vif while it's valid, and then fill out
 	 * the info->status structures
 	 */
-	wl18xx_get_last_tx_rate(wl, info->control.vif, &info->status.rates[0]);
+	wl18xx_get_last_tx_rate(wl, info->control.vif,
+				info->band, &info->status.rates[0]);
 
 	info->status.rates[0].count = 1; /* no data about retries */
 	info->status.ack_signal = -1;
-- 
1.8.5.1.109.g3d252a9


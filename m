Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54737 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaJ1LhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 07:37:19 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so597478wgg.16
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 04:37:18 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: [PATCH] ath9k: set pulse_rssi threshold to 15
Date: Tue, 28 Oct 2014 12:37:16 +0100
Message-Id: <1414496236-20874-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141028_123739_930292_91AEC62E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduce pulse_rssi threshold to 15 in order to improve radar pattern detection
probability on ext channel

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index ba3d788..5829074 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1228,7 +1228,7 @@ static void ar5008_hw_set_radar_conf(struct ath_hw *ah)
 	conf->fir_power = -33;
 	conf->radar_rssi = 20;
 	conf->pulse_height = 10;
-	conf->pulse_rssi = 24;
+	conf->pulse_rssi = 15;
 	conf->pulse_inband = 15;
 	conf->pulse_maxlen = 255;
 	conf->pulse_inband_step = 12;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 30b2f95..9bdaa0a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1391,7 +1391,7 @@ static void ar9003_hw_set_radar_conf(struct ath_hw *ah)
 	conf->fir_power = -28;
 	conf->radar_rssi = 0;
 	conf->pulse_height = 10;
-	conf->pulse_rssi = 24;
+	conf->pulse_rssi = 15;
 	conf->pulse_inband = 8;
 	conf->pulse_maxlen = 255;
 	conf->pulse_inband_step = 12;
-- 
2.1.0


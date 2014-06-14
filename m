Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45280 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaFNNuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:50:04 -0400
Received: by mail-pd0-f175.google.com with SMTP id v10so2108340pde.20
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:50:03 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id jq6sm8988143pbb.76.2014.06.14.06.50.01
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:50:03 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/16] rsi: Using band from rsi_common to fill in ieee80211_rx_status
Date: Sat, 14 Jun 2014 19:19:53 +0530
Message-Id: <1402753793-13917-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155009_247345_5583A303)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Filling in band from common->band.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index a1bdea1..45bdb99 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -770,10 +770,7 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 
 	rxs->signal = -(rssi);
 
-	if (channel <= 14)
-		rxs->band = IEEE80211_BAND_2GHZ;
-	else
-		rxs->band = IEEE80211_BAND_5GHZ;
+	rxs->band = common->band;
 
 	freq = ieee80211_channel_to_frequency(channel, rxs->band);
 
-- 
1.7.1


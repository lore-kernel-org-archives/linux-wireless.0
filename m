Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54210 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZDMQbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:31:06 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:31:06 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26563.553701.677044@gargle.gargle.HOWL> (sfid-20090413_183111_817910_99394611)
Date: Mon, 13 Apr 2009 21:56:43 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/11] ath9k: Fix bug in determining calibration support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ADC gain calibration has to be done for all non 2GHZ-HT20 channels.
Regression from "ath9k: use ieee80211_conf on ath9k_hw_iscal_supported()"

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index d0b6755..3195c0b 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -284,8 +284,8 @@ static bool ath9k_hw_iscal_supported(struct ath_hw *ah,
 		return true;
 	case ADC_GAIN_CAL:
 	case ADC_DC_CAL:
-		if (conf->channel->band == IEEE80211_BAND_5GHZ &&
-		  conf_is_ht20(conf))
+		if (!(conf->channel->band == IEEE80211_BAND_2GHZ &&
+		      conf_is_ht20(conf)))
 			return true;
 		break;
 	}
-- 
1.6.2.2


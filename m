Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53665 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab1GEDLn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 23:11:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com
Subject: [PATCH v2 1/8] ath5k: add missing checks for rfgain probe
Date: Tue,  5 Jul 2011 10:11:17 +0700
Message-Id: <1309835484-26653-1-git-send-email-nbd@openwrt.org> (sfid-20110705_051154_392859_D71987B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfgain probe is only necessary for OFDM operation on AR5111 and AR5112.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 5544191..d0bfcad 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1604,11 +1604,13 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 	int ret;
 
 	if (ah->ah_radio == AR5K_RF5110)
-		ret = ath5k_hw_rf5110_calibrate(ah, channel);
-	else {
-		ret = ath5k_hw_rf511x_iq_calibrate(ah);
+		return ath5k_hw_rf5110_calibrate(ah, channel);
+
+	ret = ath5k_hw_rf511x_iq_calibrate(ah);
+
+	if ((ah->ah_radio == AR5K_RF5112 || ah->ah_radio == AR5K_RF5112) &&
+	    (channel->hw_value & CHANNEL_OFDM))
 		ath5k_hw_request_rfgain_probe(ah);
-	}
 
 	return ret;
 }
-- 
1.7.3.2


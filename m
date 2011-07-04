Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linknet-ip-202.77.119.130.link.net.id ([202.77.119.130]:59116
	"EHLO ppac-jak-id-1.inter-touch.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755093Ab1GDGLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 02:11:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 1/8] ath5k: add missing checks for rfgain probe
Date: Mon,  4 Jul 2011 12:47:40 +0700
Message-Id: <1309758467-1712-1-git-send-email-nbd@openwrt.org> (sfid-20110704_081123_787226_D2DF5BB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfgain probe is only necessary for OFDM operation on AR5112 and no other
radio chips

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 5544191..c774468 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1604,11 +1604,12 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 	int ret;
 
 	if (ah->ah_radio == AR5K_RF5110)
-		ret = ath5k_hw_rf5110_calibrate(ah, channel);
-	else {
-		ret = ath5k_hw_rf511x_iq_calibrate(ah);
+		return ath5k_hw_rf5110_calibrate(ah, channel);
+
+	ret = ath5k_hw_rf511x_iq_calibrate(ah);
+
+	if (ah->ah_radio == AR5K_RF5112 && (channel->hw_value & CHANNEL_OFDM))
 		ath5k_hw_request_rfgain_probe(ah);
-	}
 
 	return ret;
 }
-- 
1.7.3.2


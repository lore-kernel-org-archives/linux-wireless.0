Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:42455
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855AbbIXO7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 10:59:50 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4.3] ath9k: declare required extra tx headroom
Date: Thu, 24 Sep 2015 16:59:46 +0200
Message-Id: <1443106786-67564-1-git-send-email-nbd@openwrt.org> (sfid-20150924_165953_277668_7D834078)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k inserts padding between the 802.11 header and the data area (to
align it). Since it didn't declare this extra required headroom, this
led to some nasty issues like randomly dropped packets in some setups.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 57f95f2..90eb750 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -880,6 +880,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->max_rate_tries = 10;
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vif);
+	hw->extra_tx_headroom = 4;
 
 	hw->wiphy->available_antennas_rx = BIT(ah->caps.max_rxchains) - 1;
 	hw->wiphy->available_antennas_tx = BIT(ah->caps.max_txchains) - 1;
-- 
2.2.2


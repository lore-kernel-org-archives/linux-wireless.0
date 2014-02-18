Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61971 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaBRSlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 13:41:12 -0500
Date: Tue, 18 Feb 2014 20:41:08 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Enable U-APSD AP mode support
Message-ID: <20140218184108.GA24197@jouni.qca.qualcomm.com> (sfid-20140218_194116_149252_F9CC32B2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 handles the actual operations, so ath9k can just indicate
support for this. Based on initial tests, this combination seems to
work fine.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 07a0315..4856a17 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -949,6 +949,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_5_10_MHZ;
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+	hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 
 	hw->queues = 4;
 	hw->max_rates = 4;
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58734 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424Ab1INTYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 04/12] ath9k: call ath9k_hw_set_desc_link for beacon descriptors
Date: Wed, 14 Sep 2011 21:24:19 +0200
Message-Id: <1316028267-34187-4-git-send-email-nbd@openwrt.org> (sfid-20110914_212436_919779_6552F3CB)
In-Reply-To: <1316028267-34187-3-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
 <1316028267-34187-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ensures that only ath9k_hw_set_desc_link needs to recalculate the tx
descriptor checksum on AR9380+

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6d7088b..b97d01d 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -111,6 +111,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	series[0].RateFlags = (ctsrate) ? ATH9K_RATESERIES_RTS_CTS : 0;
 	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0, ctsrate, ctsduration,
 				     series, 4, 0);
+	ath9k_hw_set_desc_link(ah, ds, 0);
 }
 
 static void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
-- 
1.7.3.2


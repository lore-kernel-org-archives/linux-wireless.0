Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7506 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab2GCPsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 11:48:55 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k: Stop the BT timers before disabling BT
Date: Tue, 3 Jul 2012 21:18:38 +0530
Message-ID: <1341330518-14685-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120703_174912_142841_AA0273D6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Stop the BT timers 'period_timer' and 'no_stomp_timer'.
Both these timers can change the BT stomp type especially
for AR9462 chipsets eventhough we had called ath9k_hw_btcoex_disable.
ath9k_hw_btcoex_disable->ath9k_hw_btcoex_bt_stomp(ah,
ATH_BTCOEX_STOMP_NONE). Will do some more analysis before sending
at as a patch.

Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Bala Shanmugam <bkamatch@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    2 +-
 drivers/net/wireless/ath/ath9k/mci.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 5eac4d1..b224e1f 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -377,9 +377,9 @@ void ath9k_stop_btcoex(struct ath_softc *sc)
 
 	if (ah->btcoex_hw.enabled &&
 	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
-		ath9k_hw_btcoex_disable(ah);
 		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_pause(sc);
+		ath9k_hw_btcoex_disable(ah);
 		if (AR_SREV_9462(ah))
 			ath_mci_flush_profile(&sc->btcoex.mci);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 64cc782..87acff7 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -174,8 +174,8 @@ skip_tuning:
 			btcoex->btcoex_period >>= 1;
 	}
 
-	ath9k_hw_btcoex_disable(sc->sc_ah);
 	ath9k_btcoex_timer_pause(sc);
+	ath9k_hw_btcoex_disable(sc->sc_ah);
 
 	if (IS_CHAN_5GHZ(sc->sc_ah->curchan))
 		return;
-- 
1.7.0.4


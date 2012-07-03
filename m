Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48310 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GCPSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 11:18:13 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k: Fix MCI cleanup
Date: Tue, 3 Jul 2012 20:47:58 +0530
Message-ID: <1341328678-13824-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120703_171817_473460_71B0404C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

We are doing MCI cleanup eventhough BTCOEX is not enabled
via module parameter. This means we do ath_mci_cleanup
though we skipped calling ath_mci_setup. Yet it does not
causes any issues now  as we free the DMA buffer allocated
only when it is allocated during ath_mci_setup.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 5eac4d1..43557c2 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -387,11 +387,13 @@ void ath9k_stop_btcoex(struct ath_softc *sc)
 
 void ath9k_deinit_btcoex(struct ath_softc *sc)
 {
+	struct ath_hw *ah = sc->sc_ah;
+
         if ((sc->btcoex.no_stomp_timer) &&
 	    ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
 
-	if (AR_SREV_9462(sc->sc_ah))
+	if (ath9k_hw_mci_is_enabled(ah))
 		ath_mci_cleanup(sc);
 }
 
-- 
1.7.0.4


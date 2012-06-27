Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51748 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab2F0IrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 04:47:13 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20458.51271.62704.231171@gargle.gargle.HOWL> (sfid-20120627_104717_288542_3FFEB1CD)
Date: Wed, 27 Jun 2012 14:15:59 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Emmanuel Benisty <benisty.e@gmail.com>
Subject: [PATCH] ath9k: Fix compilation breakage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wrap the MCI-work canceling with CONFIG_ATH9K_BTCOEX_SUPPORT.

Reported-by: Emmanuel Benisty <benisty.e@gmail.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c14cf5a..e4e73f0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -151,8 +151,10 @@ static void __ath_cancel_work(struct ath_softc *sc)
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	cancel_delayed_work_sync(&sc->hw_pll_work);
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	if (ath9k_hw_mci_is_enabled(sc->sc_ah))
 		cancel_work_sync(&sc->mci_work);
+#endif
 }
 
 static void ath_cancel_work(struct ath_softc *sc)
-- 
1.7.11


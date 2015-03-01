Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39836 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbCAGUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 01:20:18 -0500
Received: from [117.199.133.19] (port=11028 helo=sujith-pixel.localdomain)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YRxEf-002K5A-4c
	for linux-wireless@vger.kernel.org; Sun, 01 Mar 2015 01:20:17 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] ath9k: Initialize MCI state correctly
Date: Sun,  1 Mar 2015 11:53:45 +0530
Message-Id: <1425191029-13667-3-git-send-email-sujith@msujith.org> (sfid-20150301_072029_440265_84C7CCCB)
In-Reply-To: <1425191029-13667-1-git-send-email-sujith@msujith.org>
References: <1425191029-13667-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The MCI configuration values are assigned
in ath9k_hw_btcoex_init_mci() which are used
by the MCI reset routine. When initializing
BTCOEX/MCI, ath_mci_setup() ends up using
uninitialized data. Fix this by setting up
the configuration parameters before issuing
a MCI reset.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 78695b5..257ffce 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -415,12 +415,11 @@ int ath9k_init_btcoex(struct ath_softc *sc)
 		if (ath9k_hw_mci_is_enabled(ah)) {
 			sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
 			INIT_LIST_HEAD(&sc->btcoex.mci.info);
+			ath9k_hw_btcoex_init_mci(ah);
 
 			r = ath_mci_setup(sc);
 			if (r)
 				return r;
-
-			ath9k_hw_btcoex_init_mci(ah);
 		}
 
 		break;
-- 
2.3.0


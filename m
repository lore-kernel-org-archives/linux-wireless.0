Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44845 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab3HGHDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:03:07 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/2] ath9k: Fix BTCOEX usage for RX diversity
Date: Wed,  7 Aug 2013 12:29:27 +0530
Message-Id: <1375858768-24655-2-git-send-email-sujith@msujith.org> (sfid-20130807_090314_571898_128BBCB7)
In-Reply-To: <1375858768-24655-1-git-send-email-sujith@msujith.org>
References: <1375858768-24655-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

BTCOEX has to be *disabled* for WLAN RX diversity to
work on combo cards.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4afe30e..3b56c2e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -645,11 +645,11 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	/*
 	 * Enable WLAN/BT RX Antenna diversity only when:
 	 *
-	 * - BTCOEX is enabled
+	 * - BTCOEX is disabled.
 	 * - the user manually requests the feature.
 	 * - the HW cap is set using the platform data.
 	 */
-	if (common->btcoex_enabled && ath9k_bt_ant_diversity &&
+	if (!common->btcoex_enabled && ath9k_bt_ant_diversity &&
 	    (pCap->hw_caps & ATH9K_HW_CAP_BT_ANT_DIV))
 		common->bt_ant_diversity = 1;
 
-- 
1.8.3.4


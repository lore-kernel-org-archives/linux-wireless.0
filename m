Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42964 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3HDIzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:50 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/11] ath9k: Set SWCOM value for CUS198
Date: Sun,  4 Aug 2013 14:22:01 +0530
Message-Id: <1375606322-9983-10-git-send-email-sujith@msujith.org> (sfid-20130804_105604_034612_22E38D26)
In-Reply-To: <1375606322-9983-1-git-send-email-sujith@msujith.org>
References: <1375606322-9983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

CUS198/CUS230 cards require a custom value to be
programmed into the SWCOM register. Assign this during
init time.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.h   | 1 +
 drivers/net/wireless/ath/ath9k/init.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9dc6773..38f461c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -312,6 +312,7 @@ struct ath9k_ops_config {
 
 	/* Platform specific config */
 	u32 xlna_gpio;
+	u32 ant_ctrl_comm2g_switch_enable;
 	bool xatten_margin_cfg;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b678add..4afe30e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -526,6 +526,7 @@ static void ath9k_init_platform(struct ath_softc *sc)
 			       ATH9K_PCI_CUS230)) {
 		ah->config.xlna_gpio = 9;
 		ah->config.xatten_margin_cfg = true;
+		ah->config.ant_ctrl_comm2g_switch_enable = 0x000BBB88;
 		sc->ant_comb.low_rssi_thresh = 20;
 		sc->ant_comb.fast_div_bias = 3;
 
-- 
1.8.3.4


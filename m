Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41789 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1FUJY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:24:59 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 24/32] ath9k: fix antenna diversity configuration for non AR9485 chips
Date: Tue, 21 Jun 2011 11:23:44 +0200
Message-Id: <1308648232-9906-25-git-send-email-juhosg@openwrt.org> (sfid-20110621_112544_533906_E182AFB3)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current values must be used only on AR9485 chips. Other chips
requires different values.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 5e987c7..e788fa0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1214,8 +1214,14 @@ static void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				 AR_PHY_9485_ANT_DIV_ALT_LNACONF_S;
 	antconf->fast_div_bias = (regval & AR_PHY_9485_ANT_FAST_DIV_BIAS) >>
 				  AR_PHY_9485_ANT_FAST_DIV_BIAS_S;
-	antconf->lna1_lna2_delta = -9;
-	antconf->div_group = 2;
+
+	if (AR_SREV_9485(ah)) {
+		antconf->lna1_lna2_delta = -9;
+		antconf->div_group = 2;
+	} else {
+		antconf->lna1_lna2_delta = -3;
+		antconf->div_group = 0;
+	}
 }
 
 static void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
-- 
1.7.2.1


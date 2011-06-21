Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41818 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab1FUJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:25:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 27/32] ath9k: set diversity group for AR9330
Date: Tue, 21 Jun 2011 11:23:47 +0200
Message-Id: <1308648232-9906-28-git-send-email-juhosg@openwrt.org> (sfid-20110621_112532_042677_6CA9E10B)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index e788fa0..1baca8e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1215,7 +1215,10 @@ static void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 	antconf->fast_div_bias = (regval & AR_PHY_9485_ANT_FAST_DIV_BIAS) >>
 				  AR_PHY_9485_ANT_FAST_DIV_BIAS_S;
 
-	if (AR_SREV_9485(ah)) {
+	if (AR_SREV_9330_11(ah)) {
+		antconf->lna1_lna2_delta = -9;
+		antconf->div_group = 1;
+	} else if (AR_SREV_9485(ah)) {
 		antconf->lna1_lna2_delta = -9;
 		antconf->div_group = 2;
 	} else {
-- 
1.7.2.1


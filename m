Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53488 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab1EaTrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 20/32] ath9k: set NF limits for AR9330
Date: Tue, 31 May 2011 21:37:11 +0200
Message-Id: <1306870643-7935-21-git-send-email-juhosg@openwrt.org> (sfid-20110531_214922_694168_AD9903CB)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    5 ++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index a0ca1eb..eb18b63 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1089,7 +1089,10 @@ static void ar9003_hw_set_nf_limits(struct ath_hw *ah)
 {
 	ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ;
 	ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ;
-	ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9300_2GHZ;
+	if (AR_SREV_9300(ah))
+		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9330_2GHZ;
+	else
+		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9300_2GHZ;
 	ah->nf_5g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ;
 	ah->nf_5g.min = AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ;
 	ah->nf_5g.nominal = AR_PHY_CCA_NOM_VAL_9300_5GHZ;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 443090d..d259278 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -332,6 +332,8 @@
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ     -95
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ     -100
 
+#define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
+
 /*
  * AGC Field Definitions
  */
-- 
1.7.2.1


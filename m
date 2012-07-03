Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40420 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab2GCROm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:42 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 11/20] ath9k: fix XPABIASLEVEL settings for AR9550
Date: Tue,  3 Jul 2012 19:13:25 +0200
Message-Id: <1341335614-15419-12-git-send-email-juhosg@openwrt.org> (sfid-20120703_192130_203045_6FCBD7F9)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 2cdf82b..52e6955 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3509,7 +3509,7 @@ static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 
 	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
 		REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
-	else if (AR_SREV_9462(ah))
+	else if (AR_SREV_9462(ah) || AR_SREV_9550(ah))
 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
 	else {
 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index ed662c3..89907c8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -636,8 +636,8 @@
 
 #define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
 				((AR_SREV_9462(ah) ? 0x1628c : 0x16280)))
-#define AR_CH0_TOP_XPABIASLVL (0x300)
-#define AR_CH0_TOP_XPABIASLVL_S (8)
+#define AR_CH0_TOP_XPABIASLVL (AR_SREV_9550(ah) ? 0x3c0 : 0x300)
+#define AR_CH0_TOP_XPABIASLVL_S (AR_SREV_9550(ah) ? 6 : 8)
 
 #define AR_CH0_THERM	(AR_SREV_9300(ah) ? 0x16290 : \
 				((AR_SREV_9485(ah) ? 0x1628c : 0x16294)))
-- 
1.7.2.1


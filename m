Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:37858 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbbJPL2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 07:28:16 -0400
From: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
To: kaisrja1@fel.cvut.cz
Cc: sojkam1@fel.cvut.cz, linux-wireless@vger.kernel.org,
	bernd.lehmann@volkswagen.de, jan-niklas.meier@volkswagen.de,
	s.sander@nordsys.de
Subject: [RFC PATCH 2/2] ath9k: Add support for ITS-G5 band (5.9 GHz)
Date: Fri, 16 Oct 2015 13:28:05 +0200
Message-Id: <1444994885-21825-2-git-send-email-kaisrja1@fel.cvut.cz> (sfid-20151016_132821_360101_9819E980)
In-Reply-To: <1444994885-21825-1-git-send-email-kaisrja1@fel.cvut.cz>
References: <1444994885-21825-1-git-send-email-kaisrja1@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds support for Inteligent Transportation System (ITS-G5)
band to the ath9k drivers.

Signed-off-by: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
Cc: Michal Sojka <sojkam1@fel.cvut.cz>
---
 drivers/net/wireless/ath/ath9k/common-init.c | 21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h          |  6 +++++-
 drivers/net/wireless/ath/regd.c              | 18 +++++++++++++-----
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index a006c14..0f630b1 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -86,6 +86,27 @@ static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	CHAN5G(5785, 35), /* Channel 157 */
 	CHAN5G(5805, 36), /* Channel 161 */
 	CHAN5G(5825, 37), /* Channel 165 */
+
+#ifdef CONFIG_CFG80211_REG_ITSG5_BAND
+	/* ITS-G5B */
+	CHAN5G(5855, 38), /* Channel 171 */
+	CHAN5G(5860, 39), /* Channel 172 */
+	CHAN5G(5865, 40), /* Channel 173 */
+	CHAN5G(5870, 41), /* Channel 174 */
+	/* ITS-G5A */
+	CHAN5G(5875, 42), /* Channel 175 */
+	CHAN5G(5880, 43), /* Channel 176 */
+	CHAN5G(5885, 44), /* Channel 177 */
+	CHAN5G(5890, 45), /* Channel 178 */
+	CHAN5G(5895, 46), /* Channel 179 */
+	CHAN5G(5900, 47), /* Channel 180 */
+	CHAN5G(5905, 48), /* Channel 181 */
+	/* ITS-G5D */
+	CHAN5G(5910, 49), /* Channel 182 */
+	CHAN5G(5915, 50), /* Channel 183 */
+	CHAN5G(5920, 51), /* Channel 184 */
+	CHAN5G(5925, 52), /* Channel 185 */
+#endif
 };
 
 /* Atheros hardware rate code addition for short premble */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e8454db..38da6780 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -73,7 +73,11 @@
 
 #define ATH9K_RSSI_BAD			-128
 
-#define ATH9K_NUM_CHANNELS	38
+#ifdef CONFIG_CFG80211_REG_ITSG5_BAND
+#define ATH9K_NUM_CHANNELS		53
+#else
+#define ATH9K_NUM_CHANNELS		38
+#endif
 
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 06ea6cc..28bbbe0 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -50,6 +50,9 @@ static int __ath_regd_init(struct ath_regulatory *reg);
 #define ATH9K_5GHZ_5725_5850	REG_RULE(5725-10, 5850+10, 80, 0, 30,\
 					 NL80211_RRF_NO_IR)
 
+#define ATH9K_5GHZ_ITSG5	REG_RULE(5855-5, 5925+5, 10, 0, 33,\
+					 NL80211_RRF_ITSG5)
+
 #define ATH9K_2GHZ_ALL		ATH9K_2GHZ_CH01_11, \
 				ATH9K_2GHZ_CH12_13, \
 				ATH9K_2GHZ_CH14
@@ -64,53 +67,58 @@ static int __ath_regd_init(struct ath_regulatory *reg);
 /* Can be used for:
  * 0x60, 0x61, 0x62 */
 static const struct ieee80211_regdomain ath_world_regdom_60_61_62 = {
-	.n_reg_rules = 5,
+	.n_reg_rules = 6,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH9K_2GHZ_ALL,
 		ATH9K_5GHZ_ALL,
+		ATH9K_5GHZ_ITSG5,
 	}
 };
 
 /* Can be used by 0x63 and 0x65 */
 static const struct ieee80211_regdomain ath_world_regdom_63_65 = {
-	.n_reg_rules = 4,
+	.n_reg_rules = 5,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH9K_2GHZ_CH01_11,
 		ATH9K_2GHZ_CH12_13,
 		ATH9K_5GHZ_NO_MIDBAND,
+		ATH9K_5GHZ_ITSG5,
 	}
 };
 
 /* Can be used by 0x64 only */
 static const struct ieee80211_regdomain ath_world_regdom_64 = {
-	.n_reg_rules = 3,
+	.n_reg_rules = 4,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH9K_2GHZ_CH01_11,
 		ATH9K_5GHZ_NO_MIDBAND,
+		ATH9K_5GHZ_ITSG5,
 	}
 };
 
 /* Can be used by 0x66 and 0x69 */
 static const struct ieee80211_regdomain ath_world_regdom_66_69 = {
-	.n_reg_rules = 3,
+	.n_reg_rules = 4,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH9K_2GHZ_CH01_11,
 		ATH9K_5GHZ_ALL,
+		ATH9K_5GHZ_ITSG5,
 	}
 };
 
 /* Can be used by 0x67, 0x68, 0x6A and 0x6C */
 static const struct ieee80211_regdomain ath_world_regdom_67_68_6A_6C = {
-	.n_reg_rules = 4,
+	.n_reg_rules = 5,
 	.alpha2 =  "99",
 	.reg_rules = {
 		ATH9K_2GHZ_CH01_11,
 		ATH9K_2GHZ_CH12_13,
 		ATH9K_5GHZ_ALL,
+		ATH9K_5GHZ_ITSG5,
 	}
 };
 
-- 
2.1.4


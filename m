Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54785 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbbKWS14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:27:56 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	=?UTF-8?q?Jan=20Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>,
	Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH v2 8/8] ath9k: Add support for ITS-G5 band (5.9 GHz)
Date: Mon, 23 Nov 2015 19:27:21 +0100
Message-Id: <1448303241-27747-9-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192807_524523_BB295701)
In-Reply-To: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds support for Intelligent Transportation System (ITS-G5)
band to the ath9k driver. The corresponding channels are allowed only if
CONFIG_CFG80211_REG_ITSG5_BAND is set and if the user provides custom
regulatory database. In addition, the band is limited to OCB mode.

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 drivers/net/wireless/ath/ath9k/common-init.c | 19 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h          |  2 +-
 drivers/net/wireless/ath/regd.c              | 23 ++++++++++++++++++-----
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index a006c14..0b61c63 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -86,6 +86,25 @@ static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	CHAN5G(5785, 35), /* Channel 157 */
 	CHAN5G(5805, 36), /* Channel 161 */
 	CHAN5G(5825, 37), /* Channel 165 */
+
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
 };
 
 /* Atheros hardware rate code addition for short premble */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 831a544..cb126ff 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -73,7 +73,7 @@
 
 #define ATH9K_RSSI_BAD			-128
 
-#define ATH9K_NUM_CHANNELS	38
+#define ATH9K_NUM_CHANNELS	53
 
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 06ea6cc..38706ff 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -50,6 +50,14 @@ static int __ath_regd_init(struct ath_regulatory *reg);
 #define ATH9K_5GHZ_5725_5850	REG_RULE(5725-10, 5850+10, 80, 0, 30,\
 					 NL80211_RRF_NO_IR)
 
+#ifdef CONFIG_CFG80211_REG_ITSG5_BAND
+#define ATH9K_5GHZ_ITSG5	REG_RULE(5850, 5925, 10, 0, 33, \
+					 NL80211_RRF_USER_REGD_NEEDED | \
+					 NL80211_RRF_OCB_ONLY)
+#else
+#define ATH9K_5GHZ_ITSG5	{} /* Empty rule does not match any channel */
+#endif
+
 #define ATH9K_2GHZ_ALL		ATH9K_2GHZ_CH01_11, \
 				ATH9K_2GHZ_CH12_13, \
 				ATH9K_2GHZ_CH14
@@ -64,53 +72,58 @@ static int __ath_regd_init(struct ath_regulatory *reg);
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
2.5.3


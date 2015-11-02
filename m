Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:52525 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbbKBKXN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 05:23:13 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	=?UTF-8?q?Jan=20Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>,
	Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH v2] ath9k: Add support for ITS-G5 band (5.9 GHz)
Date: Mon,  2 Nov 2015 11:22:57 +0100
Message-Id: <1446459777-5944-1-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151102_112317_313810_544EA4AA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jan Kaisrlik <kaisrja1@fel.cvut.cz>

The patch adds support for Intelligent Transportation System (ITS-G5)
band to the ath9k driver.

Signed-off-by: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
Cc: Michal Sojka <sojkam1@fel.cvut.cz>
---

Hi all,

in this second version of the patch we removed dependency on
CFG80211_CERTIFICATION_ONUS as suggested by Johannes. We are, however,
not sure whether this is the right thing to do.

The problem is that ath9k uses (REGULATORY_STRICT_REG |
REGULATORY_CUSTOM_REG), which means that in order to use the 5.9 GHz
band, ath9k's private regdomain has to be extended. This in turn means
that the 5.9 GHz band is enabled by default in many configurations. It
can be disabled if one sends a regulatory hint and has valid regdb in
user space, but this cannot be relied upon.

As I already wrote, I don't think that regulatory documents allow such
behavior:

  In EU, regulatory (ECC Decision (08)01) reads:

    ... decides ... that CEPT administrations shall designate the
    frequency sub-band 5875-5905 MHz on a non-exclusive basis for ITS
    traffic safety applications;

  I understand this that the band can be used only by "traffic safety
  applications" and not by random laptops running Linux.

  In US, regulatory (FCC 03-324) says among others:

    § 95.603 (h) Each Dedicated Short-Range Communications Service
    On-Board Unit (DSRCS-OBU) that operates or is intended to operate
    in the DSRCS (5.850-5.925 GHz) must be certified in accordance
    with subpart L of this part and subpart J of part 2 of this
    chapter.

Especially the US regulatory suggests that using
CFG80211_CERTIFICATION_ONUS might have sense (see the previous version
http://www.mail-archive.com/linux-wireless@vger.kernel.org/msg15228.html).
What do you think?

Thanks.
-Michal & Jan


 drivers/net/wireless/ath/ath9k/common-init.c | 19 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h          |  2 +-
 drivers/net/wireless/ath/regd.c              | 17 ++++++++++++-----
 3 files changed, 32 insertions(+), 6 deletions(-)

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
index e8454db..debf609 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -73,7 +73,7 @@
 
 #define ATH9K_RSSI_BAD			-128
 
-#define ATH9K_NUM_CHANNELS	38
+#define ATH9K_NUM_CHANNELS	53
 
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 444bd28..1f8b209 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -50,6 +50,8 @@ static int __ath_regd_init(struct ath_regulatory *reg);
 #define ATH9K_5GHZ_5725_5850	REG_RULE(5725-10, 5850+10, 80, 0, 30,\
 					 NL80211_RRF_NO_IR)
 
+#define ATH9K_5GHZ_ITSG5	REG_RULE(5855-5, 5925+5, 10, 0, 33, 0)
+
 #define ATH9K_2GHZ_ALL		ATH9K_2GHZ_CH01_11, \
 				ATH9K_2GHZ_CH12_13, \
 				ATH9K_2GHZ_CH14
@@ -64,53 +66,58 @@ static int __ath_regd_init(struct ath_regulatory *reg);
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


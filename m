Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:52484 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbdCPPV4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 11:21:56 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Subject: [PATCH 1/3] ath9k: Support channels in licensed bands
Date: Thu, 16 Mar 2017 16:13:35 +0100
Message-Id: <20170316151337.24163-2-sw@simonwunderlich.de> (sfid-20170316_162718_137560_1F280B0F)
In-Reply-To: <20170316151337.24163-1-sw@simonwunderlich.de>
References: <20170316151337.24163-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Many chips support channels in licensed bands. Add support for those,
along with a corresponding kernel config option to disable them by
default. Note that these channels are not selectable even if the
option has been compiled unless the user modifies the regulatory
database to explicitly enable the corresponding channels.

NOTE:  These channels must not be used in most regulatory
domains unless you have a license from the FCC or similar!

Signed-off-by: Ben Greear <greearb@candelatech.com>
[Hide this support behind a Kconfig option]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
[only use the 20 mhz channels, add 5 ghz, change to 4.9ghz to licensed bands]
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/Kconfig       | 20 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h       |  2 +-
 drivers/net/wireless/ath/ath9k/common-init.c | 35 +++++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/hw.h          |  4 ++--
 4 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 783a38f1a626..23b8abf4449a 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -116,6 +116,26 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
+config ATH9K_LICENSED_CHAN
+	bool "Support channels in licensed bands"
+	depends on ATH9K && CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  This option enables support for licensed channels on such as
+          4.9 GHz (public safety).
+
+	  These are PUBLIC SAFETY CHANNELS and MUST NOT BE USED in most
+	  regulatory domains UNLESS YOU HAVE A FULL LICENSE for their use from
+	  your local radio regulator, e.g. the FCC or equivalent. Using these
+	  channels without proper authorisation may result in serious legal
+	  consequences.
+
+	  You will also have to build a regulatory database with these channels
+	  enabled to actually use them.
+
+	  If you are a distro kernel builder or have any doubt whatsoever about
+	  your legal ability to use these channels, say N.
+
 config ATH9K_DYNACK
 	bool "Atheros ath9k ACK timeout estimation algorithm (EXPERIMENTAL)"
 	depends on ATH9K
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index cf076719c27e..d215c3f968d4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -996,7 +996,7 @@ struct ath_softc {
 	struct device *dev;
 
 	struct survey_info *cur_survey;
-	struct survey_info survey[ATH9K_NUM_CHANNELS];
+	struct survey_info survey[ATH9K_MAX_NUM_CHANNELS];
 
 	spinlock_t intr_lock;
 	struct tasklet_struct intr_tq;
diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index 8b4f7fdabf58..0d632c22bc16 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -86,6 +86,22 @@ static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	CHAN5G(5785, 35), /* Channel 157 */
 	CHAN5G(5805, 36), /* Channel 161 */
 	CHAN5G(5825, 37), /* Channel 165 */
+
+#ifdef CONFIG_ATH9K_LICENSED_CHAN
+	/* 4.9Ghz channels, public safety channels, license is required in US
+	 * and most other regulatory domains!
+	 */
+	/* 802.11j 4.9 GHz (20 MHz) */
+	CHAN5G(4920, 38), /* channel 184 */
+	CHAN5G(4940, 39), /* channel 188 */
+	CHAN5G(4960, 40), /* channel 192 */
+	CHAN5G(4980, 41), /* channel 196 */
+	/* 802.11j 5.030 - 5.080 GHz (20 MHz) */
+	CHAN5G(5040, 42), /* channel 8 */
+	CHAN5G(5060, 43), /* channel 12 */
+	CHAN5G(5080, 44), /* channel 16 */
+#endif
+#define ATH9K_NUM_LICENSED_CHANNELS 7
 };
 
 /* Atheros hardware rate code addition for short premble */
@@ -126,10 +142,14 @@ int ath9k_cmn_init_channels_rates(struct ath_common *common)
 {
 	struct ath_hw *ah = (struct ath_hw *)common->ah;
 	void *channels;
+	int num_5ghz_chan = ARRAY_SIZE(ath9k_5ghz_chantable);
+
+	if (!IS_ENABLED(CONFIG_ATH9K_LICENSED_CHAN))
+		num_5ghz_chan -= ATH9K_NUM_LICENSED_CHANNELS;
 
 	BUILD_BUG_ON(ARRAY_SIZE(ath9k_2ghz_chantable) +
-		     ARRAY_SIZE(ath9k_5ghz_chantable) !=
-		     ATH9K_NUM_CHANNELS);
+		     ARRAY_SIZE(ath9k_5ghz_chantable) >
+		     ATH9K_MAX_NUM_CHANNELS);
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
 		channels = devm_kzalloc(ah->dev,
@@ -149,17 +169,16 @@ int ath9k_cmn_init_channels_rates(struct ath_common *common)
 	}
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ) {
-		channels = devm_kzalloc(ah->dev,
-			sizeof(ath9k_5ghz_chantable), GFP_KERNEL);
+		int ch_sz = num_5ghz_chan * sizeof(ath9k_5ghz_chantable[0]);
+
+		channels = devm_kzalloc(ah->dev, ch_sz, GFP_KERNEL);
 		if (!channels)
 			return -ENOMEM;
 
-		memcpy(channels, ath9k_5ghz_chantable,
-		       sizeof(ath9k_5ghz_chantable));
+		memcpy(channels, ath9k_5ghz_chantable, ch_sz);
 		common->sbands[NL80211_BAND_5GHZ].channels = channels;
 		common->sbands[NL80211_BAND_5GHZ].band = NL80211_BAND_5GHZ;
-		common->sbands[NL80211_BAND_5GHZ].n_channels =
-			ARRAY_SIZE(ath9k_5ghz_chantable);
+		common->sbands[NL80211_BAND_5GHZ].n_channels = num_5ghz_chan;
 		common->sbands[NL80211_BAND_5GHZ].bitrates =
 			ath9k_legacy_rates + 4;
 		common->sbands[NL80211_BAND_5GHZ].n_bitrates =
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9cbca1229bac..496e3cd1b509 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -73,7 +73,7 @@
 
 #define ATH9K_RSSI_BAD			-128
 
-#define ATH9K_NUM_CHANNELS	38
+#define ATH9K_MAX_NUM_CHANNELS	45
 
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
@@ -777,7 +777,7 @@ struct ath_hw {
 	struct ath9k_hw_version hw_version;
 	struct ath9k_ops_config config;
 	struct ath9k_hw_capabilities caps;
-	struct ath9k_channel channels[ATH9K_NUM_CHANNELS];
+	struct ath9k_channel channels[ATH9K_MAX_NUM_CHANNELS];
 	struct ath9k_channel *curchan;
 
 	union {
-- 
2.11.0

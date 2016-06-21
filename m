Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35672 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbcFUB7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 21:59:43 -0400
Received: by mail-pa0-f68.google.com with SMTP id hf6so174141pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2016 18:59:43 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, Ben Greear <greearb@candelatech.com>,
	Julian Calaby <julian.calaby@gmail.com>
Subject: [PATCH] ath9k: Support 4.9Ghz channels on AR9580 adapter.
Date: Tue, 21 Jun 2016 11:02:20 +1000
Message-Id: <1466470940-25229-1-git-send-email-julian.calaby@gmail.com> (sfid-20160621_035947_022251_E3D405EF)
In-Reply-To: <CAGRGNgWOScCrLPyqRNus2319BPOehv3awQChoHw=RRMcSDUqzQ@mail.gmail.com>
References: <CAGRGNgWOScCrLPyqRNus2319BPOehv3awQChoHw=RRMcSDUqzQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

NOTE:  These channels must not be used in most regulatory
domains unless you have a license from the FCC or similar!

A proper regulatory database is also required to actually use
these channels.

Signed-off-by: Ben Greear <greearb@candelatech.com>
[Hide this support behind a Kconfig option]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig       | 19 +++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h       |  2 +-
 drivers/net/wireless/ath/ath9k/common-init.c | 49 +++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/hw.h          |  4 +--
 4 files changed, 63 insertions(+), 11 deletions(-)

Hi Kalle,

I've only done this work as I hate to see people's efforts go to
waste and I feel that there's enough roadblocks in the way of
actually using this functionality that casual idiots won't be able
to.

I've tried to keep the code hidden by the Kconfig option as minimal
as possible, however the #ifdef in ath9k_49ghz_capable() is arguably
not required as returning true from that function still results in no
action if the option is not enabled.

This is compile tested only as I cannot test this for real as I lack
both the hardware and license required.

Thanks,

Julian Calaby


diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index f68cb00..57b0a41 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -114,6 +114,25 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
+config ATH9K_49_GHZ_CHAN
+	bool "Support 4.9Ghz public safety channels on some devices"
+	depends on ATH9K && CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  This option enables support for 4.9 GHz channels on AR9580.
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
index 93b3793..d8744b5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -954,7 +954,7 @@ struct ath_softc {
 	struct device *dev;
 
 	struct survey_info *cur_survey;
-	struct survey_info survey[ATH9K_NUM_CHANNELS];
+	struct survey_info survey[ATH9K_MAX_NUM_CHANNELS];
 
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index 8b4f7fd..f6a495b 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -86,6 +86,24 @@ static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	CHAN5G(5785, 35), /* Channel 157 */
 	CHAN5G(5805, 36), /* Channel 161 */
 	CHAN5G(5825, 37), /* Channel 165 */
+
+#ifdef ATH9K_49_GHZ_CHAN
+	/* 4.9Ghz channels, public safety channels, license is required in US
+	 * and most other regulatory domains!
+	 */
+	CHAN5G(4915, 38), /* Channel 183 */
+	CHAN5G(4920, 39), /* Channel 184 */
+	CHAN5G(4925, 40), /* Channel 185 */
+	CHAN5G(4935, 41), /* Channel 187 */
+	CHAN5G(4940, 42), /* Channel 188 */
+	CHAN5G(4945, 43), /* Channel 189 */
+	CHAN5G(4960, 44), /* Channel 192 */
+	CHAN5G(4970, 45), /* Channel 194 */
+	CHAN5G(4980, 46), /* Channel 196 */
+#define ATH9K_NUM_49GHZ_CHANNELS 9
+#else
+#define ATH9K_NUM_49GHZ_CHANNELS 0
+#endif
 };
 
 /* Atheros hardware rate code addition for short premble */
@@ -122,14 +140,31 @@ static struct ieee80211_rate ath9k_legacy_rates[] = {
 			 IEEE80211_RATE_SUPPORTS_10MHZ)),
 };
 
+static bool ath9k_49ghz_capable(struct ath_hw *ah)
+{
+#ifdef ATH9K_49_GHZ_CHAN
+	/* Seems AR9580 supports 4.9ghz, at least. */
+	switch (ah->hw_version.devid) {
+	case AR9300_DEVID_AR9580:
+		return true;
+	}
+#endif
+
+	return false;
+}
+
 int ath9k_cmn_init_channels_rates(struct ath_common *common)
 {
 	struct ath_hw *ah = (struct ath_hw *)common->ah;
 	void *channels;
+	int num_5ghz_chan = ARRAY_SIZE(ath9k_5ghz_chantable);
+
+	if (!ath9k_49ghz_capable(ah))
+		num_5ghz_chan -= ATH9K_NUM_49GHZ_CHANNELS;
 
 	BUILD_BUG_ON(ARRAY_SIZE(ath9k_2ghz_chantable) +
-		     ARRAY_SIZE(ath9k_5ghz_chantable) !=
-		     ATH9K_NUM_CHANNELS);
+		     ARRAY_SIZE(ath9k_5ghz_chantable) >
+		     ATH9K_MAX_NUM_CHANNELS);
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
 		channels = devm_kzalloc(ah->dev,
@@ -149,17 +184,16 @@ int ath9k_cmn_init_channels_rates(struct ath_common *common)
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
index 9cbca12..8115d86 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -73,7 +73,7 @@
 
 #define ATH9K_RSSI_BAD			-128
 
-#define ATH9K_NUM_CHANNELS	38
+#define ATH9K_MAX_NUM_CHANNELS	47
 
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
2.8.1


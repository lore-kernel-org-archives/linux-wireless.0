Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17555 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064Ab2GCXPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 19:15:34 -0400
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
Subject: [PATCH 2/4] ath5k: replace modparam_all_channels with CONFIG_ATH5K_TEST_CHANNELS
Date: Tue, 3 Jul 2012 16:15:13 -0700
Message-ID: <1341357315-8053-3-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120704_011537_448415_E9D3EA55)
In-Reply-To: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

This stashes away this feature from standard kernel builds.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath5k/Kconfig |    8 ++++++++
 drivers/net/wireless/ath/ath5k/base.c  |   17 ++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index e18a9aa..338c5c4 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -64,3 +64,11 @@ config ATH5K_PCI
 	---help---
 	  This adds support for PCI type chipsets of the 5xxx Atheros
 	  family.
+
+config ATH5K_TEST_CHANNELS
+	bool "Enables testing channels on ath5k"
+	depends on ATH5K && CFG80211_CERTIFICATION_ONUS
+	---help---
+	  This enables non-standard IEEE 802.11 channels on ath5k, which
+	  can be used for research purposes. This option should be disabled
+	  unless doing research.
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 44ad6fe..8c4c040 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -74,10 +74,6 @@ bool ath5k_modparam_nohwcrypt;
 module_param_named(nohwcrypt, ath5k_modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
-static bool modparam_all_channels;
-module_param_named(all_channels, modparam_all_channels, bool, S_IRUGO);
-MODULE_PARM_DESC(all_channels, "Expose all channels the device can use.");
-
 static bool modparam_fastchanswitch;
 module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
 MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
@@ -258,8 +254,15 @@ static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *re
 \********************/
 
 /*
- * Returns true for the channel numbers used without all_channels modparam.
+ * Returns true for the channel numbers used.
  */
+#ifdef CONFIG_ATH5K_TEST_CHANNELS
+static bool ath5k_is_standard_channel(short chan, enum ieee80211_band band)
+{
+	return true;
+}
+
+#else
 static bool ath5k_is_standard_channel(short chan, enum ieee80211_band band)
 {
 	if (band == IEEE80211_BAND_2GHZ && chan <= 14)
@@ -276,6 +279,7 @@ static bool ath5k_is_standard_channel(short chan, enum ieee80211_band band)
 		/* 802.11j 4.9GHz (20MHz) */
 		(chan == 184 || chan == 188 || chan == 192 || chan == 196));
 }
+#endif
 
 static unsigned int
 ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
@@ -316,8 +320,7 @@ ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
 		if (!ath5k_channel_ok(ah, &channels[count]))
 			continue;
 
-		if (!modparam_all_channels &&
-		    !ath5k_is_standard_channel(ch, band))
+		if (!ath5k_is_standard_channel(ch, band))
 			continue;
 
 		count++;
-- 
1.7.10.rc1.22.gf5241


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32592 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab2GRAPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 20:15:34 -0400
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <c_manoha@qca.qualcomm.com>, <chunkeey@googlemail.com>,
	<nbd@openwrt.org>
Subject: [RFC v2] ath: add feature to enable cell base station regulatory hints
Date: Tue, 17 Jul 2012 17:15:08 -0700
Message-ID: <1342570508-8373-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20120718_021544_830741_4B069815)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

This enables the capability to enable cellular base station
regulatory hint support to ath5k, ath9k, ath9k_htc and carl9170.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---

This adds a URL for documentation / reference. Other drivers
should consider doing the same.

 drivers/net/wireless/ath/Kconfig |   18 ++++++++++++++++++
 drivers/net/wireless/ath/regd.c  |   12 ++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 0960224..99f1f5b 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -22,6 +22,24 @@ config ATH_DEBUG
 	  Say Y, if you want to debug atheros wireless drivers.
 	  Right now only ath9k makes use of this.
 
+config ATH_CELL_STATION_HINT
+	bool "Atheros common cell base station hint support"
+	depends on (ATH9K || ATH9K_HTC || ATH5K || CARL9170)
+	depends on CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  You should disable this feature unless you are a system
+	  integrator and want to enable cellular base station
+	  regulatory hint support onto either or these drivers:
+	  ath5k, ath9k, ath9k_htc, carl9170. You should disable
+	  this feature unless you are building a specific system
+	  you are providing complete oversight over and are willing
+	  and able to test regulatory compliance for it.
+
+	  For more details refer to:
+
+	  http://wireless.kernel.org/en/developers/Regulatory/processing_rules#Cellular_base_station_regulatory_hints
+
 source "drivers/net/wireless/ath/ath5k/Kconfig"
 source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/carl9170/Kconfig"
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index d816980..6751533 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -504,6 +504,17 @@ ath_get_regpair(int regdmn)
 	return NULL;
 }
 
+#ifdef CONFIG_ATH_CELL_STATION_HINT
+static void ath_regd_features(struct wiphy *wiphy)
+{
+	wiphy->features |= NL80211_FEATURE_CELL_BASE_REG_HINTS;
+}
+#else
+static void ath_regd_features(struct wiphy *wiphy)
+{
+}
+#endif
+
 static int
 ath_regd_init_wiphy(struct ath_regulatory *reg,
 		    struct wiphy *wiphy,
@@ -514,6 +525,7 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 
 	wiphy->reg_notifier = reg_notifier;
 	wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
+	ath_regd_features(wiphy);
 
 	if (ath_is_world_regd(reg)) {
 		/*
-- 
1.7.10.rc1.22.gf5241


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:37857 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbbJPL2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 07:28:16 -0400
From: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
To: kaisrja1@fel.cvut.cz
Cc: sojkam1@fel.cvut.cz, linux-wireless@vger.kernel.org,
	bernd.lehmann@volkswagen.de, jan-niklas.meier@volkswagen.de,
	s.sander@nordsys.de
Subject: [RFC PATCH 1/2] cfg80211: Add support for ITS-G5 band (5.9 GHz)
Date: Fri, 16 Oct 2015 13:28:04 +0200
Message-Id: <1444994885-21825-1-git-send-email-kaisrja1@fel.cvut.cz> (sfid-20151016_132820_779190_3F5069D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds support for Intelligent Transportation System (ITS-G5)
band as defined by ETSI EN 302 663 standard. This band is enabled by
a new configuration option CFG80211_REG_ITSG5_BAND, which depends on
CFG80211_CERTIFICATION_ONUS.

Signed-off-by: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
Cc: Michal Sojka <sojkam1@fel.cvut.cz>
---
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/Kconfig         | 21 +++++++++++++++++++++
 net/wireless/reg.c           |  4 ++++
 3 files changed, 27 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c0ab6b0..9defe0a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2838,6 +2838,7 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_NO_HT40PLUS: channels can't be used in HT40+ operation
  * @NL80211_RRF_NO_80MHZ: 80MHz operation not allowed
  * @NL80211_RRF_NO_160MHZ: 160MHz operation not allowed
+ * @NL80211_RRF_ITSG5: band is reserved for Intelligent Transportation System
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2855,6 +2856,7 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_HT40PLUS		= 1<<14,
 	NL80211_RRF_NO_80MHZ		= 1<<15,
 	NL80211_RRF_NO_160MHZ		= 1<<16,
+	NL80211_RRF_ITSG5		= 1<<17,
 };
 
 #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 4f5543d..2f7767c 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -132,6 +132,27 @@ config CFG80211_REG_RELAX_NO_IR
 	 support this feature by declaring the appropriate channel flags and
 	 capabilities in their registration flow.
 
+config CFG80211_REG_ITSG5_BAND
+	bool "cfg80211 support for ITS-G5 bands (5.9 GHz)"
+	def_bool n
+	depends on CFG80211_CERTIFICATION_ONUS
+	---help---
+	This option enables support for Inteligent Transportation System (ITS)
+	band 5.855 to 5.925 GHz. The band is standardized for Europe in the ETSI
+	EN 302 663 standard. This band is split into several sub-bands:
+
+	- ITS-G5A (5.875 to 5.905 GHz) band is reserved for ITS road safety
+	  related applications and is regulated by Commission Decision 2008/671/EC.
+
+	- ITS-G5B (5.855 to 5.875 GHz) band is reserved for ITS non-safety
+	  applications and is regulated by ECC Recommendation ECC/REC/(08)01.
+
+	- ITS-G5D (5.905 to 5.925 GHz) band is reserved for future ITS
+	  applications and is regulated by ECC Decision ECC/DEC(02)01.
+
+	Enable this option only if you work on the above mentioned applications
+	and comply with the regulatory documents.
+
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2510b231..82e7b3b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1020,6 +1020,10 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 		rr = &regd->reg_rules[i];
 		fr = &rr->freq_range;
 
+		if (!config_enabled(CONFIG_CFG80211_REG_ITSG5_BAND) &&
+			 (rr->flags & NL80211_RRF_ITSG5))
+			return ERR_PTR(-EPERM);
+
 		/*
 		 * We only need to know if one frequency rule was
 		 * was in center_freq's band, that's enough, so lets
-- 
2.1.4


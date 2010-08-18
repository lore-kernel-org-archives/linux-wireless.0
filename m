Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1413 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab0HRQSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/16] iwlwifi: configurable ampdu factor and density
Date: Wed, 18 Aug 2010 09:22:48 -0700
Message-Id: <1282148571-9258-14-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ampdu factor and density to .cfg, this allow both parameters
can be configure per device based.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   13 ++++++++++++-
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c31177c..e6497c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -239,7 +239,11 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
 	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
+	if (priv->cfg->ampdu_factor)
+		ht_info->ampdu_factor = priv->cfg->ampdu_factor;
 	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
+	if (priv->cfg->ampdu_density)
+		ht_info->ampdu_density = priv->cfg->ampdu_density;
 
 	ht_info->mcs.rx_mask[0] = 0xFF;
 	if (rx_chains_num >= 2)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4f4280e..6bd6013 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -281,6 +281,8 @@ struct iwl_mod_params {
  * @need_dc_calib: need to perform init dc calibration
  * @bt_statistics: use BT version of statistics notification
  * @agg_time_limit: maximum number of uSec in aggregation
+ * @ampdu_factor: Maximum A-MPDU length factor
+ * @ampdu_density: Minimum A-MPDU spacing
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -352,6 +354,8 @@ struct iwl_cfg {
 	const bool need_dc_calib;
 	const bool bt_statistics;
 	u16 agg_time_limit;
+	u8 ampdu_factor;
+	u8 ampdu_density;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 37ec76a..1ad3303 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -435,7 +435,13 @@ union iwl_ht_rate_supp {
 	};
 };
 
-#define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
+#define CFG_HT_RX_AMPDU_FACTOR_8K   (0x0)
+#define CFG_HT_RX_AMPDU_FACTOR_16K  (0x1)
+#define CFG_HT_RX_AMPDU_FACTOR_32K  (0x2)
+#define CFG_HT_RX_AMPDU_FACTOR_64K  (0x3)
+#define CFG_HT_RX_AMPDU_FACTOR_DEF  CFG_HT_RX_AMPDU_FACTOR_64K
+#define CFG_HT_RX_AMPDU_FACTOR_MAX  CFG_HT_RX_AMPDU_FACTOR_64K
+#define CFG_HT_RX_AMPDU_FACTOR_MIN  CFG_HT_RX_AMPDU_FACTOR_8K
 
 /*
  * Maximal MPDU density for TX aggregation
@@ -444,8 +450,13 @@ union iwl_ht_rate_supp {
  * 6 - 8us density
  * 7 - 16us density
  */
+#define CFG_HT_MPDU_DENSITY_2USEC   (0x4)
 #define CFG_HT_MPDU_DENSITY_4USEC   (0x5)
+#define CFG_HT_MPDU_DENSITY_8USEC   (0x6)
+#define CFG_HT_MPDU_DENSITY_16USEC  (0x7)
 #define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_4USEC
+#define CFG_HT_MPDU_DENSITY_MAX CFG_HT_MPDU_DENSITY_16USEC
+#define CFG_HT_MPDU_DENSITY_MIN     (0x1)
 
 struct iwl_ht_config {
 	/* self configuration data */
-- 
1.7.0.4


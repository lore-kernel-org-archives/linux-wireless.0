Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1413 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab0HRQSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/16] iwlwifi: make aggregation time limit configurable
Date: Wed, 18 Aug 2010 09:22:39 -0700
Message-Id: <1282148571-9258-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By default, aggregation time limit is 4000 uSec, add the parameter to
.cfg
to allow this parameter can be configure per device base if needed.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 ++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 23e5c42..7c4deee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2694,8 +2694,18 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 
 	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	lq_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+
 	lq_cmd->agg_params.agg_time_limit =
 		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
+	/*
+	 * overwrite if needed, pass aggregation time limit
+	 * to uCode in uSec
+	 */
+	if (priv && priv->cfg->agg_time_limit &&
+	    priv->cfg->agg_time_limit >= LINK_QUAL_AGG_TIME_LIMIT_MIN &&
+	    priv->cfg->agg_time_limit <= LINK_QUAL_AGG_TIME_LIMIT_MAX)
+		lq_cmd->agg_params.agg_time_limit =
+			cpu_to_le16(priv->cfg->agg_time_limit);
 }
 
 static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index c6a0470..14a7a8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2110,8 +2110,10 @@ struct iwl_link_qual_general_params {
  */
 struct iwl_link_qual_agg_params {
 
-	/* Maximum number of uSec in aggregation.
-	 * Driver should set this to 4000 (4 milliseconds). */
+	/*
+	 *Maximum number of uSec in aggregation.
+	 * default set to 4000 (4 milliseconds) if not configured in .cfg
+	 */
 	__le16 agg_time_limit;
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 51ebd03..17fae00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -280,6 +280,7 @@ struct iwl_mod_params {
  * @scan_antennas: available antenna for scan operation
  * @need_dc_calib: need to perform init dc calibration
  * @bt_statistics: use BT version of statistics notification
+ * @agg_time_limit: maximum number of uSec in aggregation
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -350,6 +351,7 @@ struct iwl_cfg {
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 	const bool need_dc_calib;
 	const bool bt_statistics;
+	u16 agg_time_limit;
 };
 
 /***************************
-- 
1.7.0.4


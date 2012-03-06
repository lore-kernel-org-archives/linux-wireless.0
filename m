Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031489Ab2CFWnf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 18/33] iwlwifi: keep plcp_delta_threshold in priv
Date: Tue,  6 Mar 2012 13:30:53 -0800
Message-Id: <1331069468-11074-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234417_260265_914D4522)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The base_params shouldn't be writable, so keep
a copy of this in priv that can be modified.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    3 +++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    2 ++
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index d16e73d..5c9c88b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -320,7 +320,7 @@ static bool iwlagn_good_plcp_health(struct iwl_priv *priv,
 				 unsigned int msecs)
 {
 	int delta;
-	int threshold = cfg(priv)->base_params->plcp_delta_threshold;
+	int threshold = priv->plcp_delta_threshold;
 
 	if (threshold == IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
 		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8cf149c..ac23aa3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1045,6 +1045,9 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->ieee_rates = NULL;
 	priv->band = IEEE80211_BAND_2GHZ;
 
+	priv->plcp_delta_threshold =
+		cfg(priv)->base_params->plcp_delta_threshold;
+
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 8fefb43..04eb8d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2241,7 +2241,7 @@ static ssize_t iwl_dbgfs_plcp_delta_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "%u\n",
-			cfg(priv)->base_params->plcp_delta_threshold);
+			priv->plcp_delta_threshold);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
@@ -2263,10 +2263,10 @@ static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
 		return -EINVAL;
 	if ((plcp < IWL_MAX_PLCP_ERR_THRESHOLD_MIN) ||
 		(plcp > IWL_MAX_PLCP_ERR_THRESHOLD_MAX))
-		cfg(priv)->base_params->plcp_delta_threshold =
+		priv->plcp_delta_threshold =
 			IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE;
 	else
-		cfg(priv)->base_params->plcp_delta_threshold = plcp;
+		priv->plcp_delta_threshold = plcp;
 	return count;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 73acbab..0c397fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -770,6 +770,8 @@ struct iwl_priv {
 	struct iwl_channel_info *channel_info;	/* channel info array */
 	u8 channel_count;	/* # of channels */
 
+	u8 plcp_delta_threshold;
+
 	/* thermal calibration */
 	s32 temperature;	/* Celsius */
 	s32 last_temperature;
-- 
1.7.0.4


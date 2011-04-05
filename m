Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21335 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab1DERBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/25] iwlagn: remove pointless return variables
Date: Tue,  5 Apr 2011 09:41:53 -0700
Message-Id: <1302021732-21250-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A number of places just use a variable to return
it right away, which is useless, so let's remove
the variables there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    4 +---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    7 ++-----
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index e394e49..97abc10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2771,16 +2771,13 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
 			  gfp_t gfp)
 {
-	struct iwl_lq_sta *lq_sta;
 	struct iwl_station_priv *sta_priv = (struct iwl_station_priv *) sta->drv_priv;
 	struct iwl_priv *priv;
 
 	priv = (struct iwl_priv *)priv_rate;
 	IWL_DEBUG_RATE(priv, "create station rate scale window\n");
 
-	lq_sta = &sta_priv->lq_sta;
-
-	return lq_sta;
+	return &sta_priv->lq_sta;
 }
 
 /*
@@ -3259,7 +3256,6 @@ static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 {
 	char buff[120];
 	int desc = 0;
-	ssize_t ret;
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
 	struct iwl_priv *priv;
@@ -3276,8 +3272,7 @@ static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 				"Bit Rate= %d Mb/s\n",
 				iwl_rates[lq_sta->last_txrate_idx].ieee >> 1);
 
-	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
 }
 
 static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 5d35e35..bb262a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -653,7 +653,5 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 	 * Selection of bootstrap image (vs. other images) is arbitrary. */
 	image = (__le32 *)priv->ucode_boot.v_addr;
 	len = priv->ucode_boot.len;
-	ret = iwl_verify_inst_full(priv, image, len);
-
-	return ret;
+	return iwl_verify_inst_full(priv, image, len);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 8842411..90f2b64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1572,12 +1572,10 @@ static ssize_t iwl_dbgfs_bt_traffic_read(struct file *file,
 	int pos = 0;
 	char buf[200];
 	const size_t bufsz = sizeof(buf);
-	ssize_t ret;
 
 	if (!priv->bt_enable_flag) {
 		pos += scnprintf(buf + pos, bufsz - pos, "BT coex disabled\n");
-		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-		return ret;
+		return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	}
 	pos += scnprintf(buf + pos, bufsz - pos, "BT enable flag: 0x%x\n",
 		priv->bt_enable_flag);
@@ -1608,8 +1606,7 @@ static ssize_t iwl_dbgfs_bt_traffic_read(struct file *file,
 		break;
 	}
 
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
 static ssize_t iwl_dbgfs_protection_mode_read(struct file *file,
-- 
1.7.0.4


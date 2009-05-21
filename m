Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27647 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbZEUUhy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 16:37:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: add Greenfield support for 11n
Date: Thu, 21 May 2009 13:44:22 -0700
Message-Id: <1242938663-7937-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1242938663-7937-2-git-send-email-reinette.chatre@intel.com>
References: <1242938663-7937-1-git-send-email-reinette.chatre@intel.com>
 <1242938663-7937-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add "Greenfield" support for all devices except 4965 and
3945. "Greenfield" is part of 11n features to improve HT performance.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   34 +++++++++++++++++------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 4c88e87..a1b0ff5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -652,19 +652,19 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
 	return 1;
 }
 
-/* FIXME:RS: in 4965 we don't use greenfield at all */
-/* FIXME:RS: don't use greenfield for now in TX */
-#if 0
-static inline u8 rs_use_green(struct iwl_priv *priv, struct ieee80211_conf *conf)
+/* in 4965 we don't use greenfield at all */
+static inline u8 rs_use_green(struct iwl_priv *priv,
+			      struct ieee80211_conf *conf)
 {
-	return (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
-		priv->current_ht_config.is_green_field &&
-		!priv->current_ht_config.non_GF_STA_present;
-}
-#endif
-static inline u8 rs_use_green(struct iwl_priv *priv, struct ieee80211_conf *conf)
-{
-	return 0;
+	u8 is_green;
+
+	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
+		is_green = 0;
+	else
+		is_green = (conf_is_ht(conf) &&
+			   priv->current_ht_config.is_green_field &&
+			   !priv->current_ht_config.non_GF_STA_present);
+	return is_green;
 }
 
 /**
@@ -2061,6 +2061,10 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		active_tbl = 1 - lq_sta->active_tbl;
 
 	tbl = &(lq_sta->lq_info[active_tbl]);
+	if (is_legacy(tbl->lq_type))
+		lq_sta->is_green = 0;
+	else
+		lq_sta->is_green = rs_use_green(priv, conf);
 	is_green = lq_sta->is_green;
 
 	/* current tx rate */
@@ -2896,7 +2900,8 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 		   ((is_mimo2(tbl->lq_type)) ? "MIMO2" : "MIMO3"));
 		   desc += sprintf(buff+desc, " %s",
 		   (tbl->is_fat) ? "40MHz" : "20MHz");
-		desc += sprintf(buff+desc, " %s\n", (tbl->is_SGI) ? "SGI" : "");
+		   desc += sprintf(buff+desc, " %s %s\n", (tbl->is_SGI) ? "SGI" : "",
+		   (lq_sta->is_green) ? "GF enabled" : "");
 	}
 	desc += sprintf(buff+desc, "last tx rate=0x%X\n",
 		lq_sta->last_rate_n_flags);
@@ -2959,13 +2964,14 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 		return -ENOMEM;
 
 	for (i = 0; i < LQ_SIZE; i++) {
-		desc += sprintf(buff+desc, "%s type=%d SGI=%d FAT=%d DUP=%d\n"
+		desc += sprintf(buff+desc, "%s type=%d SGI=%d FAT=%d DUP=%d GF=%d\n"
 				"rate=0x%X\n",
 				lq_sta->active_tbl == i ? "*" : "x",
 				lq_sta->lq_info[i].lq_type,
 				lq_sta->lq_info[i].is_SGI,
 				lq_sta->lq_info[i].is_fat,
 				lq_sta->lq_info[i].is_dup,
+				lq_sta->is_green,
 				lq_sta->lq_info[i].current_rate);
 		for (j = 0; j < IWL_RATE_COUNT; j++) {
 			desc += sprintf(buff+desc,
-- 
1.5.6.3


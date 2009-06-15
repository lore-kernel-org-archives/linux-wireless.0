Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:23887 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756814AbZFOT6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:58:10 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 08/11 v2][w-t] iwmc3200wifi: change coexist periodic calibration flag
Date: Mon, 15 Jun 2009 21:59:53 +0200
Message-Id: <ef2fab83a02bac39c9547326d419f51789659161.1245091931.git.samuel@sortiz.org>
In-Reply-To: <3e375906194bc0105dd43d39260e2a826bf5b557.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
 <7413d2605b449b8e43bcfe61719ee30fccb592b7.1245091931.git.samuel@sortiz.org>
 <e72e3c0d6b16655fdf4da5dcabc6349be7b5c0a2.1245091931.git.samuel@sortiz.org>
 <4fa0241c41670096a2933b81c7bd32e6a5551faa.1245091931.git.samuel@sortiz.org>
 <445a117dd08007f653105f41f36f9bbf2ed1e4c6.1245091931.git.samuel@sortiz.org>
 <3e375906194bc0105dd43d39260e2a826bf5b557.1245091931.git.samuel@sortiz.org>
In-Reply-To: <cover.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

The patch changes coexist periodic calibration priority flag. It also
set wireless mode to UMAC and set PM control flag to 0x1.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |   13 +++++++++----
 drivers/net/wireless/iwmc3200wifi/commands.h |    4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 145f6f5..0d35afe 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -120,7 +120,7 @@ static struct coex_event iwm_sta_cm_prio_tbl[COEX_EVENTS_NUM] =
 	{4, 3, 0, COEX_UNASSOC_MANUAL_SCAN_FLAGS},
 	{3, 3, 0, COEX_UNASSOC_AUTO_SCAN_FLAGS},
 	{5, 5, 0, COEX_CALIBRATION_FLAGS},
-	{4, 4, 0, COEX_PERIODIC_CALIBRATION_FLAGS},
+	{3, 3, 0, COEX_PERIODIC_CALIBRATION_FLAGS},
 	{5, 4, 0, COEX_CONNECTION_ESTAB_FLAGS},
 	{4, 4, 0, COEX_ASSOCIATED_IDLE_FLAGS},
 	{4, 4, 0, COEX_ASSOC_MANUAL_SCAN_FLAGS},
@@ -345,8 +345,7 @@ int iwm_umac_set_config_var(struct iwm_priv *iwm, u16 key,
 	return ret;
 }
 
-int iwm_send_umac_config(struct iwm_priv *iwm,
-			 __le32 reset_flags)
+int iwm_send_umac_config(struct iwm_priv *iwm, __le32 reset_flags)
 {
 	int ret;
 
@@ -374,6 +373,12 @@ int iwm_send_umac_config(struct iwm_priv *iwm,
 		return ret;
 
 	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				      CFG_WIRELESS_MODE,
+				      iwm->conf.wireless_mode);
+	if (ret < 0)
+		return ret;
+
+	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
 				      CFG_COEX_MODE, iwm->conf.coexist_mode);
 	if (ret < 0)
 		return ret;
@@ -415,7 +420,7 @@ int iwm_send_umac_config(struct iwm_priv *iwm,
 		return ret;
 
 	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
-				      CFG_PM_CTRL_FLAGS, 0x30001);
+				      CFG_PM_CTRL_FLAGS, 0x1);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index 3510df8..e24d5b6 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -106,8 +106,7 @@ enum {
 	CFG_TLC_SPATIAL_STREAM_SUPPORTED,
 	CFG_TLC_RETRY_PER_RATE,
 	CFG_TLC_RETRY_PER_HT_RATE,
-	CFG_TLC_FIXED_RATE,
-	CFG_TLC_FIXED_RATE_FLAGS,
+	CFG_TLC_FIXED_MCS,
 	CFG_TLC_CONTROL_FLAGS,
 	CFG_TLC_SR_MIN_FAIL,
 	CFG_TLC_SR_MIN_PASS,
@@ -232,6 +231,7 @@ struct iwm_umac_cmd_get_channel_list {
 /* Wireless mode */
 #define WIRELESS_MODE_11A  0x1
 #define WIRELESS_MODE_11G  0x2
+#define WIRELESS_MODE_11N  0x4
 
 #define UMAC_PROFILE_EX_IE_REQUIRED	0x1
 #define UMAC_PROFILE_QOS_ALLOWED	0x2
-- 
1.6.3.1


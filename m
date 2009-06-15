Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:19177 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761104AbZFOPix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:38:53 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 09/12][w-t] iwmc3200wifi: change coexist periodic calibration flag
Date: Mon, 15 Jun 2009 17:39:25 +0200
Message-Id: <d0765f00e18e0501dc41d8507f05eb03ec940cdc.1245076752.git.samuel@sortiz.org>
In-Reply-To: <d0337f0d1ddef69bbb0144eb894bafd0580550d6.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
 <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
 <afbb543a0654cc171faa882457cc603d3f038d27.1245076752.git.samuel@sortiz.org>
 <9b2b9b463d1313b871f56ad77b48b4960653b766.1245076752.git.samuel@sortiz.org>
 <ed1078e3b1524ac3bf3888b0881e40bddc8fb690.1245076752.git.samuel@sortiz.org>
 <99a6f971c65b2fb751206cff9e428eb60037629b.1245076752.git.samuel@sortiz.org>
 <f3d3b8fac2046f9c26773232c585b4c688b8df03.1245076752.git.samuel@sortiz.org>
 <87c8d2a38226859644cfd3217366a4e42d9e7d81.1245076752.git.samuel@sortiz.org>
 <d0337f0d1ddef69bbb0144eb894bafd0580550d6.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
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


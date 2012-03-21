Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42576 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2CUJeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 05:34:15 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 2/2] ath6kl: Optimize target power in deep sleep suspend
Date: Wed, 21 Mar 2012 15:03:38 +0530
Message-ID: <1332322418-16572-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20120321_103430_378649_FA4B1CB1)
In-Reply-To: <1332322418-16572-1-git-send-email-rmani@qca.qualcomm.com>
References: <1332322418-16572-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Adding below steps helps to get good power numbers
in deep sleep suspend path,

    * Disable WOW mode.
    * Flush data packets and wait for all control packets.
      to be cleared in TX path before deep sleep suspend.
    * Set host sleep mode to SLEEP.

Below steps are added to perform the recovery action
while the system resume from deep sleep,

     * Set host sleep mode to AWAKE.
     * Reset scan parameters to default value.

In addition, Debug prints are added to track deep sleep
suspend/resume state.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   98 +++++++++++++++++++++++-----
 1 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 883a0ca..aa9315d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2119,6 +2119,77 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 	return 0;
 }
 
+static int ath6kl_cfg80211_deepsleep_suspend(struct ath6kl *ar)
+{
+	struct ath6kl_vif *vif;
+	int ret;
+
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	if (!ath6kl_cfg80211_ready(vif))
+		return -EIO;
+
+	ath6kl_cfg80211_stop_all(ar);
+
+	/* Save the current power mode before enabling power save */
+	ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
+
+	ret = ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER);
+	if (ret)
+		return ret;
+
+	/* Disable WOW mode */
+	ret = ath6kl_wmi_set_wow_mode_cmd(ar->wmi, vif->fw_vif_idx,
+					  ATH6KL_WOW_MODE_DISABLE,
+					  0, 0);
+	if (ret)
+		return ret;
+
+	/* Flush all non control pkts in TX path */
+	ath6kl_tx_data_cleanup(ar);
+
+	ret = ath6kl_cfg80211_host_sleep(ar, vif);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ath6kl_cfg80211_deepsleep_resume(struct ath6kl *ar)
+{
+	struct ath6kl_vif *vif;
+	int ret;
+
+	vif = ath6kl_vif_first(ar);
+
+	if (!vif)
+		return -EIO;
+
+	if (ar->wmi->pwr_mode != ar->wmi->saved_pwr_mode) {
+		ret = ath6kl_wmi_powermode_cmd(ar->wmi, 0,
+					       ar->wmi->saved_pwr_mode);
+		if (ret)
+			return ret;
+	}
+
+	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
+						 ATH6KL_HOST_MODE_AWAKE);
+	if (ret)
+		return ret;
+
+	ar->state = ATH6KL_STATE_ON;
+
+	/* Reset scan parameter to default values */
+	ret = ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx,
+					0, 0, 0, 0, 0, 0, 3, 0, 0, 0);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 			    enum ath6kl_cfg_suspend_mode mode,
 			    struct cfg80211_wowlan *wow)
@@ -2147,15 +2218,12 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 	case ATH6KL_CFG_SUSPEND_DEEPSLEEP:
 
-		ath6kl_cfg80211_stop_all(ar);
-
-		/* save the current power mode before enabling power save */
-		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
+		ath6kl_dbg(ATH6KL_DBG_SUSPEND, "deep sleep suspend\n");
 
-		ret = ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER);
+		ret = ath6kl_cfg80211_deepsleep_suspend(ar);
 		if (ret) {
-			ath6kl_warn("wmi powermode command failed during suspend: %d\n",
-				    ret);
+			ath6kl_err("deepsleep suspend failed: %d\n", ret);
+			return ret;
 		}
 
 		ar->state = ATH6KL_STATE_DEEPSLEEP;
@@ -2216,17 +2284,13 @@ int ath6kl_cfg80211_resume(struct ath6kl *ar)
 		break;
 
 	case ATH6KL_STATE_DEEPSLEEP:
-		if (ar->wmi->pwr_mode != ar->wmi->saved_pwr_mode) {
-			ret = ath6kl_wmi_powermode_cmd(ar->wmi, 0,
-						       ar->wmi->saved_pwr_mode);
-			if (ret) {
-				ath6kl_warn("wmi powermode command failed during resume: %d\n",
-					    ret);
-			}
-		}
-
-		ar->state = ATH6KL_STATE_ON;
+		ath6kl_dbg(ATH6KL_DBG_SUSPEND, "deep sleep resume\n");
 
+		ret = ath6kl_cfg80211_deepsleep_resume(ar);
+		if (ret) {
+			ath6kl_warn("deep sleep resume failed: %d\n", ret);
+			return ret;
+		}
 		break;
 
 	case ATH6KL_STATE_CUTPOWER:
-- 
1.7.1


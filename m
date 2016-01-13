Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55033 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbcAMPrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 10:47:36 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 3/7] ath10k: Cleanup setting pdev paramaters
Date: Wed, 13 Jan 2016 21:16:30 +0530
Message-ID: <1452699994-5078-4-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160113_164738_817976_646464D0)
In-Reply-To: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Replace the local variable 'burst_enable' with 'param'
for mapping and setting pdev paraemeters and with this patch
pretty easy to extend support for new parameters adhering to
linux kernel coding guidelines

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b4bdeb0..2dba57c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3987,7 +3987,7 @@ static int ath10k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 static int ath10k_start(struct ieee80211_hw *hw)
 {
 	struct ath10k *ar = hw->priv;
-	u32 burst_enable;
+	u32 param;
 	int ret = 0;
 
 	/*
@@ -4030,13 +4030,15 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_power_down;
 	}
 
-	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->pmf_qos, 1);
+	param = ar->wmi.pdev_param->pmf_qos;
+	ret = ath10k_wmi_pdev_set_param(ar, param, 1);
 	if (ret) {
 		ath10k_warn(ar, "failed to enable PMF QOS: %d\n", ret);
 		goto err_core_stop;
 	}
 
-	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->dynamic_bw, 1);
+	param = ar->wmi.pdev_param->dynamic_bw;
+	ret = ath10k_wmi_pdev_set_param(ar, param, 1);
 	if (ret) {
 		ath10k_warn(ar, "failed to enable dynamic BW: %d\n", ret);
 		goto err_core_stop;
@@ -4052,8 +4054,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	}
 
 	if (test_bit(WMI_SERVICE_BURST, ar->wmi.svc_map)) {
-		burst_enable = ar->wmi.pdev_param->burst_enable;
-		ret = ath10k_wmi_pdev_set_param(ar, burst_enable, 0);
+		param = ar->wmi.pdev_param->burst_enable;
+		ret = ath10k_wmi_pdev_set_param(ar, param, 0);
 		if (ret) {
 			ath10k_warn(ar, "failed to disable burst: %d\n", ret);
 			goto err_core_stop;
@@ -4071,8 +4073,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	 * this problem.
 	 */
 
-	ret = ath10k_wmi_pdev_set_param(ar,
-					ar->wmi.pdev_param->arp_ac_override, 0);
+	param = ar->wmi.pdev_param->arp_ac_override;
+	ret = ath10k_wmi_pdev_set_param(ar, param, 0);
 	if (ret) {
 		ath10k_warn(ar, "failed to set arp ac override parameter: %d\n",
 			    ret);
@@ -4091,8 +4093,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		}
 	}
 
-	ret = ath10k_wmi_pdev_set_param(ar,
-					ar->wmi.pdev_param->ani_enable, 1);
+	param = ar->wmi.pdev_param->ani_enable;
+	ret = ath10k_wmi_pdev_set_param(ar, param, 1);
 	if (ret) {
 		ath10k_warn(ar, "failed to enable ani by default: %d\n",
 			    ret);
-- 
1.7.9.5


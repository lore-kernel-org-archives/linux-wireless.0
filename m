Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5656 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLCIJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 03:09:54 -0500
Subject: [PATCH v4 1/8] ath10k: clean up error handling in
 ath10k_core_probe_fw()
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 3 Dec 2014 10:09:31 +0200
Message-ID: <20141203080931.31187.15394.stgit@potku.adurom.net> (sfid-20141203_090957_280461_49ECB2F0)
In-Reply-To: <20141203080803.31187.85059.stgit@potku.adurom.net>
References: <20141203080803.31187.85059.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the error handling style preferred in ath10k. Makes it easier to add
ath10k_init_firmware_features() function in the next patch.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7762061a1944..09784c68339b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1025,8 +1025,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	ret = ath10k_bmi_get_target_info(ar, &target_info);
 	if (ret) {
 		ath10k_err(ar, "could not get target info (%d)\n", ret);
-		ath10k_hif_power_down(ar);
-		return ret;
+		goto err_power_down;
 	}
 
 	ar->target_version = target_info.version;
@@ -1035,15 +1034,13 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	ret = ath10k_init_hw_params(ar);
 	if (ret) {
 		ath10k_err(ar, "could not get hw params (%d)\n", ret);
-		ath10k_hif_power_down(ar);
-		return ret;
+		goto err_power_down;
 	}
 
 	ret = ath10k_core_fetch_firmware_files(ar);
 	if (ret) {
 		ath10k_err(ar, "could not fetch firmware files (%d)\n", ret);
-		ath10k_hif_power_down(ar);
-		return ret;
+		goto err_power_down;
 	}
 
 	ath10k_core_init_max_sta_count(ar);
@@ -1053,10 +1050,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL);
 	if (ret) {
 		ath10k_err(ar, "could not init core (%d)\n", ret);
-		ath10k_core_free_firmware_files(ar);
-		ath10k_hif_power_down(ar);
-		mutex_unlock(&ar->conf_mutex);
-		return ret;
+		goto err_unlock;
 	}
 
 	ath10k_print_driver_info(ar);
@@ -1066,6 +1060,16 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	ath10k_hif_power_down(ar);
 	return 0;
+
+err_unlock:
+	mutex_unlock(&ar->conf_mutex);
+
+	ath10k_core_free_firmware_files(ar);
+
+err_power_down:
+	ath10k_hif_power_down(ar);
+
+	return ret;
 }
 
 static int ath10k_core_check_chip_id(struct ath10k *ar)


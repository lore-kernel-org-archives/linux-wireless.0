Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24064 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbaLAOpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 09:45:06 -0500
Subject: [PATCH v3 1/7] ath10k: create ath10k_core_init_features()
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 1 Dec 2014 16:44:58 +0200
Message-ID: <20141201144458.18248.28568.stgit@potku.adurom.net> (sfid-20141201_154510_292075_6F458CBC)
In-Reply-To: <20141201144400.18248.62714.stgit@potku.adurom.net>
References: <20141201144400.18248.62714.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's easier to manage firmware version differences when we configure them in
one place. Rename ath10k_core_init_max_sta_count() to
ath10k_core_init_firmware_features() and start moving most of the firmware
version ("features") handling to that function.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7762061a1944..bd6315952ad0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -582,13 +582,6 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 		goto err;
 	}
 
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features) &&
-	    !test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		ath10k_err(ar, "feature bits corrupted: 10.2 feature requires 10.x feature to be set as well");
-		ret = -EINVAL;
-		goto err;
-	}
-
 	/* now fetch the board file */
 	if (ar->hw_params.fw.board == NULL) {
 		ath10k_err(ar, "board data file not defined");
@@ -799,8 +792,14 @@ static void ath10k_core_restart(struct work_struct *work)
 	mutex_unlock(&ar->conf_mutex);
 }
 
-static void ath10k_core_init_max_sta_count(struct ath10k *ar)
+static int ath10k_core_init_firmware_features(struct ath10k *ar)
 {
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features) &&
+	    !test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
+		ath10k_err(ar, "feature bits corrupted: 10.2 feature requires 10.x feature to be set as well");
+		return -EINVAL;
+	}
+
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
 		ar->max_num_peers = TARGET_10X_NUM_PEERS;
 		ar->max_num_stations = TARGET_10X_NUM_STATIONS;
@@ -808,6 +807,8 @@ static void ath10k_core_init_max_sta_count(struct ath10k *ar)
 		ar->max_num_peers = TARGET_NUM_PEERS;
 		ar->max_num_stations = TARGET_NUM_STATIONS;
 	}
+
+	return 0;
 }
 
 int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
@@ -1046,7 +1047,12 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		return ret;
 	}
 
-	ath10k_core_init_max_sta_count(ar);
+	ret = ath10k_core_init_firmware_features(ar);
+	if (ret) {
+		ath10k_err(ar, "fatal problem with firmware features: %d\n",
+			   ret);
+		return ret;
+	}
 
 	mutex_lock(&ar->conf_mutex);
 


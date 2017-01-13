Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35083 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdAMVfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:35:31 -0500
Received: by mail-lf0-f68.google.com with SMTP id v186so7072221lfa.2
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 13:35:30 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 08/10] ath10k: add start_once support
Date: Fri, 13 Jan 2017 22:35:07 +0100
Message-Id: <1484343309-6327-9-git-send-email-erik.stromdahl@gmail.com> (sfid-20170113_223541_245153_0BBAF1BE)
In-Reply-To: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
References: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add possibility to configure the driver to only start target once.
This can reduce startup time of SDIO devices significantly since
loading the firmware can take a substantial amount of time.

The patch is also necessary for high latency devices in general
since it does not seem to be possible to rerun the BMI phase
(fw upload) without power-cycling the device.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 20 ++++++++++++++++----
 drivers/net/wireless/ath/ath10k/core.h |  2 ++
 drivers/net/wireless/ath/ath10k/hw.h   |  6 ++++++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 31a9471..250e32b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -302,6 +302,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.max_num_peers = TARGET_QCA9377_HL_NUM_PEERS,
 		.is_high_latency = true,
 		.bus = ATH10K_BUS_USB,
+		.start_once = true,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -1841,6 +1842,9 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	int status;
 	u32 val;
 
+	if (ar->is_started && ar->hw_params.start_once)
+		return 0;
+
 	lockdep_assert_held(&ar->conf_mutex);
 
 	clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
@@ -2053,6 +2057,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	if (status)
 		goto err_hif_stop;
 
+	ar->is_started = true;
 	return 0;
 
 err_hif_stop:
@@ -2105,6 +2110,7 @@ void ath10k_core_stop(struct ath10k *ar)
 	ath10k_htt_tx_stop(&ar->htt);
 	ath10k_htt_rx_free(&ar->htt);
 	ath10k_wmi_detach(ar);
+	ar->is_started = false;
 }
 EXPORT_SYMBOL(ath10k_core_stop);
 
@@ -2202,12 +2208,18 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_unlock;
 	}
 
-	ath10k_debug_print_boot_info(ar);
-	ath10k_core_stop(ar);
+	/* Leave target running if hw_params.start_once is set */
+	if (ar->hw_params.start_once) {
+		mutex_unlock(&ar->conf_mutex);
+	} else {
+		ath10k_debug_print_boot_info(ar);
+		ath10k_core_stop(ar);
 
-	mutex_unlock(&ar->conf_mutex);
+		mutex_unlock(&ar->conf_mutex);
+
+		ath10k_hif_power_down(ar);
+	}
 
-	ath10k_hif_power_down(ar);
 	return 0;
 
 err_unlock:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d9d7805..800f058 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -746,6 +746,8 @@ struct ath10k {
 
 	bool is_high_latency;
 
+	bool is_started;
+
 	struct {
 		enum ath10k_bus bus;
 		const struct ath10k_hif_ops *ops;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 33186be..04ae66d 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -436,6 +436,12 @@ struct ath10k_hw_params {
 	bool is_high_latency;
 
 	enum ath10k_bus bus;
+
+	/* Specifies whether or not the device should be started once.
+	 * If set, the device will be started once by the early fw probe
+	 * and it will not be terminated afterwards.
+	 */
+	bool start_once;
 };
 
 struct htt_rx_desc;
-- 
2.7.4

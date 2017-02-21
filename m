Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33624 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753748AbdBUQQ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 11:16:29 -0500
Received: by mail-lf0-f68.google.com with SMTP id 86so5300454lfv.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 08:16:28 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 16/21] ath10k: add start_once support
Date: Tue, 21 Feb 2017 17:15:36 +0100
Message-Id: <1487693741-10042-17-git-send-email-erik.stromdahl@gmail.com> (sfid-20170221_172342_926590_36B65ACE)
In-Reply-To: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
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
 drivers/net/wireless/ath/ath10k/core.c | 19 +++++++++++++++----
 drivers/net/wireless/ath/ath10k/core.h |  2 ++
 drivers/net/wireless/ath/ath10k/hw.h   |  6 ++++++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6b667c7..0a177bf 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1919,6 +1919,9 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	int status;
 	u32 val;
 
+	if (ar->is_started && ar->hw_params.start_once)
+		return 0;
+
 	lockdep_assert_held(&ar->conf_mutex);
 
 	clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
@@ -2138,6 +2141,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	if (status)
 		goto err_hif_stop;
 
+	ar->is_started = true;
 	return 0;
 
 err_hif_stop:
@@ -2190,6 +2194,7 @@ void ath10k_core_stop(struct ath10k *ar)
 	ath10k_htt_tx_stop(&ar->htt);
 	ath10k_htt_rx_free(&ar->htt);
 	ath10k_wmi_detach(ar);
+	ar->is_started = false;
 }
 EXPORT_SYMBOL(ath10k_core_stop);
 
@@ -2291,12 +2296,18 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
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
index e3cdaba..6be6e66 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -780,6 +780,8 @@ struct ath10k {
 
 	bool is_high_latency;
 
+	bool is_started;
+
 	struct {
 		enum ath10k_bus bus;
 		const struct ath10k_hif_ops *ops;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index bc4fd43..cf88aba 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -466,6 +466,12 @@ struct ath10k_hw_params {
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

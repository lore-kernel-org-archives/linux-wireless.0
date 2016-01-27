Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35108 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbcA0J6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:58:21 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 08/12] ath10k: add reset ctrl related functions in ahb
Date: Wed, 27 Jan 2016 15:24:29 +0530
Message-ID: <1453888473-2879-9-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105825_381387_35FC3817)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To perform reset on qca4019 wifi, multiple reset lines needs
to be toggled in a sequence with help of reset controller support
in the kernel. This patch adds functions to reset control init/deinit
and release reset.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/Kconfig |   2 +-
 drivers/net/wireless/ath/ath10k/ahb.c   | 138 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ahb.h   |   6 ++
 3 files changed, 145 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index d7f207a..db1ca62 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -17,7 +17,7 @@ config ATH10K_PCI
 
 config ATH10K_AHB
 	bool "Atheros ath10k AHB support"
-	depends on ATH10K_PCI && OF
+	depends on ATH10K_PCI && OF && RESET_CONTROLLER
 	---help---
 	  This module adds support for AHB bus
 
diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 11185c0..d1f1972 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -16,6 +16,7 @@
  */
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/reset.h>
 #include "core.h"
 #include "debug.h"
 #include "pci.h"
@@ -207,6 +208,143 @@ static void ath10k_ahb_clock_disable(struct ath10k *ar)
 		clk_disable_unprepare(ar_ahb->rtc_clk);
 }
 
+static int ath10k_ahb_rst_ctrl_init(struct ath10k *ar)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+	struct device *dev;
+	int ret;
+
+	dev = &ar_ahb->pdev->dev;
+
+	ar_ahb->core_cold_rst = reset_control_get(dev, "wifi_core_cold");
+	if (IS_ERR_OR_NULL(ar_ahb->core_cold_rst)) {
+		ath10k_err(ar, "failed to get core cold rst ctrl: %ld\n",
+			   PTR_ERR(ar_ahb->core_cold_rst));
+		ret = ar_ahb->core_cold_rst ?
+			PTR_ERR(ar_ahb->core_cold_rst) : -ENODEV;
+		goto out;
+	}
+
+	ar_ahb->radio_cold_rst = reset_control_get(dev, "wifi_radio_cold");
+	if (IS_ERR_OR_NULL(ar_ahb->radio_cold_rst)) {
+		ath10k_err(ar, "failed to get radio cold rst ctrl: %ld\n",
+			   PTR_ERR(ar_ahb->radio_cold_rst));
+		ret = ar_ahb->radio_cold_rst ?
+			PTR_ERR(ar_ahb->radio_cold_rst) : -ENODEV;
+		goto err_core_cold_rst_put;
+	}
+
+	ar_ahb->radio_warm_rst = reset_control_get(dev, "wifi_radio_warm");
+	if (IS_ERR_OR_NULL(ar_ahb->radio_warm_rst)) {
+		ath10k_err(ar, "failed to get radio warm rst ctrl: %ld\n",
+			   PTR_ERR(ar_ahb->radio_warm_rst));
+		ret = ar_ahb->radio_warm_rst ?
+			PTR_ERR(ar_ahb->radio_warm_rst) : -ENODEV;
+		goto err_radio_cold_rst_put;
+	}
+
+	ar_ahb->radio_srif_rst = reset_control_get(dev, "wifi_radio_srif");
+	if (IS_ERR_OR_NULL(ar_ahb->radio_srif_rst)) {
+		ath10k_err(ar, "failed to get radio srif rst ctrl: %ld\n",
+			   PTR_ERR(ar_ahb->radio_srif_rst));
+		ret = ar_ahb->radio_srif_rst ?
+			PTR_ERR(ar_ahb->radio_srif_rst) : -ENODEV;
+		goto err_radio_warm_rst_put;
+	}
+
+	ar_ahb->cpu_init_rst = reset_control_get(dev, "wifi_cpu_init");
+	if (IS_ERR_OR_NULL(ar_ahb->cpu_init_rst)) {
+		ath10k_err(ar, "failed to get cpu init rst ctrl: %ld\n",
+			   PTR_ERR(ar_ahb->cpu_init_rst));
+		ret = ar_ahb->cpu_init_rst ?
+			PTR_ERR(ar_ahb->cpu_init_rst) : -ENODEV;
+		goto err_radio_srif_rst_put;
+	}
+
+	return 0;
+
+err_radio_srif_rst_put:
+	reset_control_put(ar_ahb->radio_srif_rst);
+
+err_radio_warm_rst_put:
+	reset_control_put(ar_ahb->radio_warm_rst);
+
+err_radio_cold_rst_put:
+	reset_control_put(ar_ahb->radio_cold_rst);
+
+err_core_cold_rst_put:
+	reset_control_put(ar_ahb->core_cold_rst);
+
+out:
+	return ret;
+}
+
+static void ath10k_ahb_rst_ctrl_deinit(struct ath10k *ar)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+
+	if (!IS_ERR_OR_NULL(ar_ahb->core_cold_rst))
+		reset_control_put(ar_ahb->core_cold_rst);
+
+	if (!IS_ERR_OR_NULL(ar_ahb->radio_cold_rst))
+		reset_control_put(ar_ahb->radio_cold_rst);
+
+	if (!IS_ERR_OR_NULL(ar_ahb->radio_warm_rst))
+		reset_control_put(ar_ahb->radio_warm_rst);
+
+	if (!IS_ERR_OR_NULL(ar_ahb->radio_srif_rst))
+		reset_control_put(ar_ahb->radio_srif_rst);
+
+	if (!IS_ERR_OR_NULL(ar_ahb->cpu_init_rst))
+		reset_control_put(ar_ahb->cpu_init_rst);
+
+	ar_ahb->core_cold_rst = NULL;
+	ar_ahb->radio_cold_rst = NULL;
+	ar_ahb->radio_warm_rst = NULL;
+	ar_ahb->radio_srif_rst = NULL;
+	ar_ahb->cpu_init_rst = NULL;
+}
+
+static int ath10k_ahb_release_reset(struct ath10k *ar)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+	int ret;
+
+	if (IS_ERR_OR_NULL(ar_ahb->radio_cold_rst) ||
+	    IS_ERR_OR_NULL(ar_ahb->radio_warm_rst) ||
+	    IS_ERR_OR_NULL(ar_ahb->radio_srif_rst) ||
+	    IS_ERR_OR_NULL(ar_ahb->cpu_init_rst)) {
+		ath10k_err(ar, "rst ctrl(s) is/are not initialized\n");
+		return -EINVAL;
+	}
+
+	ret = reset_control_deassert(ar_ahb->radio_cold_rst);
+	if (ret) {
+		ath10k_err(ar, "failed to deassert radio cold rst: %d\n", ret);
+		return ret;
+	}
+
+	ret = reset_control_deassert(ar_ahb->radio_warm_rst);
+	if (ret) {
+		ath10k_err(ar, "failed to deassert radio warm rst: %d\n", ret);
+		return ret;
+	}
+
+	ret = reset_control_deassert(ar_ahb->radio_srif_rst);
+	if (ret) {
+		ath10k_err(ar, "failed to deassert radio srif rst: %d\n", ret);
+		return ret;
+	}
+
+	ret = reset_control_deassert(ar_ahb->cpu_init_rst);
+	if (ret) {
+		ath10k_err(ar, "failed to deassert cpu init rst: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int ath10k_ahb_probe(struct platform_device *pdev)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/ahb.h b/drivers/net/wireless/ath/ath10k/ahb.h
index 753b433..2904b7b 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.h
+++ b/drivers/net/wireless/ath/ath10k/ahb.h
@@ -29,6 +29,12 @@ struct ath10k_ahb {
 	struct clk *cmd_clk;
 	struct clk *ref_clk;
 	struct clk *rtc_clk;
+
+	struct reset_control *core_cold_rst;
+	struct reset_control *radio_cold_rst;
+	struct reset_control *radio_warm_rst;
+	struct reset_control *radio_srif_rst;
+	struct reset_control *cpu_init_rst;
 };
 
 #ifdef CONFIG_ATH10K_AHB
-- 
1.8.1.2


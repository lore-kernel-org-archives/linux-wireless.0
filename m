Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52981 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaK0MJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 07:09:22 -0500
Subject: [PATCH v4 2/2] ath10k: read calibration data from Device Tree
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <devicetree@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<toshik@chromium.org>
Date: Thu, 27 Nov 2014 14:09:18 +0200
Message-ID: <20141127120917.17546.44254.stgit@potku.adurom.net> (sfid-20141127_130928_588338_2B0C5E01)
In-Reply-To: <20141127120727.17546.61202.stgit@potku.adurom.net>
References: <20141127120727.17546.61202.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Toshi Kikuchi <toshik@chromium.org>

This patch adds support for reading calibration data from Device Tree.
It looks for the calibration data in Device Tree if it can't find it
in a file. If there's no node in Device Tree, ath10k will try to find the
calibration data from OTP.

The node for the calibration data should be defined like this:

pci {
        pcie@0 {
                reg = <0 0 0 0 0>;
                #interrupt-cells = <1>;
                #size-cells = <2>;
                #address-cells = <3>;
                device_type = "pci";

                ath10k@0,0 {
                        reg = <0 0 0 0 0>;
                        device_type = "pci";
                        qcom,ath10k-calibration-data = [ 01 02 03 ... ];
                };
        };
};

Signed-off-by: Toshi Kikuchi <toshik@chromium.org>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   70 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h |    3 +
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7762061a1944..6165f2735b35 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -17,6 +17,7 @@
 
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <linux/of.h>
 
 #include "core.h"
 #include "mac.h"
@@ -249,6 +250,63 @@ static int ath10k_download_cal_file(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_download_cal_dt(struct ath10k *ar)
+{
+	struct device_node *node;
+	int data_len;
+	void *data;
+	int ret;
+
+	node = ar->dev->of_node;
+	if (!node)
+		/* Device Tree is optional, don't print any warnings if
+		 * there's no node for ath10k.
+		 */
+		return -ENOENT;
+
+	if (!of_get_property(node, "qcom,ath10k-calibration-data",
+			     &data_len)) {
+		/* The calibration data node is optional */
+		return -ENOENT;
+	}
+
+	if (data_len != QCA988X_CAL_DATA_LEN) {
+		ath10k_warn(ar, "invalid calibration data length in DT: %d\n",
+			    data_len);
+		ret = -EMSGSIZE;
+		goto out;
+	}
+
+	data = kmalloc(data_len, GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = of_property_read_u8_array(node, "qcom,ath10k-calibration-data",
+					data, data_len);
+	if (ret) {
+		ath10k_warn(ar, "failed to read calibration data from DT: %d\n",
+			    ret);
+		goto out_free;
+	}
+
+	ret = ath10k_download_board_data(ar, data, data_len);
+	if (ret) {
+		ath10k_warn(ar, "failed to download calibration data from Device Tree: %d\n",
+			    ret);
+		goto out_free;
+	}
+
+	ret = 0;
+
+out_free:
+	kfree(data);
+
+out:
+	return ret;
+}
+
 static int ath10k_download_and_run_otp(struct ath10k *ar)
 {
 	u32 result, address = ar->hw_params.patch_load_addr;
@@ -662,7 +720,17 @@ static int ath10k_download_cal_data(struct ath10k *ar)
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot did not find a calibration file, try OTP next: %d\n",
+		   "boot did not find a calibration file, try DT next: %d\n",
+		   ret);
+
+	ret = ath10k_download_cal_dt(ar);
+	if (ret == 0) {
+		ar->cal_mode = ATH10K_CAL_MODE_DT;
+		goto done;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot did not find DT entry, try OTP next: %d\n",
 		   ret);
 
 	ret = ath10k_download_and_run_otp(ar);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4a294987736c..2dd1bb05a3fc 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -400,6 +400,7 @@ enum ath10k_dev_flags {
 enum ath10k_cal_mode {
 	ATH10K_CAL_MODE_FILE,
 	ATH10K_CAL_MODE_OTP,
+	ATH10K_CAL_MODE_DT,
 };
 
 static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
@@ -409,6 +410,8 @@ static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
 		return "file";
 	case ATH10K_CAL_MODE_OTP:
 		return "otp";
+	case ATH10K_CAL_MODE_DT:
+		return "dt";
 	}
 
 	return "unknown";


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29950 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdDMIaa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 04:30:30 -0400
Subject: [PATCH v7 07/10] ath10k: sdio get target info
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 13 Apr 2017 11:30:19 +0300
Message-ID: <149207221900.4590.2144598113613283818.stgit@potku.adurom.net> (sfid-20170413_103034_622630_5E73C311)
In-Reply-To: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
References: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erik Stromdahl <erik.stromdahl@gmail.com>

Special BMI get target info function for SDIO.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/bmi.c  |   71 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/bmi.h  |    2 +
 drivers/net/wireless/ath/ath10k/core.c |    5 ++
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index abeee200310b..2d3a2f31123d 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -97,6 +97,77 @@ int ath10k_bmi_get_target_info(struct ath10k *ar,
 	return 0;
 }
 
+#define TARGET_VERSION_SENTINAL 0xffffffffu
+
+int ath10k_bmi_get_target_info_sdio(struct ath10k *ar,
+				    struct bmi_target_info *target_info)
+{
+	struct bmi_cmd cmd;
+	union bmi_resp resp;
+	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.get_target_info);
+	u32 resplen, ver_len;
+	__le32 tmp;
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi get target info SDIO\n");
+
+	if (ar->bmi.done_sent) {
+		ath10k_warn(ar, "BMI Get Target Info Command disallowed\n");
+		return -EBUSY;
+	}
+
+	cmd.id = __cpu_to_le32(BMI_GET_TARGET_INFO);
+
+	/* Step 1: Read 4 bytes of the target info and check if it is
+	 * the special sentinal version word or the first word in the
+	 * version response.
+	 */
+	resplen = sizeof(u32);
+	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen, &tmp, &resplen);
+	if (ret) {
+		ath10k_warn(ar, "unable to read from device\n");
+		return ret;
+	}
+
+	/* Some SDIO boards have a special sentinal byte before the real
+	 * version response.
+	 */
+	if (__le32_to_cpu(tmp) == TARGET_VERSION_SENTINAL) {
+		/* Step 1b: Read the version length */
+		resplen = sizeof(u32);
+		ret = ath10k_hif_exchange_bmi_msg(ar, NULL, 0, &tmp,
+						  &resplen);
+		if (ret) {
+			ath10k_warn(ar, "unable to read from device\n");
+			return ret;
+		}
+	}
+
+	ver_len = __le32_to_cpu(tmp);
+
+	/* Step 2: Check the target info length */
+	if (ver_len != sizeof(resp.get_target_info)) {
+		ath10k_warn(ar, "Unexpected target info len: %u. Expected: %zu\n",
+			    ver_len, sizeof(resp.get_target_info));
+		return -EINVAL;
+	}
+
+	/* Step 3: Read the rest of the version response */
+	resplen = sizeof(resp.get_target_info) - sizeof(u32);
+	ret = ath10k_hif_exchange_bmi_msg(ar, NULL, 0,
+					  &resp.get_target_info.version,
+					  &resplen);
+	if (ret) {
+		ath10k_warn(ar, "unable to read from device\n");
+		return ret;
+	}
+
+	target_info->version = __le32_to_cpu(resp.get_target_info.version);
+	target_info->type    = __le32_to_cpu(resp.get_target_info.type);
+
+	return 0;
+}
+
 int ath10k_bmi_read_memory(struct ath10k *ar,
 			   u32 address, void *buffer, u32 length)
 {
diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index cc45b63ade15..0342073ed397 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -198,6 +198,8 @@ void ath10k_bmi_start(struct ath10k *ar);
 int ath10k_bmi_done(struct ath10k *ar);
 int ath10k_bmi_get_target_info(struct ath10k *ar,
 			       struct bmi_target_info *target_info);
+int ath10k_bmi_get_target_info_sdio(struct ath10k *ar,
+				    struct bmi_target_info *target_info);
 int ath10k_bmi_read_memory(struct ath10k *ar, u32 address,
 			   void *buffer, u32 length);
 int ath10k_bmi_write_memory(struct ath10k *ar, u32 address,
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 15a9549aad07..23cf6b191770 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2206,7 +2206,10 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	}
 
 	memset(&target_info, 0, sizeof(target_info));
-	ret = ath10k_bmi_get_target_info(ar, &target_info);
+	if (ar->hif.bus == ATH10K_BUS_SDIO)
+		ret = ath10k_bmi_get_target_info_sdio(ar, &target_info);
+	else
+		ret = ath10k_bmi_get_target_info(ar, &target_info);
 	if (ret) {
 		ath10k_err(ar, "could not get target info (%d)\n", ret);
 		goto err_power_down;

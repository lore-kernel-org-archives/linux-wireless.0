Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:43666 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaCKPdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 11:33:25 -0400
Subject: [PATCH 1/2] ath10k: separate result parameter in ath10k_bmi_execute()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Mar 2014 17:33:19 +0200
Message-ID: <20140311153318.7148.47415.stgit@potku.adurom.net> (sfid-20140311_163328_214322_D8DD4829)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's just cleaner to have separate argument for the parameter and result. Also
fix returned error value if response length is invalid.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/bmi.c  |   13 ++++++++-----
 drivers/net/wireless/ath/ath10k/bmi.h  |    2 +-
 drivers/net/wireless/ath/ath10k/core.c |    6 ++----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index a1f099628850..17d221abd58c 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -175,7 +175,7 @@ int ath10k_bmi_write_memory(struct ath10k *ar,
 	return 0;
 }
 
-int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 *param)
+int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 param, u32 *result)
 {
 	struct bmi_cmd cmd;
 	union bmi_resp resp;
@@ -184,7 +184,7 @@ int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 *param)
 	int ret;
 
 	ath10k_dbg(ATH10K_DBG_BMI, "bmi execute address 0x%x param 0x%x\n",
-		   address, *param);
+		   address, param);
 
 	if (ar->bmi.done_sent) {
 		ath10k_warn("command disallowed\n");
@@ -193,7 +193,7 @@ int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 *param)
 
 	cmd.id            = __cpu_to_le32(BMI_EXECUTE);
 	cmd.execute.addr  = __cpu_to_le32(address);
-	cmd.execute.param = __cpu_to_le32(*param);
+	cmd.execute.param = __cpu_to_le32(param);
 
 	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen, &resp, &resplen);
 	if (ret) {
@@ -204,10 +204,13 @@ int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 *param)
 	if (resplen < sizeof(resp.execute)) {
 		ath10k_warn("invalid execute response length (%d)\n",
 			    resplen);
-		return ret;
+		return -EIO;
 	}
 
-	*param = __le32_to_cpu(resp.execute.result);
+	*result = __le32_to_cpu(resp.execute.result);
+
+	ath10k_dbg(ATH10K_DBG_BMI, "bmi execute result 0x%x\n", *result);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 8d81ce1cec21..3a9bdf51c96a 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -217,7 +217,7 @@ int ath10k_bmi_write_memory(struct ath10k *ar, u32 address,
 		ret;							\
 	})
 
-int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 *param);
+int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 param, u32 *result);
 int ath10k_bmi_lz_stream_start(struct ath10k *ar, u32 address);
 int ath10k_bmi_lz_data(struct ath10k *ar, const void *buffer, u32 length);
 int ath10k_bmi_fast_download(struct ath10k *ar, u32 address,
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ebc5fc2ede75..602fb9644cbf 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -249,8 +249,7 @@ exit:
 
 static int ath10k_download_and_run_otp(struct ath10k *ar)
 {
-	u32 address = ar->hw_params.patch_load_addr;
-	u32 exec_param;
+	u32 result, address = ar->hw_params.patch_load_addr;
 	int ret;
 
 	/* OTP is optional */
@@ -264,8 +263,7 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 		goto exit;
 	}
 
-	exec_param = 0;
-	ret = ath10k_bmi_execute(ar, address, &exec_param);
+	ret = ath10k_bmi_execute(ar, address, 0, &result);
 	if (ret) {
 		ath10k_err("could not execute otp (%d)\n", ret);
 		goto exit;


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:38198 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab3CIKBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 05:01:46 -0500
Subject: [PATCH v2 2/3] ath6kl: fix usb related error handling and warnings
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Mar 2013 12:01:43 +0200
Message-ID: <20130309100143.432.69714.stgit@localhost6.localdomain6> (sfid-20130309_110149_081561_858FF987)
In-Reply-To: <20130309100031.432.94974.stgit@localhost6.localdomain6>
References: <20130309100031.432.94974.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was annoying to debug usb warm reboot initialisation problems as many usb
related functions just ignored errors and it wasn't obvious from the kernel
logs what was failing. Fix all that so that error messages are printed and
errors are handled properly.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   10 ++++----
 drivers/net/wireless/ath/ath6kl/init.c     |   10 +++++---
 drivers/net/wireless/ath/ath6kl/usb.c      |   34 ++++++++++++++++++----------
 3 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index 9adb567..c02d9d3 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -1167,7 +1167,7 @@ static int htc_wait_recv_ctrl_message(struct htc_target *target)
 	}
 
 	if (count <= 0) {
-		ath6kl_dbg(ATH6KL_DBG_HTC, "%s: Timeout!\n", __func__);
+		ath6kl_warn("htc pipe control receive timeout!\n");
 		return -ECOMM;
 	}
 
@@ -1581,16 +1581,16 @@ static int ath6kl_htc_pipe_wait_target(struct htc_target *target)
 		return status;
 
 	if (target->pipe.ctrl_response_len < sizeof(*ready_msg)) {
-		ath6kl_dbg(ATH6KL_DBG_HTC, "invalid htc ready msg len:%d!\n",
-			   target->pipe.ctrl_response_len);
+		ath6kl_warn("invalid htc pipe ready msg len: %d\n",
+			    target->pipe.ctrl_response_len);
 		return -ECOMM;
 	}
 
 	ready_msg = (struct htc_ready_ext_msg *) target->pipe.ctrl_response_buf;
 
 	if (ready_msg->ver2_0_info.msg_id != cpu_to_le16(HTC_MSG_READY_ID)) {
-		ath6kl_dbg(ATH6KL_DBG_HTC, "invalid htc ready msg : 0x%X !\n",
-			   ready_msg->ver2_0_info.msg_id);
+		ath6kl_warn("invalid htc pipe ready msg: 0x%x\n",
+			    ready_msg->ver2_0_info.msg_id);
 		return -ECOMM;
 	}
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index ae1e477..8b01ec3 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1657,13 +1657,15 @@ static int __ath6kl_init_hw_start(struct ath6kl *ar)
 	 * driver layer has to init BMI in order to set the host block
 	 * size.
 	 */
-	if (ath6kl_htc_wait_target(ar->htc_target)) {
-		ret = -EIO;
+	ret = ath6kl_htc_wait_target(ar->htc_target);
+	if (ret) {
+		ath6kl_err("htc wait target failed: %d\n", ret);
 		goto err_power_off;
 	}
 
-	if (ath6kl_init_service_ep(ar)) {
-		ret = -EIO;
+	ret = ath6kl_init_service_ep(ar);
+	if (ret) {
+		ath6kl_err("Endpoint service initilisation failed: %d\n", ret);
 		goto err_cleanup_scatter;
 	}
 
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 5fcd342..63948f6 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -872,8 +872,9 @@ static int ath6kl_usb_submit_ctrl_out(struct ath6kl_usb *ar_usb,
 			      size, 1000);
 
 	if (ret < 0) {
-		ath6kl_dbg(ATH6KL_DBG_USB, "%s failed,result = %d\n",
-			   __func__, ret);
+		ath6kl_warn("Failed to submit usb control message: %d\n", ret);
+		kfree(buf);
+		return ret;
 	}
 
 	kfree(buf);
@@ -903,8 +904,9 @@ static int ath6kl_usb_submit_ctrl_in(struct ath6kl_usb *ar_usb,
 				 size, 2 * HZ);
 
 	if (ret < 0) {
-		ath6kl_dbg(ATH6KL_DBG_USB, "%s failed,result = %d\n",
-			   __func__, ret);
+		ath6kl_warn("Failed to read usb control message: %d\n", ret);
+		kfree(buf);
+		return ret;
 	}
 
 	memcpy((u8 *) data, buf, size);
@@ -961,8 +963,10 @@ static int ath6kl_usb_diag_read32(struct ath6kl *ar, u32 address, u32 *data)
 				ATH6KL_USB_CONTROL_REQ_DIAG_RESP,
 				ar_usb->diag_resp_buffer, &resp_len);
 
-	if (ret)
+	if (ret) {
+		ath6kl_warn("diag read32 failed: %d\n", ret);
 		return ret;
+	}
 
 	resp = (struct ath6kl_usb_ctrl_diag_resp_read *)
 		ar_usb->diag_resp_buffer;
@@ -976,6 +980,7 @@ static int ath6kl_usb_diag_write32(struct ath6kl *ar, u32 address, __le32 data)
 {
 	struct ath6kl_usb *ar_usb = ar->hif_priv;
 	struct ath6kl_usb_ctrl_diag_cmd_write *cmd;
+	int ret;
 
 	cmd = (struct ath6kl_usb_ctrl_diag_cmd_write *) ar_usb->diag_cmd_buffer;
 
@@ -984,12 +989,17 @@ static int ath6kl_usb_diag_write32(struct ath6kl *ar, u32 address, __le32 data)
 	cmd->address = cpu_to_le32(address);
 	cmd->value = data;
 
-	return ath6kl_usb_ctrl_msg_exchange(ar_usb,
-					    ATH6KL_USB_CONTROL_REQ_DIAG_CMD,
-					    (u8 *) cmd,
-					    sizeof(*cmd),
-					    0, NULL, NULL);
+	ret = ath6kl_usb_ctrl_msg_exchange(ar_usb,
+					   ATH6KL_USB_CONTROL_REQ_DIAG_CMD,
+					   (u8 *) cmd,
+					   sizeof(*cmd),
+					   0, NULL, NULL);
+	if (ret) {
+		ath6kl_warn("diag_write32 failed: %d\n", ret);
+		return ret;
+	}
 
+	return 0;
 }
 
 static int ath6kl_usb_bmi_read(struct ath6kl *ar, u8 *buf, u32 len)
@@ -1001,7 +1011,7 @@ static int ath6kl_usb_bmi_read(struct ath6kl *ar, u8 *buf, u32 len)
 	ret = ath6kl_usb_submit_ctrl_in(ar_usb,
 					ATH6KL_USB_CONTROL_REQ_RECV_BMI_RESP,
 					0, 0, buf, len);
-	if (ret != 0) {
+	if (ret) {
 		ath6kl_err("Unable to read the bmi data from the device: %d\n",
 			   ret);
 		return ret;
@@ -1019,7 +1029,7 @@ static int ath6kl_usb_bmi_write(struct ath6kl *ar, u8 *buf, u32 len)
 	ret = ath6kl_usb_submit_ctrl_out(ar_usb,
 					 ATH6KL_USB_CONTROL_REQ_SEND_BMI_CMD,
 					 0, 0, buf, len);
-	if (ret != 0) {
+	if (ret) {
 		ath6kl_err("unable to send the bmi data to the device: %d\n",
 			   ret);
 		return ret;


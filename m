Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51209 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbaHYHuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 03:50:50 -0400
Received: by mail-lb0-f179.google.com with SMTP id v6so11683773lbi.38
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2014 00:50:46 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC] ath10k: improve logging to include dev id
Date: Mon, 25 Aug 2014 09:40:56 +0200
Message-Id: <1408952456-3121-1-git-send-email-michal.kazior@tieto.com> (sfid-20140825_095105_570473_82549F68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it a lot easier to log and debug
messages if there's more than 1 ath10k device on a
system.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/bmi.c      |  52 ++--
 drivers/net/wireless/ath/ath10k/ce.c       |  14 +-
 drivers/net/wireless/ath/ath10k/core.c     | 185 +++++++------
 drivers/net/wireless/ath/ath10k/debug.c    |  60 ++--
 drivers/net/wireless/ath/ath10k/debug.h    |  18 +-
 drivers/net/wireless/ath/ath10k/htc.c      |  99 ++++---
 drivers/net/wireless/ath/ath10k/htc.h      |   2 +-
 drivers/net/wireless/ath/ath10k/htt.c      |   9 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c   | 116 ++++----
 drivers/net/wireless/ath/ath10k/htt_tx.c   |  46 ++--
 drivers/net/wireless/ath/ath10k/mac.c      | 427 +++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/pci.c      | 226 +++++++--------
 drivers/net/wireless/ath/ath10k/spectral.c |   8 +-
 drivers/net/wireless/ath/ath10k/txrx.c     |  17 +-
 drivers/net/wireless/ath/ath10k/wmi.c      | 355 ++++++++++++------------
 15 files changed, 845 insertions(+), 789 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index 17d221a..3d29b08 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -22,7 +22,7 @@
 
 void ath10k_bmi_start(struct ath10k *ar)
 {
-	ath10k_dbg(ATH10K_DBG_BMI, "bmi start\n");
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi start\n");
 
 	ar->bmi.done_sent = false;
 }
@@ -33,10 +33,10 @@ int ath10k_bmi_done(struct ath10k *ar)
 	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.done);
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BMI, "bmi done\n");
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi done\n");
 
 	if (ar->bmi.done_sent) {
-		ath10k_dbg(ATH10K_DBG_BMI, "bmi skipped\n");
+		ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi skipped\n");
 		return 0;
 	}
 
@@ -45,7 +45,7 @@ int ath10k_bmi_done(struct ath10k *ar)
 
 	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen, NULL, NULL);
 	if (ret) {
-		ath10k_warn("unable to write to the device: %d\n", ret);
+		ath10k_warn(ar, "unable to write to the device: %d\n", ret);
 		return ret;
 	}
 
@@ -61,10 +61,10 @@ int ath10k_bmi_get_target_info(struct ath10k *ar,
 	u32 resplen = sizeof(resp.get_target_info);
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BMI, "bmi get target info\n");
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi get target info\n");
 
 	if (ar->bmi.done_sent) {
-		ath10k_warn("BMI Get Target Info Command disallowed\n");
+		ath10k_warn(ar, "BMI Get Target Info Command disallowed\n");
 		return -EBUSY;
 	}
 
@@ -72,12 +72,12 @@ int ath10k_bmi_get_target_info(struct ath10k *ar,
 
 	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen, &resp, &resplen);
 	if (ret) {
-		ath10k_warn("unable to get target info from device\n");
+		ath10k_warn(ar, "unable to get target info from device\n");
 		return ret;
 	}
 
 	if (resplen < sizeof(resp.get_target_info)) {
-		ath10k_warn("invalid get_target_info response length (%d)\n",
+		ath10k_warn(ar, "invalid get_target_info response length (%d)\n",
 			    resplen);
 		return -EIO;
 	}
@@ -97,11 +97,11 @@ int ath10k_bmi_read_memory(struct ath10k *ar,
 	u32 rxlen;
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BMI, "bmi read address 0x%x length %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi read address 0x%x length %d\n",
 		   address, length);
 
 	if (ar->bmi.done_sent) {
-		ath10k_warn("command disallowed\n");
+		ath10k_warn(ar, "command disallowed\n");
 		return -EBUSY;
 	}
 
@@ -115,7 +115,7 @@ int ath10k_bmi_read_memory(struct ath10k *ar,
 		ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen,
 						  &resp, &rxlen);
 		if (ret) {
-			ath10k_warn("unable to read from the device (%d)\n",
+			ath10k_warn(ar, "unable to read from the device (%d)\n",
 				    ret);
 			return ret;
 		}
@@ -137,11 +137,11 @@ int ath10k_bmi_write_memory(struct ath10k *ar,
 	u32 txlen;
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BMI, "bmi write address 0x%x length %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi write address 0x%x length %d\n",
 		   address, length);
 
 	if (ar->bmi.done_sent) {
-		ath10k_warn("command disallowed\n");
+		ath10k_warn(ar, "command disallowed\n");
 		return -EBUSY;
 	}
 
@@ -159,7 +159,7 @@ int ath10k_bmi_write_memory(struct ath10k *ar,
 		ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, hdrlen + txlen,
 						  NULL, NULL);
 		if (ret) {
-			ath10k_warn("unable to write to the device (%d)\n",
+			ath10k_warn(ar, "unable to write to the device (%d)\n",
 				    ret);
 			return ret;
 		}
@@ -183,11 +183,11 @@ int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 param, u32 *result)
 	u32 resplen = sizeof(resp.execute);
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BMI, "bmi execute address 0x%x param 0x%x\n",
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi execute address 0x%x param 0x%x\n",
 		   address, param);
 
 	if (ar->bmi.done_sent) {
-		ath10k_warn("command disallowed\n");
+		ath10k_warn(ar, "command disallowed\n");
 		return -EBUSY;
 	}
 
@@ -197,19 +197,19 @@ int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 param, u32 *result)
 
 	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen, &resp, &resplen);
 	if (ret) {
-		ath10k_warn("unable to read from the device\n");
+		ath10k_warn(ar, "unable to read from the device\n");
 		return ret;
 	}
 
 	if (resplen < sizeof(resp.execute)) {
-		ath10k_warn("invalid execute response length (%d)\n",
+		ath10k_warn(ar, "invalid execute response length (%d)\n",
 			    resplen);
 		return -EIO;
 	}
 
 	*result = __le32_to_cpu(resp.execute.result);
 
-	ath10k_dbg(ATH10K_DBG_BMI, "bmi execute result 0x%x\n", *result);
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi execute result 0x%x\n", *result);
 
 	return 0;
 }
@@ -221,11 +221,11 @@ int ath10k_bmi_lz_data(struct ath10k *ar, const void *buffer, u32 length)
 	u32 txlen;
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BMI, "bmi lz data buffer 0x%p length %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi lz data buffer 0x%p length %d\n",
 		   buffer, length);
 
 	if (ar->bmi.done_sent) {
-		ath10k_warn("command disallowed\n");
+		ath10k_warn(ar, "command disallowed\n");
 		return -EBUSY;
 	}
 
@@ -241,7 +241,7 @@ int ath10k_bmi_lz_data(struct ath10k *ar, const void *buffer, u32 length)
 		ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, hdrlen + txlen,
 						  NULL, NULL);
 		if (ret) {
-			ath10k_warn("unable to write to the device\n");
+			ath10k_warn(ar, "unable to write to the device\n");
 			return ret;
 		}
 
@@ -258,11 +258,11 @@ int ath10k_bmi_lz_stream_start(struct ath10k *ar, u32 address)
 	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.lz_start);
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BMI, "bmi lz stream start address 0x%x\n",
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi lz stream start address 0x%x\n",
 		   address);
 
 	if (ar->bmi.done_sent) {
-		ath10k_warn("command disallowed\n");
+		ath10k_warn(ar, "command disallowed\n");
 		return -EBUSY;
 	}
 
@@ -271,7 +271,7 @@ int ath10k_bmi_lz_stream_start(struct ath10k *ar, u32 address)
 
 	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen, NULL, NULL);
 	if (ret) {
-		ath10k_warn("unable to Start LZ Stream to the device\n");
+		ath10k_warn(ar, "unable to Start LZ Stream to the device\n");
 		return ret;
 	}
 
@@ -286,7 +286,7 @@ int ath10k_bmi_fast_download(struct ath10k *ar,
 	u32 trailer_len = length - head_len;
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BMI,
+	ath10k_dbg(ar, ATH10K_DBG_BMI,
 		   "bmi fast download address 0x%x buffer 0x%p length %d\n",
 		   address, buffer, length);
 
diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 5117705..c0fb7bc 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -284,7 +284,7 @@ int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 	int ret = 0;
 
 	if (nbytes > ce_state->src_sz_max)
-		ath10k_warn("%s: send more we can (nbytes: %d, max: %d)\n",
+		ath10k_warn(ar, "%s: send more we can (nbytes: %d, max: %d)\n",
 			    __func__, nbytes, ce_state->src_sz_max);
 
 	if (unlikely(CE_RING_DELTA(nentries_mask,
@@ -854,7 +854,7 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 	ath10k_ce_src_ring_lowmark_set(ar, ctrl_addr, 0);
 	ath10k_ce_src_ring_highmark_set(ar, ctrl_addr, nentries);
 
-	ath10k_dbg(ATH10K_DBG_BOOT,
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
 		   "boot init ce src ring id %d entries %d base_addr %p\n",
 		   ce_id, nentries, src_ring->base_addr_owner_space);
 
@@ -888,7 +888,7 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 	ath10k_ce_dest_ring_lowmark_set(ar, ctrl_addr, 0);
 	ath10k_ce_dest_ring_highmark_set(ar, ctrl_addr, nentries);
 
-	ath10k_dbg(ATH10K_DBG_BOOT,
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
 		   "boot ce dest ring id %d entries %d base_addr %p\n",
 		   ce_id, nentries, dest_ring->base_addr_owner_space);
 
@@ -1051,7 +1051,7 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 	if (attr->src_nentries) {
 		ret = ath10k_ce_init_src_ring(ar, ce_id, attr);
 		if (ret) {
-			ath10k_err("Failed to initialize CE src ring for ID: %d (%d)\n",
+			ath10k_err(ar, "Failed to initialize CE src ring for ID: %d (%d)\n",
 				   ce_id, ret);
 			return ret;
 		}
@@ -1060,7 +1060,7 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 	if (attr->dest_nentries) {
 		ret = ath10k_ce_init_dest_ring(ar, ce_id, attr);
 		if (ret) {
-			ath10k_err("Failed to initialize CE dest ring for ID: %d (%d)\n",
+			ath10k_err(ar, "Failed to initialize CE dest ring for ID: %d (%d)\n",
 				   ce_id, ret);
 			return ret;
 		}
@@ -1105,7 +1105,7 @@ int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 		ce_state->src_ring = ath10k_ce_alloc_src_ring(ar, ce_id, attr);
 		if (IS_ERR(ce_state->src_ring)) {
 			ret = PTR_ERR(ce_state->src_ring);
-			ath10k_err("failed to allocate copy engine source ring %d: %d\n",
+			ath10k_err(ar, "failed to allocate copy engine source ring %d: %d\n",
 				   ce_id, ret);
 			ce_state->src_ring = NULL;
 			return ret;
@@ -1117,7 +1117,7 @@ int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 								attr);
 		if (IS_ERR(ce_state->dest_ring)) {
 			ret = PTR_ERR(ce_state->dest_ring);
-			ath10k_err("failed to allocate copy engine destination ring %d: %d\n",
+			ath10k_err(ar, "failed to allocate copy engine destination ring %d: %d\n",
 				   ce_id, ret);
 			ce_state->dest_ring = NULL;
 			return ret;
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ba2e87a..6666155 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -53,7 +53,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 
 static void ath10k_send_suspend_complete(struct ath10k *ar)
 {
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot suspend complete\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot suspend complete\n");
 
 	complete(&ar->target_suspend);
 }
@@ -67,14 +67,14 @@ static int ath10k_init_configure_target(struct ath10k *ar)
 	ret = ath10k_bmi_write32(ar, hi_app_host_interest,
 				 HTC_PROTOCOL_VERSION);
 	if (ret) {
-		ath10k_err("settings HTC version failed\n");
+		ath10k_err(ar, "settings HTC version failed\n");
 		return ret;
 	}
 
 	/* set the firmware mode to STA/IBSS/AP */
 	ret = ath10k_bmi_read32(ar, hi_option_flag, &param_host);
 	if (ret) {
-		ath10k_err("setting firmware mode (1/2) failed\n");
+		ath10k_err(ar, "setting firmware mode (1/2) failed\n");
 		return ret;
 	}
 
@@ -93,14 +93,14 @@ static int ath10k_init_configure_target(struct ath10k *ar)
 
 	ret = ath10k_bmi_write32(ar, hi_option_flag, param_host);
 	if (ret) {
-		ath10k_err("setting firmware mode (2/2) failed\n");
+		ath10k_err(ar, "setting firmware mode (2/2) failed\n");
 		return ret;
 	}
 
 	/* We do all byte-swapping on the host */
 	ret = ath10k_bmi_write32(ar, hi_be, 0);
 	if (ret) {
-		ath10k_err("setting host CPU BE mode failed\n");
+		ath10k_err(ar, "setting host CPU BE mode failed\n");
 		return ret;
 	}
 
@@ -108,7 +108,7 @@ static int ath10k_init_configure_target(struct ath10k *ar)
 	ret = ath10k_bmi_write32(ar, hi_fw_swap, 0);
 
 	if (ret) {
-		ath10k_err("setting FW data/desc swap flags failed\n");
+		ath10k_err(ar, "setting FW data/desc swap flags failed\n");
 		return ret;
 	}
 
@@ -146,11 +146,12 @@ static int ath10k_push_board_ext_data(struct ath10k *ar)
 
 	ret = ath10k_bmi_read32(ar, hi_board_ext_data, &board_ext_data_addr);
 	if (ret) {
-		ath10k_err("could not read board ext data addr (%d)\n", ret);
+		ath10k_err(ar, "could not read board ext data addr (%d)\n",
+			   ret);
 		return ret;
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT,
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
 		   "boot push board extended data addr 0x%x\n",
 		   board_ext_data_addr);
 
@@ -158,7 +159,7 @@ static int ath10k_push_board_ext_data(struct ath10k *ar)
 		return 0;
 
 	if (ar->board_len != (board_data_size + board_ext_data_size)) {
-		ath10k_err("invalid board (ext) data sizes %zu != %d+%d\n",
+		ath10k_err(ar, "invalid board (ext) data sizes %zu != %d+%d\n",
 			   ar->board_len, board_data_size, board_ext_data_size);
 		return -EINVAL;
 	}
@@ -167,14 +168,15 @@ static int ath10k_push_board_ext_data(struct ath10k *ar)
 				      ar->board_data + board_data_size,
 				      board_ext_data_size);
 	if (ret) {
-		ath10k_err("could not write board ext data (%d)\n", ret);
+		ath10k_err(ar, "could not write board ext data (%d)\n", ret);
 		return ret;
 	}
 
 	ret = ath10k_bmi_write32(ar, hi_board_ext_data_config,
 				 (board_ext_data_size << 16) | 1);
 	if (ret) {
-		ath10k_err("could not write board ext data bit (%d)\n", ret);
+		ath10k_err(ar, "could not write board ext data bit (%d)\n",
+			   ret);
 		return ret;
 	}
 
@@ -189,13 +191,13 @@ static int ath10k_download_board_data(struct ath10k *ar)
 
 	ret = ath10k_push_board_ext_data(ar);
 	if (ret) {
-		ath10k_err("could not push board ext data (%d)\n", ret);
+		ath10k_err(ar, "could not push board ext data (%d)\n", ret);
 		goto exit;
 	}
 
 	ret = ath10k_bmi_read32(ar, hi_board_data, &address);
 	if (ret) {
-		ath10k_err("could not read board data addr (%d)\n", ret);
+		ath10k_err(ar, "could not read board data addr (%d)\n", ret);
 		goto exit;
 	}
 
@@ -203,13 +205,13 @@ static int ath10k_download_board_data(struct ath10k *ar)
 				      min_t(u32, board_data_size,
 					    ar->board_len));
 	if (ret) {
-		ath10k_err("could not write board data (%d)\n", ret);
+		ath10k_err(ar, "could not write board data (%d)\n", ret);
 		goto exit;
 	}
 
 	ret = ath10k_bmi_write32(ar, hi_board_data_initialized, 1);
 	if (ret) {
-		ath10k_err("could not write board data bit (%d)\n", ret);
+		ath10k_err(ar, "could not write board data bit (%d)\n", ret);
 		goto exit;
 	}
 
@@ -225,30 +227,30 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	/* OTP is optional */
 
 	if (!ar->otp_data || !ar->otp_len) {
-		ath10k_warn("Not running otp, calibration will be incorrect (otp-data %p otp_len %zd)!\n",
+		ath10k_warn(ar, "Not running otp, calibration will be incorrect (otp-data %p otp_len %zd)!\n",
 			    ar->otp_data, ar->otp_len);
 		return 0;
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot upload otp to 0x%x len %zd\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot upload otp to 0x%x len %zd\n",
 		   address, ar->otp_len);
 
 	ret = ath10k_bmi_fast_download(ar, address, ar->otp_data, ar->otp_len);
 	if (ret) {
-		ath10k_err("could not write otp (%d)\n", ret);
+		ath10k_err(ar, "could not write otp (%d)\n", ret);
 		return ret;
 	}
 
 	ret = ath10k_bmi_execute(ar, address, 0, &result);
 	if (ret) {
-		ath10k_err("could not execute otp (%d)\n", ret);
+		ath10k_err(ar, "could not execute otp (%d)\n", ret);
 		return ret;
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot otp execute result %d\n", result);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot otp execute result %d\n", result);
 
 	if (result != 0) {
-		ath10k_err("otp calibration failed: %d", result);
+		ath10k_err(ar, "otp calibration failed: %d", result);
 		return -EINVAL;
 	}
 
@@ -265,7 +267,7 @@ static int ath10k_download_fw(struct ath10k *ar)
 	ret = ath10k_bmi_fast_download(ar, address, ar->firmware_data,
 				       ar->firmware_len);
 	if (ret) {
-		ath10k_err("could not write fw (%d)\n", ret);
+		ath10k_err(ar, "could not write fw (%d)\n", ret);
 		goto exit;
 	}
 
@@ -302,12 +304,12 @@ static int ath10k_core_fetch_firmware_api_1(struct ath10k *ar)
 	int ret = 0;
 
 	if (ar->hw_params.fw.fw == NULL) {
-		ath10k_err("firmware file not defined\n");
+		ath10k_err(ar, "firmware file not defined\n");
 		return -EINVAL;
 	}
 
 	if (ar->hw_params.fw.board == NULL) {
-		ath10k_err("board data file not defined");
+		ath10k_err(ar, "board data file not defined");
 		return -EINVAL;
 	}
 
@@ -316,7 +318,7 @@ static int ath10k_core_fetch_firmware_api_1(struct ath10k *ar)
 					 ar->hw_params.fw.board);
 	if (IS_ERR(ar->board)) {
 		ret = PTR_ERR(ar->board);
-		ath10k_err("could not fetch board data (%d)\n", ret);
+		ath10k_err(ar, "could not fetch board data (%d)\n", ret);
 		goto err;
 	}
 
@@ -328,7 +330,7 @@ static int ath10k_core_fetch_firmware_api_1(struct ath10k *ar)
 					    ar->hw_params.fw.fw);
 	if (IS_ERR(ar->firmware)) {
 		ret = PTR_ERR(ar->firmware);
-		ath10k_err("could not fetch firmware (%d)\n", ret);
+		ath10k_err(ar, "could not fetch firmware (%d)\n", ret);
 		goto err;
 	}
 
@@ -344,7 +346,7 @@ static int ath10k_core_fetch_firmware_api_1(struct ath10k *ar)
 				       ar->hw_params.fw.otp);
 	if (IS_ERR(ar->otp)) {
 		ret = PTR_ERR(ar->otp);
-		ath10k_err("could not fetch otp (%d)\n", ret);
+		ath10k_err(ar, "could not fetch otp (%d)\n", ret);
 		goto err;
 	}
 
@@ -369,7 +371,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	/* first fetch the firmware file (firmware-*.bin) */
 	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
 	if (IS_ERR(ar->firmware)) {
-		ath10k_err("could not fetch firmware file '%s/%s': %ld\n",
+		ath10k_err(ar, "could not fetch firmware file '%s/%s': %ld\n",
 			   ar->hw_params.fw.dir, name, PTR_ERR(ar->firmware));
 		return PTR_ERR(ar->firmware);
 	}
@@ -381,14 +383,14 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
 
 	if (len < magic_len) {
-		ath10k_err("firmware file '%s/%s' too small to contain magic: %zu\n",
+		ath10k_err(ar, "firmware file '%s/%s' too small to contain magic: %zu\n",
 			   ar->hw_params.fw.dir, name, len);
 		ret = -EINVAL;
 		goto err;
 	}
 
 	if (memcmp(data, ATH10K_FIRMWARE_MAGIC, magic_len) != 0) {
-		ath10k_err("invalid firmware magic\n");
+		ath10k_err(ar, "invalid firmware magic\n");
 		ret = -EINVAL;
 		goto err;
 	}
@@ -410,7 +412,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 		data += sizeof(*hdr);
 
 		if (len < ie_len) {
-			ath10k_err("invalid length for FW IE %d (%zu < %zu)\n",
+			ath10k_err(ar, "invalid length for FW IE %d (%zu < %zu)\n",
 				   ie_id, len, ie_len);
 			ret = -EINVAL;
 			goto err;
@@ -424,7 +426,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			memcpy(ar->hw->wiphy->fw_version, data, ie_len);
 			ar->hw->wiphy->fw_version[ie_len] = '\0';
 
-			ath10k_dbg(ATH10K_DBG_BOOT,
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
 				   "found fw version %s\n",
 				    ar->hw->wiphy->fw_version);
 			break;
@@ -434,11 +436,11 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 
 			timestamp = (__le32 *)data;
 
-			ath10k_dbg(ATH10K_DBG_BOOT, "found fw timestamp %d\n",
+			ath10k_dbg(ar, ATH10K_DBG_BOOT, "found fw timestamp %d\n",
 				   le32_to_cpup(timestamp));
 			break;
 		case ATH10K_FW_IE_FEATURES:
-			ath10k_dbg(ATH10K_DBG_BOOT,
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
 				   "found firmware features ie (%zd B)\n",
 				   ie_len);
 
@@ -450,19 +452,19 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 					break;
 
 				if (data[index] & (1 << bit)) {
-					ath10k_dbg(ATH10K_DBG_BOOT,
+					ath10k_dbg(ar, ATH10K_DBG_BOOT,
 						   "Enabling feature bit: %i\n",
 						   i);
 					__set_bit(i, ar->fw_features);
 				}
 			}
 
-			ath10k_dbg_dump(ATH10K_DBG_BOOT, "features", "",
+			ath10k_dbg_dump(ar, ATH10K_DBG_BOOT, "features", "",
 					ar->fw_features,
 					sizeof(ar->fw_features));
 			break;
 		case ATH10K_FW_IE_FW_IMAGE:
-			ath10k_dbg(ATH10K_DBG_BOOT,
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
 				   "found fw image ie (%zd B)\n",
 				   ie_len);
 
@@ -471,7 +473,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 
 			break;
 		case ATH10K_FW_IE_OTP_IMAGE:
-			ath10k_dbg(ATH10K_DBG_BOOT,
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
 				   "found otp image ie (%zd B)\n",
 				   ie_len);
 
@@ -480,7 +482,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 
 			break;
 		default:
-			ath10k_warn("Unknown FW IE: %u\n",
+			ath10k_warn(ar, "Unknown FW IE: %u\n",
 				    le32_to_cpu(hdr->id));
 			break;
 		}
@@ -493,7 +495,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	}
 
 	if (!ar->firmware_data || !ar->firmware_len) {
-		ath10k_warn("No ATH10K_FW_IE_FW_IMAGE found from '%s/%s', skipping\n",
+		ath10k_warn(ar, "No ATH10K_FW_IE_FW_IMAGE found from '%s/%s', skipping\n",
 			    ar->hw_params.fw.dir, name);
 		ret = -ENOMEDIUM;
 		goto err;
@@ -501,14 +503,14 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features) &&
 	    !test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		ath10k_err("feature bits corrupted: 10.2 feature requires 10.x feature to be set as well");
+		ath10k_err(ar, "feature bits corrupted: 10.2 feature requires 10.x feature to be set as well");
 		ret = -EINVAL;
 		goto err;
 	}
 
 	/* now fetch the board file */
 	if (ar->hw_params.fw.board == NULL) {
-		ath10k_err("board data file not defined");
+		ath10k_err(ar, "board data file not defined");
 		ret = -EINVAL;
 		goto err;
 	}
@@ -518,7 +520,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 					 ar->hw_params.fw.board);
 	if (IS_ERR(ar->board)) {
 		ret = PTR_ERR(ar->board);
-		ath10k_err("could not fetch board data '%s/%s' (%d)\n",
+		ath10k_err(ar, "could not fetch board data '%s/%s' (%d)\n",
 			   ar->hw_params.fw.dir, ar->hw_params.fw.board,
 			   ret);
 		goto err;
@@ -539,28 +541,28 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 	int ret;
 
 	ar->fw_api = 3;
-	ath10k_dbg(ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
 	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API3_FILE);
 	if (ret == 0)
 		goto success;
 
 	ar->fw_api = 2;
-	ath10k_dbg(ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
 	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API2_FILE);
 	if (ret == 0)
 		goto success;
 
 	ar->fw_api = 1;
-	ath10k_dbg(ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
 	ret = ath10k_core_fetch_firmware_api_1(ar);
 	if (ret)
 		return ret;
 
 success:
-	ath10k_dbg(ATH10K_DBG_BOOT, "using fw api %d\n", ar->fw_api);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "using fw api %d\n", ar->fw_api);
 
 	return 0;
 }
@@ -571,19 +573,19 @@ static int ath10k_init_download_firmware(struct ath10k *ar)
 
 	ret = ath10k_download_board_data(ar);
 	if (ret) {
-		ath10k_err("failed to download board data: %d\n", ret);
+		ath10k_err(ar, "failed to download board data: %d\n", ret);
 		return ret;
 	}
 
 	ret = ath10k_download_and_run_otp(ar);
 	if (ret) {
-		ath10k_err("failed to run otp: %d\n", ret);
+		ath10k_err(ar, "failed to run otp: %d\n", ret);
 		return ret;
 	}
 
 	ret = ath10k_download_fw(ar);
 	if (ret) {
-		ath10k_err("failed to download firmware: %d\n", ret);
+		ath10k_err(ar, "failed to download firmware: %d\n", ret);
 		return ret;
 	}
 
@@ -600,7 +602,7 @@ static int ath10k_init_uart(struct ath10k *ar)
 	 */
 	ret = ath10k_bmi_write32(ar, hi_serial_enable, 0);
 	if (ret) {
-		ath10k_warn("could not disable UART prints (%d)\n", ret);
+		ath10k_warn(ar, "could not disable UART prints (%d)\n", ret);
 		return ret;
 	}
 
@@ -609,24 +611,24 @@ static int ath10k_init_uart(struct ath10k *ar)
 
 	ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin, 7);
 	if (ret) {
-		ath10k_warn("could not enable UART prints (%d)\n", ret);
+		ath10k_warn(ar, "could not enable UART prints (%d)\n", ret);
 		return ret;
 	}
 
 	ret = ath10k_bmi_write32(ar, hi_serial_enable, 1);
 	if (ret) {
-		ath10k_warn("could not enable UART prints (%d)\n", ret);
+		ath10k_warn(ar, "could not enable UART prints (%d)\n", ret);
 		return ret;
 	}
 
 	/* Set the UART baud rate to 19200. */
 	ret = ath10k_bmi_write32(ar, hi_desired_baud_rate, 19200);
 	if (ret) {
-		ath10k_warn("could not set the baud rate (%d)\n", ret);
+		ath10k_warn(ar, "could not set the baud rate (%d)\n", ret);
 		return ret;
 	}
 
-	ath10k_info("UART prints enabled\n");
+	ath10k_info(ar, "UART prints enabled\n");
 	return 0;
 }
 
@@ -643,14 +645,14 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	}
 
 	if (i == ARRAY_SIZE(ath10k_hw_params_list)) {
-		ath10k_err("Unsupported hardware version: 0x%x\n",
+		ath10k_err(ar, "Unsupported hardware version: 0x%x\n",
 			   ar->target_version);
 		return -EINVAL;
 	}
 
 	ar->hw_params = *hw_params;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "Hardware name %s version 0x%x\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "Hardware name %s version 0x%x\n",
 		   ar->hw_params.name, ar->target_version);
 
 	return 0;
@@ -671,7 +673,7 @@ static void ath10k_core_restart(struct work_struct *work)
 	case ATH10K_STATE_OFF:
 		/* this can happen if driver is being unloaded
 		 * or if the crash happens during FW probing */
-		ath10k_warn("cannot restart a device that hasn't been started\n");
+		ath10k_warn(ar, "cannot restart a device that hasn't been started\n");
 		break;
 	case ATH10K_STATE_RESTARTING:
 		/* hw restart might be requested from multiple places */
@@ -680,7 +682,7 @@ static void ath10k_core_restart(struct work_struct *work)
 		ar->state = ATH10K_STATE_WEDGED;
 		/* fall through */
 	case ATH10K_STATE_WEDGED:
-		ath10k_warn("device is wedged, will not restart\n");
+		ath10k_warn(ar, "device is wedged, will not restart\n");
 		break;
 	}
 
@@ -713,7 +715,7 @@ int ath10k_core_start(struct ath10k *ar)
 
 	status = ath10k_htc_init(ar);
 	if (status) {
-		ath10k_err("could not init HTC (%d)\n", status);
+		ath10k_err(ar, "could not init HTC (%d)\n", status);
 		goto err;
 	}
 
@@ -723,84 +725,85 @@ int ath10k_core_start(struct ath10k *ar)
 
 	status = ath10k_wmi_attach(ar);
 	if (status) {
-		ath10k_err("WMI attach failed: %d\n", status);
+		ath10k_err(ar, "WMI attach failed: %d\n", status);
 		goto err;
 	}
 
 	status = ath10k_htt_init(ar);
 	if (status) {
-		ath10k_err("failed to init htt: %d\n", status);
+		ath10k_err(ar, "failed to init htt: %d\n", status);
 		goto err_wmi_detach;
 	}
 
 	status = ath10k_htt_tx_alloc(&ar->htt);
 	if (status) {
-		ath10k_err("failed to alloc htt tx: %d\n", status);
+		ath10k_err(ar, "failed to alloc htt tx: %d\n", status);
 		goto err_wmi_detach;
 	}
 
 	status = ath10k_htt_rx_alloc(&ar->htt);
 	if (status) {
-		ath10k_err("failed to alloc htt rx: %d\n", status);
+		ath10k_err(ar, "failed to alloc htt rx: %d\n", status);
 		goto err_htt_tx_detach;
 	}
 
 	status = ath10k_hif_start(ar);
 	if (status) {
-		ath10k_err("could not start HIF: %d\n", status);
+		ath10k_err(ar, "could not start HIF: %d\n", status);
 		goto err_htt_rx_detach;
 	}
 
 	status = ath10k_htc_wait_target(&ar->htc);
 	if (status) {
-		ath10k_err("failed to connect to HTC: %d\n", status);
+		ath10k_err(ar, "failed to connect to HTC: %d\n", status);
 		goto err_hif_stop;
 	}
 
 	status = ath10k_htt_connect(&ar->htt);
 	if (status) {
-		ath10k_err("failed to connect htt (%d)\n", status);
+		ath10k_err(ar, "failed to connect htt (%d)\n", status);
 		goto err_hif_stop;
 	}
 
 	status = ath10k_wmi_connect(ar);
 	if (status) {
-		ath10k_err("could not connect wmi: %d\n", status);
+		ath10k_err(ar, "could not connect wmi: %d\n", status);
 		goto err_hif_stop;
 	}
 
 	status = ath10k_htc_start(&ar->htc);
 	if (status) {
-		ath10k_err("failed to start htc: %d\n", status);
+		ath10k_err(ar, "failed to start htc: %d\n", status);
 		goto err_hif_stop;
 	}
 
 	status = ath10k_wmi_wait_for_service_ready(ar);
 	if (status <= 0) {
-		ath10k_warn("wmi service ready event not received");
+		ath10k_warn(ar, "wmi service ready event not received");
 		status = -ETIMEDOUT;
 		goto err_hif_stop;
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "firmware %s booted\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "firmware %s booted\n",
 		   ar->hw->wiphy->fw_version);
 
 	status = ath10k_wmi_cmd_init(ar);
 	if (status) {
-		ath10k_err("could not send WMI init command (%d)\n", status);
+		ath10k_err(ar, "could not send WMI init command (%d)\n",
+			   status);
 		goto err_hif_stop;
 	}
 
 	status = ath10k_wmi_wait_for_unified_ready(ar);
 	if (status <= 0) {
-		ath10k_err("wmi unified ready event not received\n");
+		ath10k_err(ar, "wmi unified ready event not received\n");
 		status = -ETIMEDOUT;
 		goto err_hif_stop;
 	}
 
 	status = ath10k_htt_setup(&ar->htt);
 	if (status) {
-		ath10k_err("failed to setup htt: %d\n", status);
+		ath10k_err(ar, "failed to setup htt: %d\n", status);
 		goto err_hif_stop;
 	}
 
@@ -816,7 +819,7 @@ int ath10k_core_start(struct ath10k *ar)
 	INIT_LIST_HEAD(&ar->arvifs);
 
 	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags)) {
-		ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
+		ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
 			    ar->hw_params.name,
 			    ar->target_version,
 			    ar->chip_id,
@@ -824,7 +827,7 @@ int ath10k_core_start(struct ath10k *ar)
 			    ar->fw_api,
 			    ar->htt.target_version_major,
 			    ar->htt.target_version_minor);
-		ath10k_info("debug %d debugfs %d tracing %d dfs %d\n",
+		ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d\n",
 			    config_enabled(CONFIG_ATH10K_DEBUG),
 			    config_enabled(CONFIG_ATH10K_DEBUGFS),
 			    config_enabled(CONFIG_ATH10K_TRACING),
@@ -856,14 +859,14 @@ int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt)
 
 	ret = ath10k_wmi_pdev_suspend_target(ar, suspend_opt);
 	if (ret) {
-		ath10k_warn("could not suspend target (%d)\n", ret);
+		ath10k_warn(ar, "could not suspend target (%d)\n", ret);
 		return ret;
 	}
 
 	ret = wait_for_completion_timeout(&ar->target_suspend, 1 * HZ);
 
 	if (ret == 0) {
-		ath10k_warn("suspend timed out - target pause event never came\n");
+		ath10k_warn(ar, "suspend timed out - target pause event never came\n");
 		return -ETIMEDOUT;
 	}
 
@@ -897,14 +900,14 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	ret = ath10k_hif_power_up(ar);
 	if (ret) {
-		ath10k_err("could not start pci hif (%d)\n", ret);
+		ath10k_err(ar, "could not start pci hif (%d)\n", ret);
 		return ret;
 	}
 
 	memset(&target_info, 0, sizeof(target_info));
 	ret = ath10k_bmi_get_target_info(ar, &target_info);
 	if (ret) {
-		ath10k_err("could not get target info (%d)\n", ret);
+		ath10k_err(ar, "could not get target info (%d)\n", ret);
 		ath10k_hif_power_down(ar);
 		return ret;
 	}
@@ -914,14 +917,14 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	ret = ath10k_init_hw_params(ar);
 	if (ret) {
-		ath10k_err("could not get hw params (%d)\n", ret);
+		ath10k_err(ar, "could not get hw params (%d)\n", ret);
 		ath10k_hif_power_down(ar);
 		return ret;
 	}
 
 	ret = ath10k_core_fetch_firmware_files(ar);
 	if (ret) {
-		ath10k_err("could not fetch firmware files (%d)\n", ret);
+		ath10k_err(ar, "could not fetch firmware files (%d)\n", ret);
 		ath10k_hif_power_down(ar);
 		return ret;
 	}
@@ -930,7 +933,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	ret = ath10k_core_start(ar);
 	if (ret) {
-		ath10k_err("could not init core (%d)\n", ret);
+		ath10k_err(ar, "could not init core (%d)\n", ret);
 		ath10k_core_free_firmware_files(ar);
 		ath10k_hif_power_down(ar);
 		mutex_unlock(&ar->conf_mutex);
@@ -949,7 +952,7 @@ static int ath10k_core_check_chip_id(struct ath10k *ar)
 {
 	u32 hw_revision = MS(ar->chip_id, SOC_CHIP_ID_REV);
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot chip_id 0x%08x hw_revision 0x%x\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot chip_id 0x%08x hw_revision 0x%x\n",
 		   ar->chip_id, hw_revision);
 
 	/* Check that we are not using hw1.0 (some of them have same pci id
@@ -957,7 +960,7 @@ static int ath10k_core_check_chip_id(struct ath10k *ar)
 	 * due to missing hw1.0 workarounds. */
 	switch (hw_revision) {
 	case QCA988X_HW_1_0_CHIP_ID_REV:
-		ath10k_err("ERROR: qca988x hw1.0 is not supported\n");
+		ath10k_err(ar, "ERROR: qca988x hw1.0 is not supported\n");
 		return -EOPNOTSUPP;
 
 	case QCA988X_HW_2_0_CHIP_ID_REV:
@@ -965,7 +968,7 @@ static int ath10k_core_check_chip_id(struct ath10k *ar)
 		return 0;
 
 	default:
-		ath10k_warn("Warning: hardware revision unknown (0x%x), expect problems\n",
+		ath10k_warn(ar, "Warning: hardware revision unknown (0x%x), expect problems\n",
 			    ar->chip_id);
 		return 0;
 	}
@@ -980,25 +983,25 @@ static void ath10k_core_register_work(struct work_struct *work)
 
 	status = ath10k_core_probe_fw(ar);
 	if (status) {
-		ath10k_err("could not probe fw (%d)\n", status);
+		ath10k_err(ar, "could not probe fw (%d)\n", status);
 		goto err;
 	}
 
 	status = ath10k_mac_register(ar);
 	if (status) {
-		ath10k_err("could not register to mac80211 (%d)\n", status);
+		ath10k_err(ar, "could not register to mac80211 (%d)\n", status);
 		goto err_release_fw;
 	}
 
 	status = ath10k_debug_create(ar);
 	if (status) {
-		ath10k_err("unable to initialize debugfs\n");
+		ath10k_err(ar, "unable to initialize debugfs\n");
 		goto err_unregister_mac;
 	}
 
 	status = ath10k_spectral_create(ar);
 	if (status) {
-		ath10k_err("failed to initialize spectral\n");
+		ath10k_err(ar, "failed to initialize spectral\n");
 		goto err_debug_destroy;
 	}
 
@@ -1026,7 +1029,7 @@ int ath10k_core_register(struct ath10k *ar, u32 chip_id)
 
 	status = ath10k_core_check_chip_id(ar);
 	if (status) {
-		ath10k_err("Unsupported chip id 0x%08x\n", ar->chip_id);
+		ath10k_err(ar, "Unsupported chip id 0x%08x\n", ar->chip_id);
 		return status;
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index df1abe7..57995b9 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -24,25 +24,7 @@
 /* ms */
 #define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
 
-static int ath10k_printk(const char *level, const char *fmt, ...)
-{
-	struct va_format vaf;
-	va_list args;
-	int rtn;
-
-	va_start(args, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	rtn = printk("%sath10k: %pV", level, &vaf);
-
-	va_end(args);
-
-	return rtn;
-}
-
-int ath10k_info(const char *fmt, ...)
+int ath10k_info(struct ath10k *ar, const char *fmt, ...)
 {
 	struct va_format vaf = {
 		.fmt = fmt,
@@ -52,7 +34,7 @@ int ath10k_info(const char *fmt, ...)
 
 	va_start(args, fmt);
 	vaf.va = &args;
-	ret = ath10k_printk(KERN_INFO, "%pV", &vaf);
+	ret = dev_info(ar->dev, "%pV", &vaf);
 	trace_ath10k_log_info(&vaf);
 	va_end(args);
 
@@ -60,7 +42,7 @@ int ath10k_info(const char *fmt, ...)
 }
 EXPORT_SYMBOL(ath10k_info);
 
-int ath10k_err(const char *fmt, ...)
+int ath10k_err(struct ath10k *ar, const char *fmt, ...)
 {
 	struct va_format vaf = {
 		.fmt = fmt,
@@ -70,7 +52,7 @@ int ath10k_err(const char *fmt, ...)
 
 	va_start(args, fmt);
 	vaf.va = &args;
-	ret = ath10k_printk(KERN_ERR, "%pV", &vaf);
+	ret = dev_err(ar->dev, "%pV", &vaf);
 	trace_ath10k_log_err(&vaf);
 	va_end(args);
 
@@ -78,7 +60,7 @@ int ath10k_err(const char *fmt, ...)
 }
 EXPORT_SYMBOL(ath10k_err);
 
-int ath10k_warn(const char *fmt, ...)
+int ath10k_warn(struct ath10k *ar, const char *fmt, ...)
 {
 	struct va_format vaf = {
 		.fmt = fmt,
@@ -88,10 +70,7 @@ int ath10k_warn(const char *fmt, ...)
 
 	va_start(args, fmt);
 	vaf.va = &args;
-
-	if (net_ratelimit())
-		ret = ath10k_printk(KERN_WARNING, "%pV", &vaf);
-
+	dev_warn_ratelimited(ar->dev, "%pV", &vaf);
 	trace_ath10k_log_warn(&vaf);
 
 	va_end(args);
@@ -317,7 +296,7 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 
 	ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
 	if (ret) {
-		ath10k_warn("could not request stats (%d)\n", ret);
+		ath10k_warn(ar, "could not request stats (%d)\n", ret);
 		goto exit;
 	}
 
@@ -535,10 +514,10 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 	}
 
 	if (!strcmp(buf, "soft")) {
-		ath10k_info("simulating soft firmware crash\n");
+		ath10k_info(ar, "simulating soft firmware crash\n");
 		ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
 	} else if (!strcmp(buf, "hard")) {
-		ath10k_info("simulating hard firmware crash\n");
+		ath10k_info(ar, "simulating hard firmware crash\n");
 		/* 0x7fff is vdev id, and it is always out of range for all
 		 * firmware variants in order to force a firmware crash.
 		 */
@@ -550,7 +529,7 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 	}
 
 	if (ret) {
-		ath10k_warn("failed to simulate firmware crash: %d\n", ret);
+		ath10k_warn(ar, "failed to simulate firmware crash: %d\n", ret);
 		goto exit;
 	}
 
@@ -607,7 +586,7 @@ static int ath10k_debug_htt_stats_req(struct ath10k *ar)
 	ret = ath10k_htt_h2t_stats_req(&ar->htt, ar->debug.htt_stats_mask,
 				       cookie);
 	if (ret) {
-		ath10k_warn("failed to send htt stats request: %d\n", ret);
+		ath10k_warn(ar, "failed to send htt stats request: %d\n", ret);
 		return ret;
 	}
 
@@ -781,7 +760,7 @@ static ssize_t ath10k_write_fw_dbglog(struct file *file,
 	if (ar->state == ATH10K_STATE_ON) {
 		ret = ath10k_wmi_dbglog_cfg(ar, ar->debug.fw_dbglog_mask);
 		if (ret) {
-			ath10k_warn("dbglog cfg failed from debugfs: %d\n",
+			ath10k_warn(ar, "dbglog cfg failed from debugfs: %d\n",
 				    ret);
 			goto exit;
 		}
@@ -812,13 +791,14 @@ int ath10k_debug_start(struct ath10k *ar)
 	ret = ath10k_debug_htt_stats_req(ar);
 	if (ret)
 		/* continue normally anyway, this isn't serious */
-		ath10k_warn("failed to start htt stats workqueue: %d\n", ret);
+		ath10k_warn(ar, "failed to start htt stats workqueue: %d\n",
+			    ret);
 
 	if (ar->debug.fw_dbglog_mask) {
 		ret = ath10k_wmi_dbglog_cfg(ar, ar->debug.fw_dbglog_mask);
 		if (ret)
 			/* not serious */
-			ath10k_warn("failed to enable dbglog during start: %d",
+			ath10k_warn(ar, "failed to enable dbglog during start: %d",
 				    ret);
 	}
 
@@ -979,7 +959,8 @@ void ath10k_debug_destroy(struct ath10k *ar)
 #endif /* CONFIG_ATH10K_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
-void ath10k_dbg(enum ath10k_debug_mask mask, const char *fmt, ...)
+void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
+		const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -990,7 +971,7 @@ void ath10k_dbg(enum ath10k_debug_mask mask, const char *fmt, ...)
 	vaf.va = &args;
 
 	if (ath10k_debug_mask & mask)
-		ath10k_printk(KERN_DEBUG, "%pV", &vaf);
+		dev_printk(KERN_DEBUG, ar->dev, "%pV", &vaf);
 
 	trace_ath10k_log_dbg(mask, &vaf);
 
@@ -998,13 +979,14 @@ void ath10k_dbg(enum ath10k_debug_mask mask, const char *fmt, ...)
 }
 EXPORT_SYMBOL(ath10k_dbg);
 
-void ath10k_dbg_dump(enum ath10k_debug_mask mask,
+void ath10k_dbg_dump(struct ath10k *ar,
+		     enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len)
 {
 	if (ath10k_debug_mask & mask) {
 		if (msg)
-			ath10k_dbg(mask, "%s\n", msg);
+			ath10k_dbg(ar, mask, "%s\n", msg);
 
 		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
 	}
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index a582499..f5a01d5 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -39,9 +39,9 @@ enum ath10k_debug_mask {
 
 extern unsigned int ath10k_debug_mask;
 
-__printf(1, 2) int ath10k_info(const char *fmt, ...);
-__printf(1, 2) int ath10k_err(const char *fmt, ...);
-__printf(1, 2) int ath10k_warn(const char *fmt, ...);
+__printf(2, 3) int ath10k_info(struct ath10k *ar, const char *fmt, ...);
+__printf(2, 3) int ath10k_err(struct ath10k *ar, const char *fmt, ...);
+__printf(2, 3) int ath10k_warn(struct ath10k *ar, const char *fmt, ...);
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 int ath10k_debug_start(struct ath10k *ar);
@@ -91,20 +91,24 @@ static inline void ath10k_debug_read_target_stats(struct ath10k *ar,
 #endif /* CONFIG_ATH10K_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
-__printf(2, 3) void ath10k_dbg(enum ath10k_debug_mask mask,
+__printf(3, 4) void ath10k_dbg(struct ath10k *ar,
+			       enum ath10k_debug_mask mask,
 			       const char *fmt, ...);
-void ath10k_dbg_dump(enum ath10k_debug_mask mask,
+void ath10k_dbg_dump(struct ath10k *ar,
+		     enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len);
 #else /* CONFIG_ATH10K_DEBUG */
 
-static inline int ath10k_dbg(enum ath10k_debug_mask dbg_mask,
+static inline int ath10k_dbg(struct ath10k *ar,
+			     enum ath10k_debug_mask dbg_mask,
 			     const char *fmt, ...)
 {
 	return 0;
 }
 
-static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
+static inline void ath10k_dbg_dump(struct ath10k *ar,
+				   enum ath10k_debug_mask mask,
 				   const char *msg, const char *prefix,
 				   const void *buf, size_t len)
 {
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 7e08bb3..fd9a251 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -46,7 +46,7 @@ static struct sk_buff *ath10k_htc_build_tx_ctrl_skb(void *ar)
 
 	skb = dev_alloc_skb(ATH10K_HTC_CONTROL_BUFFER_SIZE);
 	if (!skb) {
-		ath10k_warn("Unable to allocate ctrl skb\n");
+		ath10k_warn(ar, "Unable to allocate ctrl skb\n");
 		return NULL;
 	}
 
@@ -56,7 +56,7 @@ static struct sk_buff *ath10k_htc_build_tx_ctrl_skb(void *ar)
 	skb_cb = ATH10K_SKB_CB(skb);
 	memset(skb_cb, 0, sizeof(*skb_cb));
 
-	ath10k_dbg(ATH10K_DBG_HTC, "%s: skb %p\n", __func__, skb);
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: skb %p\n", __func__, skb);
 	return skb;
 }
 
@@ -72,13 +72,15 @@ static inline void ath10k_htc_restore_tx_skb(struct ath10k_htc *htc,
 static void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
 					    struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_HTC, "%s: ep %d skb %p\n", __func__,
+	struct ath10k *ar = ep->htc->ar;
+
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: ep %d skb %p\n", __func__,
 		   ep->eid, skb);
 
 	ath10k_htc_restore_tx_skb(ep->htc, skb);
 
 	if (!ep->ep_ops.ep_tx_complete) {
-		ath10k_warn("no tx handler for eid %d\n", ep->eid);
+		ath10k_warn(ar, "no tx handler for eid %d\n", ep->eid);
 		dev_kfree_skb_any(skb);
 		return;
 	}
@@ -89,12 +91,14 @@ static void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
 /* assumes tx_lock is held */
 static bool ath10k_htc_ep_need_credit_update(struct ath10k_htc_ep *ep)
 {
+	struct ath10k *ar = ep->htc->ar;
+
 	if (!ep->tx_credit_flow_enabled)
 		return false;
 	if (ep->tx_credits >= ep->tx_credits_per_max_message)
 		return false;
 
-	ath10k_dbg(ATH10K_DBG_HTC, "HTC: endpoint %d needs credit update\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "HTC: endpoint %d needs credit update\n",
 		   ep->eid);
 	return true;
 }
@@ -123,6 +127,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 		    enum ath10k_htc_ep_id eid,
 		    struct sk_buff *skb)
 {
+	struct ath10k *ar = htc->ar;
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	struct ath10k_hif_sg_item sg_item;
@@ -134,7 +139,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 		return -ECOMM;
 
 	if (eid >= ATH10K_HTC_EP_COUNT) {
-		ath10k_warn("Invalid endpoint id: %d\n", eid);
+		ath10k_warn(ar, "Invalid endpoint id: %d\n", eid);
 		return -ENOENT;
 	}
 
@@ -149,7 +154,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 			goto err_pull;
 		}
 		ep->tx_credits -= credits;
-		ath10k_dbg(ATH10K_DBG_HTC,
+		ath10k_dbg(ar, ATH10K_DBG_HTC,
 			   "htc ep %d consumed %d credits (total %d)\n",
 			   eid, credits, ep->tx_credits);
 		spin_unlock_bh(&htc->tx_lock);
@@ -180,7 +185,7 @@ err_credits:
 	if (ep->tx_credit_flow_enabled) {
 		spin_lock_bh(&htc->tx_lock);
 		ep->tx_credits += credits;
-		ath10k_dbg(ATH10K_DBG_HTC,
+		ath10k_dbg(ar, ATH10K_DBG_HTC,
 			   "htc ep %d reverted %d credits back (total %d)\n",
 			   eid, credits, ep->tx_credits);
 		spin_unlock_bh(&htc->tx_lock);
@@ -219,11 +224,12 @@ ath10k_htc_process_credit_report(struct ath10k_htc *htc,
 				 int len,
 				 enum ath10k_htc_ep_id eid)
 {
+	struct ath10k *ar = htc->ar;
 	struct ath10k_htc_ep *ep;
 	int i, n_reports;
 
 	if (len % sizeof(*report))
-		ath10k_warn("Uneven credit report len %d", len);
+		ath10k_warn(ar, "Uneven credit report len %d", len);
 
 	n_reports = len / sizeof(*report);
 
@@ -235,7 +241,7 @@ ath10k_htc_process_credit_report(struct ath10k_htc *htc,
 		ep = &htc->endpoint[report->eid];
 		ep->tx_credits += report->credits;
 
-		ath10k_dbg(ATH10K_DBG_HTC, "htc ep %d got %d credits (total %d)\n",
+		ath10k_dbg(ar, ATH10K_DBG_HTC, "htc ep %d got %d credits (total %d)\n",
 			   report->eid, report->credits, ep->tx_credits);
 
 		if (ep->ep_ops.ep_tx_credits) {
@@ -252,6 +258,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 				      int length,
 				      enum ath10k_htc_ep_id src_eid)
 {
+	struct ath10k *ar = htc->ar;
 	int status = 0;
 	struct ath10k_htc_record *record;
 	u8 *orig_buffer;
@@ -271,7 +278,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 
 		if (record->hdr.len > length) {
 			/* no room left in buffer for record */
-			ath10k_warn("Invalid record length: %d\n",
+			ath10k_warn(ar, "Invalid record length: %d\n",
 				    record->hdr.len);
 			status = -EINVAL;
 			break;
@@ -281,7 +288,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 		case ATH10K_HTC_RECORD_CREDITS:
 			len = sizeof(struct ath10k_htc_credit_report);
 			if (record->hdr.len < len) {
-				ath10k_warn("Credit report too long\n");
+				ath10k_warn(ar, "Credit report too long\n");
 				status = -EINVAL;
 				break;
 			}
@@ -291,7 +298,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 							 src_eid);
 			break;
 		default:
-			ath10k_warn("Unhandled record: id:%d length:%d\n",
+			ath10k_warn(ar, "Unhandled record: id:%d length:%d\n",
 				    record->hdr.id, record->hdr.len);
 			break;
 		}
@@ -305,7 +312,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 	}
 
 	if (status)
-		ath10k_dbg_dump(ATH10K_DBG_HTC, "htc rx bad trailer", "",
+		ath10k_dbg_dump(ar, ATH10K_DBG_HTC, "htc rx bad trailer", "",
 				orig_buffer, orig_length);
 
 	return status;
@@ -331,8 +338,8 @@ static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
 	eid = hdr->eid;
 
 	if (eid >= ATH10K_HTC_EP_COUNT) {
-		ath10k_warn("HTC Rx: invalid eid %d\n", eid);
-		ath10k_dbg_dump(ATH10K_DBG_HTC, "htc bad header", "",
+		ath10k_warn(ar, "HTC Rx: invalid eid %d\n", eid);
+		ath10k_dbg_dump(ar, ATH10K_DBG_HTC, "htc bad header", "",
 				hdr, sizeof(*hdr));
 		status = -EINVAL;
 		goto out;
@@ -352,19 +359,19 @@ static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
 	payload_len = __le16_to_cpu(hdr->len);
 
 	if (payload_len + sizeof(*hdr) > ATH10K_HTC_MAX_LEN) {
-		ath10k_warn("HTC rx frame too long, len: %zu\n",
+		ath10k_warn(ar, "HTC rx frame too long, len: %zu\n",
 			    payload_len + sizeof(*hdr));
-		ath10k_dbg_dump(ATH10K_DBG_HTC, "htc bad rx pkt len", "",
+		ath10k_dbg_dump(ar, ATH10K_DBG_HTC, "htc bad rx pkt len", "",
 				hdr, sizeof(*hdr));
 		status = -EINVAL;
 		goto out;
 	}
 
 	if (skb->len < payload_len) {
-		ath10k_dbg(ATH10K_DBG_HTC,
+		ath10k_dbg(ar, ATH10K_DBG_HTC,
 			   "HTC Rx: insufficient length, got %d, expected %d\n",
 			   skb->len, payload_len);
-		ath10k_dbg_dump(ATH10K_DBG_HTC, "htc bad rx pkt len",
+		ath10k_dbg_dump(ar, ATH10K_DBG_HTC, "htc bad rx pkt len",
 				"", hdr, sizeof(*hdr));
 		status = -EINVAL;
 		goto out;
@@ -380,7 +387,7 @@ static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
 
 		if ((trailer_len < min_len) ||
 		    (trailer_len > payload_len)) {
-			ath10k_warn("Invalid trailer length: %d\n",
+			ath10k_warn(ar, "Invalid trailer length: %d\n",
 				    trailer_len);
 			status = -EPROTO;
 			goto out;
@@ -413,7 +420,7 @@ static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
 				 * this is a fatal error, target should not be
 				 * sending unsolicited messages on the ep 0
 				 */
-				ath10k_warn("HTC rx ctrl still processing\n");
+				ath10k_warn(ar, "HTC rx ctrl still processing\n");
 				status = -EINVAL;
 				complete(&htc->ctl_resp);
 				goto out;
@@ -434,7 +441,7 @@ static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
 		goto out;
 	}
 
-	ath10k_dbg(ATH10K_DBG_HTC, "htc rx completion ep %d skb %p\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "htc rx completion ep %d skb %p\n",
 		   eid, skb);
 	ep->ep_ops.ep_rx_complete(ar, skb);
 
@@ -451,7 +458,7 @@ static void ath10k_htc_control_rx_complete(struct ath10k *ar,
 {
 	/* This is unexpected. FW is not supposed to send regular rx on this
 	 * endpoint. */
-	ath10k_warn("unexpected htc rx\n");
+	ath10k_warn(ar, "unexpected htc rx\n");
 	kfree_skb(skb);
 }
 
@@ -538,6 +545,7 @@ static u8 ath10k_htc_get_credit_allocation(struct ath10k_htc *htc,
 
 int ath10k_htc_wait_target(struct ath10k_htc *htc)
 {
+	struct ath10k *ar = htc->ar;
 	int i, status = 0;
 	struct ath10k_htc_svc_conn_req conn_req;
 	struct ath10k_htc_svc_conn_resp conn_resp;
@@ -555,7 +563,7 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 		 * iomap writes unmasking PCI CE irqs aren't propagated
 		 * properly in KVM PCI-passthrough sometimes.
 		 */
-		ath10k_warn("failed to receive control response completion, polling..\n");
+		ath10k_warn(ar, "failed to receive control response completion, polling..\n");
 
 		for (i = 0; i < CE_COUNT; i++)
 			ath10k_hif_send_complete_check(htc->ar, i, 1);
@@ -568,12 +576,12 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 	}
 
 	if (status < 0) {
-		ath10k_err("ctl_resp never came in (%d)\n", status);
+		ath10k_err(ar, "ctl_resp never came in (%d)\n", status);
 		return status;
 	}
 
 	if (htc->control_resp_len < sizeof(msg->hdr) + sizeof(msg->ready)) {
-		ath10k_err("Invalid HTC ready msg len:%d\n",
+		ath10k_err(ar, "Invalid HTC ready msg len:%d\n",
 			   htc->control_resp_len);
 		return -ECOMM;
 	}
@@ -584,21 +592,21 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 	credit_size  = __le16_to_cpu(msg->ready.credit_size);
 
 	if (message_id != ATH10K_HTC_MSG_READY_ID) {
-		ath10k_err("Invalid HTC ready msg: 0x%x\n", message_id);
+		ath10k_err(ar, "Invalid HTC ready msg: 0x%x\n", message_id);
 		return -ECOMM;
 	}
 
 	htc->total_transmit_credits = credit_count;
 	htc->target_credit_size = credit_size;
 
-	ath10k_dbg(ATH10K_DBG_HTC,
+	ath10k_dbg(ar, ATH10K_DBG_HTC,
 		   "Target ready! transmit resources: %d size:%d\n",
 		   htc->total_transmit_credits,
 		   htc->target_credit_size);
 
 	if ((htc->total_transmit_credits == 0) ||
 	    (htc->target_credit_size == 0)) {
-		ath10k_err("Invalid credit size received\n");
+		ath10k_err(ar, "Invalid credit size received\n");
 		return -ECOMM;
 	}
 
@@ -615,7 +623,8 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 	/* connect fake service */
 	status = ath10k_htc_connect_service(htc, &conn_req, &conn_resp);
 	if (status) {
-		ath10k_err("could not connect to htc service (%d)\n", status);
+		ath10k_err(ar, "could not connect to htc service (%d)\n",
+			   status);
 		return status;
 	}
 
@@ -626,6 +635,7 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 			       struct ath10k_htc_svc_conn_req *conn_req,
 			       struct ath10k_htc_svc_conn_resp *conn_resp)
 {
+	struct ath10k *ar = htc->ar;
 	struct ath10k_htc_msg *msg;
 	struct ath10k_htc_conn_svc *req_msg;
 	struct ath10k_htc_conn_svc_response resp_msg_dummy;
@@ -651,13 +661,13 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 	tx_alloc = ath10k_htc_get_credit_allocation(htc,
 						    conn_req->service_id);
 	if (!tx_alloc)
-		ath10k_dbg(ATH10K_DBG_BOOT,
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
 			   "boot htc service %s does not allocate target credits\n",
 			   htc_service_name(conn_req->service_id));
 
 	skb = ath10k_htc_build_tx_ctrl_skb(htc->ar);
 	if (!skb) {
-		ath10k_err("Failed to allocate HTC packet\n");
+		ath10k_err(ar, "Failed to allocate HTC packet\n");
 		return -ENOMEM;
 	}
 
@@ -695,7 +705,7 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 	if (status <= 0) {
 		if (status == 0)
 			status = -ETIMEDOUT;
-		ath10k_err("Service connect timeout: %d\n", status);
+		ath10k_err(ar, "Service connect timeout: %d\n", status);
 		return status;
 	}
 
@@ -708,11 +718,11 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 	if ((message_id != ATH10K_HTC_MSG_CONNECT_SERVICE_RESP_ID) ||
 	    (htc->control_resp_len < sizeof(msg->hdr) +
 	     sizeof(msg->connect_service_response))) {
-		ath10k_err("Invalid resp message ID 0x%x", message_id);
+		ath10k_err(ar, "Invalid resp message ID 0x%x", message_id);
 		return -EPROTO;
 	}
 
-	ath10k_dbg(ATH10K_DBG_HTC,
+	ath10k_dbg(ar, ATH10K_DBG_HTC,
 		   "HTC Service %s connect response: status: 0x%x, assigned ep: 0x%x\n",
 		   htc_service_name(service_id),
 		   resp_msg->status, resp_msg->eid);
@@ -721,7 +731,7 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 
 	/* check response status */
 	if (resp_msg->status != ATH10K_HTC_CONN_SVC_STATUS_SUCCESS) {
-		ath10k_err("HTC Service %s connect request failed: 0x%x)\n",
+		ath10k_err(ar, "HTC Service %s connect request failed: 0x%x)\n",
 			   htc_service_name(service_id),
 			   resp_msg->status);
 		return -EPROTO;
@@ -772,18 +782,18 @@ setup:
 	if (status)
 		return status;
 
-	ath10k_dbg(ATH10K_DBG_BOOT,
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
 		   "boot htc service '%s' ul pipe %d dl pipe %d eid %d ready\n",
 		   htc_service_name(ep->service_id), ep->ul_pipe_id,
 		   ep->dl_pipe_id, ep->eid);
 
-	ath10k_dbg(ATH10K_DBG_BOOT,
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
 		   "boot htc ep %d ul polled %d dl polled %d\n",
 		   ep->eid, ep->ul_is_polled, ep->dl_is_polled);
 
 	if (disable_credit_flow_ctrl && ep->tx_credit_flow_enabled) {
 		ep->tx_credit_flow_enabled = false;
-		ath10k_dbg(ATH10K_DBG_BOOT,
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
 			   "boot htc service '%s' eid %d TX flow control disabled\n",
 			   htc_service_name(ep->service_id), assigned_eid);
 	}
@@ -791,13 +801,13 @@ setup:
 	return status;
 }
 
-struct sk_buff *ath10k_htc_alloc_skb(int size)
+struct sk_buff *ath10k_htc_alloc_skb(struct ath10k *ar, int size)
 {
 	struct sk_buff *skb;
 
 	skb = dev_alloc_skb(size + sizeof(struct ath10k_htc_hdr));
 	if (!skb) {
-		ath10k_warn("could not allocate HTC tx skb\n");
+		ath10k_warn(ar, "could not allocate HTC tx skb\n");
 		return NULL;
 	}
 
@@ -805,13 +815,14 @@ struct sk_buff *ath10k_htc_alloc_skb(int size)
 
 	/* FW/HTC requires 4-byte aligned streams */
 	if (!IS_ALIGNED((unsigned long)skb->data, 4))
-		ath10k_warn("Unaligned HTC tx skb\n");
+		ath10k_warn(ar, "Unaligned HTC tx skb\n");
 
 	return skb;
 }
 
 int ath10k_htc_start(struct ath10k_htc *htc)
 {
+	struct ath10k *ar = htc->ar;
 	struct sk_buff *skb;
 	int status = 0;
 	struct ath10k_htc_msg *msg;
@@ -827,7 +838,7 @@ int ath10k_htc_start(struct ath10k_htc *htc)
 	msg->hdr.message_id =
 		__cpu_to_le16(ATH10K_HTC_MSG_SETUP_COMPLETE_EX_ID);
 
-	ath10k_dbg(ATH10K_DBG_HTC, "HTC is using TX credit flow control\n");
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "HTC is using TX credit flow control\n");
 
 	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
 	if (status) {
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index b5a9daa..bf532f6 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -355,6 +355,6 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 			       struct ath10k_htc_svc_conn_resp *conn_resp);
 int ath10k_htc_send(struct ath10k_htc *htc, enum ath10k_htc_ep_id eid,
 		    struct sk_buff *packet);
-struct sk_buff *ath10k_htc_alloc_skb(int size);
+struct sk_buff *ath10k_htc_alloc_skb(struct ath10k *ar, int size);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 19c12cc..87daae1 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -74,12 +74,14 @@ int ath10k_htt_init(struct ath10k *ar)
 
 static int ath10k_htt_verify_version(struct ath10k_htt *htt)
 {
-	ath10k_dbg(ATH10K_DBG_BOOT, "htt target version %d.%d\n",
+	struct ath10k *ar = htt->ar;
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "htt target version %d.%d\n",
 		   htt->target_version_major, htt->target_version_minor);
 
 	if (htt->target_version_major != 2 &&
 	    htt->target_version_major != 3) {
-		ath10k_err("unsupported htt major version %d. supported versions are 2 and 3\n",
+		ath10k_err(ar, "unsupported htt major version %d. supported versions are 2 and 3\n",
 			   htt->target_version_major);
 		return -ENOTSUPP;
 	}
@@ -89,6 +91,7 @@ static int ath10k_htt_verify_version(struct ath10k_htt *htt)
 
 int ath10k_htt_setup(struct ath10k_htt *htt)
 {
+	struct ath10k *ar = htt->ar;
 	int status;
 
 	init_completion(&htt->target_version_received);
@@ -100,7 +103,7 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
 	status = wait_for_completion_timeout(&htt->target_version_received,
 						HTT_TARGET_VERSION_TIMEOUT_HZ);
 	if (status <= 0) {
-		ath10k_warn("htt version request timed out\n");
+		ath10k_warn(ar, "htt version request timed out\n");
 		return -ETIMEDOUT;
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 763d6a2..30927b1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -271,13 +271,14 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
 
 static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 {
+	struct ath10k *ar = htt->ar;
 	int idx;
 	struct sk_buff *msdu;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
 	if (htt->rx_ring.fill_cnt == 0) {
-		ath10k_warn("tried to pop sk_buff from an empty rx ring\n");
+		ath10k_warn(ar, "tried to pop sk_buff from an empty rx ring\n");
 		return NULL;
 	}
 
@@ -311,6 +312,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 				   struct sk_buff **tail_msdu,
 				   u32 *attention)
 {
+	struct ath10k *ar = htt->ar;
 	int msdu_len, msdu_chaining = 0;
 	struct sk_buff *msdu;
 	struct htt_rx_desc *rx_desc;
@@ -318,7 +320,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 	lockdep_assert_held(&htt->rx_ring.lock);
 
 	if (htt->rx_confused) {
-		ath10k_warn("htt is confused. refusing rx\n");
+		ath10k_warn(ar, "htt is confused. refusing rx\n");
 		return -1;
 	}
 
@@ -331,7 +333,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 				 msdu->len + skb_tailroom(msdu),
 				 DMA_FROM_DEVICE);
 
-		ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx pop: ",
+		ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx pop: ",
 				msdu->data, msdu->len + skb_tailroom(msdu));
 
 		rx_desc = (struct htt_rx_desc *)msdu->data;
@@ -354,7 +356,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 			ath10k_htt_rx_free_msdu_chain(*head_msdu);
 			*head_msdu = NULL;
 			msdu = NULL;
-			ath10k_err("htt rx stopped. cannot recover\n");
+			ath10k_err(ar, "htt rx stopped. cannot recover\n");
 			htt->rx_confused = true;
 			break;
 		}
@@ -429,7 +431,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 					 next->len + skb_tailroom(next),
 					 DMA_FROM_DEVICE);
 
-			ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL,
+			ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL,
 					"htt rx chained: ", next->data,
 					next->len + skb_tailroom(next));
 
@@ -483,13 +485,14 @@ static void ath10k_htt_rx_replenish_task(unsigned long ptr)
 
 int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 {
+	struct ath10k *ar = htt->ar;
 	dma_addr_t paddr;
 	void *vaddr;
 	struct timer_list *timer = &htt->rx_ring.refill_retry_timer;
 
 	htt->rx_ring.size = ath10k_htt_rx_ring_size(htt);
 	if (!is_power_of_2(htt->rx_ring.size)) {
-		ath10k_warn("htt rx ring size is not power of 2\n");
+		ath10k_warn(ar, "htt rx ring size is not power of 2\n");
 		return -EINVAL;
 	}
 
@@ -550,7 +553,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	tasklet_init(&htt->txrx_compl_task, ath10k_htt_txrx_compl_task,
 		     (unsigned long)htt);
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "htt rx ring size %d fill_level %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "htt rx ring size %d fill_level %d\n",
 		   htt->rx_ring.size, htt->rx_ring.fill_level);
 	return 0;
 
@@ -572,7 +575,8 @@ err_netbuf:
 	return -ENOMEM;
 }
 
-static int ath10k_htt_rx_crypto_param_len(enum htt_rx_mpdu_encrypt_type type)
+static int ath10k_htt_rx_crypto_param_len(struct ath10k *ar,
+					  enum htt_rx_mpdu_encrypt_type type)
 {
 	switch (type) {
 	case HTT_RX_MPDU_ENCRYPT_WEP40:
@@ -588,11 +592,12 @@ static int ath10k_htt_rx_crypto_param_len(enum htt_rx_mpdu_encrypt_type type)
 		return 0;
 	}
 
-	ath10k_warn("unknown encryption type %d\n", type);
+	ath10k_warn(ar, "unknown encryption type %d\n", type);
 	return 0;
 }
 
-static int ath10k_htt_rx_crypto_tail_len(enum htt_rx_mpdu_encrypt_type type)
+static int ath10k_htt_rx_crypto_tail_len(struct ath10k *ar,
+					 enum htt_rx_mpdu_encrypt_type type)
 {
 	switch (type) {
 	case HTT_RX_MPDU_ENCRYPT_NONE:
@@ -608,7 +613,7 @@ static int ath10k_htt_rx_crypto_tail_len(enum htt_rx_mpdu_encrypt_type type)
 		return 8;
 	}
 
-	ath10k_warn("unknown encryption type %d\n", type);
+	ath10k_warn(ar, "unknown encryption type %d\n", type);
 	return 0;
 }
 
@@ -859,7 +864,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 	status = IEEE80211_SKB_RXCB(skb);
 	*status = *rx_status;
 
-	ath10k_dbg(ATH10K_DBG_DATA,
+	ath10k_dbg(ar, ATH10K_DBG_DATA,
 		   "rx skb %p len %u peer %pM %s %s sn %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
 		   skb,
 		   skb->len,
@@ -881,7 +886,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 		   !!(status->flag & RX_FLAG_FAILED_FCS_CRC),
 		   !!(status->flag & RX_FLAG_MMIC_ERROR),
 		   !!(status->flag & RX_FLAG_AMSDU_MORE));
-	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
+	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
 			skb->data, skb->len);
 
 	ieee80211_rx(ar->hw, skb);
@@ -897,6 +902,7 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 				struct ieee80211_rx_status *rx_status,
 				struct sk_buff *skb_in)
 {
+	struct ath10k *ar = htt->ar;
 	struct htt_rx_desc *rxd;
 	struct sk_buff *skb = skb_in;
 	struct sk_buff *first;
@@ -930,8 +936,8 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 		/* First frame in an A-MSDU chain has more decapped data. */
 		if (skb == first) {
 			len = round_up(ieee80211_hdrlen(hdr->frame_control), 4);
-			len += round_up(ath10k_htt_rx_crypto_param_len(enctype),
-					4);
+			len += round_up(ath10k_htt_rx_crypto_param_len(ar,
+						enctype), 4);
 			decap_hdr += len;
 		}
 
@@ -1006,6 +1012,7 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt,
 			       struct ieee80211_rx_status *rx_status,
 			       struct sk_buff *skb)
 {
+	struct ath10k *ar = htt->ar;
 	struct htt_rx_desc *rxd;
 	struct ieee80211_hdr *hdr;
 	enum rx_msdu_decap_format fmt;
@@ -1015,7 +1022,7 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt,
 
 	/* This shouldn't happen. If it does than it may be a FW bug. */
 	if (skb->next) {
-		ath10k_warn("htt rx received chained non A-MSDU frame\n");
+		ath10k_warn(ar, "htt rx received chained non A-MSDU frame\n");
 		ath10k_htt_rx_free_msdu_chain(skb->next);
 		skb->next = NULL;
 	}
@@ -1052,7 +1059,8 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt,
 
 		rfc1042 = hdr;
 		rfc1042 += roundup(hdr_len, 4);
-		rfc1042 += roundup(ath10k_htt_rx_crypto_param_len(enctype), 4);
+		rfc1042 += roundup(ath10k_htt_rx_crypto_param_len(ar,
+					enctype), 4);
 
 		skb_pull(skb, sizeof(struct ethhdr));
 		memcpy(skb_push(skb, sizeof(struct rfc1042_hdr)),
@@ -1161,27 +1169,29 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 					bool channel_set,
 					u32 attention)
 {
+	struct ath10k *ar = htt->ar;
+
 	if (head->len == 0) {
-		ath10k_dbg(ATH10K_DBG_HTT,
+		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "htt rx dropping due to zero-len\n");
 		return false;
 	}
 
 	if (attention & RX_ATTENTION_FLAGS_DECRYPT_ERR) {
-		ath10k_dbg(ATH10K_DBG_HTT,
+		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "htt rx dropping due to decrypt-err\n");
 		return false;
 	}
 
 	if (!channel_set) {
-		ath10k_warn("no channel configured; ignoring frame!\n");
+		ath10k_warn(ar, "no channel configured; ignoring frame!\n");
 		return false;
 	}
 
 	/* Skip mgmt frames while we handle this in WMI */
 	if (status == HTT_RX_IND_MPDU_STATUS_MGMT_CTRL ||
 	    attention & RX_ATTENTION_FLAGS_MGMT_TYPE) {
-		ath10k_dbg(ATH10K_DBG_HTT, "htt rx mgmt ctrl\n");
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx mgmt ctrl\n");
 		return false;
 	}
 
@@ -1189,14 +1199,14 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 	    status != HTT_RX_IND_MPDU_STATUS_TKIP_MIC_ERR &&
 	    status != HTT_RX_IND_MPDU_STATUS_ERR_INV_PEER &&
 	    !htt->ar->monitor_started) {
-		ath10k_dbg(ATH10K_DBG_HTT,
+		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "htt rx ignoring frame w/ status %d\n",
 			   status);
 		return false;
 	}
 
 	if (test_bit(ATH10K_CAC_RUNNING, &htt->ar->dev_flags)) {
-		ath10k_dbg(ATH10K_DBG_HTT,
+		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "htt rx CAC running\n");
 		return false;
 	}
@@ -1207,6 +1217,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				  struct htt_rx_indication *rx)
 {
+	struct ath10k *ar = htt->ar;
 	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
 	struct htt_rx_desc *rxd;
@@ -1252,7 +1263,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				      rx_status);
 	}
 
-	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx ind: ",
+	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx ind: ",
 			rx, sizeof(*rx) +
 			(sizeof(struct htt_rx_indication_mpdu_range) *
 				num_mpdu_ranges));
@@ -1274,7 +1285,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 						      &attention);
 
 			if (ret < 0) {
-				ath10k_warn("failed to pop amsdu from htt rx ring %d\n",
+				ath10k_warn(ar, "failed to pop amsdu from htt rx ring %d\n",
 					    ret);
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
@@ -1323,6 +1334,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 				struct htt_rx_fragment_indication *frag)
 {
+	struct ath10k *ar = htt->ar;
 	struct sk_buff *msdu_head, *msdu_tail;
 	enum htt_rx_mpdu_encrypt_type enctype;
 	struct htt_rx_desc *rxd;
@@ -1349,10 +1361,10 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 				      &attention);
 	spin_unlock_bh(&htt->rx_ring.lock);
 
-	ath10k_dbg(ATH10K_DBG_HTT_DUMP, "htt rx frag ahead\n");
+	ath10k_dbg(ar, ATH10K_DBG_HTT_DUMP, "htt rx frag ahead\n");
 
 	if (ret) {
-		ath10k_warn("failed to pop amsdu from httr rx ring for fragmented rx %d\n",
+		ath10k_warn(ar, "failed to pop amsdu from httr rx ring for fragmented rx %d\n",
 			    ret);
 		ath10k_htt_rx_free_msdu_chain(msdu_head);
 		return;
@@ -1369,7 +1381,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 			RX_MSDU_START_INFO1_DECAP_FORMAT);
 
 	if (fmt != RX_MSDU_DECAP_RAW) {
-		ath10k_warn("we dont support non-raw fragmented rx yet\n");
+		ath10k_warn(ar, "we dont support non-raw fragmented rx yet\n");
 		dev_kfree_skb_any(msdu_head);
 		goto end;
 	}
@@ -1381,17 +1393,17 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	msdu_head->ip_summed = ath10k_htt_rx_get_csum_state(msdu_head);
 
 	if (tkip_mic_err)
-		ath10k_warn("tkip mic error\n");
+		ath10k_warn(ar, "tkip mic error\n");
 
 	if (decrypt_err) {
-		ath10k_warn("decryption err in fragmented rx\n");
+		ath10k_warn(ar, "decryption err in fragmented rx\n");
 		dev_kfree_skb_any(msdu_head);
 		goto end;
 	}
 
 	if (enctype != HTT_RX_MPDU_ENCRYPT_NONE) {
 		hdrlen = ieee80211_hdrlen(hdr->frame_control);
-		paramlen = ath10k_htt_rx_crypto_param_len(enctype);
+		paramlen = ath10k_htt_rx_crypto_param_len(ar, enctype);
 
 		/* It is more efficient to move the header than the payload */
 		memmove((void *)msdu_head->data + paramlen,
@@ -1405,7 +1417,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	trim  = 4;
 
 	/* remove crypto trailer */
-	trim += ath10k_htt_rx_crypto_tail_len(enctype);
+	trim += ath10k_htt_rx_crypto_tail_len(ar, enctype);
 
 	/* last fragment of TKIP frags has MIC */
 	if (!ieee80211_has_morefrags(hdr->frame_control) &&
@@ -1413,20 +1425,20 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		trim += 8;
 
 	if (trim > msdu_head->len) {
-		ath10k_warn("htt rx fragment: trailer longer than the frame itself? drop\n");
+		ath10k_warn(ar, "htt rx fragment: trailer longer than the frame itself? drop\n");
 		dev_kfree_skb_any(msdu_head);
 		goto end;
 	}
 
 	skb_trim(msdu_head, msdu_head->len - trim);
 
-	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt rx frag mpdu: ",
+	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx frag mpdu: ",
 			msdu_head->data, msdu_head->len);
 	ath10k_process_rx(htt->ar, rx_status, msdu_head);
 
 end:
 	if (fw_desc_len > 0) {
-		ath10k_dbg(ATH10K_DBG_HTT,
+		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "expecting more fragmented rx in one indication %d\n",
 			   fw_desc_len);
 	}
@@ -1456,12 +1468,12 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
 		tx_done.discard = true;
 		break;
 	default:
-		ath10k_warn("unhandled tx completion status %d\n", status);
+		ath10k_warn(ar, "unhandled tx completion status %d\n", status);
 		tx_done.discard = true;
 		break;
 	}
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt tx completion num_msdus %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx completion num_msdus %d\n",
 		   resp->data_tx_completion.num_msdus);
 
 	for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
@@ -1482,14 +1494,14 @@ static void ath10k_htt_rx_addba(struct ath10k *ar, struct htt_resp *resp)
 	tid = MS(info0, HTT_RX_BA_INFO0_TID);
 	peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
 
-	ath10k_dbg(ATH10K_DBG_HTT,
+	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt rx addba tid %hu peer_id %hu size %hhu\n",
 		   tid, peer_id, ev->window_size);
 
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, peer_id);
 	if (!peer) {
-		ath10k_warn("received addba event for invalid peer_id: %hu\n",
+		ath10k_warn(ar, "received addba event for invalid peer_id: %hu\n",
 			    peer_id);
 		spin_unlock_bh(&ar->data_lock);
 		return;
@@ -1497,13 +1509,13 @@ static void ath10k_htt_rx_addba(struct ath10k *ar, struct htt_resp *resp)
 
 	arvif = ath10k_get_arvif(ar, peer->vdev_id);
 	if (!arvif) {
-		ath10k_warn("received addba event for invalid vdev_id: %u\n",
+		ath10k_warn(ar, "received addba event for invalid vdev_id: %u\n",
 			    peer->vdev_id);
 		spin_unlock_bh(&ar->data_lock);
 		return;
 	}
 
-	ath10k_dbg(ATH10K_DBG_HTT,
+	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt rx start rx ba session sta %pM tid %hu size %hhu\n",
 		   peer->addr, tid, ev->window_size);
 
@@ -1522,14 +1534,14 @@ static void ath10k_htt_rx_delba(struct ath10k *ar, struct htt_resp *resp)
 	tid = MS(info0, HTT_RX_BA_INFO0_TID);
 	peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
 
-	ath10k_dbg(ATH10K_DBG_HTT,
+	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt rx delba tid %hu peer_id %hu\n",
 		   tid, peer_id);
 
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, peer_id);
 	if (!peer) {
-		ath10k_warn("received addba event for invalid peer_id: %hu\n",
+		ath10k_warn(ar, "received addba event for invalid peer_id: %hu\n",
 			    peer_id);
 		spin_unlock_bh(&ar->data_lock);
 		return;
@@ -1537,13 +1549,13 @@ static void ath10k_htt_rx_delba(struct ath10k *ar, struct htt_resp *resp)
 
 	arvif = ath10k_get_arvif(ar, peer->vdev_id);
 	if (!arvif) {
-		ath10k_warn("received addba event for invalid vdev_id: %u\n",
+		ath10k_warn(ar, "received addba event for invalid vdev_id: %u\n",
 			    peer->vdev_id);
 		spin_unlock_bh(&ar->data_lock);
 		return;
 	}
 
-	ath10k_dbg(ATH10K_DBG_HTT,
+	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt rx stop rx ba session sta %pM tid %hu\n",
 		   peer->addr, tid);
 
@@ -1558,9 +1570,9 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 
 	/* confirm alignment */
 	if (!IS_ALIGNED((unsigned long)skb->data, 4))
-		ath10k_warn("unaligned htt message, expect trouble\n");
+		ath10k_warn(ar, "unaligned htt message, expect trouble\n");
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt rx, msg_type: 0x%0X\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx, msg_type: 0x%0X\n",
 		   resp->hdr.msg_type);
 	switch (resp->hdr.msg_type) {
 	case HTT_T2H_MSG_TYPE_VERSION_CONF: {
@@ -1624,7 +1636,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		struct ath10k *ar = htt->ar;
 		struct htt_security_indication *ev = &resp->security_indication;
 
-		ath10k_dbg(ATH10K_DBG_HTT,
+		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "sec ind peer_id %d unicast %d type %d\n",
 			  __le16_to_cpu(ev->peer_id),
 			  !!(ev->flags & HTT_SECURITY_IS_UNICAST),
@@ -1633,7 +1645,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_RX_FRAG_IND: {
-		ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt event: ",
+		ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt event: ",
 				skb->data, skb->len);
 		ath10k_htt_rx_frag_handler(htt, &resp->rx_frag_ind);
 		break;
@@ -1650,7 +1662,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		 * sends all tx frames as already inspected so this shouldn't
 		 * happen unless fw has a bug.
 		 */
-		ath10k_warn("received an unexpected htt tx inspect event\n");
+		ath10k_warn(ar, "received an unexpected htt tx inspect event\n");
 		break;
 	case HTT_T2H_MSG_TYPE_RX_ADDBA:
 		ath10k_htt_rx_addba(ar, resp);
@@ -1665,9 +1677,9 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	default:
-		ath10k_dbg(ATH10K_DBG_HTT, "htt event (%d) not handled\n",
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt event (%d) not handled\n",
 			   resp->hdr.msg_type);
-		ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt event: ",
+		ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt event: ",
 				skb->data, skb->len);
 		break;
 	};
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 8b27bfc..eaa73aa 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -58,6 +58,7 @@ exit:
 
 int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt)
 {
+	struct ath10k *ar = htt->ar;
 	int msdu_id;
 
 	lockdep_assert_held(&htt->tx_lock);
@@ -67,24 +68,29 @@ int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt)
 	if (msdu_id == htt->max_num_pending_tx)
 		return -ENOBUFS;
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt tx alloc msdu_id %d\n", msdu_id);
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx alloc msdu_id %d\n", msdu_id);
 	__set_bit(msdu_id, htt->used_msdu_ids);
 	return msdu_id;
 }
 
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
 {
+	struct ath10k *ar = htt->ar;
+
 	lockdep_assert_held(&htt->tx_lock);
 
 	if (!test_bit(msdu_id, htt->used_msdu_ids))
-		ath10k_warn("trying to free unallocated msdu_id %d\n", msdu_id);
+		ath10k_warn(ar, "trying to free unallocated msdu_id %d\n",
+			    msdu_id);
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt tx free msdu_id %hu\n", msdu_id);
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx free msdu_id %hu\n", msdu_id);
 	__clear_bit(msdu_id, htt->used_msdu_ids);
 }
 
 int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 {
+	struct ath10k *ar = htt->ar;
+
 	spin_lock_init(&htt->tx_lock);
 	init_waitqueue_head(&htt->empty_tx_wq);
 
@@ -93,7 +99,7 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 	else
 		htt->max_num_pending_tx = TARGET_NUM_MSDU_DESC;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
 		   htt->max_num_pending_tx);
 
 	htt->pending_tx = kzalloc(sizeof(*htt->pending_tx) *
@@ -122,6 +128,7 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 
 static void ath10k_htt_tx_free_pending(struct ath10k_htt *htt)
 {
+	struct ath10k *ar = htt->ar;
 	struct htt_tx_done tx_done = {0};
 	int msdu_id;
 
@@ -130,7 +137,7 @@ static void ath10k_htt_tx_free_pending(struct ath10k_htt *htt)
 		if (!test_bit(msdu_id, htt->used_msdu_ids))
 			continue;
 
-		ath10k_dbg(ATH10K_DBG_HTT, "force cleanup msdu_id %hu\n",
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "force cleanup msdu_id %hu\n",
 			   msdu_id);
 
 		tx_done.discard = 1;
@@ -157,6 +164,7 @@ void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 {
+	struct ath10k *ar = htt->ar;
 	struct sk_buff *skb;
 	struct htt_cmd *cmd;
 	int len = 0;
@@ -165,7 +173,7 @@ int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 	len += sizeof(cmd->hdr);
 	len += sizeof(cmd->ver_req);
 
-	skb = ath10k_htc_alloc_skb(len);
+	skb = ath10k_htc_alloc_skb(ar, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -184,6 +192,7 @@ int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 
 int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie)
 {
+	struct ath10k *ar = htt->ar;
 	struct htt_stats_req *req;
 	struct sk_buff *skb;
 	struct htt_cmd *cmd;
@@ -192,7 +201,7 @@ int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie)
 	len += sizeof(cmd->hdr);
 	len += sizeof(cmd->stats_req);
 
-	skb = ath10k_htc_alloc_skb(len);
+	skb = ath10k_htc_alloc_skb(ar, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -214,7 +223,8 @@ int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie)
 
 	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
 	if (ret) {
-		ath10k_warn("failed to send htt type stats request: %d", ret);
+		ath10k_warn(ar, "failed to send htt type stats request: %d",
+			    ret);
 		dev_kfree_skb_any(skb);
 		return ret;
 	}
@@ -224,6 +234,7 @@ int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie)
 
 int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
 {
+	struct ath10k *ar = htt->ar;
 	struct sk_buff *skb;
 	struct htt_cmd *cmd;
 	struct htt_rx_ring_setup_ring *ring;
@@ -242,7 +253,7 @@ int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
 
 	len = sizeof(cmd->hdr) + sizeof(cmd->rx_setup.hdr)
 	    + (sizeof(*ring) * num_rx_ring);
-	skb = ath10k_htc_alloc_skb(len);
+	skb = ath10k_htc_alloc_skb(ar, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -311,6 +322,7 @@ int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_ampdu,
 				u8 max_subfrms_amsdu)
 {
+	struct ath10k *ar = htt->ar;
 	struct htt_aggr_conf *aggr_conf;
 	struct sk_buff *skb;
 	struct htt_cmd *cmd;
@@ -328,7 +340,7 @@ int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 	len = sizeof(cmd->hdr);
 	len += sizeof(cmd->aggr_conf);
 
-	skb = ath10k_htc_alloc_skb(len);
+	skb = ath10k_htc_alloc_skb(ar, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -340,7 +352,7 @@ int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 	aggr_conf->max_num_ampdu_subframes = max_subfrms_ampdu;
 	aggr_conf->max_num_amsdu_subframes = max_subfrms_amsdu;
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt h2t aggr cfg msg amsdu %d ampdu %d",
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt h2t aggr cfg msg amsdu %d ampdu %d",
 		   aggr_conf->max_num_amsdu_subframes,
 		   aggr_conf->max_num_ampdu_subframes);
 
@@ -355,7 +367,8 @@ int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 {
-	struct device *dev = htt->ar->dev;
+	struct ath10k *ar = htt->ar;
+	struct device *dev = ar->dev;
 	struct sk_buff *txdesc = NULL;
 	struct htt_cmd *cmd;
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
@@ -382,7 +395,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	htt->pending_tx[msdu_id] = msdu;
 	spin_unlock_bh(&htt->tx_lock);
 
-	txdesc = ath10k_htc_alloc_skb(len);
+	txdesc = ath10k_htc_alloc_skb(ar, len);
 	if (!txdesc) {
 		res = -ENOMEM;
 		goto err_free_msdu_id;
@@ -429,7 +442,8 @@ err:
 
 int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 {
-	struct device *dev = htt->ar->dev;
+	struct ath10k *ar = htt->ar;
+	struct device *dev = ar->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
 	struct ath10k_hif_sg_item sg_items[2];
@@ -545,11 +559,11 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	skb_cb->htt.txbuf->cmd_tx.frags_paddr = __cpu_to_le32(frags_paddr);
 	skb_cb->htt.txbuf->cmd_tx.peerid = __cpu_to_le32(HTT_INVALID_PEERID);
 
-	ath10k_dbg(ATH10K_DBG_HTT,
+	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx flags0 %hhu flags1 %hu len %d id %hu frags_paddr %08x, msdu_paddr %08x vdev %hhu tid %hhu\n",
 		   flags0, flags1, msdu->len, msdu_id, frags_paddr,
 		   (u32)skb_cb->paddr, vdev_id, tid);
-	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
+	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
 			msdu->data, msdu->len);
 
 	sg_items[0].transfer_id = 0;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e568882..b858c82 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -36,6 +36,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 			   enum set_key_cmd cmd,
 			   const u8 *macaddr)
 {
+	struct ath10k *ar = arvif->ar;
 	struct wmi_vdev_install_key_arg arg = {
 		.vdev_id = arvif->vdev_id,
 		.key_idx = key->keyidx,
@@ -73,7 +74,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 			arg.key_flags = WMI_KEY_PAIRWISE;
 		break;
 	default:
-		ath10k_warn("cipher %d is not supported\n", key->cipher);
+		ath10k_warn(ar, "cipher %d is not supported\n", key->cipher);
 		return -EOPNOTSUPP;
 	}
 
@@ -168,7 +169,7 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
 			first_errno = ret;
 
 		if (ret)
-			ath10k_warn("failed to remove peer wep key %d: %d\n",
+			ath10k_warn(ar, "failed to remove peer wep key %d: %d\n",
 				    i, ret);
 
 		peer->keys[i] = NULL;
@@ -216,7 +217,7 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 			first_errno = ret;
 
 		if (ret)
-			ath10k_warn("failed to remove key for %pM: %d\n",
+			ath10k_warn(ar, "failed to remove key for %pM: %d\n",
 				    addr, ret);
 	}
 
@@ -327,14 +328,14 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 
 	ret = ath10k_wmi_peer_create(ar, vdev_id, addr);
 	if (ret) {
-		ath10k_warn("failed to create wmi peer %pM on vdev %i: %i\n",
+		ath10k_warn(ar, "failed to create wmi peer %pM on vdev %i: %i\n",
 			    addr, vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_wait_for_peer_created(ar, vdev_id, addr);
 	if (ret) {
-		ath10k_warn("failed to wait for created wmi peer %pM on vdev %i: %i\n",
+		ath10k_warn(ar, "failed to wait for created wmi peer %pM on vdev %i: %i\n",
 			    addr, vdev_id, ret);
 		return ret;
 	}
@@ -355,7 +356,7 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_pdev_set_param(ar, param,
 					ATH10K_KICKOUT_THRESHOLD);
 	if (ret) {
-		ath10k_warn("failed to set kickout threshold on vdev %i: %d\n",
+		ath10k_warn(ar, "failed to set kickout threshold on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -364,7 +365,7 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MIN_IDLE);
 	if (ret) {
-		ath10k_warn("failed to set keepalive minimum idle time on vdev %i: %d\n",
+		ath10k_warn(ar, "failed to set keepalive minimum idle time on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -373,7 +374,7 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MAX_IDLE);
 	if (ret) {
-		ath10k_warn("failed to set keepalive maximum idle time on vdev %i: %d\n",
+		ath10k_warn(ar, "failed to set keepalive maximum idle time on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -382,7 +383,7 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MAX_UNRESPONSIVE);
 	if (ret) {
-		ath10k_warn("failed to set keepalive maximum unresponsive time on vdev %i: %d\n",
+		ath10k_warn(ar, "failed to set keepalive maximum unresponsive time on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -449,7 +450,7 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 		if (peer->vdev_id != vdev_id)
 			continue;
 
-		ath10k_warn("removing stale peer %pM from vdev_id %d\n",
+		ath10k_warn(ar, "removing stale peer %pM from vdev_id %d\n",
 			    peer->addr, vdev_id);
 
 		list_del(&peer->list);
@@ -496,7 +497,7 @@ static bool ath10k_monitor_is_enabled(struct ath10k *ar)
 {
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ath10k_dbg(ATH10K_DBG_MAC,
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
 		   "mac monitor refs: promisc %d monitor %d cac %d\n",
 		   ar->promisc, ar->monitor,
 		   test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags));
@@ -531,35 +532,35 @@ static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
-		ath10k_warn("failed to request monitor vdev %i start: %d\n",
+		ath10k_warn(ar, "failed to request monitor vdev %i start: %d\n",
 			    vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("failed to synchronize setup for monitor vdev %i: %d\n",
+		ath10k_warn(ar, "failed to synchronize setup for monitor vdev %i: %d\n",
 			    vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_wmi_vdev_up(ar, vdev_id, 0, ar->mac_addr);
 	if (ret) {
-		ath10k_warn("failed to put up monitor vdev %i: %d\n",
+		ath10k_warn(ar, "failed to put up monitor vdev %i: %d\n",
 			    vdev_id, ret);
 		goto vdev_stop;
 	}
 
 	ar->monitor_vdev_id = vdev_id;
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %i started\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor vdev %i started\n",
 		   ar->monitor_vdev_id);
 	return 0;
 
 vdev_stop:
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("failed to stop monitor vdev %i after start failure: %d\n",
+		ath10k_warn(ar, "failed to stop monitor vdev %i after start failure: %d\n",
 			    ar->monitor_vdev_id, ret);
 
 	return ret;
@@ -573,20 +574,20 @@ static int ath10k_monitor_vdev_stop(struct ath10k *ar)
 
 	ret = ath10k_wmi_vdev_down(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("failed to put down monitor vdev %i: %d\n",
+		ath10k_warn(ar, "failed to put down monitor vdev %i: %d\n",
 			    ar->monitor_vdev_id, ret);
 
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("failed to to request monitor vdev %i stop: %d\n",
+		ath10k_warn(ar, "failed to to request monitor vdev %i stop: %d\n",
 			    ar->monitor_vdev_id, ret);
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret)
-		ath10k_warn("failed to synchronise monitor vdev %i: %d\n",
+		ath10k_warn(ar, "failed to synchronise monitor vdev %i: %d\n",
 			    ar->monitor_vdev_id, ret);
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %i stopped\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor vdev %i stopped\n",
 		   ar->monitor_vdev_id);
 	return ret;
 }
@@ -598,7 +599,7 @@ static int ath10k_monitor_vdev_create(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (ar->free_vdev_map == 0) {
-		ath10k_warn("failed to find free vdev id for monitor vdev\n");
+		ath10k_warn(ar, "failed to find free vdev id for monitor vdev\n");
 		return -ENOMEM;
 	}
 
@@ -610,13 +611,13 @@ static int ath10k_monitor_vdev_create(struct ath10k *ar)
 				     WMI_VDEV_TYPE_MONITOR,
 				     0, ar->mac_addr);
 	if (ret) {
-		ath10k_warn("failed to request monitor vdev %i creation: %d\n",
+		ath10k_warn(ar, "failed to request monitor vdev %i creation: %d\n",
 			    ar->monitor_vdev_id, ret);
 		return ret;
 	}
 
 	ar->free_vdev_map &= ~(1 << ar->monitor_vdev_id);
-	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d created\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor vdev %d created\n",
 		   ar->monitor_vdev_id);
 
 	return 0;
@@ -630,14 +631,14 @@ static int ath10k_monitor_vdev_delete(struct ath10k *ar)
 
 	ret = ath10k_wmi_vdev_delete(ar, ar->monitor_vdev_id);
 	if (ret) {
-		ath10k_warn("failed to request wmi monitor vdev %i removal: %d\n",
+		ath10k_warn(ar, "failed to request wmi monitor vdev %i removal: %d\n",
 			    ar->monitor_vdev_id, ret);
 		return ret;
 	}
 
 	ar->free_vdev_map |= 1 << ar->monitor_vdev_id;
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d deleted\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor vdev %d deleted\n",
 		   ar->monitor_vdev_id);
 	return ret;
 }
@@ -649,30 +650,30 @@ static int ath10k_monitor_start(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (!ath10k_monitor_is_enabled(ar)) {
-		ath10k_warn("trying to start monitor with no references\n");
+		ath10k_warn(ar, "trying to start monitor with no references\n");
 		return 0;
 	}
 
 	if (ar->monitor_started) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor already started\n");
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor already started\n");
 		return 0;
 	}
 
 	ret = ath10k_monitor_vdev_create(ar);
 	if (ret) {
-		ath10k_warn("failed to create monitor vdev: %d\n", ret);
+		ath10k_warn(ar, "failed to create monitor vdev: %d\n", ret);
 		return ret;
 	}
 
 	ret = ath10k_monitor_vdev_start(ar, ar->monitor_vdev_id);
 	if (ret) {
-		ath10k_warn("failed to start monitor vdev: %d\n", ret);
+		ath10k_warn(ar, "failed to start monitor vdev: %d\n", ret);
 		ath10k_monitor_vdev_delete(ar);
 		return ret;
 	}
 
 	ar->monitor_started = true;
-	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor started\n");
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor started\n");
 
 	return 0;
 }
@@ -684,27 +685,27 @@ static void ath10k_monitor_stop(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (ath10k_monitor_is_enabled(ar)) {
-		ath10k_dbg(ATH10K_DBG_MAC,
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac monitor will be stopped later\n");
 		return;
 	}
 
 	if (!ar->monitor_started) {
-		ath10k_dbg(ATH10K_DBG_MAC,
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac monitor probably failed to start earlier\n");
 		return;
 	}
 
 	ret = ath10k_monitor_vdev_stop(ar);
 	if (ret)
-		ath10k_warn("failed to stop monitor vdev: %d\n", ret);
+		ath10k_warn(ar, "failed to stop monitor vdev: %d\n", ret);
 
 	ret = ath10k_monitor_vdev_delete(ar);
 	if (ret)
-		ath10k_warn("failed to delete monitor vdev: %d\n", ret);
+		ath10k_warn(ar, "failed to delete monitor vdev: %d\n", ret);
 
 	ar->monitor_started = false;
-	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor stopped\n");
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor stopped\n");
 }
 
 static int ath10k_recalc_rtscts_prot(struct ath10k_vif *arvif)
@@ -737,12 +738,12 @@ static int ath10k_start_cac(struct ath10k *ar)
 
 	ret = ath10k_monitor_start(ar);
 	if (ret) {
-		ath10k_warn("failed to start monitor (cac): %d\n", ret);
+		ath10k_warn(ar, "failed to start monitor (cac): %d\n", ret);
 		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 		return ret;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac cac start monitor vdev %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac cac start monitor vdev %d\n",
 		   ar->monitor_vdev_id);
 
 	return 0;
@@ -759,7 +760,7 @@ static int ath10k_stop_cac(struct ath10k *ar)
 	clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 	ath10k_monitor_stop(ar);
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac cac finished\n");
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac cac finished\n");
 
 	return 0;
 }
@@ -785,7 +786,7 @@ static void ath10k_recalc_radar_detection(struct ath10k *ar)
 		 * radiation is not allowed, make this channel DFS_UNAVAILABLE
 		 * by indicating that radar was detected.
 		 */
-		ath10k_warn("failed to start CAC: %d\n", ret);
+		ath10k_warn(ar, "failed to start CAC: %d\n", ret);
 		ieee80211_radar_detected(ar->hw);
 	}
 }
@@ -827,7 +828,7 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
 		arg.ssid_len = arvif->vif->bss_conf.ssid_len;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC,
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
 		   "mac vdev %d start center_freq %d phymode %s\n",
 		   arg.vdev_id, arg.channel.freq,
 		   ath10k_wmi_phymode_str(arg.channel.mode));
@@ -838,14 +839,14 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
 		ret = ath10k_wmi_vdev_start(ar, &arg);
 
 	if (ret) {
-		ath10k_warn("failed to start WMI vdev %i: %d\n",
+		ath10k_warn(ar, "failed to start WMI vdev %i: %d\n",
 			    arg.vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("failed to synchronise setup for vdev %i: %d\n",
+		ath10k_warn(ar, "failed to synchronise setup for vdev %i: %d\n",
 			    arg.vdev_id, ret);
 		return ret;
 	}
@@ -877,14 +878,14 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 
 	ret = ath10k_wmi_vdev_stop(ar, arvif->vdev_id);
 	if (ret) {
-		ath10k_warn("failed to stop WMI vdev %i: %d\n",
+		ath10k_warn(ar, "failed to stop WMI vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("failed to syncronise setup for vdev %i: %d\n",
+		ath10k_warn(ar, "failed to syncronise setup for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -902,6 +903,7 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 				struct ieee80211_bss_conf *info)
 {
+	struct ath10k *ar = arvif->ar;
 	int ret = 0;
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
@@ -939,7 +941,7 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 	ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
 				 arvif->bssid);
 	if (ret) {
-		ath10k_warn("failed to bring up vdev %d: %i\n",
+		ath10k_warn(ar, "failed to bring up vdev %d: %i\n",
 			    arvif->vdev_id, ret);
 		ath10k_vdev_stop(arvif);
 		return;
@@ -948,13 +950,14 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 	arvif->is_started = true;
 	arvif->is_up = true;
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d up\n", arvif->vdev_id);
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d up\n", arvif->vdev_id);
 }
 
 static void ath10k_control_ibss(struct ath10k_vif *arvif,
 				struct ieee80211_bss_conf *info,
 				const u8 self_peer[ETH_ALEN])
 {
+	struct ath10k *ar = arvif->ar;
 	u32 vdev_param;
 	int ret = 0;
 
@@ -963,7 +966,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 	if (!info->ibss_joined) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, self_peer);
 		if (ret)
-			ath10k_warn("failed to delete IBSS self peer %pM for vdev %d: %d\n",
+			ath10k_warn(ar, "failed to delete IBSS self peer %pM for vdev %d: %d\n",
 				    self_peer, arvif->vdev_id, ret);
 
 		if (is_zero_ether_addr(arvif->bssid))
@@ -972,7 +975,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id,
 					 arvif->bssid);
 		if (ret) {
-			ath10k_warn("failed to delete IBSS BSSID peer %pM for vdev %d: %d\n",
+			ath10k_warn(ar, "failed to delete IBSS BSSID peer %pM for vdev %d: %d\n",
 				    arvif->bssid, arvif->vdev_id, ret);
 			return;
 		}
@@ -984,7 +987,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 
 	ret = ath10k_peer_create(arvif->ar, arvif->vdev_id, self_peer);
 	if (ret) {
-		ath10k_warn("failed to create IBSS self peer %pM for vdev %d: %d\n",
+		ath10k_warn(ar, "failed to create IBSS self peer %pM for vdev %d: %d\n",
 			    self_peer, arvif->vdev_id, ret);
 		return;
 	}
@@ -993,7 +996,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 	ret = ath10k_wmi_vdev_set_param(arvif->ar, arvif->vdev_id, vdev_param,
 					ATH10K_DEFAULT_ATIM);
 	if (ret)
-		ath10k_warn("failed to set IBSS ATIM for vdev %d: %d\n",
+		ath10k_warn(ar, "failed to set IBSS ATIM for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 }
 
@@ -1020,7 +1023,7 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id, param,
 						  conf->dynamic_ps_timeout);
 		if (ret) {
-			ath10k_warn("failed to set inactivity time for vdev %d: %i\n",
+			ath10k_warn(ar, "failed to set inactivity time for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1028,12 +1031,12 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 		psmode = WMI_STA_PS_MODE_DISABLED;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d psmode %s\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d psmode %s\n",
 		   arvif->vdev_id, psmode ? "enable" : "disable");
 
 	ret = ath10k_wmi_set_psmode(ar, arvif->vdev_id, psmode);
 	if (ret) {
-		ath10k_warn("failed to set PS Mode %d for vdev %d: %d\n",
+		ath10k_warn(ar, "failed to set PS Mode %d for vdev %d: %d\n",
 			    psmode, arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1117,12 +1120,12 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 
 	/* FIXME: base on RSN IE/WPA IE is a correct idea? */
 	if (rsnie || wpaie) {
-		ath10k_dbg(ATH10K_DBG_WMI, "%s: rsn ie found\n", __func__);
+		ath10k_dbg(ar, ATH10K_DBG_WMI, "%s: rsn ie found\n", __func__);
 		arg->peer_flags |= WMI_PEER_NEED_PTK_4_WAY;
 	}
 
 	if (wpaie) {
-		ath10k_dbg(ATH10K_DBG_WMI, "%s: wpa ie found\n", __func__);
+		ath10k_dbg(ar, ATH10K_DBG_WMI, "%s: wpa ie found\n", __func__);
 		arg->peer_flags |= WMI_PEER_NEED_GTK_2_WAY;
 	}
 }
@@ -1231,7 +1234,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 		arg->peer_num_spatial_streams = sta->rx_nss;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac ht peer %pM mcs cnt %d nss %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac ht peer %pM mcs cnt %d nss %d\n",
 		   arg->addr,
 		   arg->peer_ht_rates.num_rates,
 		   arg->peer_num_spatial_streams);
@@ -1248,7 +1251,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (sta->wme && sta->uapsd_queues) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac uapsd_queues 0x%x max_sp %d\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac uapsd_queues 0x%x max_sp %d\n",
 			   sta->uapsd_queues, sta->max_sp);
 
 		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
@@ -1273,7 +1276,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 						 WMI_AP_PS_PEER_PARAM_UAPSD,
 						 uapsd);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param uapsd for vdev %i: %d\n",
+			ath10k_warn(ar, "failed to set ap ps peer param uapsd for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1283,7 +1286,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 						 WMI_AP_PS_PEER_PARAM_MAX_SP,
 						 max_sp);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param max sp for vdev %i: %d\n",
+			ath10k_warn(ar, "failed to set ap ps peer param max sp for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1295,7 +1298,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 		ret = ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id, sta->addr,
 					WMI_AP_PS_PEER_PARAM_AGEOUT_TIME, 10);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param ageout time for vdev %i: %d\n",
+			ath10k_warn(ar, "failed to set ap ps peer param ageout time for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1342,7 +1345,7 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	arg->peer_vht_rates.tx_mcs_set =
 		__le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
 		   sta->addr, arg->peer_max_mpdu, arg->peer_flags);
 }
 
@@ -1415,7 +1418,7 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 		break;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac peer %pM phymode %s\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac peer %pM phymode %s\n",
 		   sta->addr, ath10k_wmi_phymode_str(phymode));
 
 	arg->peer_phymode = phymode;
@@ -1488,7 +1491,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ap_sta = ieee80211_find_sta(vif, bss_conf->bssid);
 	if (!ap_sta) {
-		ath10k_warn("failed to find station entry for bss %pM vdev %i\n",
+		ath10k_warn(ar, "failed to find station entry for bss %pM vdev %i\n",
 			    bss_conf->bssid, arvif->vdev_id);
 		rcu_read_unlock();
 		return;
@@ -1501,7 +1504,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 	ret = ath10k_peer_assoc_prepare(ar, arvif, ap_sta,
 					bss_conf, &peer_arg);
 	if (ret) {
-		ath10k_warn("failed to prepare peer assoc for %pM vdev %i: %d\n",
+		ath10k_warn(ar, "failed to prepare peer assoc for %pM vdev %i: %d\n",
 			    bss_conf->bssid, arvif->vdev_id, ret);
 		rcu_read_unlock();
 		return;
@@ -1511,19 +1514,19 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
 	if (ret) {
-		ath10k_warn("failed to run peer assoc for %pM vdev %i: %d\n",
+		ath10k_warn(ar, "failed to run peer assoc for %pM vdev %i: %d\n",
 			    bss_conf->bssid, arvif->vdev_id, ret);
 		return;
 	}
 
 	ret = ath10k_setup_peer_smps(ar, arvif, bss_conf->bssid, &ht_cap);
 	if (ret) {
-		ath10k_warn("failed to setup peer SMPS for vdev %i: %d\n",
+		ath10k_warn(ar, "failed to setup peer SMPS for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC,
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
 		   "mac vdev %d up (associated) bssid %pM aid %d\n",
 		   arvif->vdev_id, bss_conf->bssid, bss_conf->aid);
 
@@ -1532,7 +1535,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ret = ath10k_wmi_vdev_up(ar, arvif->vdev_id, arvif->aid, arvif->bssid);
 	if (ret) {
-		ath10k_warn("failed to set vdev %d up: %d\n",
+		ath10k_warn(ar, "failed to set vdev %d up: %d\n",
 			    arvif->vdev_id, ret);
 		return;
 	}
@@ -1558,7 +1561,7 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	 * No idea why this happens, even though VDEV-DOWN is supposed
 	 * to be analogous to link down, so just stop the VDEV.
 	 */
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d stop (disassociated\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d stop (disassociated\n",
 		   arvif->vdev_id);
 
 	/* FIXME: check return value */
@@ -1571,7 +1574,7 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	 * interfaces as it expects there is no rx when no interface is
 	 * running.
 	 */
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d down\n", arvif->vdev_id);
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d down\n", arvif->vdev_id);
 
 	/* FIXME: why don't we print error if wmi call fails? */
 	ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
@@ -1592,7 +1595,7 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_peer_assoc_prepare(ar, arvif, sta, NULL, &peer_arg);
 	if (ret) {
-		ath10k_warn("failed to prepare WMI peer assoc for %pM vdev %i: %i\n",
+		ath10k_warn(ar, "failed to prepare WMI peer assoc for %pM vdev %i: %i\n",
 			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1600,14 +1603,14 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 	peer_arg.peer_reassoc = reassoc;
 	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
 	if (ret) {
-		ath10k_warn("failed to run peer assoc for STA %pM vdev %i: %d\n",
+		ath10k_warn(ar, "failed to run peer assoc for STA %pM vdev %i: %d\n",
 			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_setup_peer_smps(ar, arvif, sta->addr, &sta->ht_cap);
 	if (ret) {
-		ath10k_warn("failed to setup peer SMPS for vdev %d: %d\n",
+		ath10k_warn(ar, "failed to setup peer SMPS for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1616,7 +1619,7 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 		arvif->num_legacy_stations++;
 		ret  = ath10k_recalc_rtscts_prot(arvif);
 		if (ret) {
-			ath10k_warn("failed to recalculate rts/cts prot for vdev %d: %d\n",
+			ath10k_warn(ar, "failed to recalculate rts/cts prot for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1624,14 +1627,14 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("failed to install peer wep keys for vdev %i: %d\n",
+		ath10k_warn(ar, "failed to install peer wep keys for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_peer_assoc_qos_ap(ar, arvif, sta);
 	if (ret) {
-		ath10k_warn("failed to set qos params for STA %pM for vdev %i: %d\n",
+		ath10k_warn(ar, "failed to set qos params for STA %pM for vdev %i: %d\n",
 			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1650,7 +1653,7 @@ static int ath10k_station_disassoc(struct ath10k *ar, struct ath10k_vif *arvif,
 		arvif->num_legacy_stations--;
 		ret = ath10k_recalc_rtscts_prot(arvif);
 		if (ret) {
-			ath10k_warn("failed to recalculate rts/cts prot for vdev %d: %d\n",
+			ath10k_warn(ar, "failed to recalculate rts/cts prot for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1658,7 +1661,7 @@ static int ath10k_station_disassoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_clear_peer_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("failed to clear all peer wep keys for vdev %i: %d\n",
+		ath10k_warn(ar, "failed to clear all peer wep keys for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1750,7 +1753,7 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 			if (WARN_ON_ONCE(ch->mode == MODE_UNKNOWN))
 				continue;
 
-			ath10k_dbg(ATH10K_DBG_WMI,
+			ath10k_dbg(ar, ATH10K_DBG_WMI,
 				   "mac channel [%zd/%d] freq %d maxpower %d regpower %d antenna %d mode %d\n",
 				    ch - arg.channels, arg.n_channels,
 				   ch->freq, ch->max_power, ch->max_reg_power,
@@ -1793,7 +1796,7 @@ static void ath10k_regd_update(struct ath10k *ar)
 
 	ret = ath10k_update_channel_list(ar);
 	if (ret)
-		ath10k_warn("failed to update channel list: %d\n", ret);
+		ath10k_warn(ar, "failed to update channel list: %d\n", ret);
 
 	regpair = ar->ath_common.regulatory.regpair;
 
@@ -1814,7 +1817,7 @@ static void ath10k_regd_update(struct ath10k *ar)
 					    regpair->reg_5ghz_ctl,
 					    wmi_dfs_reg);
 	if (ret)
-		ath10k_warn("failed to set pdev regdomain: %d\n", ret);
+		ath10k_warn(ar, "failed to set pdev regdomain: %d\n", ret);
 }
 
 static void ath10k_reg_notifier(struct wiphy *wiphy,
@@ -1827,12 +1830,12 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 	ath_reg_notifier_apply(wiphy, request, &ar->ath_common.regulatory);
 
 	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED) && ar->dfs_detector) {
-		ath10k_dbg(ATH10K_DBG_REGULATORY, "dfs region 0x%x\n",
+		ath10k_dbg(ar, ATH10K_DBG_REGULATORY, "dfs region 0x%x\n",
 			   request->dfs_region);
 		result = ar->dfs_detector->set_dfs_domain(ar->dfs_detector,
 							  request->dfs_region);
 		if (!result)
-			ath10k_warn("DFS region 0x%X not supported, will trigger radar for every pulse\n",
+			ath10k_warn(ar, "DFS region 0x%X not supported, will trigger radar for every pulse\n",
 				    request->dfs_region);
 	}
 
@@ -1869,7 +1872,7 @@ static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar,
 	if (ar->monitor_started)
 		return ar->monitor_vdev_id;
 
-	ath10k_warn("failed to resolve vdev id\n");
+	ath10k_warn(ar, "failed to resolve vdev id\n");
 	return 0;
 }
 
@@ -1905,6 +1908,7 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
 {
 	struct ath10k_vif *arvif = container_of(work, struct ath10k_vif,
 						wep_key_work);
+	struct ath10k *ar = arvif->ar;
 	int ret, keyidx = arvif->def_wep_key_newidx;
 
 	mutex_lock(&arvif->ar->conf_mutex);
@@ -1915,7 +1919,7 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
 	if (arvif->def_wep_key_idx == keyidx)
 		goto unlock;
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d set keyidx %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d set keyidx %d\n",
 		   arvif->vdev_id, keyidx);
 
 	ret = ath10k_wmi_vdev_set_param(arvif->ar,
@@ -1923,7 +1927,7 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
 					arvif->ar->wmi.vdev_param->def_keyid,
 					keyidx);
 	if (ret) {
-		ath10k_warn("failed to update wep key index for vdev %d: %d\n",
+		ath10k_warn(ar, "failed to update wep key index for vdev %d: %d\n",
 			    arvif->vdev_id,
 			    ret);
 		goto unlock;
@@ -2003,7 +2007,7 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 			     ar->fw_features)) {
 			if (skb_queue_len(&ar->wmi_mgmt_tx_queue) >=
 			    ATH10K_MAX_NUM_MGMT_PENDING) {
-				ath10k_warn("reached WMI management transmit queue limit\n");
+				ath10k_warn(ar, "reached WMI management transmit queue limit\n");
 				ret = -EBUSY;
 				goto exit;
 			}
@@ -2027,7 +2031,8 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 
 exit:
 	if (ret) {
-		ath10k_warn("failed to transmit packet, dropping: %d\n", ret);
+		ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
+			    ret);
 		ieee80211_free_txskb(ar->hw, skb);
 	}
 }
@@ -2069,7 +2074,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		mutex_lock(&ar->conf_mutex);
 
-		ath10k_dbg(ATH10K_DBG_MAC, "mac offchannel skb %p\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %p\n",
 			   skb);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
@@ -2082,13 +2087,13 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		if (peer)
 			/* FIXME: should this use ath10k_warn()? */
-			ath10k_dbg(ATH10K_DBG_MAC, "peer %pM on vdev %d already present\n",
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "peer %pM on vdev %d already present\n",
 				   peer_addr, vdev_id);
 
 		if (!peer) {
 			ret = ath10k_peer_create(ar, vdev_id, peer_addr);
 			if (ret)
-				ath10k_warn("failed to create peer %pM on vdev %d: %d\n",
+				ath10k_warn(ar, "failed to create peer %pM on vdev %d: %d\n",
 					    peer_addr, vdev_id, ret);
 		}
 
@@ -2102,13 +2107,13 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		ret = wait_for_completion_timeout(&ar->offchan_tx_completed,
 						  3 * HZ);
 		if (ret <= 0)
-			ath10k_warn("timed out waiting for offchannel skb %p\n",
+			ath10k_warn(ar, "timed out waiting for offchannel skb %p\n",
 				    skb);
 
 		if (!peer) {
 			ret = ath10k_peer_delete(ar, vdev_id, peer_addr);
 			if (ret)
-				ath10k_warn("failed to delete peer %pM on vdev %d: %d\n",
+				ath10k_warn(ar, "failed to delete peer %pM on vdev %d: %d\n",
 					    peer_addr, vdev_id, ret);
 		}
 
@@ -2142,7 +2147,7 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 
 		ret = ath10k_wmi_mgmt_tx(ar, skb);
 		if (ret) {
-			ath10k_warn("failed to transmit management frame via WMI: %d\n",
+			ath10k_warn(ar, "failed to transmit management frame via WMI: %d\n",
 				    ret);
 			ieee80211_free_txskb(ar->hw, skb);
 		}
@@ -2199,13 +2204,13 @@ static int ath10k_scan_stop(struct ath10k *ar)
 
 	ret = ath10k_wmi_stop_scan(ar, &arg);
 	if (ret) {
-		ath10k_warn("failed to stop wmi scan: %d\n", ret);
+		ath10k_warn(ar, "failed to stop wmi scan: %d\n", ret);
 		goto out;
 	}
 
 	ret = wait_for_completion_timeout(&ar->scan.completed, 3*HZ);
 	if (ret == 0) {
-		ath10k_warn("failed to receive scan abortion completion: timed out\n");
+		ath10k_warn(ar, "failed to receive scan abortion completion: timed out\n");
 		ret = -ETIMEDOUT;
 	} else if (ret > 0) {
 		ret = 0;
@@ -2243,7 +2248,7 @@ static void ath10k_scan_abort(struct ath10k *ar)
 		break;
 	case ATH10K_SCAN_STARTING:
 	case ATH10K_SCAN_ABORTING:
-		ath10k_warn("refusing scan abortion due to invalid scan state: %s (%d)\n",
+		ath10k_warn(ar, "refusing scan abortion due to invalid scan state: %s (%d)\n",
 			    ath10k_scan_state_str(ar->scan.state),
 			    ar->scan.state);
 		break;
@@ -2253,7 +2258,7 @@ static void ath10k_scan_abort(struct ath10k *ar)
 
 		ret = ath10k_scan_stop(ar);
 		if (ret)
-			ath10k_warn("failed to abort scan: %d\n", ret);
+			ath10k_warn(ar, "failed to abort scan: %d\n", ret);
 
 		spin_lock_bh(&ar->data_lock);
 		break;
@@ -2287,7 +2292,7 @@ static int ath10k_start_scan(struct ath10k *ar,
 	if (ret == 0) {
 		ret = ath10k_scan_stop(ar);
 		if (ret)
-			ath10k_warn("failed to stop scan: %d\n", ret);
+			ath10k_warn(ar, "failed to stop scan: %d\n", ret);
 
 		return -ETIMEDOUT;
 	}
@@ -2314,7 +2319,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	/* We should disable CCK RATE due to P2P */
 	if (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
-		ath10k_dbg(ATH10K_DBG_MAC, "IEEE80211_TX_CTL_NO_CCK_RATE\n");
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "IEEE80211_TX_CTL_NO_CCK_RATE\n");
 
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
@@ -2334,7 +2339,8 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		ATH10K_SKB_CB(skb)->vdev_id = ar->scan.vdev_id;
 		spin_unlock_bh(&ar->data_lock);
 
-		ath10k_dbg(ATH10K_DBG_MAC, "queued offchannel skb %p\n", skb);
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
+			   skb);
 
 		skb_queue_tail(&ar->offchan_tx_queue, skb);
 		ieee80211_queue_work(hw, &ar->offchan_tx_work);
@@ -2424,7 +2430,7 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->tx_chain_mask,
 					tx_ant);
 	if (ret) {
-		ath10k_warn("failed to set tx-chainmask: %d, req 0x%x\n",
+		ath10k_warn(ar, "failed to set tx-chainmask: %d, req 0x%x\n",
 			    ret, tx_ant);
 		return ret;
 	}
@@ -2432,7 +2438,7 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->rx_chain_mask,
 					rx_ant);
 	if (ret) {
-		ath10k_warn("failed to set rx-chainmask: %d, req 0x%x\n",
+		ath10k_warn(ar, "failed to set rx-chainmask: %d, req 0x%x\n",
 			    ret, rx_ant);
 		return ret;
 	}
@@ -2483,25 +2489,25 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	ret = ath10k_hif_power_up(ar);
 	if (ret) {
-		ath10k_err("Could not init hif: %d\n", ret);
+		ath10k_err(ar, "Could not init hif: %d\n", ret);
 		goto err_off;
 	}
 
 	ret = ath10k_core_start(ar);
 	if (ret) {
-		ath10k_err("Could not init core: %d\n", ret);
+		ath10k_err(ar, "Could not init core: %d\n", ret);
 		goto err_power_down;
 	}
 
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->pmf_qos, 1);
 	if (ret) {
-		ath10k_warn("failed to enable PMF QOS: %d\n", ret);
+		ath10k_warn(ar, "failed to enable PMF QOS: %d\n", ret);
 		goto err_core_stop;
 	}
 
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->dynamic_bw, 1);
 	if (ret) {
-		ath10k_warn("failed to enable dynamic BW: %d\n", ret);
+		ath10k_warn(ar, "failed to enable dynamic BW: %d\n", ret);
 		goto err_core_stop;
 	}
 
@@ -2521,7 +2527,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	ret = ath10k_wmi_pdev_set_param(ar,
 					ar->wmi.pdev_param->arp_ac_override, 0);
 	if (ret) {
-		ath10k_warn("failed to set arp ac override parameter: %d\n",
+		ath10k_warn(ar, "failed to set arp ac override parameter: %d\n",
 			    ret);
 		goto err_core_stop;
 	}
@@ -2575,7 +2581,7 @@ static int ath10k_config_ps(struct ath10k *ar)
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		ret = ath10k_mac_vif_setup_ps(arvif);
 		if (ret) {
-			ath10k_warn("failed to setup powersave: %d\n", ret);
+			ath10k_warn(ar, "failed to setup powersave: %d\n", ret);
 			break;
 		}
 	}
@@ -2613,7 +2619,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ath10k_dbg(ATH10K_DBG_MAC,
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
 		   "mac config channel to %dMHz (cf1 %dMHz cf2 %dMHz width %s)\n",
 		   ar->chandef.chan->center_freq,
 		   ar->chandef.center_freq1,
@@ -2637,7 +2643,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 
 		ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
 		if (ret) {
-			ath10k_warn("failed to down vdev %d: %d\n",
+			ath10k_warn(ar, "failed to down vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
@@ -2654,7 +2660,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 
 		ret = ath10k_vdev_restart(arvif);
 		if (ret) {
-			ath10k_warn("failed to restart vdev %d: %d\n",
+			ath10k_warn(ar, "failed to restart vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
@@ -2665,7 +2671,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 		ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
 					 arvif->bssid);
 		if (ret) {
-			ath10k_warn("failed to bring vdev up %d: %d\n",
+			ath10k_warn(ar, "failed to bring vdev up %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
@@ -2685,7 +2691,7 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&ar->conf_mutex);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ath10k_dbg(ATH10K_DBG_MAC,
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac config channel %dMHz flags 0x%x radar %d\n",
 			   conf->chandef.chan->center_freq,
 			   conf->chandef.chan->flags,
@@ -2705,21 +2711,21 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac config power %d\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac config power %d\n",
 			   hw->conf.power_level);
 
 		param = ar->wmi.pdev_param->txpower_limit2g;
 		ret = ath10k_wmi_pdev_set_param(ar, param,
 						hw->conf.power_level * 2);
 		if (ret)
-			ath10k_warn("failed to set 2g txpower %d: %d\n",
+			ath10k_warn(ar, "failed to set 2g txpower %d: %d\n",
 				    hw->conf.power_level, ret);
 
 		param = ar->wmi.pdev_param->txpower_limit5g;
 		ret = ath10k_wmi_pdev_set_param(ar, param,
 						hw->conf.power_level * 2);
 		if (ret)
-			ath10k_warn("failed to set 5g txpower %d: %d\n",
+			ath10k_warn(ar, "failed to set 5g txpower %d: %d\n",
 				    hw->conf.power_level, ret);
 	}
 
@@ -2731,7 +2737,7 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 			ar->monitor = true;
 			ret = ath10k_monitor_start(ar);
 			if (ret) {
-				ath10k_warn("failed to start monitor (config): %d\n",
+				ath10k_warn(ar, "failed to start monitor (config): %d\n",
 					    ret);
 				ar->monitor = false;
 			}
@@ -2775,7 +2781,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	INIT_LIST_HEAD(&arvif->list);
 
 	if (ar->free_vdev_map == 0) {
-		ath10k_warn("Free vdev map is empty, no more interfaces allowed.\n");
+		ath10k_warn(ar, "Free vdev map is empty, no more interfaces allowed.\n");
 		ret = -EBUSY;
 		goto err;
 	}
@@ -2811,13 +2817,13 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		break;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev create %d (add interface) type %d subtype %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev create %d (add interface) type %d subtype %d\n",
 		   arvif->vdev_id, arvif->vdev_type, arvif->vdev_subtype);
 
 	ret = ath10k_wmi_vdev_create(ar, arvif->vdev_id, arvif->vdev_type,
 				     arvif->vdev_subtype, vif->addr);
 	if (ret) {
-		ath10k_warn("failed to create WMI vdev %i: %d\n",
+		ath10k_warn(ar, "failed to create WMI vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		goto err;
 	}
@@ -2829,7 +2835,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
 					arvif->def_wep_key_idx);
 	if (ret) {
-		ath10k_warn("failed to set vdev %i default key id: %d\n",
+		ath10k_warn(ar, "failed to set vdev %i default key id: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_vdev_delete;
 	}
@@ -2839,7 +2845,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 					ATH10K_HW_TXRX_NATIVE_WIFI);
 	/* 10.X firmware does not support this VDEV parameter. Do not warn */
 	if (ret && ret != -EOPNOTSUPP) {
-		ath10k_warn("failed to set vdev %i TX encapsulation: %d\n",
+		ath10k_warn(ar, "failed to set vdev %i TX encapsulation: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_vdev_delete;
 	}
@@ -2847,14 +2853,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr);
 		if (ret) {
-			ath10k_warn("failed to create vdev %i peer for AP: %d\n",
+			ath10k_warn(ar, "failed to create vdev %i peer for AP: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_vdev_delete;
 		}
 
 		ret = ath10k_mac_set_kickout(arvif);
 		if (ret) {
-			ath10k_warn("failed to set vdev %i kickout parameters: %d\n",
+			ath10k_warn(ar, "failed to set vdev %i kickout parameters: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
@@ -2866,7 +2872,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
 		if (ret) {
-			ath10k_warn("failed to set vdev %i RX wake policy: %d\n",
+			ath10k_warn(ar, "failed to set vdev %i RX wake policy: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
@@ -2876,7 +2882,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
 		if (ret) {
-			ath10k_warn("failed to set vdev %i TX wake thresh: %d\n",
+			ath10k_warn(ar, "failed to set vdev %i TX wake thresh: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
@@ -2886,7 +2892,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
 		if (ret) {
-			ath10k_warn("failed to set vdev %i PSPOLL count: %d\n",
+			ath10k_warn(ar, "failed to set vdev %i PSPOLL count: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
@@ -2894,14 +2900,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	ret = ath10k_mac_set_rts(arvif, ar->hw->wiphy->rts_threshold);
 	if (ret) {
-		ath10k_warn("failed to set rts threshold for vdev %d: %d\n",
+		ath10k_warn(ar, "failed to set rts threshold for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_peer_delete;
 	}
 
 	ret = ath10k_mac_set_frag(arvif, ar->hw->wiphy->frag_threshold);
 	if (ret) {
-		ath10k_warn("failed to set frag threshold for vdev %d: %d\n",
+		ath10k_warn(ar, "failed to set frag threshold for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_peer_delete;
 	}
@@ -2948,7 +2954,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	ret = ath10k_spectral_vif_stop(arvif);
 	if (ret)
-		ath10k_warn("failed to stop spectral for vdev %i: %d\n",
+		ath10k_warn(ar, "failed to stop spectral for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
 	ar->free_vdev_map |= 1 << arvif->vdev_id;
@@ -2957,18 +2963,18 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, vif->addr);
 		if (ret)
-			ath10k_warn("failed to remove peer for AP vdev %i: %d\n",
+			ath10k_warn(ar, "failed to remove peer for AP vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 
 		kfree(arvif->u.ap.noa_data);
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %i delete (remove interface)\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %i delete (remove interface)\n",
 		   arvif->vdev_id);
 
 	ret = ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
 	if (ret)
-		ath10k_warn("failed to delete WMI vdev %i: %d\n",
+		ath10k_warn(ar, "failed to delete WMI vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
 	ath10k_peer_cleanup(ar, arvif->vdev_id);
@@ -3007,7 +3013,7 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 		ar->promisc = true;
 		ret = ath10k_monitor_start(ar);
 		if (ret) {
-			ath10k_warn("failed to start monitor (promisc): %d\n",
+			ath10k_warn(ar, "failed to start monitor (promisc): %d\n",
 				    ret);
 			ar->promisc = false;
 		}
@@ -3039,17 +3045,17 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		vdev_param = ar->wmi.vdev_param->beacon_interval;
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						arvif->beacon_interval);
-		ath10k_dbg(ATH10K_DBG_MAC,
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d beacon_interval %d\n",
 			   arvif->vdev_id, arvif->beacon_interval);
 
 		if (ret)
-			ath10k_warn("failed to set beacon interval for vdev %d: %i\n",
+			ath10k_warn(ar, "failed to set beacon interval for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_BEACON) {
-		ath10k_dbg(ATH10K_DBG_MAC,
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "vdev %d set beacon tx mode to staggered\n",
 			   arvif->vdev_id);
 
@@ -3057,14 +3063,14 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_pdev_set_param(ar, pdev_param,
 						WMI_BEACON_STAGGERED_MODE);
 		if (ret)
-			ath10k_warn("failed to set beacon mode for vdev %d: %i\n",
+			ath10k_warn(ar, "failed to set beacon mode for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_BEACON_INFO) {
 		arvif->dtim_period = info->dtim_period;
 
-		ath10k_dbg(ATH10K_DBG_MAC,
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d dtim_period %d\n",
 			   arvif->vdev_id, arvif->dtim_period);
 
@@ -3072,7 +3078,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						arvif->dtim_period);
 		if (ret)
-			ath10k_warn("failed to set dtim period for vdev %d: %i\n",
+			ath10k_warn(ar, "failed to set dtim period for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -3091,14 +3097,14 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID &&
 	    vif->type != NL80211_IFTYPE_AP) {
 		if (!is_zero_ether_addr(info->bssid)) {
-			ath10k_dbg(ATH10K_DBG_MAC,
+			ath10k_dbg(ar, ATH10K_DBG_MAC,
 				   "mac vdev %d create peer %pM\n",
 				   arvif->vdev_id, info->bssid);
 
 			ret = ath10k_peer_create(ar, arvif->vdev_id,
 						 info->bssid);
 			if (ret)
-				ath10k_warn("failed to add peer %pM for vdev %d when changing bssid: %i\n",
+				ath10k_warn(ar, "failed to add peer %pM for vdev %d when changing bssid: %i\n",
 					    info->bssid, arvif->vdev_id, ret);
 
 			if (vif->type == NL80211_IFTYPE_STATION) {
@@ -3108,13 +3114,13 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				 */
 				memcpy(arvif->bssid, info->bssid, ETH_ALEN);
 
-				ath10k_dbg(ATH10K_DBG_MAC,
+				ath10k_dbg(ar, ATH10K_DBG_MAC,
 					   "mac vdev %d start %pM\n",
 					   arvif->vdev_id, info->bssid);
 
 				ret = ath10k_vdev_start(arvif);
 				if (ret) {
-					ath10k_warn("failed to start vdev %i: %d\n",
+					ath10k_warn(ar, "failed to start vdev %i: %d\n",
 						    arvif->vdev_id, ret);
 					goto exit;
 				}
@@ -3138,12 +3144,12 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
 		arvif->use_cts_prot = info->use_cts_prot;
-		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d cts_prot %d\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d cts_prot %d\n",
 			   arvif->vdev_id, info->use_cts_prot);
 
 		ret = ath10k_recalc_rtscts_prot(arvif);
 		if (ret)
-			ath10k_warn("failed to recalculate rts/cts prot for vdev %d: %d\n",
+			ath10k_warn(ar, "failed to recalculate rts/cts prot for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -3155,14 +3161,14 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			slottime = WMI_VDEV_SLOT_TIME_LONG; /* 20us */
 
-		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d slot_time %d\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d slot_time %d\n",
 			   arvif->vdev_id, slottime);
 
 		vdev_param = ar->wmi.vdev_param->slot_time;
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						slottime);
 		if (ret)
-			ath10k_warn("failed to set erp slot for vdev %d: %i\n",
+			ath10k_warn(ar, "failed to set erp slot for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -3173,7 +3179,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			preamble = WMI_VDEV_PREAMBLE_LONG;
 
-		ath10k_dbg(ATH10K_DBG_MAC,
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d preamble %dn",
 			   arvif->vdev_id, preamble);
 
@@ -3181,7 +3187,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						preamble);
 		if (ret)
-			ath10k_warn("failed to set preamble for vdev %d: %i\n",
+			ath10k_warn(ar, "failed to set preamble for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -3259,7 +3265,7 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 
 	ret = ath10k_start_scan(ar, &arg);
 	if (ret) {
-		ath10k_warn("failed to start hw scan: %d\n", ret);
+		ath10k_warn(ar, "failed to start hw scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
 		ar->scan.state = ATH10K_SCAN_IDLE;
 		spin_unlock_bh(&ar->data_lock);
@@ -3315,7 +3321,7 @@ static void ath10k_set_key_h_def_keyidx(struct ath10k *ar,
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 					key->keyidx);
 	if (ret)
-		ath10k_warn("failed to set vdev %i group key as default key: %d\n",
+		ath10k_warn(ar, "failed to set vdev %i group key as default key: %d\n",
 			    arvif->vdev_id, ret);
 }
 
@@ -3353,7 +3359,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (!peer) {
 		if (cmd == SET_KEY) {
-			ath10k_warn("failed to install key for non-existent peer %pM\n",
+			ath10k_warn(ar, "failed to install key for non-existent peer %pM\n",
 				    peer_addr);
 			ret = -EOPNOTSUPP;
 			goto exit;
@@ -3376,7 +3382,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	ret = ath10k_install_key(arvif, key, cmd, peer_addr);
 	if (ret) {
-		ath10k_warn("failed to install key for vdev %i peer %pM: %d\n",
+		ath10k_warn(ar, "failed to install key for vdev %i peer %pM: %d\n",
 			    arvif->vdev_id, peer_addr, ret);
 		goto exit;
 	}
@@ -3391,7 +3397,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		peer->keys[key->keyidx] = NULL;
 	else if (peer == NULL)
 		/* impossible unless FW goes crazy */
-		ath10k_warn("Peer %pM disappeared!\n", peer_addr);
+		ath10k_warn(ar, "Peer %pM disappeared!\n", peer_addr);
 	spin_unlock_bh(&ar->data_lock);
 
 exit:
@@ -3427,45 +3433,45 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 	mutex_lock(&ar->conf_mutex);
 
 	if (changed & IEEE80211_RC_BW_CHANGED) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac update sta %pM peer bw %d\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM peer bw %d\n",
 			   sta->addr, bw);
 
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
 						WMI_PEER_CHAN_WIDTH, bw);
 		if (err)
-			ath10k_warn("failed to update STA %pM peer bw %d: %d\n",
+			ath10k_warn(ar, "failed to update STA %pM peer bw %d: %d\n",
 				    sta->addr, bw, err);
 	}
 
 	if (changed & IEEE80211_RC_NSS_CHANGED) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac update sta %pM nss %d\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM nss %d\n",
 			   sta->addr, nss);
 
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
 						WMI_PEER_NSS, nss);
 		if (err)
-			ath10k_warn("failed to update STA %pM nss %d: %d\n",
+			ath10k_warn(ar, "failed to update STA %pM nss %d: %d\n",
 				    sta->addr, nss, err);
 	}
 
 	if (changed & IEEE80211_RC_SMPS_CHANGED) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac update sta %pM smps %d\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM smps %d\n",
 			   sta->addr, smps);
 
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
 						WMI_PEER_SMPS_STATE, smps);
 		if (err)
-			ath10k_warn("failed to update STA %pM smps %d: %d\n",
+			ath10k_warn(ar, "failed to update STA %pM smps %d: %d\n",
 				    sta->addr, smps, err);
 	}
 
 	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac update sta %pM supp rates\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM supp rates\n",
 			   sta->addr);
 
 		err = ath10k_station_assoc(ar, arvif, sta, true);
 		if (err)
-			ath10k_warn("failed to reassociate station: %pM\n",
+			ath10k_warn(ar, "failed to reassociate station: %pM\n",
 				    sta->addr);
 	}
 
@@ -3510,31 +3516,31 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			max_num_peers = TARGET_NUM_PEERS;
 
 		if (ar->num_peers >= max_num_peers) {
-			ath10k_warn("number of peers exceeded: peers number %d (max peers %d)\n",
+			ath10k_warn(ar, "number of peers exceeded: peers number %d (max peers %d)\n",
 				    ar->num_peers, max_num_peers);
 			ret = -ENOBUFS;
 			goto exit;
 		}
 
-		ath10k_dbg(ATH10K_DBG_MAC,
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d peer create %pM (new sta) num_peers %d\n",
 			   arvif->vdev_id, sta->addr, ar->num_peers);
 
 		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
 		if (ret)
-			ath10k_warn("failed to add peer %pM for vdev %d when adding a new sta: %i\n",
+			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	} else if ((old_state == IEEE80211_STA_NONE &&
 		    new_state == IEEE80211_STA_NOTEXIST)) {
 		/*
 		 * Existing station deletion.
 		 */
-		ath10k_dbg(ATH10K_DBG_MAC,
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d peer delete %pM (sta gone)\n",
 			   arvif->vdev_id, sta->addr);
 		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 		if (ret)
-			ath10k_warn("failed to delete peer %pM for vdev %d: %i\n",
+			ath10k_warn(ar, "failed to delete peer %pM for vdev %d: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 
 		if (vif->type == NL80211_IFTYPE_STATION)
@@ -3546,12 +3552,12 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		/*
 		 * New association.
 		 */
-		ath10k_dbg(ATH10K_DBG_MAC, "mac sta %pM associated\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac sta %pM associated\n",
 			   sta->addr);
 
 		ret = ath10k_station_assoc(ar, arvif, sta, false);
 		if (ret)
-			ath10k_warn("failed to associate station %pM for vdev %i: %i\n",
+			ath10k_warn(ar, "failed to associate station %pM for vdev %i: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH &&
@@ -3560,12 +3566,12 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		/*
 		 * Disassociation.
 		 */
-		ath10k_dbg(ATH10K_DBG_MAC, "mac sta %pM disassociated\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac sta %pM disassociated\n",
 			   sta->addr);
 
 		ret = ath10k_station_disassoc(ar, arvif, sta);
 		if (ret)
-			ath10k_warn("failed to disassociate station: %pM vdev %i: %i\n",
+			ath10k_warn(ar, "failed to disassociate station: %pM vdev %i: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	}
 exit:
@@ -3613,7 +3619,7 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 					  WMI_STA_PS_PARAM_UAPSD,
 					  arvif->u.sta.uapsd);
 	if (ret) {
-		ath10k_warn("failed to set uapsd params: %d\n", ret);
+		ath10k_warn(ar, "failed to set uapsd params: %d\n", ret);
 		goto exit;
 	}
 
@@ -3626,7 +3632,7 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 					  WMI_STA_PS_PARAM_RX_WAKE_POLICY,
 					  value);
 	if (ret)
-		ath10k_warn("failed to set rx wake param: %d\n", ret);
+		ath10k_warn(ar, "failed to set rx wake param: %d\n", ret);
 
 exit:
 	return ret;
@@ -3676,13 +3682,13 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 	/* FIXME: FW accepts wmm params per hw, not per vif */
 	ret = ath10k_wmi_pdev_set_wmm_params(ar, &ar->wmm_params);
 	if (ret) {
-		ath10k_warn("failed to set wmm params: %d\n", ret);
+		ath10k_warn(ar, "failed to set wmm params: %d\n", ret);
 		goto exit;
 	}
 
 	ret = ath10k_conf_tx_uapsd(ar, vif, ac, params->uapsd);
 	if (ret)
-		ath10k_warn("failed to set sta uapsd: %d\n", ret);
+		ath10k_warn(ar, "failed to set sta uapsd: %d\n", ret);
 
 exit:
 	mutex_unlock(&ar->conf_mutex);
@@ -3741,7 +3747,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 
 	ret = ath10k_start_scan(ar, &arg);
 	if (ret) {
-		ath10k_warn("failed to start roc scan: %d\n", ret);
+		ath10k_warn(ar, "failed to start roc scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
 		ar->scan.state = ATH10K_SCAN_IDLE;
 		spin_unlock_bh(&ar->data_lock);
@@ -3750,11 +3756,11 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 
 	ret = wait_for_completion_timeout(&ar->scan.on_channel, 3*HZ);
 	if (ret == 0) {
-		ath10k_warn("failed to switch to channel for roc scan\n");
+		ath10k_warn(ar, "failed to switch to channel for roc scan\n");
 
 		ret = ath10k_scan_stop(ar);
 		if (ret)
-			ath10k_warn("failed to stop scan: %d\n", ret);
+			ath10k_warn(ar, "failed to stop scan: %d\n", ret);
 
 		ret = -ETIMEDOUT;
 		goto exit;
@@ -3791,12 +3797,12 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 	mutex_lock(&ar->conf_mutex);
 	list_for_each_entry(arvif, &ar->arvifs, list) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d rts threshold %d\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d rts threshold %d\n",
 			   arvif->vdev_id, value);
 
 		ret = ath10k_mac_set_rts(arvif, value);
 		if (ret) {
-			ath10k_warn("failed to set rts threshold for vdev %d: %d\n",
+			ath10k_warn(ar, "failed to set rts threshold for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			break;
 		}
@@ -3814,12 +3820,12 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 
 	mutex_lock(&ar->conf_mutex);
 	list_for_each_entry(arvif, &ar->arvifs, list) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d fragmentation threshold %d\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d fragmentation threshold %d\n",
 			   arvif->vdev_id, value);
 
 		ret = ath10k_mac_set_rts(arvif, value);
 		if (ret) {
-			ath10k_warn("failed to set fragmentation threshold for vdev %d: %d\n",
+			ath10k_warn(ar, "failed to set fragmentation threshold for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			break;
 		}
@@ -3859,7 +3865,7 @@ static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		}), ATH10K_FLUSH_TIMEOUT_HZ);
 
 	if (ret <= 0 || skip)
-		ath10k_warn("failed to flush transmit queue (skip %i ar-state %i): %i\n",
+		ath10k_warn(ar, "failed to flush transmit queue (skip %i ar-state %i): %i\n",
 			    skip, ar->state, ret);
 
 skip:
@@ -3894,7 +3900,7 @@ static int ath10k_suspend(struct ieee80211_hw *hw,
 
 	ret = ath10k_hif_suspend(ar);
 	if (ret) {
-		ath10k_warn("failed to suspend hif: %d\n", ret);
+		ath10k_warn(ar, "failed to suspend hif: %d\n", ret);
 		goto resume;
 	}
 
@@ -3903,7 +3909,7 @@ static int ath10k_suspend(struct ieee80211_hw *hw,
 resume:
 	ret = ath10k_wmi_pdev_resume_target(ar);
 	if (ret)
-		ath10k_warn("failed to resume target: %d\n", ret);
+		ath10k_warn(ar, "failed to resume target: %d\n", ret);
 
 	ret = 1;
 exit:
@@ -3920,14 +3926,14 @@ static int ath10k_resume(struct ieee80211_hw *hw)
 
 	ret = ath10k_hif_resume(ar);
 	if (ret) {
-		ath10k_warn("failed to resume hif: %d\n", ret);
+		ath10k_warn(ar, "failed to resume hif: %d\n", ret);
 		ret = 1;
 		goto exit;
 	}
 
 	ret = ath10k_wmi_pdev_resume_target(ar);
 	if (ret) {
-		ath10k_warn("failed to resume target: %d\n", ret);
+		ath10k_warn(ar, "failed to resume target: %d\n", ret);
 		ret = 1;
 		goto exit;
 	}
@@ -3948,7 +3954,7 @@ static void ath10k_restart_complete(struct ieee80211_hw *hw)
 	/* If device failed to restart it will be in a different state, e.g.
 	 * ATH10K_STATE_WEDGED */
 	if (ar->state == ATH10K_STATE_RESTARTED) {
-		ath10k_info("device successfully recovered\n");
+		ath10k_info(ar, "device successfully recovered\n");
 		ar->state = ATH10K_STATE_ON;
 	}
 
@@ -4145,7 +4151,8 @@ ath10k_bitrate_mask_correct(const struct cfg80211_bitrate_mask *mask,
 }
 
 static bool
-ath10k_bitrate_mask_rate(const struct cfg80211_bitrate_mask *mask,
+ath10k_bitrate_mask_rate(struct ath10k *ar,
+			 const struct cfg80211_bitrate_mask *mask,
 			 enum ieee80211_band band,
 			 u8 *fixed_rate,
 			 u8 *fixed_nss)
@@ -4203,7 +4210,7 @@ ath10k_bitrate_mask_rate(const struct cfg80211_bitrate_mask *mask,
 	nss <<= 4;
 	pream <<= 6;
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac fixed rate pream 0x%02x nss 0x%02x rate 0x%02x\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac fixed rate pream 0x%02x nss 0x%02x rate 0x%02x\n",
 		   pream, nss, rate);
 
 	*fixed_rate = pream | nss | rate;
@@ -4211,7 +4218,8 @@ ath10k_bitrate_mask_rate(const struct cfg80211_bitrate_mask *mask,
 	return true;
 }
 
-static bool ath10k_get_fixed_rate_nss(const struct cfg80211_bitrate_mask *mask,
+static bool ath10k_get_fixed_rate_nss(struct ath10k *ar,
+				      const struct cfg80211_bitrate_mask *mask,
 				      enum ieee80211_band band,
 				      u8 *fixed_rate,
 				      u8 *fixed_nss)
@@ -4221,7 +4229,7 @@ static bool ath10k_get_fixed_rate_nss(const struct cfg80211_bitrate_mask *mask,
 		return true;
 
 	/* Next Check single rate is set */
-	return ath10k_bitrate_mask_rate(mask, band, fixed_rate, fixed_nss);
+	return ath10k_bitrate_mask_rate(ar, mask, band, fixed_rate, fixed_nss);
 }
 
 static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
@@ -4241,16 +4249,16 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 		goto exit;
 
 	if (fixed_rate == WMI_FIXED_RATE_NONE)
-		ath10k_dbg(ATH10K_DBG_MAC, "mac disable fixed bitrate mask\n");
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac disable fixed bitrate mask\n");
 
 	if (force_sgi)
-		ath10k_dbg(ATH10K_DBG_MAC, "mac force sgi\n");
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac force sgi\n");
 
 	vdev_param = ar->wmi.vdev_param->fixed_rate;
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 					vdev_param, fixed_rate);
 	if (ret) {
-		ath10k_warn("failed to set fixed rate param 0x%02x: %d\n",
+		ath10k_warn(ar, "failed to set fixed rate param 0x%02x: %d\n",
 			    fixed_rate, ret);
 		ret = -EINVAL;
 		goto exit;
@@ -4263,7 +4271,7 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 					vdev_param, fixed_nss);
 
 	if (ret) {
-		ath10k_warn("failed to set fixed nss param %d: %d\n",
+		ath10k_warn(ar, "failed to set fixed nss param %d: %d\n",
 			    fixed_nss, ret);
 		ret = -EINVAL;
 		goto exit;
@@ -4276,7 +4284,7 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 					force_sgi);
 
 	if (ret) {
-		ath10k_warn("failed to set sgi param %d: %d\n",
+		ath10k_warn(ar, "failed to set sgi param %d: %d\n",
 			    force_sgi, ret);
 		ret = -EINVAL;
 		goto exit;
@@ -4305,14 +4313,14 @@ static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
 		return -EINVAL;
 
 	if (!ath10k_default_bitrate_mask(ar, band, mask)) {
-		if (!ath10k_get_fixed_rate_nss(mask, band,
+		if (!ath10k_get_fixed_rate_nss(ar, mask, band,
 					       &fixed_rate,
 					       &fixed_nss))
 			return -EINVAL;
 	}
 
 	if (fixed_rate == WMI_FIXED_RATE_NONE && force_sgi) {
-		ath10k_warn("failed to force SGI usage for default rate settings\n");
+		ath10k_warn(ar, "failed to force SGI usage for default rate settings\n");
 		return -EINVAL;
 	}
 
@@ -4331,7 +4339,7 @@ static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&ar->data_lock);
 
-	ath10k_dbg(ATH10K_DBG_MAC,
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
 		   "mac sta rc update for %pM changed %08x bw %d nss %d smps %d\n",
 		   sta->addr, changed, sta->bandwidth, sta->rx_nss,
 		   sta->smps_mode);
@@ -4350,7 +4358,7 @@ static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
 			bw = WMI_PEER_CHWIDTH_80MHZ;
 			break;
 		case IEEE80211_STA_RX_BW_160:
-			ath10k_warn("Invalid bandwith %d in rc update for %pM\n",
+			ath10k_warn(ar, "Invalid bandwith %d in rc update for %pM\n",
 				    sta->bandwidth, sta->addr);
 			bw = WMI_PEER_CHWIDTH_20MHZ;
 			break;
@@ -4377,7 +4385,7 @@ static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
 			smps = WMI_PEER_SMPS_DYNAMIC;
 			break;
 		case IEEE80211_SMPS_NUM_MODES:
-			ath10k_warn("Invalid smps %d in sta rc update for %pM\n",
+			ath10k_warn(ar, "Invalid smps %d in sta rc update for %pM\n",
 				    sta->smps_mode, sta->addr);
 			smps = WMI_PEER_SMPS_PS_NONE;
 			break;
@@ -4409,9 +4417,10 @@ static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 			       u8 buf_size)
 {
+	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac ampdu vdev_id %i sta %pM tid %hu action %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac ampdu vdev_id %i sta %pM tid %hu action %d\n",
 		   arvif->vdev_id, sta->addr, tid, action);
 
 	switch (action) {
@@ -4739,7 +4748,7 @@ struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id)
 						   ath10k_get_arvif_iter,
 						   &arvif_iter);
 	if (!arvif_iter.arvif) {
-		ath10k_warn("No VIF found for vdev %d\n", vdev_id);
+		ath10k_warn(ar, "No VIF found for vdev %d\n", vdev_id);
 		return NULL;
 	}
 
@@ -4885,19 +4894,19 @@ int ath10k_mac_register(struct ath10k *ar)
 							     NL80211_DFS_UNSET);
 
 		if (!ar->dfs_detector)
-			ath10k_warn("failed to initialise DFS pattern detector\n");
+			ath10k_warn(ar, "failed to initialise DFS pattern detector\n");
 	}
 
 	ret = ath_regd_init(&ar->ath_common.regulatory, ar->hw->wiphy,
 			    ath10k_reg_notifier);
 	if (ret) {
-		ath10k_err("failed to initialise regulatory: %i\n", ret);
+		ath10k_err(ar, "failed to initialise regulatory: %i\n", ret);
 		goto err_free;
 	}
 
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
-		ath10k_err("failed to register ieee80211: %d\n", ret);
+		ath10k_err(ar, "failed to register ieee80211: %d\n", ret);
 		goto err_free;
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 98c029b..5a2aadc 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -294,7 +294,7 @@ static int ath10k_pci_request_early_irq(struct ath10k *ar)
 	ret = request_irq(ar_pci->pdev->irq, ath10k_pci_early_irq_handler,
 			  IRQF_SHARED, "ath10k_pci (early)", ar);
 	if (ret) {
-		ath10k_warn("failed to request early irq: %d\n", ret);
+		ath10k_warn(ar, "failed to request early irq: %d\n", ret);
 		return ret;
 	}
 
@@ -450,7 +450,7 @@ done:
 				__le32_to_cpu(((__le32 *)data_buf)[i]);
 		}
 	} else
-		ath10k_warn("failed to read diag value at 0x%x: %d\n",
+		ath10k_warn(ar, "failed to read diag value at 0x%x: %d\n",
 			    address, ret);
 
 	if (data_buf)
@@ -598,7 +598,7 @@ done:
 	}
 
 	if (ret != 0)
-		ath10k_warn("failed to write diag value at 0x%x: %d\n",
+		ath10k_warn(ar, "failed to write diag value at 0x%x: %d\n",
 			    address, ret);
 
 	return ret;
@@ -703,7 +703,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 				 max_nbytes, DMA_FROM_DEVICE);
 
 		if (unlikely(max_nbytes < nbytes)) {
-			ath10k_warn("rxed more than expected (nbytes %d, max %d)",
+			ath10k_warn(ar, "rxed more than expected (nbytes %d, max %d)",
 				    nbytes, max_nbytes);
 			dev_kfree_skb_any(skb);
 			continue;
@@ -716,7 +716,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 	err = ath10k_pci_post_rx_pipe(pipe_info, num_replenish);
 	if (unlikely(err)) {
 		/* FIXME: retry */
-		ath10k_warn("failed to replenish CE rx ring %d (%d bufs): %d\n",
+		ath10k_warn(ar, "failed to replenish CE rx ring %d (%d bufs): %d\n",
 			    pipe_info->pipe_num, num_replenish, err);
 	}
 }
@@ -746,10 +746,10 @@ static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 	}
 
 	for (i = 0; i < n_items - 1; i++) {
-		ath10k_dbg(ATH10K_DBG_PCI,
+		ath10k_dbg(ar, ATH10K_DBG_PCI,
 			   "pci tx item %d paddr 0x%08x len %d n_items %d\n",
 			   i, items[i].paddr, items[i].len, n_items);
-		ath10k_dbg_dump(ATH10K_DBG_PCI_DUMP, NULL, "item data: ",
+		ath10k_dbg_dump(ar, ATH10K_DBG_PCI_DUMP, NULL, "pci tx data: ",
 				items[i].vaddr, items[i].len);
 
 		err = ath10k_ce_send_nolock(ce_pipe,
@@ -764,10 +764,10 @@ static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 
 	/* `i` is equal to `n_items -1` after for() */
 
-	ath10k_dbg(ATH10K_DBG_PCI,
+	ath10k_dbg(ar, ATH10K_DBG_PCI,
 		   "pci tx item %d paddr 0x%08x len %d n_items %d\n",
 		   i, items[i].paddr, items[i].len, n_items);
-	ath10k_dbg_dump(ATH10K_DBG_PCI_DUMP, NULL, "item data: ",
+	ath10k_dbg_dump(ar, ATH10K_DBG_PCI_DUMP, NULL, "pci tx data: ",
 			items[i].vaddr, items[i].len);
 
 	err = ath10k_ce_send_nolock(ce_pipe,
@@ -794,7 +794,7 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	ath10k_dbg(ATH10K_DBG_PCI, "pci hif get free queue number\n");
+	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif get free queue number\n");
 
 	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
@@ -807,34 +807,36 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 	int ret;
 	u32 i;
 
-	ath10k_err("firmware crashed!\n");
-	ath10k_err("hardware name %s version 0x%x\n",
+	ath10k_err(ar, "firmware crashed!\n");
+	ath10k_err(ar, "hardware name %s version 0x%x\n",
 		   ar->hw_params.name, ar->target_version);
-	ath10k_err("firmware version: %s\n", ar->hw->wiphy->fw_version);
+	ath10k_err(ar, "firmware version: %s\n", ar->hw->wiphy->fw_version);
 
 	host_addr = host_interest_item_address(HI_ITEM(hi_failure_state));
 	ret = ath10k_pci_diag_read_mem(ar, host_addr,
 				       &reg_dump_area, sizeof(u32));
 	if (ret) {
-		ath10k_err("failed to read FW dump area address: %d\n", ret);
+		ath10k_err(ar, "failed to read FW dump area address: %d\n",
+			   ret);
 		return;
 	}
 
-	ath10k_err("target register Dump Location: 0x%08X\n", reg_dump_area);
+	ath10k_err(ar, "target register Dump Location: 0x%08X\n",
+		   reg_dump_area);
 
 	ret = ath10k_pci_diag_read_mem(ar, reg_dump_area,
 				       &reg_dump_values[0],
 				       REG_DUMP_COUNT_QCA988X * sizeof(u32));
 	if (ret != 0) {
-		ath10k_err("failed to read FW dump area: %d\n", ret);
+		ath10k_err(ar, "failed to read FW dump area: %d\n", ret);
 		return;
 	}
 
 	BUILD_BUG_ON(REG_DUMP_COUNT_QCA988X % 4);
 
-	ath10k_err("target Register Dump\n");
+	ath10k_err(ar, "target Register Dump\n");
 	for (i = 0; i < REG_DUMP_COUNT_QCA988X; i += 4)
-		ath10k_err("[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X\n",
+		ath10k_err(ar, "[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X\n",
 			   i,
 			   reg_dump_values[i],
 			   reg_dump_values[i + 1],
@@ -847,7 +849,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
 					       int force)
 {
-	ath10k_dbg(ATH10K_DBG_PCI, "pci hif send complete check\n");
+	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif send complete check\n");
 
 	if (!force) {
 		int resources;
@@ -875,7 +877,7 @@ static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	ath10k_dbg(ATH10K_DBG_PCI, "pci hif set callbacks\n");
+	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif set callbacks\n");
 
 	memcpy(&ar_pci->msg_callbacks_current, callbacks,
 	       sizeof(ar_pci->msg_callbacks_current));
@@ -933,7 +935,7 @@ static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar,
 {
 	int ret = 0;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "pci hif map service\n");
+	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif map service\n");
 
 	/* polling for received messages not supported */
 	*dl_is_polled = 0;
@@ -994,7 +996,7 @@ static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
 {
 	int ul_is_polled, dl_is_polled;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "pci hif get default pipe\n");
+	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif get default pipe\n");
 
 	(void)ath10k_pci_hif_map_service_to_pipe(ar,
 						 ATH10K_HTC_SVC_ID_RSVD_CTRL,
@@ -1020,7 +1022,7 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 	for (i = 0; i < num; i++) {
 		skb = dev_alloc_skb(pipe_info->buf_sz);
 		if (!skb) {
-			ath10k_warn("failed to allocate skbuff for pipe %d\n",
+			ath10k_warn(ar, "failed to allocate skbuff for pipe %d\n",
 				    num);
 			ret = -ENOMEM;
 			goto err;
@@ -1033,7 +1035,7 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 					 DMA_FROM_DEVICE);
 
 		if (unlikely(dma_mapping_error(ar->dev, ce_data))) {
-			ath10k_warn("failed to DMA map sk_buff\n");
+			ath10k_warn(ar, "failed to DMA map sk_buff\n");
 			dev_kfree_skb_any(skb);
 			ret = -EIO;
 			goto err;
@@ -1048,7 +1050,7 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 		ret = ath10k_ce_recv_buf_enqueue(ce_state, (void *)skb,
 						 ce_data);
 		if (ret) {
-			ath10k_warn("failed to enqueue to pipe %d: %d\n",
+			ath10k_warn(ar, "failed to enqueue to pipe %d: %d\n",
 				    num, ret);
 			goto err;
 		}
@@ -1078,7 +1080,7 @@ static int ath10k_pci_post_rx(struct ath10k *ar)
 		ret = ath10k_pci_post_rx_pipe(pipe_info,
 					      attr->dest_nentries - 1);
 		if (ret) {
-			ath10k_warn("failed to post RX buffer for pipe %d: %d\n",
+			ath10k_warn(ar, "failed to post RX buffer for pipe %d: %d\n",
 				    pipe_num, ret);
 
 			for (; pipe_num >= 0; pipe_num--) {
@@ -1097,28 +1099,28 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret, ret_early;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif start\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
 
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 
 	ret = ath10k_pci_request_irq(ar);
 	if (ret) {
-		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
+		ath10k_warn(ar, "failed to post RX buffers for all pipes: %d\n",
 			    ret);
 		goto err_early_irq;
 	}
 
 	ret = ath10k_pci_setup_ce_irq(ar);
 	if (ret) {
-		ath10k_warn("failed to setup CE interrupts: %d\n", ret);
+		ath10k_warn(ar, "failed to setup CE interrupts: %d\n", ret);
 		goto err_stop;
 	}
 
 	/* Post buffers once to start things off. */
 	ret = ath10k_pci_post_rx(ar);
 	if (ret) {
-		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
+		ath10k_warn(ar, "failed to post RX buffers for all pipes: %d\n",
 			    ret);
 		goto err_stop;
 	}
@@ -1136,7 +1138,8 @@ err_early_irq:
 	 * driver lifecycle. */
 	ret_early = ath10k_pci_request_early_irq(ar);
 	if (ret_early)
-		ath10k_warn("failed to re-enable early irq: %d\n", ret_early);
+		ath10k_warn(ar, "failed to re-enable early irq: %d\n",
+			    ret_early);
 
 	return ret;
 }
@@ -1245,21 +1248,21 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif stop\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif stop\n");
 
 	if (WARN_ON(!ar_pci->started))
 		return;
 
 	ret = ath10k_ce_disable_interrupts(ar);
 	if (ret)
-		ath10k_warn("failed to disable CE interrupts: %d\n", ret);
+		ath10k_warn(ar, "failed to disable CE interrupts: %d\n", ret);
 
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 
 	ret = ath10k_pci_request_early_irq(ar);
 	if (ret)
-		ath10k_warn("failed to re-enable early irq: %d\n", ret);
+		ath10k_warn(ar, "failed to re-enable early irq: %d\n", ret);
 
 	/* At this point, asynchronous threads are stopped, the target should
 	 * not DMA nor interrupt. We process the leftovers and then free
@@ -1383,6 +1386,7 @@ static void ath10k_pci_bmi_send_done(struct ath10k_ce_pipe *ce_state)
 
 static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
 {
+	struct ath10k *ar = ce_state->ar;
 	struct bmi_xfer *xfer;
 	u32 ce_data;
 	unsigned int nbytes;
@@ -1394,7 +1398,7 @@ static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
 		return;
 
 	if (!xfer->wait_for_resp) {
-		ath10k_warn("unexpected: BMI data received; ignoring\n");
+		ath10k_warn(ar, "unexpected: BMI data received; ignoring\n");
 		return;
 	}
 
@@ -1530,7 +1534,7 @@ static int ath10k_pci_wake_target_cpu(struct ath10k *ar)
 					      CORE_CTRL_ADDRESS,
 					  &core_ctrl);
 	if (ret) {
-		ath10k_warn("failed to read core_ctrl: %d\n", ret);
+		ath10k_warn(ar, "failed to read core_ctrl: %d\n", ret);
 		return ret;
 	}
 
@@ -1541,7 +1545,7 @@ static int ath10k_pci_wake_target_cpu(struct ath10k *ar)
 					       CORE_CTRL_ADDRESS,
 					   core_ctrl);
 	if (ret) {
-		ath10k_warn("failed to set target CPU interrupt mask: %d\n",
+		ath10k_warn(ar, "failed to set target CPU interrupt mask: %d\n",
 			    ret);
 		return ret;
 	}
@@ -1570,13 +1574,13 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 	ret = ath10k_pci_diag_read_access(ar, interconnect_targ_addr,
 					  &pcie_state_targ_addr);
 	if (ret != 0) {
-		ath10k_err("Failed to get pcie state addr: %d\n", ret);
+		ath10k_err(ar, "Failed to get pcie state addr: %d\n", ret);
 		return ret;
 	}
 
 	if (pcie_state_targ_addr == 0) {
 		ret = -EIO;
-		ath10k_err("Invalid pcie state addr\n");
+		ath10k_err(ar, "Invalid pcie state addr\n");
 		return ret;
 	}
 
@@ -1585,13 +1589,13 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 						   pipe_cfg_addr),
 					  &pipe_cfg_targ_addr);
 	if (ret != 0) {
-		ath10k_err("Failed to get pipe cfg addr: %d\n", ret);
+		ath10k_err(ar, "Failed to get pipe cfg addr: %d\n", ret);
 		return ret;
 	}
 
 	if (pipe_cfg_targ_addr == 0) {
 		ret = -EIO;
-		ath10k_err("Invalid pipe cfg addr\n");
+		ath10k_err(ar, "Invalid pipe cfg addr\n");
 		return ret;
 	}
 
@@ -1600,7 +1604,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 				 sizeof(target_ce_config_wlan));
 
 	if (ret != 0) {
-		ath10k_err("Failed to write pipe cfg: %d\n", ret);
+		ath10k_err(ar, "Failed to write pipe cfg: %d\n", ret);
 		return ret;
 	}
 
@@ -1609,13 +1613,13 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 						   svc_to_pipe_map),
 					  &svc_to_pipe_map);
 	if (ret != 0) {
-		ath10k_err("Failed to get svc/pipe map: %d\n", ret);
+		ath10k_err(ar, "Failed to get svc/pipe map: %d\n", ret);
 		return ret;
 	}
 
 	if (svc_to_pipe_map == 0) {
 		ret = -EIO;
-		ath10k_err("Invalid svc_to_pipe map\n");
+		ath10k_err(ar, "Invalid svc_to_pipe map\n");
 		return ret;
 	}
 
@@ -1623,7 +1627,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 				 target_service_to_ce_map_wlan,
 				 sizeof(target_service_to_ce_map_wlan));
 	if (ret != 0) {
-		ath10k_err("Failed to write svc/pipe map: %d\n", ret);
+		ath10k_err(ar, "Failed to write svc/pipe map: %d\n", ret);
 		return ret;
 	}
 
@@ -1632,7 +1636,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 						   config_flags),
 					  &pcie_config_flags);
 	if (ret != 0) {
-		ath10k_err("Failed to get pcie config_flags: %d\n", ret);
+		ath10k_err(ar, "Failed to get pcie config_flags: %d\n", ret);
 		return ret;
 	}
 
@@ -1643,7 +1647,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 				 &pcie_config_flags,
 				 sizeof(pcie_config_flags));
 	if (ret != 0) {
-		ath10k_err("Failed to write pcie config_flags: %d\n", ret);
+		ath10k_err(ar, "Failed to write pcie config_flags: %d\n", ret);
 		return ret;
 	}
 
@@ -1652,7 +1656,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 
 	ret = ath10k_pci_diag_read_access(ar, ealloc_targ_addr, &ealloc_value);
 	if (ret != 0) {
-		ath10k_err("Faile to get early alloc val: %d\n", ret);
+		ath10k_err(ar, "Faile to get early alloc val: %d\n", ret);
 		return ret;
 	}
 
@@ -1664,7 +1668,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 
 	ret = ath10k_pci_diag_write_access(ar, ealloc_targ_addr, ealloc_value);
 	if (ret != 0) {
-		ath10k_err("Failed to set early alloc val: %d\n", ret);
+		ath10k_err(ar, "Failed to set early alloc val: %d\n", ret);
 		return ret;
 	}
 
@@ -1673,7 +1677,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 
 	ret = ath10k_pci_diag_read_access(ar, flag2_targ_addr, &flag2_value);
 	if (ret != 0) {
-		ath10k_err("Failed to get option val: %d\n", ret);
+		ath10k_err(ar, "Failed to get option val: %d\n", ret);
 		return ret;
 	}
 
@@ -1681,7 +1685,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 
 	ret = ath10k_pci_diag_write_access(ar, flag2_targ_addr, flag2_value);
 	if (ret != 0) {
-		ath10k_err("Failed to set option val: %d\n", ret);
+		ath10k_err(ar, "Failed to set option val: %d\n", ret);
 		return ret;
 	}
 
@@ -1695,7 +1699,7 @@ static int ath10k_pci_alloc_ce(struct ath10k *ar)
 	for (i = 0; i < CE_COUNT; i++) {
 		ret = ath10k_ce_alloc_pipe(ar, i, &host_ce_config_wlan[i]);
 		if (ret) {
-			ath10k_err("failed to allocate copy engine pipe %d: %d\n",
+			ath10k_err(ar, "failed to allocate copy engine pipe %d: %d\n",
 				   i, ret);
 			return ret;
 		}
@@ -1728,7 +1732,7 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
 
 		ret = ath10k_ce_init_pipe(ar, pipe_num, attr);
 		if (ret) {
-			ath10k_err("failed to initialize copy engine pipe %d: %d\n",
+			ath10k_err(ar, "failed to initialize copy engine pipe %d: %d\n",
 				   pipe_num, ret);
 			return ret;
 		}
@@ -1767,7 +1771,7 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 			 * Probable Target failure before we're prepared
 			 * to handle it.  Generally unexpected.
 			 */
-			ath10k_warn("early firmware event indicated\n");
+			ath10k_warn(ar, "early firmware event indicated\n");
 		}
 	}
 }
@@ -1796,16 +1800,17 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 {
 	u32 val;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot warm reset\n");
 
 	/* debug */
 	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 				PCIE_INTR_CAUSE_ADDRESS);
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot host cpu intr cause: 0x%08x\n", val);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot host cpu intr cause: 0x%08x\n",
+		   val);
 
 	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 				CPU_INTR_ADDRESS);
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot target cpu intr cause: 0x%08x\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot target cpu intr cause: 0x%08x\n",
 		   val);
 
 	/* disable pending irqs */
@@ -1848,11 +1853,12 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 	/* debug */
 	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 				PCIE_INTR_CAUSE_ADDRESS);
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot host cpu intr cause: 0x%08x\n", val);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot host cpu intr cause: 0x%08x\n",
+		   val);
 
 	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 				CPU_INTR_ADDRESS);
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot target cpu intr cause: 0x%08x\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot target cpu intr cause: 0x%08x\n",
 		   val);
 
 	/* CPU warm reset */
@@ -1863,11 +1869,12 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 
 	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
 				SOC_RESET_CONTROL_ADDRESS);
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot target reset state: 0x%08x\n", val);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot target reset state: 0x%08x\n",
+		   val);
 
 	msleep(100);
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset complete\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot warm reset complete\n");
 
 	return 0;
 }
@@ -1894,49 +1901,49 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		ret = ath10k_pci_warm_reset(ar);
 
 	if (ret) {
-		ath10k_err("failed to reset target: %d\n", ret);
+		ath10k_err(ar, "failed to reset target: %d\n", ret);
 		goto err;
 	}
 
 	ret = ath10k_pci_ce_init(ar);
 	if (ret) {
-		ath10k_err("failed to initialize CE: %d\n", ret);
+		ath10k_err(ar, "failed to initialize CE: %d\n", ret);
 		goto err;
 	}
 
 	ret = ath10k_ce_disable_interrupts(ar);
 	if (ret) {
-		ath10k_err("failed to disable CE interrupts: %d\n", ret);
+		ath10k_err(ar, "failed to disable CE interrupts: %d\n", ret);
 		goto err_ce;
 	}
 
 	ret = ath10k_pci_init_irq(ar);
 	if (ret) {
-		ath10k_err("failed to init irqs: %d\n", ret);
+		ath10k_err(ar, "failed to init irqs: %d\n", ret);
 		goto err_ce;
 	}
 
 	ret = ath10k_pci_request_early_irq(ar);
 	if (ret) {
-		ath10k_err("failed to request early irq: %d\n", ret);
+		ath10k_err(ar, "failed to request early irq: %d\n", ret);
 		goto err_deinit_irq;
 	}
 
 	ret = ath10k_pci_wait_for_target_init(ar);
 	if (ret) {
-		ath10k_err("failed to wait for target to init: %d\n", ret);
+		ath10k_err(ar, "failed to wait for target to init: %d\n", ret);
 		goto err_free_early_irq;
 	}
 
 	ret = ath10k_pci_init_config(ar);
 	if (ret) {
-		ath10k_err("failed to setup init config: %d\n", ret);
+		ath10k_err(ar, "failed to setup init config: %d\n", ret);
 		goto err_free_early_irq;
 	}
 
 	ret = ath10k_pci_wake_target_cpu(ar);
 	if (ret) {
-		ath10k_err("could not wake up target CPU: %d\n", ret);
+		ath10k_err(ar, "could not wake up target CPU: %d\n", ret);
 		goto err_free_early_irq;
 	}
 
@@ -1948,7 +1955,7 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		irq_mode = "legacy";
 
 	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
-		ath10k_info("pci irq %s irq_mode %d reset_mode %d\n",
+		ath10k_info(ar, "pci irq %s irq_mode %d reset_mode %d\n",
 			    irq_mode, ath10k_pci_irq_mode,
 			    ath10k_pci_reset_mode);
 
@@ -1980,7 +1987,7 @@ static int ath10k_pci_hif_power_up_warm(struct ath10k *ar)
 		if (ret == 0)
 			break;
 
-		ath10k_warn("failed to warm reset (attempt %d out of %d): %d\n",
+		ath10k_warn(ar, "failed to warm reset (attempt %d out of %d): %d\n",
 			    i + 1, ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS, ret);
 	}
 
@@ -1991,7 +1998,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	int ret;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif power up\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power up\n");
 
 	/*
 	 * Hardware CUS232 version 2 has some issues with cold reset and the
@@ -2003,17 +2010,17 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	 */
 	ret = ath10k_pci_hif_power_up_warm(ar);
 	if (ret) {
-		ath10k_warn("failed to power up target using warm reset: %d\n",
+		ath10k_warn(ar, "failed to power up target using warm reset: %d\n",
 			    ret);
 
 		if (ath10k_pci_reset_mode == ATH10K_PCI_RESET_WARM_ONLY)
 			return ret;
 
-		ath10k_warn("trying cold reset\n");
+		ath10k_warn(ar, "trying cold reset\n");
 
 		ret = __ath10k_pci_hif_power_up(ar, true);
 		if (ret) {
-			ath10k_err("failed to power up target using cold reset too (%d)\n",
+			ath10k_err(ar, "failed to power up target using cold reset too (%d)\n",
 				   ret);
 			return ret;
 		}
@@ -2024,7 +2031,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
 static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif power down\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power down\n");
 
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
@@ -2126,7 +2133,8 @@ static irqreturn_t ath10k_pci_per_engine_handler(int irq, void *arg)
 	int ce_id = irq - ar_pci->pdev->irq - MSI_ASSIGN_CE_INITIAL;
 
 	if (ce_id < 0 || ce_id >= ARRAY_SIZE(ar_pci->pipe_info)) {
-		ath10k_warn("unexpected/invalid irq %d ce_id %d\n", irq, ce_id);
+		ath10k_warn(ar, "unexpected/invalid irq %d ce_id %d\n", irq,
+			    ce_id);
 		return IRQ_HANDLED;
 	}
 
@@ -2210,7 +2218,7 @@ static int ath10k_pci_request_irq_msix(struct ath10k *ar)
 			  ath10k_pci_msi_fw_handler,
 			  IRQF_SHARED, "ath10k_pci", ar);
 	if (ret) {
-		ath10k_warn("failed to request MSI-X fw irq %d: %d\n",
+		ath10k_warn(ar, "failed to request MSI-X fw irq %d: %d\n",
 			    ar_pci->pdev->irq + MSI_ASSIGN_FW, ret);
 		return ret;
 	}
@@ -2220,7 +2228,7 @@ static int ath10k_pci_request_irq_msix(struct ath10k *ar)
 				  ath10k_pci_per_engine_handler,
 				  IRQF_SHARED, "ath10k_pci", ar);
 		if (ret) {
-			ath10k_warn("failed to request MSI-X ce irq %d: %d\n",
+			ath10k_warn(ar, "failed to request MSI-X ce irq %d: %d\n",
 				    ar_pci->pdev->irq + i, ret);
 
 			for (i--; i >= MSI_ASSIGN_CE_INITIAL; i--)
@@ -2243,7 +2251,7 @@ static int ath10k_pci_request_irq_msi(struct ath10k *ar)
 			  ath10k_pci_interrupt_handler,
 			  IRQF_SHARED, "ath10k_pci", ar);
 	if (ret) {
-		ath10k_warn("failed to request MSI irq %d: %d\n",
+		ath10k_warn(ar, "failed to request MSI irq %d: %d\n",
 			    ar_pci->pdev->irq, ret);
 		return ret;
 	}
@@ -2260,7 +2268,7 @@ static int ath10k_pci_request_irq_legacy(struct ath10k *ar)
 			  ath10k_pci_interrupt_handler,
 			  IRQF_SHARED, "ath10k_pci", ar);
 	if (ret) {
-		ath10k_warn("failed to request legacy irq %d: %d\n",
+		ath10k_warn(ar, "failed to request legacy irq %d: %d\n",
 			    ar_pci->pdev->irq, ret);
 		return ret;
 	}
@@ -2281,7 +2289,7 @@ static int ath10k_pci_request_irq(struct ath10k *ar)
 		return ath10k_pci_request_irq_msix(ar);
 	}
 
-	ath10k_warn("unknown irq configuration upon request\n");
+	ath10k_warn(ar, "unknown irq configuration upon request\n");
 	return -EINVAL;
 }
 
@@ -2323,7 +2331,8 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 
 	if (ath10k_pci_irq_mode != ATH10K_PCI_IRQ_AUTO &&
 	    !test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
-		ath10k_info("limiting irq mode to: %d\n", ath10k_pci_irq_mode);
+		ath10k_info(ar, "limiting irq mode to: %d\n",
+			    ath10k_pci_irq_mode);
 
 	/* Try MSI-X */
 	if (ath10k_pci_irq_mode == ATH10K_PCI_IRQ_AUTO) {
@@ -2385,7 +2394,7 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
 		pci_disable_msi(ar_pci->pdev);
 	}
 
-	ath10k_warn("unknown irq configuration upon deinit\n");
+	ath10k_warn(ar, "unknown irq configuration upon deinit\n");
 	return -EINVAL;
 }
 
@@ -2395,14 +2404,15 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	unsigned long timeout;
 	u32 val;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot waiting target to initialise\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot waiting target to initialise\n");
 
 	timeout = jiffies + msecs_to_jiffies(ATH10K_PCI_TARGET_WAIT);
 
 	do {
 		val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
 
-		ath10k_dbg(ATH10K_DBG_BOOT, "boot target indicator %x\n", val);
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot target indicator %x\n",
+			   val);
 
 		/* target should never return this */
 		if (val == 0xffffffff)
@@ -2425,12 +2435,12 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	} while (time_before(jiffies, timeout));
 
 	if (val == 0xffffffff) {
-		ath10k_err("failed to read device register, device is gone\n");
+		ath10k_err(ar, "failed to read device register, device is gone\n");
 		return -EIO;
 	}
 
 	if (val & FW_IND_EVENT_PENDING) {
-		ath10k_warn("device has crashed during init\n");
+		ath10k_warn(ar, "device has crashed during init\n");
 		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
 				   val & ~FW_IND_EVENT_PENDING);
 		ath10k_pci_hif_dump_area(ar);
@@ -2438,12 +2448,12 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	}
 
 	if (!(val & FW_IND_INITIALIZED)) {
-		ath10k_err("failed to receive initialized event from target: %08x\n",
+		ath10k_err(ar, "failed to receive initialized event from target: %08x\n",
 			   val);
 		return -ETIMEDOUT;
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot target initialised\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot target initialised\n");
 	return 0;
 }
 
@@ -2452,7 +2462,7 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 	int i;
 	u32 val;
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot cold reset\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cold reset\n");
 
 	/* Put Target, including PCIe, into RESET. */
 	val = ath10k_pci_reg_read32(ar, SOC_GLOBAL_RESET_ADDRESS);
@@ -2477,7 +2487,7 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 		msleep(1);
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot cold reset complete\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cold reset complete\n");
 
 	return 0;
 }
@@ -2493,13 +2503,13 @@ static int ath10k_pci_claim(struct ath10k *ar)
 
 	ret = pci_enable_device(pdev);
 	if (ret) {
-		ath10k_err("failed to enable pci device: %d\n", ret);
+		ath10k_err(ar, "failed to enable pci device: %d\n", ret);
 		return ret;
 	}
 
 	ret = pci_request_region(pdev, BAR_NUM, "ath");
 	if (ret) {
-		ath10k_err("failed to request region BAR%d: %d\n", BAR_NUM,
+		ath10k_err(ar, "failed to request region BAR%d: %d\n", BAR_NUM,
 			   ret);
 		goto err_device;
 	}
@@ -2507,13 +2517,13 @@ static int ath10k_pci_claim(struct ath10k *ar)
 	/* Target expects 32 bit DMA. Enforce it. */
 	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		ath10k_err("failed to set dma mask to 32-bit: %d\n", ret);
+		ath10k_err(ar, "failed to set dma mask to 32-bit: %d\n", ret);
 		goto err_region;
 	}
 
 	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		ath10k_err("failed to set consistent dma mask to 32-bit: %d\n",
+		ath10k_err(ar, "failed to set consistent dma mask to 32-bit: %d\n",
 			   ret);
 		goto err_region;
 	}
@@ -2527,12 +2537,12 @@ static int ath10k_pci_claim(struct ath10k *ar)
 	/* Arrange for access to Target SoC registers. */
 	ar_pci->mem = pci_iomap(pdev, BAR_NUM, 0);
 	if (!ar_pci->mem) {
-		ath10k_err("failed to iomap BAR%d\n", BAR_NUM);
+		ath10k_err(ar, "failed to iomap BAR%d\n", BAR_NUM);
 		ret = -EIO;
 		goto err_master;
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot pci_mem 0x%p\n", ar_pci->mem);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot pci_mem 0x%p\n", ar_pci->mem);
 	return 0;
 
 err_master:
@@ -2566,12 +2576,12 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	struct ath10k_pci *ar_pci;
 	u32 chip_id;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "pci probe\n");
+	dev_printk(KERN_DEBUG, &pdev->dev, "pci probe\n");
 
 	ar = ath10k_core_create(sizeof(*ar_pci), &pdev->dev,
 				&ath10k_pci_hif_ops);
 	if (!ar) {
-		ath10k_err("failed to allocate core\n");
+		dev_err(&pdev->dev, "failed to allocate core\n");
 		return -ENOMEM;
 	}
 
@@ -2584,31 +2594,32 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	ret = ath10k_pci_claim(ar);
 	if (ret) {
-		ath10k_err("failed to claim device: %d\n", ret);
+		ath10k_err(ar, "failed to claim device: %d\n", ret);
 		goto err_core_destroy;
 	}
 
 	ret = ath10k_pci_wake(ar);
 	if (ret) {
-		ath10k_err("failed to wake up: %d\n", ret);
+		ath10k_err(ar, "failed to wake up: %d\n", ret);
 		goto err_release;
 	}
 
 	chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 	if (chip_id == 0xffffffff) {
-		ath10k_err("failed to get chip id\n");
+		ath10k_err(ar, "failed to get chip id\n");
 		goto err_sleep;
 	}
 
 	ret = ath10k_pci_alloc_ce(ar);
 	if (ret) {
-		ath10k_err("failed to allocate copy engine pipes: %d\n", ret);
+		ath10k_err(ar, "failed to allocate copy engine pipes: %d\n",
+			   ret);
 		goto err_sleep;
 	}
 
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
-		ath10k_err("failed to register driver core: %d\n", ret);
+		ath10k_err(ar, "failed to register driver core: %d\n", ret);
 		goto err_free_ce;
 	}
 
@@ -2634,7 +2645,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	struct ath10k *ar = pci_get_drvdata(pdev);
 	struct ath10k_pci *ar_pci;
 
-	ath10k_dbg(ATH10K_DBG_PCI, "pci remove\n");
+	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci remove\n");
 
 	if (!ar)
 		return;
@@ -2666,7 +2677,8 @@ static int __init ath10k_pci_init(void)
 
 	ret = pci_register_driver(&ath10k_pci_driver);
 	if (ret)
-		ath10k_err("failed to register PCI driver: %d\n", ret);
+		printk(KERN_ERR "failed to register ath10k pci driver: %d\n",
+		       ret);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index a53afc2..3e1454b 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -237,7 +237,7 @@ static int ath10k_spectral_scan_config(struct ath10k *ar,
 					      WMI_SPECTRAL_TRIGGER_CMD_CLEAR,
 					      WMI_SPECTRAL_ENABLE_CMD_DISABLE);
 	if (res < 0) {
-		ath10k_warn("failed to enable spectral scan: %d\n", res);
+		ath10k_warn(ar, "failed to enable spectral scan: %d\n", res);
 		return res;
 	}
 
@@ -271,7 +271,7 @@ static int ath10k_spectral_scan_config(struct ath10k *ar,
 
 	res = ath10k_wmi_vdev_spectral_conf(ar, &arg);
 	if (res < 0) {
-		ath10k_warn("failed to configure spectral scan: %d\n", res);
+		ath10k_warn(ar, "failed to configure spectral scan: %d\n", res);
 		return res;
 	}
 
@@ -332,12 +332,12 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 			res = ath10k_spectral_scan_config(ar,
 							  ar->spectral.mode);
 			if (res < 0) {
-				ath10k_warn("failed to reconfigure spectral scan: %d\n",
+				ath10k_warn(ar, "failed to reconfigure spectral scan: %d\n",
 					    res);
 			}
 			res = ath10k_spectral_scan_trigger(ar);
 			if (res < 0) {
-				ath10k_warn("failed to trigger spectral scan: %d\n",
+				ath10k_warn(ar, "failed to trigger spectral scan: %d\n",
 					    res);
 			}
 		} else {
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index f4fa22d..2eeec8a 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -32,14 +32,14 @@ static void ath10k_report_offchan_tx(struct ath10k *ar, struct sk_buff *skb)
 	 * offchan_tx_skb. */
 	spin_lock_bh(&ar->data_lock);
 	if (ar->offchan_tx_skb != skb) {
-		ath10k_warn("completed old offchannel frame\n");
+		ath10k_warn(ar, "completed old offchannel frame\n");
 		goto out;
 	}
 
 	complete(&ar->offchan_tx_completed);
 	ar->offchan_tx_skb = NULL; /* just for sanity */
 
-	ath10k_dbg(ATH10K_DBG_HTT, "completed offchannel skb %p\n", skb);
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "completed offchannel skb %p\n", skb);
 out:
 	spin_unlock_bh(&ar->data_lock);
 }
@@ -47,18 +47,19 @@ out:
 void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 			  const struct htt_tx_done *tx_done)
 {
-	struct device *dev = htt->ar->dev;
+	struct ath10k *ar = htt->ar;
+	struct device *dev = ar->dev;
 	struct ieee80211_tx_info *info;
 	struct ath10k_skb_cb *skb_cb;
 	struct sk_buff *msdu;
 
 	lockdep_assert_held(&htt->tx_lock);
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt tx completion msdu_id %u discard %d no_ack %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx completion msdu_id %u discard %d no_ack %d\n",
 		   tx_done->msdu_id, !!tx_done->discard, !!tx_done->no_ack);
 
 	if (tx_done->msdu_id >= htt->max_num_pending_tx) {
-		ath10k_warn("warning: msdu_id %d too big, ignoring\n",
+		ath10k_warn(ar, "warning: msdu_id %d too big, ignoring\n",
 			    tx_done->msdu_id);
 		return;
 	}
@@ -182,7 +183,7 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
 		wake_up(&ar->peer_mapping_wq);
 	}
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt peer map vdev %d peer %pM id %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt peer map vdev %d peer %pM id %d\n",
 		   ev->vdev_id, ev->addr, ev->peer_id);
 
 	set_bit(ev->peer_id, peer->peer_ids);
@@ -199,12 +200,12 @@ void ath10k_peer_unmap_event(struct ath10k_htt *htt,
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, ev->peer_id);
 	if (!peer) {
-		ath10k_warn("peer-unmap-event: unknown peer id %d\n",
+		ath10k_warn(ar, "peer-unmap-event: unknown peer id %d\n",
 			    ev->peer_id);
 		goto exit;
 	}
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt peer unmap vdev %d peer %pM id %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt peer unmap vdev %d peer %pM id %d\n",
 		   peer->vdev_id, peer->addr, ev->peer_id);
 
 	clear_bit(ev->peer_id, peer->peer_ids);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 23acbad..72c5055 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -624,18 +624,18 @@ int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar)
 	return ret;
 }
 
-static struct sk_buff *ath10k_wmi_alloc_skb(u32 len)
+static struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len)
 {
 	struct sk_buff *skb;
 	u32 round_len = roundup(len, 4);
 
-	skb = ath10k_htc_alloc_skb(WMI_SKB_HEADROOM + round_len);
+	skb = ath10k_htc_alloc_skb(ar, WMI_SKB_HEADROOM + round_len);
 	if (!skb)
 		return NULL;
 
 	skb_reserve(skb, WMI_SKB_HEADROOM);
 	if (!IS_ALIGNED((unsigned long)skb->data, 4))
-		ath10k_warn("Unaligned WMI skb\n");
+		ath10k_warn(ar, "Unaligned WMI skb\n");
 
 	skb_put(skb, round_len);
 	memset(skb->data, 0, round_len);
@@ -733,7 +733,7 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 	might_sleep();
 
 	if (cmd_id == WMI_CMD_UNSUPPORTED) {
-		ath10k_warn("wmi command %d is not supported by firmware\n",
+		ath10k_warn(ar, "wmi command %d is not supported by firmware\n",
 			    cmd_id);
 		return ret;
 	}
@@ -781,7 +781,7 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 
 	len = round_up(len, 4);
 
-	wmi_skb = ath10k_wmi_alloc_skb(len);
+	wmi_skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!wmi_skb)
 		return -ENOMEM;
 
@@ -795,7 +795,7 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	memcpy(cmd->hdr.peer_macaddr.addr, ieee80211_get_DA(hdr), ETH_ALEN);
 	memcpy(cmd->buf, skb->data, skb->len);
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
 		   wmi_skb, wmi_skb->len, fc & IEEE80211_FCTL_FTYPE,
 		   fc & IEEE80211_FCTL_STYPE);
 
@@ -819,7 +819,7 @@ static void ath10k_wmi_event_scan_started(struct ath10k *ar)
 	case ATH10K_SCAN_IDLE:
 	case ATH10K_SCAN_RUNNING:
 	case ATH10K_SCAN_ABORTING:
-		ath10k_warn("received scan started event in an invalid scan state: %s (%d)\n",
+		ath10k_warn(ar, "received scan started event in an invalid scan state: %s (%d)\n",
 			    ath10k_scan_state_str(ar->scan.state),
 			    ar->scan.state);
 		break;
@@ -849,7 +849,7 @@ static void ath10k_wmi_event_scan_completed(struct ath10k *ar)
 		 * is) ignored by the host as it may be just firmware's scan
 		 * state machine recovering.
 		 */
-		ath10k_warn("received scan completed event in an invalid scan state: %s (%d)\n",
+		ath10k_warn(ar, "received scan completed event in an invalid scan state: %s (%d)\n",
 			    ath10k_scan_state_str(ar->scan.state),
 			    ar->scan.state);
 		break;
@@ -867,7 +867,7 @@ static void ath10k_wmi_event_scan_bss_chan(struct ath10k *ar)
 	switch (ar->scan.state) {
 	case ATH10K_SCAN_IDLE:
 	case ATH10K_SCAN_STARTING:
-		ath10k_warn("received scan bss chan event in an invalid scan state: %s (%d)\n",
+		ath10k_warn(ar, "received scan bss chan event in an invalid scan state: %s (%d)\n",
 			    ath10k_scan_state_str(ar->scan.state),
 			    ar->scan.state);
 		break;
@@ -885,7 +885,7 @@ static void ath10k_wmi_event_scan_foreign_chan(struct ath10k *ar, u32 freq)
 	switch (ar->scan.state) {
 	case ATH10K_SCAN_IDLE:
 	case ATH10K_SCAN_STARTING:
-		ath10k_warn("received scan foreign chan event in an invalid scan state: %s (%d)\n",
+		ath10k_warn(ar, "received scan foreign chan event in an invalid scan state: %s (%d)\n",
 			    ath10k_scan_state_str(ar->scan.state),
 			    ar->scan.state);
 		break;
@@ -954,7 +954,7 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 
 	spin_lock_bh(&ar->data_lock);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "scan event %s type %d reason %d freq %d req_id %d scan_id %d vdev_id %d state %s (%d)\n",
 		   ath10k_wmi_event_scan_type_str(event_type, reason),
 		   event_type, reason, freq, req_id, scan_id, vdev_id,
@@ -974,7 +974,7 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_scan_foreign_chan(ar, freq);
 		break;
 	case WMI_SCAN_EVENT_START_FAILED:
-		ath10k_warn("received scan start failure event\n");
+		ath10k_warn(ar, "received scan start failure event\n");
 		break;
 	case WMI_SCAN_EVENT_DEQUEUED:
 	case WMI_SCAN_EVENT_PREEMPTED:
@@ -1107,7 +1107,7 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	memset(status, 0, sizeof(*status));
 
-	ath10k_dbg(ATH10K_DBG_MGMT,
+	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx status %08x\n", rx_status);
 
 	if (test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags)) {
@@ -1143,9 +1143,9 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 
 		if (phy_mode == MODE_11B &&
 		    status->band == IEEE80211_BAND_5GHZ)
-			ath10k_dbg(ATH10K_DBG_MGMT, "wmi mgmt rx 11b (CCK) on 5GHz\n");
+			ath10k_dbg(ar, ATH10K_DBG_MGMT, "wmi mgmt rx 11b (CCK) on 5GHz\n");
 	} else {
-		ath10k_warn("using (unreliable) phy_mode to extract band for mgmt rx\n");
+		ath10k_warn(ar, "using (unreliable) phy_mode to extract band for mgmt rx\n");
 		status->band = phy_mode_to_band(phy_mode);
 	}
 
@@ -1175,12 +1175,12 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		}
 	}
 
-	ath10k_dbg(ATH10K_DBG_MGMT,
+	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx skb %p len %d ftype %02x stype %02x\n",
 		   skb, skb->len,
 		   fc & IEEE80211_FCTL_FTYPE, fc & IEEE80211_FCTL_STYPE);
 
-	ath10k_dbg(ATH10K_DBG_MGMT,
+	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx freq %d band %d snr %d, rate_idx %d\n",
 		   status->freq, status->band, status->signal,
 		   status->rate_idx);
@@ -1230,7 +1230,7 @@ static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 	rx_clear_count = __le32_to_cpu(ev->rx_clear_count);
 	cycle_count = __le32_to_cpu(ev->cycle_count);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "chan info err_code %d freq %d cmd_flags %d noise_floor %d rx_clear_count %d cycle_count %d\n",
 		   err_code, freq, cmd_flags, noise_floor, rx_clear_count,
 		   cycle_count);
@@ -1240,7 +1240,7 @@ static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 	switch (ar->scan.state) {
 	case ATH10K_SCAN_IDLE:
 	case ATH10K_SCAN_STARTING:
-		ath10k_warn("received chan info event without a scan request, ignoring\n");
+		ath10k_warn(ar, "received chan info event without a scan request, ignoring\n");
 		goto exit;
 	case ATH10K_SCAN_RUNNING:
 	case ATH10K_SCAN_ABORTING:
@@ -1249,7 +1249,7 @@ static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 
 	idx = freq_to_idx(ar, freq);
 	if (idx >= ARRAY_SIZE(ar->survey)) {
-		ath10k_warn("chan info: invalid frequency %d (idx %d out of bounds)\n",
+		ath10k_warn(ar, "chan info: invalid frequency %d (idx %d out of bounds)\n",
 			    freq, idx);
 		goto exit;
 	}
@@ -1280,12 +1280,12 @@ exit:
 
 static void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_ECHO_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_ECHO_EVENTID\n");
 }
 
 static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi event debug mesg len %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug mesg len %d\n",
 		   skb->len);
 
 	trace_ath10k_wmi_dbglog(skb->data, skb->len);
@@ -1298,7 +1298,7 @@ static void ath10k_wmi_event_update_stats(struct ath10k *ar,
 {
 	struct wmi_stats_event *ev = (struct wmi_stats_event *)skb->data;
 
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_UPDATE_STATS_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_UPDATE_STATS_EVENTID\n");
 
 	ath10k_debug_read_target_stats(ar, ev);
 }
@@ -1308,7 +1308,7 @@ static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
 {
 	struct wmi_vdev_start_response_event *ev;
 
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_START_RESP_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_START_RESP_EVENTID\n");
 
 	ev = (struct wmi_vdev_start_response_event *)skb->data;
 
@@ -1321,7 +1321,7 @@ static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
 static void ath10k_wmi_event_vdev_stopped(struct ath10k *ar,
 					  struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_STOPPED_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_STOPPED_EVENTID\n");
 	complete(&ar->vdev_setup_done);
 }
 
@@ -1333,14 +1333,14 @@ static void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar,
 
 	ev = (struct wmi_peer_sta_kickout_event *)skb->data;
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi event peer sta kickout %pM\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event peer sta kickout %pM\n",
 		   ev->peer_macaddr.addr);
 
 	rcu_read_lock();
 
 	sta = ieee80211_find_sta_by_ifaddr(ar->hw, ev->peer_macaddr.addr, NULL);
 	if (!sta) {
-		ath10k_warn("Spurious quick kickout for STA %pM\n",
+		ath10k_warn(ar, "Spurious quick kickout for STA %pM\n",
 			    ev->peer_macaddr.addr);
 		goto exit;
 	}
@@ -1417,7 +1417,7 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 				    (u8 *)skb_tail_pointer(bcn) - ies);
 	if (!ie) {
 		if (arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
-			ath10k_warn("no tim ie found;\n");
+			ath10k_warn(ar, "no tim ie found;\n");
 		return;
 	}
 
@@ -1437,12 +1437,12 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 			ie_len += expand_size;
 			pvm_len += expand_size;
 		} else {
-			ath10k_warn("tim expansion failed\n");
+			ath10k_warn(ar, "tim expansion failed\n");
 		}
 	}
 
 	if (pvm_len > sizeof(arvif->u.ap.tim_bitmap)) {
-		ath10k_warn("tim pvm length is too great (%d)\n", pvm_len);
+		ath10k_warn(ar, "tim pvm length is too great (%d)\n", pvm_len);
 		return;
 	}
 
@@ -1456,7 +1456,7 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 			ATH10K_SKB_CB(bcn)->bcn.deliver_cab = true;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MGMT, "dtim %d/%d mcast %d pvmlen %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_MGMT, "dtim %d/%d mcast %d pvmlen %d\n",
 		   tim->dtim_count, tim->dtim_period,
 		   tim->bitmap_ctrl, pvm_len);
 }
@@ -1534,7 +1534,7 @@ static void ath10k_wmi_update_noa(struct ath10k *ar, struct ath10k_vif *arvif,
 	if (arvif->vdev_subtype != WMI_VDEV_SUBTYPE_P2P_GO)
 		return;
 
-	ath10k_dbg(ATH10K_DBG_MGMT, "noa changed: %d\n", noa->changed);
+	ath10k_dbg(ar, ATH10K_DBG_MGMT, "noa changed: %d\n", noa->changed);
 	if (noa->changed & WMI_P2P_NOA_CHANGED_BIT) {
 		new_len = ath10k_p2p_calc_noa_ie_len(noa);
 		if (!new_len)
@@ -1582,7 +1582,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 	ev = (struct wmi_host_swba_event *)skb->data;
 	map = __le32_to_cpu(ev->vdev_map);
 
-	ath10k_dbg(ATH10K_DBG_MGMT, "mgmt swba vdev_map 0x%x\n",
+	ath10k_dbg(ar, ATH10K_DBG_MGMT, "mgmt swba vdev_map 0x%x\n",
 		   ev->vdev_map);
 
 	for (; map; map >>= 1, vdev_id++) {
@@ -1592,13 +1592,13 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		i++;
 
 		if (i >= WMI_MAX_AP_VDEV) {
-			ath10k_warn("swba has corrupted vdev map\n");
+			ath10k_warn(ar, "swba has corrupted vdev map\n");
 			break;
 		}
 
 		bcn_info = &ev->bcn_info[i];
 
-		ath10k_dbg(ATH10K_DBG_MGMT,
+		ath10k_dbg(ar, ATH10K_DBG_MGMT,
 			   "mgmt event bcn_info %d tim_len %d mcast %d changed %d num_ps_pending %d bitmap 0x%08x%08x%08x%08x\n",
 			   i,
 			   __le32_to_cpu(bcn_info->tim_info.tim_len),
@@ -1612,7 +1612,8 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 
 		arvif = ath10k_get_arvif(ar, vdev_id);
 		if (arvif == NULL) {
-			ath10k_warn("no vif for vdev_id %d found\n", vdev_id);
+			ath10k_warn(ar, "no vif for vdev_id %d found\n",
+				    vdev_id);
 			continue;
 		}
 
@@ -1629,7 +1630,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 
 		bcn = ieee80211_beacon_get(ar->hw, arvif->vif);
 		if (!bcn) {
-			ath10k_warn("could not get mac80211 beacon\n");
+			ath10k_warn(ar, "could not get mac80211 beacon\n");
 			continue;
 		}
 
@@ -1641,7 +1642,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 
 		if (arvif->beacon) {
 			if (!arvif->beacon_sent)
-				ath10k_warn("SWBA overrun on vdev %d\n",
+				ath10k_warn(ar, "SWBA overrun on vdev %d\n",
 					    arvif->vdev_id);
 
 			dma_unmap_single(arvif->ar->dev,
@@ -1657,7 +1658,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		ret = dma_mapping_error(arvif->ar->dev,
 					ATH10K_SKB_CB(bcn)->paddr);
 		if (ret) {
-			ath10k_warn("failed to map beacon: %d\n", ret);
+			ath10k_warn(ar, "failed to map beacon: %d\n", ret);
 			dev_kfree_skb_any(bcn);
 			goto skip;
 		}
@@ -1674,7 +1675,7 @@ skip:
 static void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar,
 					       struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_TBTTOFFSET_UPDATE_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TBTTOFFSET_UPDATE_EVENTID\n");
 }
 
 static void ath10k_dfs_radar_report(struct ath10k *ar,
@@ -1690,20 +1691,20 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 	reg0 = __le32_to_cpu(rr->reg0);
 	reg1 = __le32_to_cpu(rr->reg1);
 
-	ath10k_dbg(ATH10K_DBG_REGULATORY,
+	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "wmi phyerr radar report chirp %d max_width %d agc_total_gain %d pulse_delta_diff %d\n",
 		   MS(reg0, RADAR_REPORT_REG0_PULSE_IS_CHIRP),
 		   MS(reg0, RADAR_REPORT_REG0_PULSE_IS_MAX_WIDTH),
 		   MS(reg0, RADAR_REPORT_REG0_AGC_TOTAL_GAIN),
 		   MS(reg0, RADAR_REPORT_REG0_PULSE_DELTA_DIFF));
-	ath10k_dbg(ATH10K_DBG_REGULATORY,
+	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "wmi phyerr radar report pulse_delta_pean %d pulse_sidx %d fft_valid %d agc_mb_gain %d subchan_mask %d\n",
 		   MS(reg0, RADAR_REPORT_REG0_PULSE_DELTA_PEAK),
 		   MS(reg0, RADAR_REPORT_REG0_PULSE_SIDX),
 		   MS(reg1, RADAR_REPORT_REG1_PULSE_SRCH_FFT_VALID),
 		   MS(reg1, RADAR_REPORT_REG1_PULSE_AGC_MB_GAIN),
 		   MS(reg1, RADAR_REPORT_REG1_PULSE_SUBCHAN_MASK));
-	ath10k_dbg(ATH10K_DBG_REGULATORY,
+	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "wmi phyerr radar report pulse_tsf_offset 0x%X pulse_dur: %d\n",
 		   MS(reg1, RADAR_REPORT_REG1_PULSE_TSF_OFFSET),
 		   MS(reg1, RADAR_REPORT_REG1_PULSE_DUR));
@@ -1730,25 +1731,25 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 	pe.width = width;
 	pe.rssi = rssi;
 
-	ath10k_dbg(ATH10K_DBG_REGULATORY,
+	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "dfs add pulse freq: %d, width: %d, rssi %d, tsf: %llX\n",
 		   pe.freq, pe.width, pe.rssi, pe.ts);
 
 	ATH10K_DFS_STAT_INC(ar, pulses_detected);
 
 	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe)) {
-		ath10k_dbg(ATH10K_DBG_REGULATORY,
+		ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 			   "dfs no pulse pattern detected, yet\n");
 		return;
 	}
 
-	ath10k_dbg(ATH10K_DBG_REGULATORY, "dfs radar detected\n");
+	ath10k_dbg(ar, ATH10K_DBG_REGULATORY, "dfs radar detected\n");
 	ATH10K_DFS_STAT_INC(ar, radar_detected);
 
 	/* Control radar events reporting in debugfs file
 	   dfs_block_radar_events */
 	if (ar->dfs_block_radar_events) {
-		ath10k_info("DFS Radar detected, but ignored as requested\n");
+		ath10k_info(ar, "DFS Radar detected, but ignored as requested\n");
 		return;
 	}
 
@@ -1767,13 +1768,13 @@ static int ath10k_dfs_fft_report(struct ath10k *ar,
 	reg1 = __le32_to_cpu(fftr->reg1);
 	rssi = event->hdr.rssi_combined;
 
-	ath10k_dbg(ATH10K_DBG_REGULATORY,
+	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "wmi phyerr fft report total_gain_db %d base_pwr_db %d fft_chn_idx %d peak_sidx %d\n",
 		   MS(reg0, SEARCH_FFT_REPORT_REG0_TOTAL_GAIN_DB),
 		   MS(reg0, SEARCH_FFT_REPORT_REG0_BASE_PWR_DB),
 		   MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX),
 		   MS(reg0, SEARCH_FFT_REPORT_REG0_PEAK_SIDX));
-	ath10k_dbg(ATH10K_DBG_REGULATORY,
+	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "wmi phyerr fft report rel_pwr_db %d avgpwr_db %d peak_mag %d num_store_bin %d\n",
 		   MS(reg1, SEARCH_FFT_REPORT_REG1_RELPWR_DB),
 		   MS(reg1, SEARCH_FFT_REPORT_REG1_AVGPWR_DB),
@@ -1785,7 +1786,7 @@ static int ath10k_dfs_fft_report(struct ath10k *ar,
 	/* false event detection */
 	if (rssi == DFS_RSSI_POSSIBLY_FALSE &&
 	    peak_mag < 2 * DFS_PEAK_MAG_THOLD_POSSIBLY_FALSE) {
-		ath10k_dbg(ATH10K_DBG_REGULATORY, "dfs false pulse detected\n");
+		ath10k_dbg(ar, ATH10K_DBG_REGULATORY, "dfs false pulse detected\n");
 		ATH10K_DFS_STAT_INC(ar, pulses_discarded);
 		return -EINVAL;
 	}
@@ -1804,7 +1805,7 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
 	u8 *tlv_buf;
 
 	buf_len = __le32_to_cpu(event->hdr.buf_len);
-	ath10k_dbg(ATH10K_DBG_REGULATORY,
+	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "wmi event dfs err_code %d rssi %d tsfl 0x%X tsf64 0x%llX len %d\n",
 		   event->hdr.phy_err_code, event->hdr.rssi_combined,
 		   __le32_to_cpu(event->hdr.tsf_timestamp), tsf, buf_len);
@@ -1817,21 +1818,22 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
 
 	while (i < buf_len) {
 		if (i + sizeof(*tlv) > buf_len) {
-			ath10k_warn("too short buf for tlv header (%d)\n", i);
+			ath10k_warn(ar, "too short buf for tlv header (%d)\n",
+				    i);
 			return;
 		}
 
 		tlv = (struct phyerr_tlv *)&event->bufp[i];
 		tlv_len = __le16_to_cpu(tlv->len);
 		tlv_buf = &event->bufp[i + sizeof(*tlv)];
-		ath10k_dbg(ATH10K_DBG_REGULATORY,
+		ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 			   "wmi event dfs tlv_len %d tlv_tag 0x%02X tlv_sig 0x%02X\n",
 			   tlv_len, tlv->tag, tlv->sig);
 
 		switch (tlv->tag) {
 		case PHYERR_TLV_TAG_RADAR_PULSE_SUMMARY:
 			if (i + sizeof(*tlv) + sizeof(*rr) > buf_len) {
-				ath10k_warn("too short radar pulse summary (%d)\n",
+				ath10k_warn(ar, "too short radar pulse summary (%d)\n",
 					    i);
 				return;
 			}
@@ -1841,7 +1843,8 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
 			break;
 		case PHYERR_TLV_TAG_SEARCH_FFT_REPORT:
 			if (i + sizeof(*tlv) + sizeof(*fftr) > buf_len) {
-				ath10k_warn("too short fft report (%d)\n", i);
+				ath10k_warn(ar, "too short fft report (%d)\n",
+					    i);
 				return;
 			}
 
@@ -1870,7 +1873,7 @@ static void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 
 	while (i < buf_len) {
 		if (i + sizeof(*tlv) > buf_len) {
-			ath10k_warn("failed to parse phyerr tlv header at byte %d\n",
+			ath10k_warn(ar, "failed to parse phyerr tlv header at byte %d\n",
 				    i);
 			return;
 		}
@@ -1880,7 +1883,7 @@ static void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 		tlv_buf = &event->bufp[i + sizeof(*tlv)];
 
 		if (i + sizeof(*tlv) + tlv_len > buf_len) {
-			ath10k_warn("failed to parse phyerr tlv payload at byte %d\n",
+			ath10k_warn(ar, "failed to parse phyerr tlv payload at byte %d\n",
 				    i);
 			return;
 		}
@@ -1888,7 +1891,7 @@ static void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 		switch (tlv->tag) {
 		case PHYERR_TLV_TAG_SEARCH_FFT_REPORT:
 			if (sizeof(*fftr) > tlv_len) {
-				ath10k_warn("failed to parse fft report at byte %d\n",
+				ath10k_warn(ar, "failed to parse fft report at byte %d\n",
 					    i);
 				return;
 			}
@@ -1899,7 +1902,7 @@ static void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 							  fftr, fftr_len,
 							  tsf);
 			if (res < 0) {
-				ath10k_warn("failed to process fft report: %d\n",
+				ath10k_warn(ar, "failed to process fft report: %d\n",
 					    res);
 				return;
 			}
@@ -1922,7 +1925,7 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 
 	/* Check if combined event available */
 	if (left_len < sizeof(*comb_event)) {
-		ath10k_warn("wmi phyerr combined event wrong len\n");
+		ath10k_warn(ar, "wmi phyerr combined event wrong len\n");
 		return;
 	}
 
@@ -1936,7 +1939,7 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 	tsf <<= 32;
 	tsf |= __le32_to_cpu(comb_event->hdr.tsf_l32);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi event phyerr count %d tsf64 0x%llX\n",
 		   count, tsf);
 
@@ -1944,7 +1947,8 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 	for (i = 0; i < count; i++) {
 		/* Check if we can read event header */
 		if (left_len < sizeof(*event)) {
-			ath10k_warn("single event (%d) wrong head len\n", i);
+			ath10k_warn(ar, "single event (%d) wrong head len\n",
+				    i);
 			return;
 		}
 
@@ -1954,7 +1958,7 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 		phy_err_code = event->hdr.phy_err_code;
 
 		if (left_len < buf_len) {
-			ath10k_warn("single event (%d) wrong buf len\n", i);
+			ath10k_warn(ar, "single event (%d) wrong buf len\n", i);
 			return;
 		}
 
@@ -1981,13 +1985,13 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 
 static void ath10k_wmi_event_roam(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_ROAM_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_ROAM_EVENTID\n");
 }
 
 static void ath10k_wmi_event_profile_match(struct ath10k *ar,
 				    struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_PROFILE_MATCH\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PROFILE_MATCH\n");
 }
 
 static void ath10k_wmi_event_debug_print(struct ath10k *ar,
@@ -2012,7 +2016,7 @@ static void ath10k_wmi_event_debug_print(struct ath10k *ar,
 	}
 
 	if (i == sizeof(buf) - 1)
-		ath10k_warn("wmi debug print truncated: %d\n", skb->len);
+		ath10k_warn(ar, "wmi debug print truncated: %d\n", skb->len);
 
 	/* for some reason the debug prints end with \n, remove that */
 	if (skb->data[i - 1] == '\n')
@@ -2021,108 +2025,108 @@ static void ath10k_wmi_event_debug_print(struct ath10k *ar,
 	/* the last byte is always reserved for the null character */
 	buf[i] = '\0';
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi event debug print '%s'\n", buf);
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug print '%s'\n", buf);
 }
 
 static void ath10k_wmi_event_pdev_qvit(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_PDEV_QVIT_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PDEV_QVIT_EVENTID\n");
 }
 
 static void ath10k_wmi_event_wlan_profile_data(struct ath10k *ar,
 					       struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_WLAN_PROFILE_DATA_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_WLAN_PROFILE_DATA_EVENTID\n");
 }
 
 static void ath10k_wmi_event_rtt_measurement_report(struct ath10k *ar,
 					     struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_RTT_MEASUREMENT_REPORT_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_RTT_MEASUREMENT_REPORT_EVENTID\n");
 }
 
 static void ath10k_wmi_event_tsf_measurement_report(struct ath10k *ar,
 					     struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_TSF_MEASUREMENT_REPORT_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TSF_MEASUREMENT_REPORT_EVENTID\n");
 }
 
 static void ath10k_wmi_event_rtt_error_report(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_RTT_ERROR_REPORT_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_RTT_ERROR_REPORT_EVENTID\n");
 }
 
 static void ath10k_wmi_event_wow_wakeup_host(struct ath10k *ar,
 					     struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_WOW_WAKEUP_HOST_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_WOW_WAKEUP_HOST_EVENTID\n");
 }
 
 static void ath10k_wmi_event_dcs_interference(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_DCS_INTERFERENCE_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_DCS_INTERFERENCE_EVENTID\n");
 }
 
 static void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar,
 					     struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_PDEV_TPC_CONFIG_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PDEV_TPC_CONFIG_EVENTID\n");
 }
 
 static void ath10k_wmi_event_pdev_ftm_intg(struct ath10k *ar,
 					   struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_PDEV_FTM_INTG_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PDEV_FTM_INTG_EVENTID\n");
 }
 
 static void ath10k_wmi_event_gtk_offload_status(struct ath10k *ar,
 					 struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_GTK_OFFLOAD_STATUS_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_GTK_OFFLOAD_STATUS_EVENTID\n");
 }
 
 static void ath10k_wmi_event_gtk_rekey_fail(struct ath10k *ar,
 					    struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_GTK_REKEY_FAIL_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_GTK_REKEY_FAIL_EVENTID\n");
 }
 
 static void ath10k_wmi_event_delba_complete(struct ath10k *ar,
 					    struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_TX_DELBA_COMPLETE_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TX_DELBA_COMPLETE_EVENTID\n");
 }
 
 static void ath10k_wmi_event_addba_complete(struct ath10k *ar,
 					    struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_TX_ADDBA_COMPLETE_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TX_ADDBA_COMPLETE_EVENTID\n");
 }
 
 static void ath10k_wmi_event_vdev_install_key_complete(struct ath10k *ar,
 						struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_INSTALL_KEY_COMPLETE_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_INSTALL_KEY_COMPLETE_EVENTID\n");
 }
 
 static void ath10k_wmi_event_inst_rssi_stats(struct ath10k *ar,
 					     struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_INST_RSSI_STATS_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_INST_RSSI_STATS_EVENTID\n");
 }
 
 static void ath10k_wmi_event_vdev_standby_req(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_STANDBY_REQ_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_STANDBY_REQ_EVENTID\n");
 }
 
 static void ath10k_wmi_event_vdev_resume_req(struct ath10k *ar,
 					     struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_RESUME_REQ_EVENTID\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_RESUME_REQ_EVENTID\n");
 }
 
 static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
@@ -2142,7 +2146,7 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 							   &paddr,
 							   GFP_ATOMIC);
 	if (!ar->wmi.mem_chunks[idx].vaddr) {
-		ath10k_warn("failed to allocate memory chunk\n");
+		ath10k_warn(ar, "failed to allocate memory chunk\n");
 		return -ENOMEM;
 	}
 
@@ -2163,7 +2167,7 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_BM_SIZE) = {};
 
 	if (skb->len < sizeof(*ev)) {
-		ath10k_warn("Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
+		ath10k_warn(ar, "Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
 			    skb->len, sizeof(*ev));
 		return;
 	}
@@ -2186,7 +2190,7 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 		set_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features);
 
 	if (ar->num_rf_chains > WMI_MAX_SPATIAL_STREAM) {
-		ath10k_warn("hardware advertises support for more spatial streams than it should (%d > %d)\n",
+		ath10k_warn(ar, "hardware advertises support for more spatial streams than it should (%d > %d)\n",
 			    ar->num_rf_chains, WMI_MAX_SPATIAL_STREAM);
 		ar->num_rf_chains = WMI_MAX_SPATIAL_STREAM;
 	}
@@ -2196,7 +2200,7 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 
 	wmi_10x_svc_map(ev->wmi_service_bitmap, svc_bmap);
 	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
-	ath10k_dbg_dump(ATH10K_DBG_WMI, NULL, "ath10k: wmi svc: ",
+	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
 			ev->wmi_service_bitmap, sizeof(ev->wmi_service_bitmap));
 
 	if (strlen(ar->hw->wiphy->fw_version) == 0) {
@@ -2211,11 +2215,11 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 
 	/* FIXME: it probably should be better to support this */
 	if (__le32_to_cpu(ev->num_mem_reqs) > 0) {
-		ath10k_warn("target requested %d memory chunks; ignoring\n",
+		ath10k_warn(ar, "target requested %d memory chunks; ignoring\n",
 			    __le32_to_cpu(ev->num_mem_reqs));
 	}
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi event service ready sw_ver 0x%08x sw_ver1 0x%08x abi_ver %u phy_cap 0x%08x ht_cap 0x%08x vht_cap 0x%08x vht_supp_msc 0x%08x sys_cap_info 0x%08x mem_reqs %u num_rf_chains %u\n",
 		   __le32_to_cpu(ev->sw_version),
 		   __le32_to_cpu(ev->sw_version_1),
@@ -2240,7 +2244,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_BM_SIZE) = {};
 
 	if (skb->len < sizeof(*ev)) {
-		ath10k_warn("Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
+		ath10k_warn(ar, "Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
 			    skb->len, sizeof(*ev));
 		return;
 	}
@@ -2256,7 +2260,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	ar->num_rf_chains = __le32_to_cpu(ev->num_rf_chains);
 
 	if (ar->num_rf_chains > WMI_MAX_SPATIAL_STREAM) {
-		ath10k_warn("hardware advertises support for more spatial streams than it should (%d > %d)\n",
+		ath10k_warn(ar, "hardware advertises support for more spatial streams than it should (%d > %d)\n",
 			    ar->num_rf_chains, WMI_MAX_SPATIAL_STREAM);
 		ar->num_rf_chains = WMI_MAX_SPATIAL_STREAM;
 	}
@@ -2266,7 +2270,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 
 	wmi_main_svc_map(ev->wmi_service_bitmap, svc_bmap);
 	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
-	ath10k_dbg_dump(ATH10K_DBG_WMI, NULL, "ath10k: wmi svc: ",
+	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
 			ev->wmi_service_bitmap, sizeof(ev->wmi_service_bitmap));
 
 	if (strlen(ar->hw->wiphy->fw_version) == 0) {
@@ -2280,7 +2284,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	num_mem_reqs = __le32_to_cpu(ev->num_mem_reqs);
 
 	if (num_mem_reqs > ATH10K_MAX_MEM_REQS) {
-		ath10k_warn("requested memory chunks number (%d) exceeds the limit\n",
+		ath10k_warn(ar, "requested memory chunks number (%d) exceeds the limit\n",
 			    num_mem_reqs);
 		return;
 	}
@@ -2288,7 +2292,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	if (!num_mem_reqs)
 		goto exit;
 
-	ath10k_dbg(ATH10K_DBG_WMI, "firmware has requested %d memory chunks\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "firmware has requested %d memory chunks\n",
 		   num_mem_reqs);
 
 	for (i = 0; i < num_mem_reqs; ++i) {
@@ -2306,7 +2310,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 		else if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS)
 			num_units = TARGET_10X_NUM_VDEVS + 1;
 
-		ath10k_dbg(ATH10K_DBG_WMI,
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "wmi mem_req_id %d num_units %d num_unit_info %d unit size %d actual units %d\n",
 			   req_id,
 			   __le32_to_cpu(ev->mem_reqs[i].num_units),
@@ -2321,7 +2325,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	}
 
 exit:
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi event service ready sw_ver 0x%08x abi_ver %u phy_cap 0x%08x ht_cap 0x%08x vht_cap 0x%08x vht_supp_msc 0x%08x sys_cap_info 0x%08x mem_reqs %u num_rf_chains %u\n",
 		   __le32_to_cpu(ev->sw_version),
 		   __le32_to_cpu(ev->abi_version),
@@ -2345,7 +2349,7 @@ static int ath10k_wmi_ready_event_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	memcpy(ar->mac_addr, ev->mac_addr.addr, ETH_ALEN);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi event ready sw_version %u abi_version %u mac_addr %pM status %d skb->len %i ev-sz %zu\n",
 		   __le32_to_cpu(ev->sw_version),
 		   __le32_to_cpu(ev->abi_version),
@@ -2465,7 +2469,7 @@ static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_ready_event_rx(ar, skb);
 		break;
 	default:
-		ath10k_warn("Unknown eventid: %d\n", id);
+		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
 	}
 
@@ -2572,7 +2576,7 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_ready_event_rx(ar, skb);
 		break;
 	default:
-		ath10k_warn("Unknown eventid: %d\n", id);
+		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
 	}
 
@@ -2685,11 +2689,11 @@ static void ath10k_wmi_10_2_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_2_MCAST_BUF_RELEASE_EVENTID:
 	case WMI_10_2_MCAST_LIST_AGEOUT_EVENTID:
 	case WMI_10_2_WDS_PEER_EVENTID:
-		ath10k_dbg(ATH10K_DBG_WMI,
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "received event id %d not implemented\n", id);
 		break;
 	default:
-		ath10k_warn("Unknown eventid: %d\n", id);
+		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
 	}
 
@@ -2766,7 +2770,7 @@ int ath10k_wmi_connect(struct ath10k *ar)
 
 	status = ath10k_htc_connect_service(&ar->htc, &conn_req, &conn_resp);
 	if (status) {
-		ath10k_warn("failed to connect to WMI CONTROL service status: %d\n",
+		ath10k_warn(ar, "failed to connect to WMI CONTROL service status: %d\n",
 			    status);
 		return status;
 	}
@@ -2782,7 +2786,7 @@ static int ath10k_wmi_main_pdev_set_regdomain(struct ath10k *ar, u16 rd,
 	struct wmi_pdev_set_regdomain_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -2793,7 +2797,7 @@ static int ath10k_wmi_main_pdev_set_regdomain(struct ath10k *ar, u16 rd,
 	cmd->conformance_test_limit_2G = __cpu_to_le32(ctl2g);
 	cmd->conformance_test_limit_5G = __cpu_to_le32(ctl5g);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi pdev regdomain rd %x rd2g %x rd5g %x ctl2g %x ctl5g %x\n",
 		   rd, rd2g, rd5g, ctl2g, ctl5g);
 
@@ -2809,7 +2813,7 @@ static int ath10k_wmi_10x_pdev_set_regdomain(struct ath10k *ar, u16 rd,
 	struct wmi_pdev_set_regdomain_cmd_10x *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -2821,7 +2825,7 @@ static int ath10k_wmi_10x_pdev_set_regdomain(struct ath10k *ar, u16 rd,
 	cmd->conformance_test_limit_5G = __cpu_to_le32(ctl5g);
 	cmd->dfs_domain = __cpu_to_le32(dfs_reg);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi pdev regdomain rd %x rd2g %x rd5g %x ctl2g %x ctl5g %x dfs_region %x\n",
 		   rd, rd2g, rd5g, ctl2g, ctl5g, dfs_reg);
 
@@ -2851,7 +2855,7 @@ int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 	if (arg->passive)
 		return -EINVAL;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -2869,7 +2873,7 @@ int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 	cmd->chan.reg_classid       = arg->reg_class_id;
 	cmd->chan.antenna_max       = arg->max_antenna_gain;
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi set channel mode %d freq %d\n",
 		   arg->mode, arg->freq);
 
@@ -2882,7 +2886,7 @@ int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt)
 	struct wmi_pdev_suspend_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -2896,7 +2900,7 @@ int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
 {
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(0);
+	skb = ath10k_wmi_alloc_skb(ar, 0);
 	if (skb == NULL)
 		return -ENOMEM;
 
@@ -2909,11 +2913,12 @@ int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
 	struct sk_buff *skb;
 
 	if (id == WMI_PDEV_PARAM_UNSUPPORTED) {
-		ath10k_warn("pdev param %d not supported by firmware\n", id);
+		ath10k_warn(ar, "pdev param %d not supported by firmware\n",
+			    id);
 		return -EOPNOTSUPP;
 	}
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -2921,7 +2926,7 @@ int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
 	cmd->param_id    = __cpu_to_le32(id);
 	cmd->param_value = __cpu_to_le32(value);
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi pdev set param %d value %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi pdev set param %d value %d\n",
 		   id, value);
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_set_param_cmdid);
 }
@@ -2988,7 +2993,7 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 	len = sizeof(*cmd) +
 	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
 
-	buf = ath10k_wmi_alloc_skb(len);
+	buf = ath10k_wmi_alloc_skb(ar, len);
 	if (!buf)
 		return -ENOMEM;
 
@@ -2999,7 +3004,7 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 		goto out;
 	}
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
 		   ar->wmi.num_mem_chunks);
 
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
@@ -3012,7 +3017,7 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 		cmd->host_mem_chunks[i].req_id =
 			__cpu_to_le32(ar->wmi.mem_chunks[i].req_id);
 
-		ath10k_dbg(ATH10K_DBG_WMI,
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "wmi chunk %d len %d requested, addr 0x%llx\n",
 			   i,
 			   ar->wmi.mem_chunks[i].len,
@@ -3021,7 +3026,7 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 out:
 	memcpy(&cmd->resource_config, &config, sizeof(config));
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi init\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi init\n");
 	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->init_cmdid);
 }
 
@@ -3079,7 +3084,7 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 	len = sizeof(*cmd) +
 	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
 
-	buf = ath10k_wmi_alloc_skb(len);
+	buf = ath10k_wmi_alloc_skb(ar, len);
 	if (!buf)
 		return -ENOMEM;
 
@@ -3090,7 +3095,7 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 		goto out;
 	}
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
 		   ar->wmi.num_mem_chunks);
 
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
@@ -3103,7 +3108,7 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 		cmd->host_mem_chunks[i].req_id =
 			__cpu_to_le32(ar->wmi.mem_chunks[i].req_id);
 
-		ath10k_dbg(ATH10K_DBG_WMI,
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "wmi chunk %d len %d requested, addr 0x%llx\n",
 			   i,
 			   ar->wmi.mem_chunks[i].len,
@@ -3112,7 +3117,7 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 out:
 	memcpy(&cmd->resource_config, &config, sizeof(config));
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi init 10x\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi init 10x\n");
 	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->init_cmdid);
 }
 
@@ -3170,7 +3175,7 @@ static int ath10k_wmi_10_2_cmd_init(struct ath10k *ar)
 	len = sizeof(*cmd) +
 	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
 
-	buf = ath10k_wmi_alloc_skb(len);
+	buf = ath10k_wmi_alloc_skb(ar, len);
 	if (!buf)
 		return -ENOMEM;
 
@@ -3181,7 +3186,7 @@ static int ath10k_wmi_10_2_cmd_init(struct ath10k *ar)
 		goto out;
 	}
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
 		   ar->wmi.num_mem_chunks);
 
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
@@ -3194,7 +3199,7 @@ static int ath10k_wmi_10_2_cmd_init(struct ath10k *ar)
 		cmd->host_mem_chunks[i].req_id =
 			__cpu_to_le32(ar->wmi.mem_chunks[i].req_id);
 
-		ath10k_dbg(ATH10K_DBG_WMI,
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "wmi chunk %d len %d requested, addr 0x%llx\n",
 			   i,
 			   ar->wmi.mem_chunks[i].len,
@@ -3203,7 +3208,7 @@ static int ath10k_wmi_10_2_cmd_init(struct ath10k *ar)
 out:
 	memcpy(&cmd->resource_config.common, &config, sizeof(config));
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi init 10.2\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi init 10.2\n");
 	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->init_cmdid);
 }
 
@@ -3295,7 +3300,7 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 	if (len < 0)
 		return len; /* len contains error code here */
 
-	skb = ath10k_wmi_alloc_skb(len);
+	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -3391,7 +3396,7 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 		return -EINVAL;
 	}
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi start scan\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi start scan\n");
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->start_scan_cmdid);
 }
 
@@ -3433,7 +3438,7 @@ int ath10k_wmi_stop_scan(struct ath10k *ar, const struct wmi_stop_scan_arg *arg)
 	if (arg->req_type == WMI_SCAN_STOP_ONE && arg->u.scan_id > 0xFFF)
 		return -EINVAL;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3449,7 +3454,7 @@ int ath10k_wmi_stop_scan(struct ath10k *ar, const struct wmi_stop_scan_arg *arg)
 	cmd->scan_id     = __cpu_to_le32(scan_id);
 	cmd->scan_req_id = __cpu_to_le32(req_id);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi stop scan reqid %d req_type %d vdev/scan_id %d\n",
 		   arg->req_id, arg->req_type, arg->u.scan_id);
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->stop_scan_cmdid);
@@ -3463,7 +3468,7 @@ int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
 	struct wmi_vdev_create_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3473,7 +3478,7 @@ int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
 	cmd->vdev_subtype = __cpu_to_le32(subtype);
 	memcpy(cmd->vdev_macaddr.addr, macaddr, ETH_ALEN);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "WMI vdev create: id %d type %d subtype %d macaddr %pM\n",
 		   vdev_id, type, subtype, macaddr);
 
@@ -3485,14 +3490,14 @@ int ath10k_wmi_vdev_delete(struct ath10k *ar, u32 vdev_id)
 	struct wmi_vdev_delete_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
 	cmd = (struct wmi_vdev_delete_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "WMI vdev delete id %d\n", vdev_id);
 
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_delete_cmdid);
@@ -3525,7 +3530,7 @@ static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 	else
 		return -EINVAL; /* should not happen, we already check cmd_id */
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3563,7 +3568,7 @@ static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 	cmd->chan.reg_classid = arg->channel.reg_class_id;
 	cmd->chan.antenna_max = arg->channel.max_antenna_gain;
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi vdev %s id 0x%x flags: 0x%0X, freq %d, mode %d, "
 		   "ch_flags: 0x%0X, max_power: %d\n", cmdname, arg->vdev_id,
 		   flags, arg->channel.freq, arg->channel.mode,
@@ -3593,14 +3598,14 @@ int ath10k_wmi_vdev_stop(struct ath10k *ar, u32 vdev_id)
 	struct wmi_vdev_stop_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
 	cmd = (struct wmi_vdev_stop_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi vdev stop id 0x%x\n", vdev_id);
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi vdev stop id 0x%x\n", vdev_id);
 
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_stop_cmdid);
 }
@@ -3610,7 +3615,7 @@ int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
 	struct wmi_vdev_up_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3619,7 +3624,7 @@ int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
 	cmd->vdev_assoc_id = __cpu_to_le32(aid);
 	memcpy(&cmd->vdev_bssid.addr, bssid, ETH_ALEN);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi mgmt vdev up id 0x%x assoc id %d bssid %pM\n",
 		   vdev_id, aid, bssid);
 
@@ -3631,14 +3636,14 @@ int ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id)
 	struct wmi_vdev_down_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
 	cmd = (struct wmi_vdev_down_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi mgmt vdev down id 0x%x\n", vdev_id);
 
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_down_cmdid);
@@ -3651,13 +3656,13 @@ int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 	struct sk_buff *skb;
 
 	if (param_id == WMI_VDEV_PARAM_UNSUPPORTED) {
-		ath10k_dbg(ATH10K_DBG_WMI,
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "vdev param %d not supported by firmware\n",
 			    param_id);
 		return -EOPNOTSUPP;
 	}
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3666,7 +3671,7 @@ int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 	cmd->param_id    = __cpu_to_le32(param_id);
 	cmd->param_value = __cpu_to_le32(param_value);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi vdev id 0x%x set param %d value %d\n",
 		   vdev_id, param_id, param_value);
 
@@ -3684,7 +3689,7 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 	if (arg->key_cipher != WMI_CIPHER_NONE && arg->key_data == NULL)
 		return -EINVAL;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd) + arg->key_len);
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd) + arg->key_len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -3702,7 +3707,7 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 	if (arg->key_data)
 		memcpy(cmd->key_data, arg->key_data, arg->key_len);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi vdev install key idx %d cipher %d len %d\n",
 		   arg->key_idx, arg->key_cipher, arg->key_len);
 	return ath10k_wmi_cmd_send(ar, skb,
@@ -3716,7 +3721,7 @@ int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
 	struct sk_buff *skb;
 	u32 cmdid;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3752,7 +3757,7 @@ int ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
 	struct sk_buff *skb;
 	u32 cmdid;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3771,7 +3776,7 @@ int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 	struct wmi_peer_create_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3779,7 +3784,7 @@ int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 	memcpy(cmd->peer_macaddr.addr, peer_addr, ETH_ALEN);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer create vdev_id %d peer_addr %pM\n",
 		   vdev_id, peer_addr);
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_create_cmdid);
@@ -3791,7 +3796,7 @@ int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
 	struct wmi_peer_delete_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3799,7 +3804,7 @@ int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 	memcpy(cmd->peer_macaddr.addr, peer_addr, ETH_ALEN);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer delete vdev_id %d peer_addr %pM\n",
 		   vdev_id, peer_addr);
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_delete_cmdid);
@@ -3811,7 +3816,7 @@ int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
 	struct wmi_peer_flush_tids_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3820,7 +3825,7 @@ int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
 	cmd->peer_tid_bitmap = __cpu_to_le32(tid_bitmap);
 	memcpy(cmd->peer_macaddr.addr, peer_addr, ETH_ALEN);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer flush vdev_id %d peer_addr %pM tids %08x\n",
 		   vdev_id, peer_addr, tid_bitmap);
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_flush_tids_cmdid);
@@ -3833,7 +3838,7 @@ int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
 	struct wmi_peer_set_param_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3843,7 +3848,7 @@ int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
 	cmd->param_value = __cpu_to_le32(param_value);
 	memcpy(&cmd->peer_macaddr.addr, peer_addr, ETH_ALEN);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi vdev %d peer 0x%pM set param %d value %d\n",
 		   vdev_id, peer_addr, param_id, param_value);
 
@@ -3856,7 +3861,7 @@ int ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
 	struct wmi_sta_powersave_mode_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3864,7 +3869,7 @@ int ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
 	cmd->vdev_id     = __cpu_to_le32(vdev_id);
 	cmd->sta_ps_mode = __cpu_to_le32(psmode);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi set powersave id 0x%x mode %d\n",
 		   vdev_id, psmode);
 
@@ -3879,7 +3884,7 @@ int ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
 	struct wmi_sta_powersave_param_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3888,7 +3893,7 @@ int ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
 	cmd->param_id    = __cpu_to_le32(param_id);
 	cmd->param_value = __cpu_to_le32(value);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi sta ps param vdev_id 0x%x param %d value %d\n",
 		   vdev_id, param_id, value);
 	return ath10k_wmi_cmd_send(ar, skb,
@@ -3904,7 +3909,7 @@ int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 	if (!mac)
 		return -EINVAL;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -3914,7 +3919,7 @@ int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 	cmd->param_value = __cpu_to_le32(value);
 	memcpy(&cmd->peer_macaddr, mac, ETH_ALEN);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi ap ps param vdev_id 0x%X param %d value %d mac_addr %pM\n",
 		   vdev_id, param_id, value, mac);
 
@@ -3934,7 +3939,7 @@ int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 
 	len = sizeof(*cmd) + arg->n_channels * sizeof(struct wmi_channel);
 
-	skb = ath10k_wmi_alloc_skb(len);
+	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
 		return -EINVAL;
 
@@ -4076,7 +4081,7 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 		len = sizeof(struct wmi_main_peer_assoc_complete_cmd);
 	}
 
-	skb = ath10k_wmi_alloc_skb(len);
+	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -4089,7 +4094,7 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 		ath10k_wmi_peer_assoc_fill_main(ar, skb->data, arg);
 	}
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer assoc vdev %d addr %pM (%s)\n",
 		   arg->vdev_id, arg->addr,
 		   arg->peer_reassoc ? "reassociate" : "new");
@@ -4107,7 +4112,7 @@ int ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif)
 	int ret;
 	u16 fc;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -4155,7 +4160,7 @@ int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 	struct wmi_pdev_set_wmm_params *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -4165,7 +4170,7 @@ int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_vi, &arg->ac_vi);
 	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_vo, &arg->ac_vo);
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi pdev set wmm params\n");
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi pdev set wmm params\n");
 	return ath10k_wmi_cmd_send(ar, skb,
 				   ar->wmi.cmd->pdev_set_wmm_params_cmdid);
 }
@@ -4175,14 +4180,14 @@ int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
 	struct wmi_request_stats_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
 	cmd = (struct wmi_request_stats_cmd *)skb->data;
 	cmd->stats_id = __cpu_to_le32(stats_id);
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi request stats %d\n", (int)stats_id);
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi request stats %d\n", (int)stats_id);
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->request_stats_cmdid);
 }
 
@@ -4192,7 +4197,7 @@ int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 	struct wmi_force_fw_hang_cmd *cmd;
 	struct sk_buff *skb;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -4200,7 +4205,7 @@ int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 	cmd->type = __cpu_to_le32(type);
 	cmd->delay_ms = __cpu_to_le32(delay_ms);
 
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi force fw hang %d delay %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi force fw hang %d delay %d\n",
 		   type, delay_ms);
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->force_fw_hang_cmdid);
 }
@@ -4211,7 +4216,7 @@ int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable)
 	struct sk_buff *skb;
 	u32 cfg;
 
-	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
 
@@ -4232,7 +4237,7 @@ int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable)
 	cmd->config_enable = __cpu_to_le32(cfg);
 	cmd->config_valid = __cpu_to_le32(ATH10K_DBGLOG_CFG_LOG_LVL_MASK);
 
-	ath10k_dbg(ATH10K_DBG_WMI,
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi dbglog cfg modules %08x %08x config %08x %08x\n",
 		   __le32_to_cpu(cmd->module_enable),
 		   __le32_to_cpu(cmd->module_valid),
-- 
1.8.5.3


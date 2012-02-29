Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40227 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab2B2RT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:19:26 -0500
Subject: [PATCH 06/12] ath6kl: add ath6kl_bmi_write_hi32()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:19:21 +0200
Message-ID: <20120229171921.24264.78077.stgit@localhost6.localdomain6> (sfid-20120229_181939_752765_DFDB9289)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have a lot of 32 bit writes to the host interest area and the code
doing that is ugly. Clean that up by adding ath6kl_bmi_write_hi32().

This also fixes few checkpatch warnings.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.h  |    9 +++
 drivers/net/wireless/ath/ath6kl/init.c |   99 +++++++-------------------------
 2 files changed, 32 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
index 114f7b2..e6a7330 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.h
+++ b/drivers/net/wireless/ath/ath6kl/bmi.h
@@ -223,6 +223,15 @@ struct ath6kl_bmi_target_info {
 	__le32 type;         /* target type */
 } __packed;
 
+#define ath6kl_bmi_write_hi32(ar, item, val)				\
+	({								\
+		u32 addr, v;						\
+		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
+		v = val;						\
+		ath6kl_bmi_write(ar, addr, (u8 *) &v, sizeof(v));	\
+	})
+
+
 int ath6kl_bmi_init(struct ath6kl *ar);
 void ath6kl_bmi_cleanup(struct ath6kl *ar);
 void ath6kl_bmi_reset(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 445426f..da5900d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -352,11 +352,7 @@ static int ath6kl_set_htc_params(struct ath6kl *ar, u32 mbox_isr_yield_val,
 		blk_size |=  ((u32)htc_ctrl_buf) << 16;
 
 	/* set the host interest area for the block size */
-	status = ath6kl_bmi_write(ar,
-			ath6kl_get_hi_item_addr(ar,
-			HI_ITEM(hi_mbox_io_block_sz)),
-			(u8 *)&blk_size,
-			4);
+	status = ath6kl_bmi_write_hi32(ar, hi_mbox_io_block_sz, blk_size);
 	if (status) {
 		ath6kl_err("bmi_write_memory for IO block size failed\n");
 		goto out;
@@ -368,11 +364,8 @@ static int ath6kl_set_htc_params(struct ath6kl *ar, u32 mbox_isr_yield_val,
 
 	if (mbox_isr_yield_val) {
 		/* set the host interest area for the mbox ISR yield limit */
-		status = ath6kl_bmi_write(ar,
-				ath6kl_get_hi_item_addr(ar,
-				HI_ITEM(hi_mbox_isr_yield_limit)),
-				(u8 *)&mbox_isr_yield_val,
-				4);
+		status = ath6kl_bmi_write_hi32(ar, hi_mbox_isr_yield_limit,
+					       mbox_isr_yield_val);
 		if (status) {
 			ath6kl_err("bmi_write_memory for yield limit failed\n");
 			goto out;
@@ -463,8 +456,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	int i, status;
 
 	param = !!(ar->conf_flags & ATH6KL_CONF_UART_DEBUG);
-	if (ath6kl_bmi_write(ar, ath6kl_get_hi_item_addr(ar,
-			     HI_ITEM(hi_serial_enable)), (u8 *)&param, 4)) {
+	if (ath6kl_bmi_write_hi32(ar, hi_serial_enable, param)) {
 		ath6kl_err("bmi_write_memory for uart debug failed\n");
 		return -EIO;
 	}
@@ -500,11 +492,8 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	if (ar->p2p && ar->vif_max == 1)
 		fw_submode = HI_OPTION_FW_SUBMODE_P2PDEV;
 
-	param = HTC_PROTOCOL_VERSION;
-	if (ath6kl_bmi_write(ar,
-			     ath6kl_get_hi_item_addr(ar,
-			     HI_ITEM(hi_app_host_interest)),
-			     (u8 *)&param, 4) != 0) {
+	if (ath6kl_bmi_write_hi32(ar, hi_app_host_interest,
+				  HTC_PROTOCOL_VERSION) != 0) {
 		ath6kl_err("bmi_write_memory for htc version failed\n");
 		return -EIO;
 	}
@@ -527,11 +516,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	param |= (0 << HI_OPTION_MAC_ADDR_METHOD_SHIFT);
 	param |= (0 << HI_OPTION_FW_BRIDGE_SHIFT);
 
-	if (ath6kl_bmi_write(ar,
-			     ath6kl_get_hi_item_addr(ar,
-			     HI_ITEM(hi_option_flag)),
-			     (u8 *)&param,
-			     4) != 0) {
+	if (ath6kl_bmi_write_hi32(ar, hi_option_flag, param) != 0) {
 		ath6kl_err("bmi_write_memory for setting fwmode failed\n");
 		return -EIO;
 	}
@@ -550,16 +535,13 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	param = ar->hw.board_ext_data_addr;
 	ram_reserved_size = ar->hw.reserved_ram_size;
 
-	if (ath6kl_bmi_write(ar, ath6kl_get_hi_item_addr(ar,
-					HI_ITEM(hi_board_ext_data)),
-			     (u8 *)&param, 4) != 0) {
+	if (ath6kl_bmi_write_hi32(ar, hi_board_ext_data, param) != 0) {
 		ath6kl_err("bmi_write_memory for hi_board_ext_data failed\n");
 		return -EIO;
 	}
 
-	if (ath6kl_bmi_write(ar, ath6kl_get_hi_item_addr(ar,
-					HI_ITEM(hi_end_ram_reserve_sz)),
-			     (u8 *)&ram_reserved_size, 4) != 0) {
+	if (ath6kl_bmi_write_hi32(ar, hi_end_ram_reserve_sz,
+				  ram_reserved_size) != 0) {
 		ath6kl_err("bmi_write_memory for hi_end_ram_reserve_sz failed\n");
 		return -EIO;
 	}
@@ -570,20 +552,13 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		return -EIO;
 
 	/* Configure GPIO AR600x UART */
-	param = ar->hw.uarttx_pin;
-	status = ath6kl_bmi_write(ar,
-				ath6kl_get_hi_item_addr(ar,
-				HI_ITEM(hi_dbg_uart_txpin)),
-				(u8 *)&param, 4);
+	status = ath6kl_bmi_write_hi32(ar, hi_dbg_uart_txpin,
+				       ar->hw.uarttx_pin);
 	if (status)
 		return status;
 
 	/* Configure target refclk_hz */
-	param =  ar->hw.refclk_hz;
-	status = ath6kl_bmi_write(ar,
-				ath6kl_get_hi_item_addr(ar,
-				HI_ITEM(hi_refclk_hz)),
-				(u8 *)&param, 4);
+	status = ath6kl_bmi_write_hi32(ar, hi_refclk_hz, ar->hw.refclk_hz);
 	if (status)
 		return status;
 
@@ -1096,11 +1071,8 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 	 * writing board data.
 	 */
 	if (ar->hw.board_addr != 0) {
-		board_address = ar->hw.board_addr;
-		ath6kl_bmi_write(ar,
-				ath6kl_get_hi_item_addr(ar,
-				HI_ITEM(hi_board_data)),
-				(u8 *) &board_address, 4);
+		ath6kl_bmi_write_hi32(ar, hi_board_data,
+				      ar->hw.board_addr);
 	} else {
 		ath6kl_bmi_read(ar,
 				ath6kl_get_hi_item_addr(ar,
@@ -1157,10 +1129,7 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 		/* record that extended board data is initialized */
 		param = (board_ext_data_size << 16) | 1;
 
-		ath6kl_bmi_write(ar,
-				 ath6kl_get_hi_item_addr(ar,
-				 HI_ITEM(hi_board_ext_data_config)),
-				 (unsigned char *) &param, 4);
+		ath6kl_bmi_write_hi32(ar, hi_board_ext_data_config, param);
 	}
 
 	if (ar->fw_board_len < board_data_size) {
@@ -1181,11 +1150,7 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 	}
 
 	/* record the fact that Board Data IS initialized */
-	param = 1;
-	ath6kl_bmi_write(ar,
-			 ath6kl_get_hi_item_addr(ar,
-			 HI_ITEM(hi_board_data_initialized)),
-			 (u8 *)&param, 4);
+	ath6kl_bmi_write_hi32(ar, hi_board_data_initialized, 1);
 
 	return ret;
 }
@@ -1273,7 +1238,7 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 
 static int ath6kl_upload_patch(struct ath6kl *ar)
 {
-	u32 address, param;
+	u32 address;
 	int ret;
 
 	if (ar->fw_patch == NULL)
@@ -1290,18 +1255,14 @@ static int ath6kl_upload_patch(struct ath6kl *ar)
 		return ret;
 	}
 
-	param = address;
-	ath6kl_bmi_write(ar,
-			 ath6kl_get_hi_item_addr(ar,
-			 HI_ITEM(hi_dset_list_head)),
-			 (unsigned char *) &param, 4);
+	ath6kl_bmi_write_hi32(ar, hi_dset_list_head, address);
 
 	return 0;
 }
 
 static int ath6kl_upload_testscript(struct ath6kl *ar)
 {
-	u32 address, param;
+	u32 address;
 	int ret;
 
 	if (ar->testmode != 2)
@@ -1322,23 +1283,9 @@ static int ath6kl_upload_testscript(struct ath6kl *ar)
 		return ret;
 	}
 
-	param = address;
-	ath6kl_bmi_write(ar,
-			ath6kl_get_hi_item_addr(ar,
-			HI_ITEM(hi_ota_testscript)),
-			(unsigned char *) &param, 4);
-
-	param = 4096;
-	ath6kl_bmi_write(ar,
-			ath6kl_get_hi_item_addr(ar,
-			HI_ITEM(hi_end_ram_reserve_sz)),
-			(unsigned char *) &param, 4);
-
-	param = 1;
-	ath6kl_bmi_write(ar,
-			ath6kl_get_hi_item_addr(ar,
-			HI_ITEM(hi_test_apps_related)),
-			(unsigned char *) &param, 4);
+	ath6kl_bmi_write_hi32(ar, hi_ota_testscript, address);
+	ath6kl_bmi_write_hi32(ar, hi_end_ram_reserve_sz, 4096);
+	ath6kl_bmi_write_hi32(ar, hi_test_apps_related, 1);
 
 	return 0;
 }


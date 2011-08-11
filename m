Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45065 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1HKGtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 02:49:08 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	Kevin Fang <chienf@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 2/7] ath6kl: add call back function for read/write through diagnostic window
Date: Thu, 11 Aug 2011 14:48:10 +0800
Message-ID: <1313045295-16202-2-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20110811_084912_976214_2E7C68FA)
In-Reply-To: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
References: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is conflict method of read/write diag between sdio and usb.
Therefore, add callback function for these read/write diag method.

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h    |    1 -
 drivers/net/wireless/ath/ath6kl/hif-ops.h |   20 +++++
 drivers/net/wireless/ath/ath6kl/hif.h     |    5 ++
 drivers/net/wireless/ath/ath6kl/init.c    |    4 +-
 drivers/net/wireless/ath/ath6kl/main.c    |  108 +----------------------------
 drivers/net/wireless/ath/ath6kl/sdio.c    |  100 ++++++++++++++++++++++++++
 6 files changed, 130 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 214d114..0f7b0c0 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -496,7 +496,6 @@ void ath6kl_stop_txrx(struct ath6kl *ar);
 void ath6kl_cleanup_amsdu_rxbufs(struct ath6kl *ar);
 int ath6kl_access_datadiag(struct ath6kl *ar, u32 address,
 			   u8 *data, u32 length, bool read);
-int ath6kl_read_reg_diag(struct ath6kl *ar, u32 *address, u32 *data);
 void ath6kl_init_profile_info(struct ath6kl *ar);
 void ath6kl_tx_data_cleanup(struct ath6kl *ar);
 void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index c923979..a42acba 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -69,4 +69,24 @@ static inline void ath6kl_hif_cleanup_scatter(struct ath6kl *ar)
 	return ar->hif_ops->cleanup_scatter(ar);
 }
 
+/*
+ * Read from the ATH6KL through its diagnostic window. No cooperation from
+ * the Target is required for this.
+ */
+static inline int ath6kl_hif_read_diag(struct ath6kl *ar, u32 address,
+					u32 *data)
+{
+	return ar->hif_ops->read_reg_diag(ar, address, data);
+}
+
+/*
+ * Write to the ATH6KL through its diagnostic window. No cooperation from
+ * the Target is required for this.
+ */
+static inline int ath6kl_hif_write_diag(struct ath6kl *ar, u32 address,
+					u32 *data)
+{
+	return ar->hif_ops->write_reg_diag(ar, address, data);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 5ceff54..2fff554 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -202,6 +202,11 @@ struct ath6kl_hif_ops {
 	int (*scat_req_rw) (struct ath6kl *ar,
 			    struct hif_scatter_req *scat_req);
 	void (*cleanup_scatter)(struct ath6kl *ar);
+
+	int (*read_reg_diag)(struct ath6kl *ar, u32 address,
+			u32 *data);
+	int (*write_reg_diag)(struct ath6kl *ar, u32 address,
+			u32 *data);
 };
 
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index df15bfa..5cc2697 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -131,7 +131,7 @@ static int ath6kl_set_host_app_area(struct ath6kl *ar)
 	address = ath6kl_get_hi_item_addr(ar, HI_ITEM(hi_app_host_interest));
 	address = TARG_VTOP(ar->target_type, address);
 
-	if (ath6kl_read_reg_diag(ar, &address, &data))
+	if (ath6kl_hif_read_diag(ar, address, &data))
 		return -EIO;
 
 	address = TARG_VTOP(ar->target_type, data);
@@ -375,7 +375,7 @@ static void ath6kl_dump_target_assert_info(struct ath6kl *ar)
 	address = TARG_VTOP(ar->target_type, address);
 
 	/* read RAM location through diagnostic window */
-	status = ath6kl_read_reg_diag(ar, &address, &regdump_loc);
+	status = ath6kl_hif_read_diag(ar, address, &regdump_loc);
 
 	if (status || !regdump_loc) {
 		ath6kl_err("failed to get ptr to register dump area\n");
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 3cee0e3..052db4b 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -173,108 +173,6 @@ void ath6kl_free_cookie(struct ath6kl *ar, struct ath6kl_cookie *cookie)
 	ar->cookie_count++;
 }
 
-/* set the window address register (using 4-byte register access ). */
-static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
-{
-	int status;
-	u8 addr_val[4];
-	s32 i;
-
-	/*
-	 * Write bytes 1,2,3 of the register to set the upper address bytes,
-	 * the LSB is written last to initiate the access cycle
-	 */
-
-	for (i = 1; i <= 3; i++) {
-		/*
-		 * Fill the buffer with the address byte value we want to
-		 * hit 4 times.
-		 */
-		memset(addr_val, ((u8 *)&addr)[i], 4);
-
-		/*
-		 * Hit each byte of the register address with a 4-byte
-		 * write operation to the same address, this is a harmless
-		 * operation.
-		 */
-		status = hif_read_write_sync(ar, reg_addr + i, addr_val,
-					     4, HIF_WR_SYNC_BYTE_FIX);
-		if (status)
-			break;
-	}
-
-	if (status) {
-		ath6kl_err("failed to write initial bytes of 0x%x to window reg: 0x%X\n",
-			   addr, reg_addr);
-		return status;
-	}
-
-	/*
-	 * Write the address register again, this time write the whole
-	 * 4-byte value. The effect here is that the LSB write causes the
-	 * cycle to start, the extra 3 byte write to bytes 1,2,3 has no
-	 * effect since we are writing the same values again
-	 */
-	status = hif_read_write_sync(ar, reg_addr, (u8 *)(&addr),
-				     4, HIF_WR_SYNC_BYTE_INC);
-
-	if (status) {
-		ath6kl_err("failed to write 0x%x to window reg: 0x%X\n",
-			   addr, reg_addr);
-		return status;
-	}
-
-	return 0;
-}
-
-/*
- * Read from the ATH6KL through its diagnostic window. No cooperation from
- * the Target is required for this.
- */
-int ath6kl_read_reg_diag(struct ath6kl *ar, u32 *address, u32 *data)
-{
-	int status;
-
-	/* set window register to start read cycle */
-	status = ath6kl_set_addrwin_reg(ar, WINDOW_READ_ADDR_ADDRESS,
-					*address);
-
-	if (status)
-		return status;
-
-	/* read the data */
-	status = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *)data,
-				     sizeof(u32), HIF_RD_SYNC_BYTE_INC);
-	if (status) {
-		ath6kl_err("failed to read from window data addr\n");
-		return status;
-	}
-
-	return status;
-}
-
-
-/*
- * Write to the ATH6KL through its diagnostic window. No cooperation from
- * the Target is required for this.
- */
-static int ath6kl_write_reg_diag(struct ath6kl *ar, u32 *address, u32 *data)
-{
-	int status;
-
-	/* set write data */
-	status = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *)data,
-				     sizeof(u32), HIF_WR_SYNC_BYTE_INC);
-	if (status) {
-		ath6kl_err("failed to write 0x%x to window data addr\n", *data);
-		return status;
-	}
-
-	/* set window register, which starts the write cycle */
-	return ath6kl_set_addrwin_reg(ar, WINDOW_WRITE_ADDR_ADDRESS,
-				      *address);
-}
-
 int ath6kl_access_datadiag(struct ath6kl *ar, u32 address,
 			   u8 *data, u32 length, bool read)
 {
@@ -283,12 +181,12 @@ int ath6kl_access_datadiag(struct ath6kl *ar, u32 address,
 
 	for (count = 0; count < length; count += 4, address += 4) {
 		if (read) {
-			status = ath6kl_read_reg_diag(ar, &address,
+			status = ath6kl_hif_read_diag(ar, address,
 						      (u32 *) &data[count]);
 			if (status)
 				break;
 		} else {
-			status = ath6kl_write_reg_diag(ar, &address,
+			status = ath6kl_hif_write_diag(ar, address,
 						       (u32 *) &data[count]);
 			if (status)
 				break;
@@ -312,7 +210,7 @@ static void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 	data = cold_reset ? RESET_CONTROL_COLD_RST : RESET_CONTROL_MBOX_RST;
 
 	address = RTC_BASE_ADDRESS;
-	status = ath6kl_write_reg_diag(ar, &address, &data);
+	status = ath6kl_hif_write_diag(ar, address, &data);
 
 	if (status)
 		ath6kl_err("failed to reset target\n");
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 3417160..0fb06fc 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -721,6 +721,104 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 	return 0;
 }
 
+/* set the window address register (using 4-byte register access ). */
+static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
+{
+	int status;
+	u8 addr_val[4];
+	s32 i;
+
+	/*
+	 * Write bytes 1,2,3 of the register to set the upper address bytes,
+	 * the LSB is written last to initiate the access cycle
+	 */
+
+	for (i = 1; i <= 3; i++) {
+		/*
+		 * Fill the buffer with the address byte value we want to
+		 * hit 4 times.
+		 */
+		memset(addr_val, ((u8 *)&addr)[i], 4);
+
+		/*
+		 * Hit each byte of the register address with a 4-byte
+		 * write operation to the same address, this is a harmless
+		 * operation.
+		 */
+		status = ath6kl_sdio_read_write_sync(ar, reg_addr + i, addr_val,
+					     4, HIF_WR_SYNC_BYTE_FIX);
+		if (status)
+			break;
+	}
+
+	if (status) {
+		ath6kl_err("%s: failed to write initial bytes of 0x%x "
+			   "to window reg: 0x%X\n", __func__,
+			   addr, reg_addr);
+		return status;
+	}
+
+	/*
+	 * Write the address register again, this time write the whole
+	 * 4-byte value. The effect here is that the LSB write causes the
+	 * cycle to start, the extra 3 byte write to bytes 1,2,3 has no
+	 * effect since we are writing the same values again
+	 */
+	status = ath6kl_sdio_read_write_sync(ar, reg_addr, (u8 *)(&addr),
+				     4, HIF_WR_SYNC_BYTE_INC);
+
+	if (status) {
+		ath6kl_err("%s: failed to write 0x%x to window reg: 0x%X\n",
+			   __func__, addr, reg_addr);
+		return status;
+	}
+
+	return 0;
+}
+
+static int ath6kl_sdio_read_reg_diag(struct ath6kl *ar, u32 address,
+			u32 *data)
+{
+	int status;
+
+	/* set window register to start read cycle */
+	status = ath6kl_set_addrwin_reg(ar, WINDOW_READ_ADDR_ADDRESS,
+					address);
+
+	if (status)
+		return status;
+
+	/* read the data */
+	status = ath6kl_sdio_read_write_sync(ar, WINDOW_DATA_ADDRESS,
+				(u8 *)data, sizeof(u32), HIF_RD_SYNC_BYTE_INC);
+	if (status) {
+		ath6kl_err("%s: failed to read from window data addr\n",
+			__func__);
+		return status;
+	}
+
+	return status;
+}
+
+static int ath6kl_sdio_write_reg_diag(struct ath6kl *ar, u32 address,
+			u32 *data)
+{
+	int status;
+
+	/* set write data */
+	status = ath6kl_sdio_read_write_sync(ar, WINDOW_DATA_ADDRESS,
+				(u8 *)data, sizeof(u32), HIF_WR_SYNC_BYTE_INC);
+	if (status) {
+		ath6kl_err("%s: failed to write 0x%x to window data addr\n",
+			   __func__, *data);
+		return status;
+	}
+
+	/* set window register, which starts the write cycle */
+	return ath6kl_set_addrwin_reg(ar, WINDOW_WRITE_ADDR_ADDRESS,
+				      address);
+}
+
 static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.read_write_sync = ath6kl_sdio_read_write_sync,
 	.write_async = ath6kl_sdio_write_async,
@@ -731,6 +829,8 @@ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.enable_scatter = ath6kl_sdio_enable_scatter,
 	.scat_req_rw = ath6kl_sdio_async_rw_scatter,
 	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
+	.read_reg_diag = ath6kl_sdio_read_reg_diag,
+	.write_reg_diag = ath6kl_sdio_write_reg_diag,
 };
 
 static int ath6kl_sdio_probe(struct sdio_func *func,
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:51255 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1KKKRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:17:55 -0500
Subject: [PATCH 03/10] ath6kl: move diag commands to hif driver
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2011 12:17:51 +0200
Message-ID: <20111111101751.12075.25454.stgit@localhost6.localdomain6> (sfid-20111111_111758_335653_55D2283C)
In-Reply-To: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
References: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is preparation for USB support which will have different diag
commands.

Based on code by Kevin Fang.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif-ops.h |   20 ++++++
 drivers/net/wireless/ath/ath6kl/hif.h     |    2 +
 drivers/net/wireless/ath/ath6kl/main.c    |   76 +---------------------
 drivers/net/wireless/ath/ath6kl/sdio.c    |  100 +++++++++++++++++++++++++++++
 4 files changed, 126 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index 0c4c602..2fe1dad 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -91,6 +91,26 @@ static inline int ath6kl_hif_suspend(struct ath6kl *ar,
 	return ar->hif_ops->suspend(ar, wow);
 }
 
+/*
+ * Read from the ATH6KL through its diagnostic window. No cooperation from
+ * the Target is required for this.
+ */
+static inline int ath6kl_hif_diag_read32(struct ath6kl *ar, u32 address,
+					 u32 *value)
+{
+	return ar->hif_ops->diag_read32(ar, address, value);
+}
+
+/*
+ * Write to the ATH6KL through its diagnostic window. No cooperation from
+ * the Target is required for this.
+ */
+static inline int ath6kl_hif_diag_write32(struct ath6kl *ar, u32 address,
+					  __le32 value)
+{
+	return ar->hif_ops->diag_write32(ar, address, value);
+}
+
 static inline int ath6kl_hif_bmi_read(struct ath6kl *ar, u8 *buf, u32 len)
 {
 	return ar->hif_ops->bmi_read(ar, buf, len);
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 42004e9..15b5d98 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -244,6 +244,8 @@ struct ath6kl_hif_ops {
 	void (*cleanup_scatter)(struct ath6kl *ar);
 	int (*suspend)(struct ath6kl *ar, struct cfg80211_wowlan *wow);
 	int (*resume)(struct ath6kl *ar);
+	int (*diag_read32)(struct ath6kl *ar, u32 address, u32 *value);
+	int (*diag_write32)(struct ath6kl *ar, u32 address, __le32 value);
 	int (*bmi_read)(struct ath6kl *ar, u8 *buf, u32 len);
 	int (*bmi_write)(struct ath6kl *ar, u8 *buf, u32 len);
 	int (*power_on)(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 5e5f4ca..7043635 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -175,64 +175,6 @@ void ath6kl_free_cookie(struct ath6kl *ar, struct ath6kl_cookie *cookie)
 	ar->cookie_count++;
 }
 
-/* set the window address register (using 4-byte register access ). */
-static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
-{
-	int status;
-	s32 i;
-	__le32 addr_val;
-
-	/*
-	 * Write bytes 1,2,3 of the register to set the upper address bytes,
-	 * the LSB is written last to initiate the access cycle
-	 */
-
-	for (i = 1; i <= 3; i++) {
-		/*
-		 * Fill the buffer with the address byte value we want to
-		 * hit 4 times. No need to worry about endianness as the
-		 * same byte is copied to all four bytes of addr_val at
-		 * any time.
-		 */
-		memset((u8 *)&addr_val, ((u8 *)&addr)[i], 4);
-
-		/*
-		 * Hit each byte of the register address with a 4-byte
-		 * write operation to the same address, this is a harmless
-		 * operation.
-		 */
-		status = hif_read_write_sync(ar, reg_addr + i, (u8 *)&addr_val,
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
-	addr_val = cpu_to_le32(addr);
-	status = hif_read_write_sync(ar, reg_addr,
-				     (u8 *)&(addr_val),
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
 /*
  * Read from the hardware through its diagnostic window. No cooperation
  * from the firmware is required for this.
@@ -241,14 +183,7 @@ int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
 {
 	int ret;
 
-	/* set window register to start read cycle */
-	ret = ath6kl_set_addrwin_reg(ar, WINDOW_READ_ADDR_ADDRESS, address);
-	if (ret)
-		return ret;
-
-	/* read the data */
-	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) value,
-				  sizeof(*value), HIF_RD_SYNC_BYTE_INC);
+	ret = ath6kl_hif_diag_read32(ar, address, value);
 	if (ret) {
 		ath6kl_warn("failed to read32 through diagnose window: %d\n",
 			    ret);
@@ -266,18 +201,15 @@ int ath6kl_diag_write32(struct ath6kl *ar, u32 address, __le32 value)
 {
 	int ret;
 
-	/* set write data */
-	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) &value,
-				  sizeof(value), HIF_WR_SYNC_BYTE_INC);
+	ret = ath6kl_hif_diag_write32(ar, address, value);
+
 	if (ret) {
 		ath6kl_err("failed to write 0x%x during diagnose window to 0x%d\n",
 			   address, value);
 		return ret;
 	}
 
-	/* set window register, which starts the write cycle */
-	return ath6kl_set_addrwin_reg(ar, WINDOW_WRITE_ADDR_ADDRESS,
-				      address);
+	return 0;
 }
 
 int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length)
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index beb73c7..14e2590 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -846,6 +846,104 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
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
+static int ath6kl_sdio_diag_read32(struct ath6kl *ar, u32 address, u32 *data)
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
+static int ath6kl_sdio_diag_write32(struct ath6kl *ar, u32 address,
+				    __le32 data)
+{
+	int status;
+	u32 val = (__force u32) data;
+
+	/* set write data */
+	status = ath6kl_sdio_read_write_sync(ar, WINDOW_DATA_ADDRESS,
+				(u8 *) &val, sizeof(u32), HIF_WR_SYNC_BYTE_INC);
+	if (status) {
+		ath6kl_err("%s: failed to write 0x%x to window data addr\n",
+			   __func__, data);
+		return status;
+	}
+
+	/* set window register, which starts the write cycle */
+	return ath6kl_set_addrwin_reg(ar, WINDOW_WRITE_ADDR_ADDRESS,
+				      address);
+}
+
 static int ath6kl_sdio_bmi_credits(struct ath6kl *ar)
 {
 	u32 addr;
@@ -1050,6 +1148,8 @@ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
 	.suspend = ath6kl_sdio_suspend,
 	.resume = ath6kl_sdio_resume,
+	.diag_read32 = ath6kl_sdio_diag_read32,
+	.diag_write32 = ath6kl_sdio_diag_write32,
 	.bmi_read = ath6kl_sdio_bmi_read,
 	.bmi_write = ath6kl_sdio_bmi_write,
 	.power_on = ath6kl_sdio_power_on,


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:59128 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab1H3Noz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 09:44:55 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id 9382F8C5AA
	for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 16:44:53 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 6B29BE51A2
	for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 16:44:50 +0300 (EEST)
Subject: [PATCH 3/4] ath6kl: cleanup diagnose window read and write functions
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Tue, 30 Aug 2011 16:44:50 +0300
Message-ID: <20110830134450.21543.40524.stgit@localhost6.localdomain6> (sfid-20110830_154457_442394_E667088D)
In-Reply-To: <20110830134432.21543.89808.stgit@localhost6.localdomain6>
References: <20110830134432.21543.89808.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to make them a bit easier to read and unify naming. 32 suffix
in the function name means that it will be a 32 bit transfer. If there's
no number a buffer is transfered instead.

Use void pointers to get rid of ugly casts.

Don't provide target address as a pointer, pass it by value. Same for
the value used in write32().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    6 +-
 drivers/net/wireless/ath/ath6kl/init.c |   16 ++---
 drivers/net/wireless/ath/ath6kl/main.c |   94 ++++++++++++++++++--------------
 3 files changed, 61 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index d5c21bf..33c84c0 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -509,9 +509,9 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 					       struct htc_packet *packet);
 void ath6kl_stop_txrx(struct ath6kl *ar);
 void ath6kl_cleanup_amsdu_rxbufs(struct ath6kl *ar);
-int ath6kl_access_datadiag(struct ath6kl *ar, u32 address,
-			   u8 *data, u32 length, bool read);
-int ath6kl_read_reg_diag(struct ath6kl *ar, u32 *address, u32 *data);
+int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length);
+int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value);
+int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length);
 void ath6kl_init_profile_info(struct ath6kl *ar);
 void ath6kl_tx_data_cleanup(struct ath6kl *ar);
 void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index bcb94ab..b6a1e69 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -131,14 +131,13 @@ static int ath6kl_set_host_app_area(struct ath6kl *ar)
 	address = ath6kl_get_hi_item_addr(ar, HI_ITEM(hi_app_host_interest));
 	address = TARG_VTOP(ar->target_type, address);
 
-	if (ath6kl_read_reg_diag(ar, &address, &data))
+	if (ath6kl_diag_read32(ar, address, &data))
 		return -EIO;
 
 	address = TARG_VTOP(ar->target_type, data);
 	host_app_area.wmi_protocol_ver = WMI_PROTOCOL_VERSION;
-	if (ath6kl_access_datadiag(ar, address,
-				(u8 *)&host_app_area,
-				sizeof(struct host_app_area), false))
+	if (ath6kl_diag_write(ar, address, (u8 *) &host_app_area,
+			      sizeof(struct host_app_area)))
 		return -EIO;
 
 	return 0;
@@ -375,7 +374,7 @@ static void ath6kl_dump_target_assert_info(struct ath6kl *ar)
 	address = TARG_VTOP(ar->target_type, address);
 
 	/* read RAM location through diagnostic window */
-	status = ath6kl_read_reg_diag(ar, &address, &regdump_loc);
+	status = ath6kl_diag_read32(ar, address, &regdump_loc);
 
 	if (status || !regdump_loc) {
 		ath6kl_err("failed to get ptr to register dump area\n");
@@ -387,11 +386,8 @@ static void ath6kl_dump_target_assert_info(struct ath6kl *ar)
 	regdump_loc = TARG_VTOP(ar->target_type, regdump_loc);
 
 	/* fetch register dump data */
-	status = ath6kl_access_datadiag(ar,
-					regdump_loc,
-					(u8 *)&regdump_val[0],
-					REG_DUMP_COUNT_AR6003 * (sizeof(u32)),
-					true);
+	status = ath6kl_diag_read(ar, regdump_loc, (u8 *)&regdump_val[0],
+				  REG_DUMP_COUNT_AR6003 * (sizeof(u32)));
 
 	if (status) {
 		ath6kl_err("failed to get register dump\n");
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index b64b2a3..8d29d4e 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -228,74 +228,84 @@ static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
 }
 
 /*
- * Read from the ATH6KL through its diagnostic window. No cooperation from
- * the Target is required for this.
+ * Read from the hardware through its diagnostic window. No cooperation
+ * from the firmware is required for this.
  */
-int ath6kl_read_reg_diag(struct ath6kl *ar, u32 *address, u32 *data)
+int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
 {
-	int status;
+	int ret;
 
 	/* set window register to start read cycle */
-	status = ath6kl_set_addrwin_reg(ar, WINDOW_READ_ADDR_ADDRESS,
-					*address);
-
-	if (status)
-		return status;
+	ret = ath6kl_set_addrwin_reg(ar, WINDOW_READ_ADDR_ADDRESS, address);
+	if (ret)
+		return ret;
 
 	/* read the data */
-	status = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *)data,
-				     sizeof(u32), HIF_RD_SYNC_BYTE_INC);
-	if (status) {
-		ath6kl_err("failed to read from window data addr\n");
-		return status;
+	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) value,
+				  sizeof(*value), HIF_RD_SYNC_BYTE_INC);
+	if (ret) {
+		ath6kl_warn("failed to read32 through diagnose window: %d\n",
+			    ret);
+		return ret;
 	}
 
-	return status;
+	return 0;
 }
 
-
 /*
  * Write to the ATH6KL through its diagnostic window. No cooperation from
  * the Target is required for this.
  */
-static int ath6kl_write_reg_diag(struct ath6kl *ar, u32 *address, u32 *data)
+static int ath6kl_diag_write32(struct ath6kl *ar, u32 address, u32 value)
 {
-	int status;
+	int ret;
 
 	/* set write data */
-	status = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *)data,
-				     sizeof(u32), HIF_WR_SYNC_BYTE_INC);
-	if (status) {
-		ath6kl_err("failed to write 0x%x to window data addr\n", *data);
-		return status;
+	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) &value,
+				  sizeof(value), HIF_WR_SYNC_BYTE_INC);
+	if (ret) {
+		ath6kl_err("failed to write 0x%x during diagnose window to 0x%d\n",
+			   address, value);
+		return ret;
 	}
 
 	/* set window register, which starts the write cycle */
 	return ath6kl_set_addrwin_reg(ar, WINDOW_WRITE_ADDR_ADDRESS,
-				      *address);
+				      address);
 }
 
-int ath6kl_access_datadiag(struct ath6kl *ar, u32 address,
-			   u8 *data, u32 length, bool read)
+int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length)
 {
-	u32 count;
-	int status = 0;
+	u32 count, *buf = data;
+	int ret;
 
-	for (count = 0; count < length; count += 4, address += 4) {
-		if (read) {
-			status = ath6kl_read_reg_diag(ar, &address,
-						      (u32 *) &data[count]);
-			if (status)
-				break;
-		} else {
-			status = ath6kl_write_reg_diag(ar, &address,
-						       (u32 *) &data[count]);
-			if (status)
-				break;
-		}
+	if (WARN_ON(length % 4))
+		return -EINVAL;
+
+	for (count = 0; count < length / 4; count++, address += 4) {
+		ret = ath6kl_diag_read32(ar, address, &buf[count]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length)
+{
+	u32 count, *buf = data;
+	int ret;
+
+	if (WARN_ON(length % 4))
+		return -EINVAL;
+
+	for (count = 0; count < length / 4; count++, address += 4) {
+		ret = ath6kl_diag_write32(ar, address, buf[count]);
+		if (ret)
+			return ret;
 	}
 
-	return status;
+	return ret;
 }
 
 /* FIXME: move to a better place, target.h? */
@@ -327,7 +337,7 @@ static void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 		break;
 	}
 
-	status = ath6kl_write_reg_diag(ar, &address, &data);
+	status = ath6kl_diag_write32(ar, address, data);
 
 	if (status)
 		ath6kl_err("failed to reset target\n");


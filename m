Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:60678 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1J3TQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 15:16:46 -0400
Subject: [PATCH 4/5] ath6kl: print firmware crashes always
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Oct 2011 21:16:41 +0200
Message-ID: <20111030191641.20466.36114.stgit@localhost6.localdomain6> (sfid-20111030_201651_994689_81616184)
In-Reply-To: <20111030190922.20466.299.stgit@localhost6.localdomain6>
References: <20111030190922.20466.299.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently firmware crash dump is printed only if debug is enabled.
Change it so that the crash dump is always printed.

Also move the code from init.c to hif.c.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 
 drivers/net/wireless/ath/ath6kl/hif.c  |   69 ++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/init.c |   55 --------------------------
 3 files changed, 61 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 1ac0dd1..95aed7d 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -654,7 +654,6 @@ void aggr_recv_delba_req_evt(struct ath6kl_vif *vif, u8 tid);
 void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
 			     u8 win_sz);
 void ath6kl_wakeup_event(void *dev);
-void ath6kl_target_failure(struct ath6kl *ar);
 
 void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 			 bool wait_fot_compltn, bool cold_reset);
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index 309be98..e57da35 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -59,26 +59,79 @@ int ath6kl_hif_rw_comp_handler(void *context, int status)
 
 	return 0;
 }
+#define REG_DUMP_COUNT_AR6003   60
+#define REGISTER_DUMP_LEN_MAX   60
+
+static void ath6kl_hif_dump_fw_crash(struct ath6kl *ar)
+{
+	__le32 regdump_val[REGISTER_DUMP_LEN_MAX];
+	u32 i, address, regdump_addr = 0;
+	int ret;
+
+	if (ar->target_type != TARGET_TYPE_AR6003)
+		return;
+
+	/* the reg dump pointer is copied to the host interest area */
+	address = ath6kl_get_hi_item_addr(ar, HI_ITEM(hi_failure_state));
+	address = TARG_VTOP(ar->target_type, address);
+
+	/* read RAM location through diagnostic window */
+	ret = ath6kl_diag_read32(ar, address, &regdump_addr);
+
+	if (ret || !regdump_addr) {
+		ath6kl_warn("failed to get ptr to register dump area: %d\n",
+			    ret);
+		return;
+	}
+
+	ath6kl_dbg(ATH6KL_DBG_IRQ, "register dump data address 0x%x\n",
+		regdump_addr);
+	regdump_addr = TARG_VTOP(ar->target_type, regdump_addr);
+
+	/* fetch register dump data */
+	ret = ath6kl_diag_read(ar, regdump_addr, (u8 *)&regdump_val[0],
+				  REG_DUMP_COUNT_AR6003 * (sizeof(u32)));
+	if (ret) {
+		ath6kl_warn("failed to get register dump: %d\n", ret);
+		return;
+	}
+
+	ath6kl_info("crash dump:\n");
+	ath6kl_info("hw 0x%x fw %s\n", ar->wiphy->hw_version,
+		    ar->wiphy->fw_version);
+
+	BUILD_BUG_ON(REG_DUMP_COUNT_AR6003 % 4);
+
+	for (i = 0; i < REG_DUMP_COUNT_AR6003 / 4; i++) {
+		ath6kl_info("%d: 0x%8.8x 0x%8.8x 0x%8.8x 0x%8.8x\n",
+			    4 * i,
+			    le32_to_cpu(regdump_val[i]),
+			    le32_to_cpu(regdump_val[i + 1]),
+			    le32_to_cpu(regdump_val[i + 2]),
+			    le32_to_cpu(regdump_val[i + 3]));
+	}
+
+}
 
 static int ath6kl_hif_proc_dbg_intr(struct ath6kl_device *dev)
 {
 	u32 dummy;
-	int status;
+	int ret;
 
-	ath6kl_err("target debug interrupt\n");
-
-	ath6kl_target_failure(dev->ar);
+	ath6kl_warn("firmware crashed\n");
 
 	/*
 	 * read counter to clear the interrupt, the debug error interrupt is
 	 * counter 0.
 	 */
-	status = hif_read_write_sync(dev->ar, COUNT_DEC_ADDRESS,
+	ret = hif_read_write_sync(dev->ar, COUNT_DEC_ADDRESS,
 				     (u8 *)&dummy, 4, HIF_RD_SYNC_BYTE_INC);
-	if (status)
-		WARN_ON(1);
+	if (ret)
+		ath6kl_warn("Failed to clear debug interrupt: %d\n", ret);
 
-	return status;
+	ath6kl_hif_dump_fw_crash(dev->ar);
+
+	return ret;
 }
 
 /* mailbox recv message polling */
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c197e4c..06e5cea 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -298,61 +298,6 @@ out:
 	return status;
 }
 
-#define REG_DUMP_COUNT_AR6003   60
-#define REGISTER_DUMP_LEN_MAX   60
-
-static void ath6kl_dump_target_assert_info(struct ath6kl *ar)
-{
-	u32 address;
-	u32 regdump_loc = 0;
-	int status;
-	u32 regdump_val[REGISTER_DUMP_LEN_MAX];
-	u32 i;
-
-	if (ar->target_type != TARGET_TYPE_AR6003)
-		return;
-
-	/* the reg dump pointer is copied to the host interest area */
-	address = ath6kl_get_hi_item_addr(ar, HI_ITEM(hi_failure_state));
-	address = TARG_VTOP(ar->target_type, address);
-
-	/* read RAM location through diagnostic window */
-	status = ath6kl_diag_read32(ar, address, &regdump_loc);
-
-	if (status || !regdump_loc) {
-		ath6kl_err("failed to get ptr to register dump area\n");
-		return;
-	}
-
-	ath6kl_dbg(ATH6KL_DBG_TRC, "location of register dump data: 0x%X\n",
-		regdump_loc);
-	regdump_loc = TARG_VTOP(ar->target_type, regdump_loc);
-
-	/* fetch register dump data */
-	status = ath6kl_diag_read(ar, regdump_loc, (u8 *)&regdump_val[0],
-				  REG_DUMP_COUNT_AR6003 * (sizeof(u32)));
-
-	if (status) {
-		ath6kl_err("failed to get register dump\n");
-		return;
-	}
-	ath6kl_dbg(ATH6KL_DBG_TRC, "Register Dump:\n");
-
-	for (i = 0; i < REG_DUMP_COUNT_AR6003; i++)
-		ath6kl_dbg(ATH6KL_DBG_TRC, " %d :  0x%8.8X\n",
-			   i, regdump_val[i]);
-
-}
-
-void ath6kl_target_failure(struct ath6kl *ar)
-{
-	ath6kl_err("target asserted\n");
-
-	/* try dumping target assertion information (if any) */
-	ath6kl_dump_target_assert_info(ar);
-
-}
-
 static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 {
 	int status = 0;


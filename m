Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab2BMKYw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:52 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 22/24] iwlegacy: s/S_RF_KILL_HW/S_RFKILL/g
Date: Mon, 13 Feb 2012 11:23:29 +0100
Message-Id: <1329128611-6815-23-git-send-email-sgruszka@redhat.com> (sfid-20120213_112457_267952_BEC4F24E)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |   30 +++++++++++++++---------------
 drivers/net/wireless/iwlegacy/4965-mac.c |   28 ++++++++++++++--------------
 drivers/net/wireless/iwlegacy/common.c   |    6 +++---
 drivers/net/wireless/iwlegacy/common.h   |    4 ++--
 drivers/net/wireless/iwlegacy/debug.c    |    4 ++--
 5 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index ee91ab2..0ccc934 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -809,16 +809,16 @@ il3945_hdl_card_state(struct il_priv *il, struct il_rx_buf *rxb)
 	_il_wr(il, CSR_UCODE_DRV_GP1_SET, CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	if (flags & HW_CARD_DISABLED)
-		set_bit(S_RF_KILL_HW, &il->status);
+		set_bit(S_RFKILL, &il->status);
 	else
-		clear_bit(S_RF_KILL_HW, &il->status);
+		clear_bit(S_RFKILL, &il->status);
 
 	il_scan_cancel(il);
 
-	if ((test_bit(S_RF_KILL_HW, &status) !=
-	     test_bit(S_RF_KILL_HW, &il->status)))
+	if ((test_bit(S_RFKILL, &status) !=
+	     test_bit(S_RFKILL, &il->status)))
 		wiphy_rfkill_set_hw_state(il->hw->wiphy,
-					  test_bit(S_RF_KILL_HW, &il->status));
+					  test_bit(S_RFKILL, &il->status));
 	else
 		wake_up(&il->wait_command_queue);
 }
@@ -2166,7 +2166,7 @@ il3945_alive_start(struct il_priv *il)
 	D_INFO("RFKILL status: 0x%x\n", rfkill);
 
 	if (rfkill & 0x1) {
-		clear_bit(S_RF_KILL_HW, &il->status);
+		clear_bit(S_RFKILL, &il->status);
 		/* if RFKILL is not on, then wait for thermal
 		 * sensor in adapter to kick in */
 		while (il3945_hw_get_temperature(il) == 0) {
@@ -2178,7 +2178,7 @@ il3945_alive_start(struct il_priv *il)
 			D_INFO("Thermal calibration took %dus\n",
 			       thermal_spin * 10);
 	} else
-		set_bit(S_RF_KILL_HW, &il->status);
+		set_bit(S_RFKILL, &il->status);
 
 	/* After the ALIVE response, we can send commands to 3945 uCode */
 	set_bit(S_ALIVE, &il->status);
@@ -2272,7 +2272,7 @@ __il3945_down(struct il_priv *il)
 	 * clear all bits but the RF Kill bits and return */
 	if (!il_is_init(il)) {
 		il->status =
-		    test_bit(S_RF_KILL_HW, &il->status) << S_RF_KILL_HW |
+		    test_bit(S_RFKILL, &il->status) << S_RFKILL |
 		    test_bit(S_GEO_CONFIGURED, &il->status) << S_GEO_CONFIGURED |
 		    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
 		goto exit;
@@ -2281,7 +2281,7 @@ __il3945_down(struct il_priv *il)
 	/* ...otherwise clear out all the status bits but the RF Kill
 	 * bit and continue taking the NIC down. */
 	il->status &=
-	    test_bit(S_RF_KILL_HW, &il->status) << S_RF_KILL_HW |
+	    test_bit(S_RFKILL, &il->status) << S_RFKILL |
 	    test_bit(S_GEO_CONFIGURED, &il->status) << S_GEO_CONFIGURED |
 	    test_bit(S_FW_ERROR, &il->status) << S_FW_ERROR |
 	    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
@@ -2371,9 +2371,9 @@ __il3945_up(struct il_priv *il)
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (_il_rd(il, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(S_RF_KILL_HW, &il->status);
+		clear_bit(S_RFKILL, &il->status);
 	else {
-		set_bit(S_RF_KILL_HW, &il->status);
+		set_bit(S_RFKILL, &il->status);
 		IL_WARN("Radio disabled by HW RF Kill switch\n");
 		return -ENODEV;
 	}
@@ -2405,7 +2405,7 @@ __il3945_up(struct il_priv *il)
 	       il->ucode_data.len);
 
 	/* We return success when we resume from suspend and rf_kill is on. */
-	if (test_bit(S_RF_KILL_HW, &il->status))
+	if (test_bit(S_RFKILL, &il->status))
 		return 0;
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
@@ -2485,15 +2485,15 @@ il3945_rfkill_poll(struct work_struct *data)
 {
 	struct il_priv *il =
 	    container_of(data, struct il_priv, _3945.rfkill_poll.work);
-	bool old_rfkill = test_bit(S_RF_KILL_HW, &il->status);
+	bool old_rfkill = test_bit(S_RFKILL, &il->status);
 	bool new_rfkill =
 	    !(_il_rd(il, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 
 	if (new_rfkill != old_rfkill) {
 		if (new_rfkill)
-			set_bit(S_RF_KILL_HW, &il->status);
+			set_bit(S_RFKILL, &il->status);
 		else
-			clear_bit(S_RF_KILL_HW, &il->status);
+			clear_bit(S_RFKILL, &il->status);
 
 		wiphy_rfkill_set_hw_state(il->hw->wiphy, new_rfkill);
 
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index a0158e3..3aa0ee5 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4110,17 +4110,17 @@ il4965_hdl_card_state(struct il_priv *il, struct il_rx_buf *rxb)
 		il4965_perform_ct_kill_task(il);
 
 	if (flags & HW_CARD_DISABLED)
-		set_bit(S_RF_KILL_HW, &il->status);
+		set_bit(S_RFKILL, &il->status);
 	else
-		clear_bit(S_RF_KILL_HW, &il->status);
+		clear_bit(S_RFKILL, &il->status);
 
 	if (!(flags & RXON_CARD_DISABLED))
 		il_scan_cancel(il);
 
-	if ((test_bit(S_RF_KILL_HW, &status) !=
-	     test_bit(S_RF_KILL_HW, &il->status)))
+	if ((test_bit(S_RFKILL, &status) !=
+	     test_bit(S_RFKILL, &il->status)))
 		wiphy_rfkill_set_hw_state(il->hw->wiphy,
-					  test_bit(S_RF_KILL_HW, &il->status));
+					  test_bit(S_RFKILL, &il->status));
 	else
 		wake_up(&il->wait_command_queue);
 }
@@ -4412,9 +4412,9 @@ il4965_irq_tasklet(struct il_priv *il)
 		 */
 		if (!test_bit(S_ALIVE, &il->status)) {
 			if (hw_rf_kill)
-				set_bit(S_RF_KILL_HW, &il->status);
+				set_bit(S_RFKILL, &il->status);
 			else
-				clear_bit(S_RF_KILL_HW, &il->status);
+				clear_bit(S_RFKILL, &il->status);
 			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 		}
 
@@ -5383,7 +5383,7 @@ __il4965_down(struct il_priv *il)
 	 * clear all bits but the RF Kill bit and return */
 	if (!il_is_init(il)) {
 		il->status =
-		    test_bit(S_RF_KILL_HW, &il->status) << S_RF_KILL_HW |
+		    test_bit(S_RFKILL, &il->status) << S_RFKILL |
 		    test_bit(S_GEO_CONFIGURED, &il->status) << S_GEO_CONFIGURED |
 		    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
 		goto exit;
@@ -5392,7 +5392,7 @@ __il4965_down(struct il_priv *il)
 	/* ...otherwise clear out all the status bits but the RF Kill
 	 * bit and continue taking the NIC down. */
 	il->status &=
-	    test_bit(S_RF_KILL_HW, &il->status) << S_RF_KILL_HW |
+	    test_bit(S_RFKILL, &il->status) << S_RFKILL |
 	    test_bit(S_GEO_CONFIGURED, &il->status) << S_GEO_CONFIGURED |
 	    test_bit(S_FW_ERROR, &il->status) << S_FW_ERROR |
 	    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
@@ -5514,9 +5514,9 @@ __il4965_up(struct il_priv *il)
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (_il_rd(il, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(S_RF_KILL_HW, &il->status);
+		clear_bit(S_RFKILL, &il->status);
 	else {
-		set_bit(S_RF_KILL_HW, &il->status);
+		set_bit(S_RFKILL, &il->status);
 		wiphy_rfkill_set_hw_state(il->hw->wiphy, true);
 
 		il_enable_rfkill_int(il);
@@ -6612,12 +6612,12 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (_il_rd(il, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(S_RF_KILL_HW, &il->status);
+		clear_bit(S_RFKILL, &il->status);
 	else
-		set_bit(S_RF_KILL_HW, &il->status);
+		set_bit(S_RFKILL, &il->status);
 
 	wiphy_rfkill_set_hw_state(il->hw->wiphy,
-				  test_bit(S_RF_KILL_HW, &il->status));
+				  test_bit(S_RFKILL, &il->status));
 
 	il_power_initialize(il);
 
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 872302a..defe8d9 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -350,7 +350,7 @@ il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 		}
 	}
 
-	if (test_bit(S_RF_KILL_HW, &il->status)) {
+	if (test_bit(S_RFKILL, &il->status)) {
 		IL_ERR("Command %s aborted: RF KILL Switch\n",
 		       il_get_cmd_string(cmd->id));
 		ret = -ECANCELED;
@@ -4890,9 +4890,9 @@ il_pci_resume(struct device *device)
 		hw_rfkill = true;
 
 	if (hw_rfkill)
-		set_bit(S_RF_KILL_HW, &il->status);
+		set_bit(S_RFKILL, &il->status);
 	else
-		clear_bit(S_RF_KILL_HW, &il->status);
+		clear_bit(S_RFKILL, &il->status);
 
 	wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rfkill);
 
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index e2f55dc..4282018 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1906,7 +1906,7 @@ void il_free_geos(struct il_priv *il);
 #define S_HCMD_ACTIVE	0	/* host command in progress */
 /* 1 is unused (used to be S_HCMD_SYNC_ACTIVE) */
 #define S_INT_ENABLED	2
-#define S_RF_KILL_HW	3
+#define S_RFKILL	3
 #define S_CT_KILL		4
 #define S_INIT		5
 #define S_ALIVE		6
@@ -1947,7 +1947,7 @@ il_is_init(struct il_priv *il)
 static inline int
 il_is_rfkill_hw(struct il_priv *il)
 {
-	return test_bit(S_RF_KILL_HW, &il->status);
+	return test_bit(S_RFKILL, &il->status);
 }
 
 static inline int
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index 236dc90..2298491 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -630,8 +630,8 @@ il_dbgfs_status_read(struct file *file, char __user *user_buf, size_t count,
 	    scnprintf(buf + pos, bufsz - pos, "S_INT_ENABLED:\t %d\n",
 		      test_bit(S_INT_ENABLED, &il->status));
 	pos +=
-	    scnprintf(buf + pos, bufsz - pos, "S_RF_KILL_HW:\t %d\n",
-		      test_bit(S_RF_KILL_HW, &il->status));
+	    scnprintf(buf + pos, bufsz - pos, "S_RFKILL:\t %d\n",
+		      test_bit(S_RFKILL, &il->status));
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos, "S_CT_KILL:\t\t %d\n",
 		      test_bit(S_CT_KILL, &il->status));
-- 
1.7.1


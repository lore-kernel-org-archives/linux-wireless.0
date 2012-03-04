Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab2CDUnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:12 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 089/101] iwlwifi: separate status to priv and trans
Date: Sun,  4 Mar 2012 11:29:43 -0800
Message-Id: <1330889395-533-90-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214446_180735_DF3A5386)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The shared status bits are a mixture of transport and op mode bits.
Some are used just by one or the other, some are shared.  Begin the
de-tangling of these bits.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |   16 +++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    6 +-----
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    2 --
 7 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 6d8a857..3fed4bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1291,7 +1291,7 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 
 int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	if (iwl_is_rfkill(priv->shrd) || iwl_is_ctkill(priv->shrd)) {
+	if (iwl_is_rfkill(priv->shrd) || iwl_is_ctkill(priv)) {
 		IWL_WARN(priv, "Not sending command - %s KILL\n",
 			 iwl_is_rfkill(priv->shrd) ? "RF" : "CT");
 		return -EIO;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 9a12b70..fa94153 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -233,7 +233,7 @@ static void iwl_tt_ready_for_ct_kill(unsigned long data)
 		IWL_DEBUG_TEMP(priv, "entering CT_KILL state when "
 				"temperature timer expired\n");
 		tt->state = IWL_TI_CT_KILL;
-		set_bit(STATUS_CT_KILL, &priv->shrd->status);
+		set_bit(STATUS_CT_KILL, &priv->status);
 		iwl_perform_ct_kill_task(priv, true);
 	}
 }
@@ -313,22 +313,21 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 		}
 		mutex_lock(&priv->mutex);
 		if (old_state == IWL_TI_CT_KILL)
-			clear_bit(STATUS_CT_KILL, &priv->shrd->status);
+			clear_bit(STATUS_CT_KILL, &priv->status);
 		if (tt->state != IWL_TI_CT_KILL &&
 		    iwl_power_update_mode(priv, true)) {
 			/* TT state not updated
 			 * try again during next temperature read
 			 */
 			if (old_state == IWL_TI_CT_KILL)
-				set_bit(STATUS_CT_KILL, &priv->shrd->status);
+				set_bit(STATUS_CT_KILL, &priv->status);
 			tt->state = old_state;
 			IWL_ERR(priv, "Cannot update power mode, "
 					"TT state not updated\n");
 		} else {
 			if (tt->state == IWL_TI_CT_KILL) {
 				if (force) {
-					set_bit(STATUS_CT_KILL,
-						&priv->shrd->status);
+					set_bit(STATUS_CT_KILL, &priv->status);
 					iwl_perform_ct_kill_task(priv, true);
 				} else {
 					iwl_prepare_ct_kill_task(priv);
@@ -454,7 +453,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 		}
 		mutex_lock(&priv->mutex);
 		if (old_state == IWL_TI_CT_KILL)
-			clear_bit(STATUS_CT_KILL, &priv->shrd->status);
+			clear_bit(STATUS_CT_KILL, &priv->status);
 		if (tt->state != IWL_TI_CT_KILL &&
 		    iwl_power_update_mode(priv, true)) {
 			/* TT state not updated
@@ -463,7 +462,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			IWL_ERR(priv, "Cannot update power mode, "
 					"TT state not updated\n");
 			if (old_state == IWL_TI_CT_KILL)
-				set_bit(STATUS_CT_KILL, &priv->shrd->status);
+				set_bit(STATUS_CT_KILL, &priv->status);
 			tt->state = old_state;
 		} else {
 			IWL_DEBUG_TEMP(priv,
@@ -474,8 +473,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 				if (force) {
 					IWL_DEBUG_TEMP(priv,
 						"Enter IWL_TI_CT_KILL\n");
-					set_bit(STATUS_CT_KILL,
-						&priv->shrd->status);
+					set_bit(STATUS_CT_KILL, &priv->status);
 					iwl_perform_ct_kill_task(priv, true);
 				} else {
 					iwl_prepare_ct_kill_task(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 6345ab0..ede1852 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -367,11 +367,6 @@ static inline int iwl_is_alive(struct iwl_shared *shrd)
 	return test_bit(STATUS_ALIVE, &shrd->status);
 }
 
-static inline int iwl_is_init(struct iwl_shared *shrd)
-{
-	return test_bit(STATUS_INIT, &shrd->status);
-}
-
 static inline int iwl_is_rfkill_hw(struct iwl_shared *shrd)
 {
 	return test_bit(STATUS_RF_KILL_HW, &shrd->status);
@@ -382,9 +377,9 @@ static inline int iwl_is_rfkill(struct iwl_shared *shrd)
 	return iwl_is_rfkill_hw(shrd);
 }
 
-static inline int iwl_is_ctkill(struct iwl_shared *shrd)
+static inline int iwl_is_ctkill(struct iwl_priv *priv)
 {
-	return test_bit(STATUS_CT_KILL, &shrd->status);
+	return test_bit(STATUS_CT_KILL, &priv->status);
 }
 
 static inline int iwl_is_ready_rf(struct iwl_shared *shrd)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 5e1b078..71f8cc8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -530,15 +530,11 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_HW:\t %d\n",
 		test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_CT_KILL:\t\t %d\n",
-		test_bit(STATUS_CT_KILL, &priv->shrd->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INIT:\t\t %d\n",
-		test_bit(STATUS_INIT, &priv->shrd->status));
+		test_bit(STATUS_CT_KILL, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_ALIVE:\t\t %d\n",
 		test_bit(STATUS_ALIVE, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_READY:\t\t %d\n",
 		test_bit(STATUS_READY, &priv->shrd->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_TEMPERATURE:\t %d\n",
-		test_bit(STATUS_TEMPERATURE, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_GEO_CONFIGURED:\t %d\n",
 		test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_EXIT_PENDING:\t %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c3f372e..1b05fae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -713,6 +713,7 @@ struct iwl_priv {
 	/*data shared among all the driver's layers */
 	struct iwl_shared *shrd;
 	const struct iwl_fw *fw;
+	unsigned long status;
 
 	spinlock_t sta_lock;
 	struct mutex mutex;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 93d89a3..16a32ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -247,6 +247,7 @@ struct iwl_tx_queue {
  * @hw_base: pci hardware address support
  * @ucode_write_complete: indicates that the ucode has been copied.
  * @ucode_write_waitq: wait queue for uCode load
+ * @status - transport specific status flags
  */
 struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
@@ -287,6 +288,7 @@ struct iwl_trans_pcie {
 
 	bool ucode_write_complete;
 	wait_queue_head_t ucode_write_waitq;
+	unsigned long status;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 1d35d0e..4e56c3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -840,8 +840,6 @@ static int iwl_nic_init(struct iwl_trans *trans)
 			0x800FFFFF);
 	}
 
-	set_bit(STATUS_INIT, &trans->shrd->status);
-
 	return 0;
 }
 
-- 
1.7.0.4


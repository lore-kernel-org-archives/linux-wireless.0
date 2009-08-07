Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbZHGWl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/16] iwlwifi: revert uCode Alive notification with timeout
Date: Fri,  7 Aug 2009 15:41:44 -0700
Message-Id: <1249684912-22936-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

commit "iwlwifi: uCode Alive notification with timeout" introduced a more
reliable mechanism for ucode loading. Unfortunately we hit a problem with
it frequently enough to make a 4965 unusable. The problem can be seen in
debug log below. What this code attempts is to set runtime ucode up to
load, start a timer to wait for the alive response from runtime ucode, and
if it times out it tries again. As can be seen below we receive the alive
response and wake the waiting task _before_ the tasks starts waiting. The
task thus times out as the alive response is not received while it is
waiting for it and it restarts the device. This starts the cycle all over
again.

[29739.000819] ieee80211 phy0: U iwl_mac_start enter
[29739.005751] ieee80211 phy0: U iwl_prepare_card_hw iwl_prepare_card_hw enter
[29739.012798] ieee80211 phy0: U iwl_set_hw_ready hardware ready
[29739.057200] ieee80211 phy0: U iwl4965_load_bsm Begin load bsm
[29739.063366] ieee80211 phy0: U iwl4965_verify_bsm Begin verify bsm
[29739.072485] ieee80211 phy0: U iwl4965_verify_bsm BSM bootstrap uCode image OK
[29739.079671] ieee80211 phy0: U iwl4965_load_bsm BSM write complete, poll 0 iterations
[29739.257019] ieee80211 phy0: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
[29739.260964] ieee80211 phy0: I iwl_rx_reply_alive Initialization Alive received.
[29739.260964] ieee80211 phy0: U __iwl_up iwlagn is coming up
[29739.278571] ieee80211 phy0: U iwl_mac_start Start UP work done.
[29739.284509] ieee80211 phy0: U iwlcore_verify_inst_sparse ucode inst image size is 788
[29739.292432] ieee80211 phy0: U iwlcore_verify_inst_sparse ucode inst image size is 10312
[29739.302004] ieee80211 phy0: U iwl_verify_ucode Initialize uCode is good in inst SRAM
[29739.309746] ieee80211 phy0: U iwl4965_hw_get_temperature Running temperature calibration
[29739.317833] ieee80211 phy0: U iwl4965_hw_get_temperature Calib values R[1-3]: -36 13522 -13496 R4: -2726
[29739.327337] ieee80211 phy0: U iwl4965_hw_get_temperature Calibrated temperature: 310K, 37C
[29739.335598] ieee80211 phy0: U iwl4965_init_alive_start Initialization Alive received.
[29739.343477] ieee80211 phy0: U iwl4965_set_ucode_ptrs Runtime uCode pointers are set.
[29739.351283] ieee80211 phy0: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
[29739.355210] ieee80211 phy0: I iwl_rx_reply_alive Runtime Alive received.
[29739.366731] iwlagn 0000:03:00.0: Runtime uCode already alive? Waiting for alive anyway
[29743.284110] iwlagn 0000:03:00.0: START_ALIVE timeout after 4000ms.
[29743.290337] ieee80211 phy0: U iwl_mac_add_interface enter: type 2
[29744.364089] iwlagn 0000:03:00.0: Runtime timeout after 5000ms
[29744.370882] ieee80211 phy0: U iwl_alive_start Runtime Alive received.
[29744.377347] ieee80211 phy0: U iwlcore_verify_inst_sparse ucode inst image size is 788
[29744.385287] ieee80211 phy0: U iwlcore_verify_inst_sparse ucode inst image size is 10312
[29744.393397] ieee80211 phy0: U iwlcore_verify_inst_sparse ucode inst image size is 94720
[29744.415835] ieee80211 phy0: U iwl_verify_ucode Runtime uCode is good in inst SRAM

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   26 +---------------
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   50 -------------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c |   39 +++++------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 -
 5 files changed, 10 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f02023e..e427a89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -146,7 +146,7 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO(priv, "Begin load bsm\n");
 
-	priv->ucode_type = UCODE_INIT;
+	priv->ucode_type = UCODE_RT;
 
 	/* make sure bootstrap program is no larger than BSM's SRAM size */
 	if (len > IWL49_MAX_BSM_SIZE)
@@ -256,8 +256,6 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 */
 static void iwl4965_init_alive_start(struct iwl_priv *priv)
 {
-	int ret;
-
 	/* Check alive response for "valid" sign from uCode */
 	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
@@ -289,28 +287,6 @@ static void iwl4965_init_alive_start(struct iwl_priv *priv)
 		IWL_DEBUG_INFO(priv, "Couldn't set up uCode pointers.\n");
 		goto restart;
 	}
-	priv->ucode_type = UCODE_RT;
-	if (test_bit(STATUS_RT_UCODE_ALIVE, &priv->status)) {
-		IWL_WARN(priv, "Runtime uCode already alive? "
-			"Waiting for alive anyway\n");
-		clear_bit(STATUS_RT_UCODE_ALIVE, &priv->status);
-	}
-	ret = wait_event_interruptible_timeout(
-			priv->wait_command_queue,
-			test_bit(STATUS_RT_UCODE_ALIVE, &priv->status),
-			UCODE_ALIVE_TIMEOUT);
-	if (!ret) {
-		/* FIXME: if STATUS_RT_UCODE_ALIVE timeout
-		 * go back to restart the download Init uCode again
-		 * this might cause to trap in the restart loop
-		 */
-		priv->ucode_type = UCODE_NONE;
-		if (!test_bit(STATUS_RT_UCODE_ALIVE, &priv->status)) {
-			IWL_ERR(priv, "Runtime timeout after %dms\n",
-				jiffies_to_msecs(UCODE_ALIVE_TIMEOUT));
-			goto restart;
-		}
-	}
 	return;
 
 restart:
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c9a1aac..319df4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -533,16 +533,12 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 
 	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
 		IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
-		set_bit(STATUS_INIT_UCODE_ALIVE, &priv->status);
-		wake_up_interruptible(&priv->wait_command_queue);
 		memcpy(&priv->card_alive_init,
 		       &pkt->u.alive_frame,
 		       sizeof(struct iwl_init_alive_resp));
 		pwork = &priv->init_alive_start;
 	} else {
 		IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
-		set_bit(STATUS_RT_UCODE_ALIVE, &priv->status);
-		wake_up_interruptible(&priv->wait_command_queue);
 		memcpy(&priv->card_alive, &pkt->u.alive_frame,
 		       sizeof(struct iwl_alive_resp));
 		pwork = &priv->alive_start;
@@ -1784,7 +1780,6 @@ static int __iwl_up(struct iwl_priv *priv)
 {
 	int i;
 	int ret;
-	unsigned long status;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
@@ -1862,51 +1857,6 @@ static int __iwl_up(struct iwl_priv *priv)
 		/* start card; "initialize" will load runtime ucode */
 		iwl_nic_start(priv);
 
-		/* Just finish download Init or Runtime uCode image to device
-		 * now we wait here for uCode send REPLY_ALIVE notification
-		 * to indicate uCode is ready.
-		 * 1) For Init uCode image, all iwlagn devices should wait here
-		 * on STATUS_INIT_UCODE_ALIVE status bit; if timeout before
-		 * receive the REPLY_ALIVE notification, go back and try to
-		 * download the Init uCode image again.
-		 * 2) For Runtime uCode image, all iwlagn devices except 4965
-		 * wait here on STATUS_RT_UCODE_ALIVE status bit; if
-		 * timeout before receive the REPLY_ALIVE notification, go back
-		 * and download the Runtime uCode image again.
-		 * 3) For 4965 Runtime uCode, it will not go through this path,
-		 * need to wait for STATUS_RT_UCODE_ALIVE status bit in
-		 * iwl4965_init_alive_start() function; if timeout, need to
-		 * restart and download Init uCode image.
-		 */
-		if (priv->ucode_type == UCODE_INIT)
-			status = STATUS_INIT_UCODE_ALIVE;
-		else
-			status = STATUS_RT_UCODE_ALIVE;
-		if (test_bit(status, &priv->status)) {
-			IWL_WARN(priv,
-				"%s uCode already alive? "
-				"Waiting for alive anyway\n",
-				(status == STATUS_INIT_UCODE_ALIVE)
-				? "INIT" : "Runtime");
-			clear_bit(status, &priv->status);
-		}
-		ret = wait_event_interruptible_timeout(
-				priv->wait_command_queue,
-				test_bit(status, &priv->status),
-				UCODE_ALIVE_TIMEOUT);
-		if (!ret) {
-			if (!test_bit(status, &priv->status)) {
-				priv->ucode_type =
-					(status == STATUS_INIT_UCODE_ALIVE)
-					? UCODE_NONE : UCODE_INIT;
-				IWL_ERR(priv,
-					"%s timeout after %dms\n",
-					(status == STATUS_INIT_UCODE_ALIVE)
-					? "INIT" : "Runtime",
-					jiffies_to_msecs(UCODE_ALIVE_TIMEOUT));
-				continue;
-			}
-		}
 		IWL_DEBUG_INFO(priv, DRV_NAME " is coming up\n");
 
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 202bc39..79170a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1343,17 +1343,10 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	u32 desc, time, count, base, data1;
 	u32 blink1, blink2, ilink1, ilink2;
 
-	switch (priv->ucode_type) {
-	case UCODE_RT:
-		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
-		break;
-	case UCODE_INIT:
+	if (priv->ucode_type == UCODE_INIT)
 		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
-		break;
-	default:
-		IWL_ERR(priv, "uCode image not available\n");
-		return;
-	}
+	else
+		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv, "Not valid error log pointer 0x%08X\n", base);
@@ -1405,17 +1398,10 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 	if (num_events == 0)
 		return;
-	switch (priv->ucode_type) {
-	case UCODE_RT:
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-		break;
-	case UCODE_INIT:
+	if (priv->ucode_type == UCODE_INIT)
 		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-		break;
-	default:
-		IWL_ERR(priv, "uCode image not available\n");
-		return;
-	}
+	else
+		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 
 	if (mode == 0)
 		event_size = 2 * sizeof(u32);
@@ -1452,17 +1438,10 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	u32 next_entry; /* index of next entry to be written by uCode */
 	u32 size;       /* # entries that we'll print */
 
-	switch (priv->ucode_type) {
-	case UCODE_RT:
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-		break;
-	case UCODE_INIT:
+	if (priv->ucode_type == UCODE_INIT)
 		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-		break;
-	default:
-		IWL_ERR(priv, "uCode image not available\n");
-		return;
-	}
+	else
+		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index fc096b9..ea8748d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -547,8 +547,6 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
 #define STATUS_MODE_PENDING	18
-#define STATUS_INIT_UCODE_ALIVE	19
-#define STATUS_RT_UCODE_ALIVE	20
 
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index dcf9d57..61f9523 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -823,8 +823,6 @@ struct iwl_calib_result {
 	size_t buf_len;
 };
 
-#define UCODE_ALIVE_TIMEOUT	(5 * HZ)
-
 enum ucode_type {
 	UCODE_NONE = 0,
 	UCODE_INIT,
-- 
1.5.6.3


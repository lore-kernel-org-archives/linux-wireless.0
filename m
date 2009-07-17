Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47318 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964889AbZGQQac (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/14] iwlwifi: uCode Alive notification with timeout
Date: Fri, 17 Jul 2009 09:30:23 -0700
Message-Id: <1247848227-24031-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-10-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-8-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-9-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Wait for REPLY_ALIVE notification from init and runtime uCode.
based on the type of REPLY_ALIVE, different status bit will be set to
wake up the queue:
STATUS_INIT_UCODE_ALIVE for init uCode
STATUS_RT_UCODE_ALIVE for runtime uCode.

If timeout, attempt to download the failing uCode image again. This can
only be done for the init ucode images of all iwlagn devices and the
runtime ucode image of the 5000 series and up. If there is a problem
with the 4965 runtime ucode coming up we restart the interface and thus
trigger a new download of the init ucode also.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   26 +++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   50 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |   39 ++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +
 5 files changed, 109 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f4eb683..272409c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -146,7 +146,7 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO(priv, "Begin load bsm\n");
 
-	priv->ucode_type = UCODE_RT;
+	priv->ucode_type = UCODE_INIT;
 
 	/* make sure bootstrap program is no larger than BSM's SRAM size */
 	if (len > IWL49_MAX_BSM_SIZE)
@@ -256,6 +256,8 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 */
 static void iwl4965_init_alive_start(struct iwl_priv *priv)
 {
+	int ret;
+
 	/* Check alive response for "valid" sign from uCode */
 	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
@@ -287,6 +289,28 @@ static void iwl4965_init_alive_start(struct iwl_priv *priv)
 		IWL_DEBUG_INFO(priv, "Couldn't set up uCode pointers.\n");
 		goto restart;
 	}
+	priv->ucode_type = UCODE_RT;
+	if (test_bit(STATUS_RT_UCODE_ALIVE, &priv->status)) {
+		IWL_WARN(priv, "Runtime uCode already alive? "
+			"Waiting for alive anyway\n");
+		clear_bit(STATUS_RT_UCODE_ALIVE, &priv->status);
+	}
+	ret = wait_event_interruptible_timeout(
+			priv->wait_command_queue,
+			test_bit(STATUS_RT_UCODE_ALIVE, &priv->status),
+			UCODE_ALIVE_TIMEOUT);
+	if (!ret) {
+		/* FIXME: if STATUS_RT_UCODE_ALIVE timeout
+		 * go back to restart the download Init uCode again
+		 * this might cause to trap in the restart loop
+		 */
+		priv->ucode_type = UCODE_NONE;
+		if (!test_bit(STATUS_RT_UCODE_ALIVE, &priv->status)) {
+			IWL_ERR(priv, "Runtime timeout after %dms\n",
+				jiffies_to_msecs(UCODE_ALIVE_TIMEOUT));
+			goto restart;
+		}
+	}
 	return;
 
 restart:
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6b874da..f61f653 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -533,12 +533,16 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 
 	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
 		IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
+		set_bit(STATUS_INIT_UCODE_ALIVE, &priv->status);
+		wake_up_interruptible(&priv->wait_command_queue);
 		memcpy(&priv->card_alive_init,
 		       &pkt->u.alive_frame,
 		       sizeof(struct iwl_init_alive_resp));
 		pwork = &priv->init_alive_start;
 	} else {
 		IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
+		set_bit(STATUS_RT_UCODE_ALIVE, &priv->status);
+		wake_up_interruptible(&priv->wait_command_queue);
 		memcpy(&priv->card_alive, &pkt->u.alive_frame,
 		       sizeof(struct iwl_alive_resp));
 		pwork = &priv->alive_start;
@@ -1782,6 +1786,7 @@ static int __iwl_up(struct iwl_priv *priv)
 {
 	int i;
 	int ret;
+	unsigned long status;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
@@ -1859,6 +1864,51 @@ static int __iwl_up(struct iwl_priv *priv)
 		/* start card; "initialize" will load runtime ucode */
 		iwl_nic_start(priv);
 
+		/* Just finish download Init or Runtime uCode image to device
+		 * now we wait here for uCode send REPLY_ALIVE notification
+		 * to indicate uCode is ready.
+		 * 1) For Init uCode image, all iwlagn devices should wait here
+		 * on STATUS_INIT_UCODE_ALIVE status bit; if timeout before
+		 * receive the REPLY_ALIVE notification, go back and try to
+		 * download the Init uCode image again.
+		 * 2) For Runtime uCode image, all iwlagn devices except 4965
+		 * wait here on STATUS_RT_UCODE_ALIVE status bit; if
+		 * timeout before receive the REPLY_ALIVE notification, go back
+		 * and download the Runtime uCode image again.
+		 * 3) For 4965 Runtime uCode, it will not go through this path,
+		 * need to wait for STATUS_RT_UCODE_ALIVE status bit in
+		 * iwl4965_init_alive_start() function; if timeout, need to
+		 * restart and download Init uCode image.
+		 */
+		if (priv->ucode_type == UCODE_INIT)
+			status = STATUS_INIT_UCODE_ALIVE;
+		else
+			status = STATUS_RT_UCODE_ALIVE;
+		if (test_bit(status, &priv->status)) {
+			IWL_WARN(priv,
+				"%s uCode already alive? "
+				"Waiting for alive anyway\n",
+				(status == STATUS_INIT_UCODE_ALIVE)
+				? "INIT" : "Runtime");
+			clear_bit(status, &priv->status);
+		}
+		ret = wait_event_interruptible_timeout(
+				priv->wait_command_queue,
+				test_bit(status, &priv->status),
+				UCODE_ALIVE_TIMEOUT);
+		if (!ret) {
+			if (!test_bit(status, &priv->status)) {
+				priv->ucode_type =
+					(status == STATUS_INIT_UCODE_ALIVE)
+					? UCODE_NONE : UCODE_INIT;
+				IWL_ERR(priv,
+					"%s timeout after %dms\n",
+					(status == STATUS_INIT_UCODE_ALIVE)
+					? "INIT" : "Runtime",
+					jiffies_to_msecs(UCODE_ALIVE_TIMEOUT));
+				continue;
+			}
+		}
 		IWL_DEBUG_INFO(priv, DRV_NAME " is coming up\n");
 
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d5cd9a2..4013549 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2091,10 +2091,17 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	u32 desc, time, count, base, data1;
 	u32 blink1, blink2, ilink1, ilink2;
 
-	if (priv->ucode_type == UCODE_INIT)
-		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
-	else
+	switch (priv->ucode_type) {
+	case UCODE_RT:
 		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
+		break;
+	case UCODE_INIT:
+		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
+		break;
+	default:
+		IWL_ERR(priv, "uCode image not available\n");
+		return;
+	}
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv, "Not valid error log pointer 0x%08X\n", base);
@@ -2147,10 +2154,17 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 	if (num_events == 0)
 		return;
-	if (priv->ucode_type == UCODE_INIT)
-		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-	else
+	switch (priv->ucode_type) {
+	case UCODE_RT:
 		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+		break;
+	case UCODE_INIT:
+		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
+		break;
+	default:
+		IWL_ERR(priv, "uCode image not available\n");
+		return;
+	}
 
 	if (mode == 0)
 		event_size = 2 * sizeof(u32);
@@ -2187,10 +2201,17 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	u32 next_entry; /* index of next entry to be written by uCode */
 	u32 size;       /* # entries that we'll print */
 
-	if (priv->ucode_type == UCODE_INIT)
-		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
-	else
+	switch (priv->ucode_type) {
+	case UCODE_RT:
 		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+		break;
+	case UCODE_INIT:
+		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
+		break;
+	default:
+		IWL_ERR(priv, "uCode image not available\n");
+		return;
+	}
 
 	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6127687..233127d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -513,6 +513,8 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
 #define STATUS_MODE_PENDING	18
+#define STATUS_INIT_UCODE_ALIVE	19
+#define STATUS_RT_UCODE_ALIVE	20
 
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f4afd0c..926df3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -772,6 +772,8 @@ struct iwl_calib_result {
 	size_t buf_len;
 };
 
+#define UCODE_ALIVE_TIMEOUT	(5 * HZ)
+
 enum ucode_type {
 	UCODE_NONE = 0,
 	UCODE_INIT,
-- 
1.5.6.3


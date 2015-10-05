Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57172 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752443AbbJEPBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:45 +0300
Message-Id: <1444055820-27506-14-git-send-email-luca@coelho.fi> (sfid-20151005_170133_545210_CA7D4356)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 14/29] iwlwifi: transport: track number of allocated queues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As the transport will decide how many queues (and MSI-X vectors)
to allocate, add a field to indicate that to the op-mode so it
can size/allocate its own data structures appropriately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.c | 1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 9f8bcef..7161096 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -87,6 +87,7 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 	trans->cfg = cfg;
 	trans->ops = ops;
 	trans->dev_cmd_headroom = dev_cmd_headroom;
+	trans->num_rx_queues = 1;
 
 	snprintf(trans->dev_cmd_pool_name, sizeof(trans->dev_cmd_pool_name),
 		 "iwl_cmd_pool:%s", dev_name(trans->dev));
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index c829c50..bb51b6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -386,6 +386,7 @@ static inline void iwl_free_rxb(struct iwl_rx_cmd_buffer *r)
 #define IWL_MAX_HW_QUEUES		32
 #define IWL_MAX_TID_COUNT	8
 #define IWL_FRAME_LIMIT	64
+#define IWL_MAX_RX_HW_QUEUES	16
 
 /**
  * enum iwl_wowlan_status - WoWLAN image/device status
@@ -654,6 +655,8 @@ enum iwl_d0i3_mode {
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @pm_support: set to true in start_hw if link pm is supported
  * @ltr_enabled: set to true if the LTR is enabled
+ * @num_rx_queues: number of RX queues allocated by the transport;
+ *	the transport must set this before calling iwl_drv_start()
  * @dev_cmd_pool: pool for Tx cmd allocation - for internal use only.
  *	The user should use iwl_trans_{alloc,free}_tx_cmd.
  * @dev_cmd_headroom: room needed for the transport's private use before the
@@ -693,6 +696,8 @@ struct iwl_trans {
 	bool pm_support;
 	bool ltr_enabled;
 
+	u8 num_rx_queues;
+
 	/* The following fields are internal only */
 	struct kmem_cache *dev_cmd_pool;
 	size_t dev_cmd_headroom;
-- 
2.5.3


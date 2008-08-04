Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46683 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYHDIDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:51 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/10] iwlwifi: kill struct iwl4965_lq_mngr
Date: Mon,  4 Aug 2008 16:00:41 +0800
Message-Id: <1217836848-24288-4-git-send-email-yi.zhu@intel.com> (sfid-20080804_100355_992617_629161C3)
In-Reply-To: <1217836848-24288-3-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-2-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes struct iwl4965_lq_mngr it is not used.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   15 ---------------
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9bd6180..f3dd622 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -877,7 +877,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 	spin_lock_init(&priv->power_data.lock);
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
-	spin_lock_init(&priv->lq_mngr.lock);
 
 	INIT_LIST_HEAD(&priv->free_frames);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7920308..f46e9cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -672,18 +672,6 @@ struct iwl_kw {
 
 #define TX_POWER_IWL_ILLEGAL_VOLTAGE -10000
 
-struct iwl4965_lq_mngr {
-	spinlock_t lock;
-	s32 max_window_size;
-	s32 *expected_tpt;
-	u8 *next_higher_rate;
-	u8 *next_lower_rate;
-	unsigned long stamp;
-	unsigned long stamp_last;
-	u32 flush_time;
-	u32 tx_packets;
-};
-
 /* Sensitivity and chain noise calibration */
 #define INTERFERENCE_DATA_AVAILABLE	__constant_cpu_to_le32(1)
 #define INITIALIZATION_VALUE		0xFFFF
@@ -939,9 +927,6 @@ struct iwl_priv {
 	u8 last_phy_res[100];
 
 	/* Rate scaling data */
-	struct iwl4965_lq_mngr lq_mngr;
-
-	/* Rate scaling data */
 	s8 data_retry_limit;
 	u8 retry_rate;
 
-- 
1.5.3.6


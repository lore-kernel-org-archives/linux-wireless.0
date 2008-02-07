Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60716 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935101AbYBGVQd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 16:16:33 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2] iwlwifi: earlier rx allocation
Date: Thu,  7 Feb 2008 13:16:33 -0800
Message-Id: <1202418993-31737-1-git-send-email-reinette.chatre@intel.com> (sfid-20080207_211701_793885_6CFE9A99)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

Value of count is used to decide when to replenish rx buffers. If it is
equal or above 8 we replenish the buffers. Ensure there is no starvation
by initializing count to 8 - thus forcing replenish at first iteration.

This is helpful when rx receives batches of buffers smaller than 8.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

Resending with new patch description.

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a846436..24dcf59 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4272,7 +4272,7 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 	int reclaim;
 	unsigned long flags;
 	u8 fill_rx = 0;
-	u32 count = 0;
+	u32 count = 8;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 8fe47ea..a70d26a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4646,7 +4646,7 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 	int reclaim;
 	unsigned long flags;
 	u8 fill_rx = 0;
-	u32 count = 0;
+	u32 count = 8;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
-- 
1.5.3.4


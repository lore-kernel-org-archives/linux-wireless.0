Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:9607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZGIRdp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:33:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwlagn: fix minimum number of queues setting
Date: Thu,  9 Jul 2009 10:33:41 -0700
Message-Id: <1247160821-14989-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247160821-14989-6-git-send-email-reinette.chatre@intel.com>
References: <1247160821-14989-1-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-2-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-3-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-4-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-5-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

We need to provide a reasonable minimum that will result in a
working setup if used. Set minimum to be 10 to provide for
4 standard TX queues + 1 command queue + 2 (unused) HCCA queues +
4 HT queues (one per AC).

We allow the user to change the number of queues used via a module
parameter and use this minimum value to check if it is valid. Without
this patch a user can select a value for the number of queues that
will result in a failing setup.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1a2fe37..b989d5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -258,8 +258,10 @@ struct iwl_channel_info {
 #define IWL_TX_FIFO_HCCA_2	6
 #define IWL_TX_FIFO_NONE	7
 
-/* Minimum number of queues. MAX_NUM is defined in hw specific files */
-#define IWL_MIN_NUM_QUEUES	4
+/* Minimum number of queues. MAX_NUM is defined in hw specific files.
+ * Set the minimum to accommodate the 4 standard TX queues, 1 command
+ * queue, 2 (unused) HCCA queues, and 4 HT queues (one for each AC) */
+#define IWL_MIN_NUM_QUEUES	10
 
 /* Power management (not Tx power) structures */
 
-- 
1.5.6.3


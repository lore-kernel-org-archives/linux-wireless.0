Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44885 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405AbYBGSWZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 13:22:25 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: earlier rx allocation
Date: Thu,  7 Feb 2008 10:18:59 -0800
Message-Id: <1202408339-21010-1-git-send-email-reinette.chatre@intel.com> (sfid-20080207_182250_606514_BAB126AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

the rx handler has chech in the rx patch if buffers available in rx is
below  certain number to do allocation and stocking in the rx handler,
this way we only allocate only if necessarily. the problem with code
that only kick the allocation after 8 read. this mean if I have heavy
traffic and  my  rx 8  read is less than 8 the ucode will starve. the
bellow  patch  fix this to do rx allocation if we have many free slot
more right away for the first time.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
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


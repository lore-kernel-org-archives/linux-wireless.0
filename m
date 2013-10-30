Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4744 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab3J3UcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 16:32:10 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/9] iwlwifi: transport config n_no_reclaim_cmds should be unsigned
Date: Wed, 30 Oct 2013 22:31:30 +0200
Message-Id: <1383165097-4445-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131030_213215_002410_4CBDE0F6)
In-Reply-To: <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
References: <527143AA.5070900@gmail.com>
 <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The number of commands can never be negative, so it should
be using an unsigned type. This also shuts up an smatch
warning elsewhere in the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index dd57a36..2dc64b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -344,7 +344,7 @@ struct iwl_trans_config {
 	u8 cmd_queue;
 	u8 cmd_fifo;
 	const u8 *no_reclaim_cmds;
-	int n_no_reclaim_cmds;
+	unsigned int n_no_reclaim_cmds;
 
 	bool rx_buf_size_8k;
 	bool bc_table_dword;
-- 
1.8.3.2


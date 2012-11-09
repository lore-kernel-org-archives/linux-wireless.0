Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab2KIUHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/13] iwlwifi: zero trans_cfg before settings its fields
Date: Fri,  9 Nov 2012 21:08:07 +0100
Message-Id: <1352491692-28994-9-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210751_293202_B68DC09E)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

People tend not to set the fields they want to leave as 0.
So make sure the struct is zeroed properly.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 95d348b..bcaec84 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1231,7 +1231,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	struct iwl_op_mode *op_mode;
 	u16 num_mac;
 	u32 ucode_flags;
-	struct iwl_trans_config trans_cfg;
+	struct iwl_trans_config trans_cfg = {};
 	static const u8 no_reclaim_cmds[] = {
 		REPLY_RX_PHY_CMD,
 		REPLY_RX_MPDU_CMD,
-- 
1.8.0


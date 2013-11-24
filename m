Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62610 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3KXUHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:13 -0500
Received: by mail-wi0-f182.google.com with SMTP id en1so4596362wid.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:11 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/29] iwlwifi: mvm: BT Coex - fine tune the aggregation size
Date: Sun, 24 Nov 2013 22:06:34 +0200
Message-Id: <1385323606-3603-17-git-send-email-egrumbach@gmail.com> (sfid-20131124_210807_948383_4117F40F)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Latest tests have shown that when BT is active and has
connections but the traffic is low, the WiFi aggregation can
be large up to 4000us without noticeable impact on BT.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 5d066cb..7dbb058 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -917,7 +917,7 @@ u16 iwl_mvm_bt_coex_agg_time_limit(struct iwl_mvm *mvm,
 	enum iwl_bt_coex_lut_type lut_type;
 
 	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
-	    BT_LOW_TRAFFIC)
+	    BT_HIGH_TRAFFIC)
 		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
 
 	lut_type = iwl_get_coex_type(mvm, mvmsta->vif);
-- 
1.7.9.5


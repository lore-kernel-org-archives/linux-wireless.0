Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34254 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753731AbdFVVVM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:42 +0300
Message-Id: <20170622212101.16422-7-luca@coelho.fi> (sfid-20170622_232116_480358_5A1CDA93)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: mvm: remove pointless num_stored condition
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we exit if buf->num_stored is 0, there's no need to
check it again later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 966cd7543629..36fd8c87027c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -503,7 +503,7 @@ void iwl_mvm_reorder_timer_expired(unsigned long data)
 			     buf->sta_id, sn);
 		iwl_mvm_release_frames(buf->mvm, sta, NULL, buf, sn);
 		rcu_read_unlock();
-	} else if (buf->num_stored) {
+	} else {
 		/*
 		 * If no frame expired and there are stored frames, index is now
 		 * pointing to the first unexpired frame - modify timer
-- 
2.11.0

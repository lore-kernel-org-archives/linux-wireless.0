Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36258 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752391AbdI2Qoq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:44:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:11 +0300
Message-Id: <20170929164423.23666-7-luca@coelho.fi> (sfid-20170929_200759_024276_7DCFE679)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 06/18] iwlwifi: mvm: change warning to warn_once()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In case there is a FW bug where the BAID value in the
metadata is not properly initialized we hit the warning for
every RX packet.
Change it to warn once and add elaborate message.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index a0b406e68d55..836c6cf4b369 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -624,7 +624,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 		return false;
 
 	/* no sta yet */
-	if (WARN_ON(IS_ERR_OR_NULL(sta)))
+	if (WARN_ONCE(IS_ERR_OR_NULL(sta),
+		      "Got valid BAID without a valid station assigned\n"))
 		return false;
 
 	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
-- 
2.14.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40796 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbcEJUa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:07 +0300
Message-Id: <1462910797-20303-11-git-send-email-luca@coelho.fi> (sfid-20160510_223034_687226_5DE1A235)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 11/41] iwlwifi: mvm: support queue removal in ADD_STA hcmd
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

To indicate to the FW that a queue has been removed, an
existing flag in the ADD_STA HCMD (that hasn't been in use)
has been changed to indicate that a queue is being removed
from a STA.

Update this in the driver code.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index e896648..38b1d04 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -173,7 +173,7 @@ enum iwl_sta_key_flag {
 
 /**
  * enum iwl_sta_modify_flag - indicate to the fw what flag are being changed
- * @STA_MODIFY_KEY: this command modifies %key
+ * @STA_MODIFY_QUEUE_REMOVAL: this command removes a queue
  * @STA_MODIFY_TID_DISABLE_TX: this command modifies %tid_disable_tx
  * @STA_MODIFY_TX_RATE: unused
  * @STA_MODIFY_ADD_BA_TID: this command modifies %add_immediate_ba_tid
@@ -183,7 +183,7 @@ enum iwl_sta_key_flag {
  * @STA_MODIFY_QUEUES: modify the queues used by this station
  */
 enum iwl_sta_modify_flag {
-	STA_MODIFY_KEY				= BIT(0),
+	STA_MODIFY_QUEUE_REMOVAL		= BIT(0),
 	STA_MODIFY_TID_DISABLE_TX		= BIT(1),
 	STA_MODIFY_TX_RATE			= BIT(2),
 	STA_MODIFY_ADD_BA_TID			= BIT(3),
-- 
2.8.1


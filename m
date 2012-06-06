Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2FFHNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 03:13:39 -0400
Message-ID: <1338966816.4513.5.camel@jlt3.sipsolutions.net> (sfid-20120606_091343_356241_7DA58328)
Subject: [PATCH 3.5] iwlwifi: don't mess up the SCD when removing a key
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 06 Jun 2012 09:13:36 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we remove a key, we put a key index which was supposed
to tell the fw that we are actually removing the key. But
instead the fw took that index as a valid index and messed
up the SRAM of the device.

This memory corruption on the device mangled the data of
the SCD. The impact on the user is that SCD queue 2 got
stuck after having removed keys.
The message is the log that was printed is:

Queue 2 stuck for 10000ms

This doesn't seem to fix the higher queues that get stuck
from time to time.

Cc: stable@vger.kernel.org [2.6.27+]
Reviewed-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index aea07aa..eb6a8ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1267,7 +1267,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	sta_cmd.key.key_flags = key_flags;
-	sta_cmd.key.key_offset = WEP_INVALID_OFFSET;
+	sta_cmd.key.key_offset = keyconf->hw_key_idx;
 	sta_cmd.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	sta_cmd.mode = STA_CONTROL_MODIFY_MSK;
 
-- 
1.7.10




Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56606 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753226AbcFJMkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:40:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 10 Jun 2016 15:39:55 +0300
Message-Id: <1465562397-1402-3-git-send-email-luca@coelho.fi> (sfid-20160610_144012_563856_990AB671)
In-Reply-To: <1465562397-1402-1-git-send-email-luca@coelho.fi>
References: <1465562195.29614.5.camel@coelho.fi>
 <1465562397-1402-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 3/5] iwlwifi: mvm: fix potential NULL-dereference in iwl_mvm_reorder()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We try to access sta before we check for IS_ERR_OR_NULL(), so we may
end up accessing a NULL pointer.  To prevent that, move the conversion
from sta to mvm_sta below the check.

Fixes: b915c10174fb ("iwlwifi: mvm: add reorder buffer per queue")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index ac2c571..2c61516 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -581,7 +581,7 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 			    struct iwl_rx_mpdu_desc *desc)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_sta *mvm_sta;
 	struct iwl_mvm_baid_data *baid_data;
 	struct iwl_mvm_reorder_buffer *buffer;
 	struct sk_buff *tail;
@@ -604,6 +604,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	if (WARN_ON(IS_ERR_OR_NULL(sta)))
 		return false;
 
+	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+
 	/* not a data packet */
 	if (!ieee80211_is_data_qos(hdr->frame_control) ||
 	    is_multicast_ether_addr(hdr->addr1))
-- 
2.8.1


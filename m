Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:49733 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaBWT5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:19 -0500
Received: by mail-we0-f182.google.com with SMTP id u57so4090315wes.27
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:18 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/17] iwlwifi: mvm: use IEEE80211_TX_CTRL_PORT_CTRL_PROTO flag
Date: Sun, 23 Feb 2014 21:56:55 +0200
Message-Id: <1393185428-8524-4-git-send-email-egrumbach@gmail.com> (sfid-20140223_205730_686930_5ECD970C)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of checking the SKB protocol against EAP, check the
IEEE80211_TX_CTRL_PORT_CTRL_PROTO flag that more generally
indicates whether or not the frame is a port control frame.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 8d18bf2..852d9d8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -122,7 +122,7 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		 * it
 		 */
 		WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_AMPDU);
-	} else if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+	} else if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO) {
 		tx_cmd->pm_frame_timeout = cpu_to_le16(2);
 	} else {
 		tx_cmd->pm_frame_timeout = 0;
-- 
1.7.9.5


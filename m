Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64538 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaCROqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:18 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so4757662eek.7
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:17 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/35] iwlwifi: mvm: don't enable protection for all AMPDUs
Date: Tue, 18 Mar 2014 16:45:23 +0200
Message-Id: <1395153939-23897-19-git-send-email-egrumbach@gmail.com> (sfid-20140318_155649_516954_29403111)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Currently RTS protection was done whenever trasnmitting an AMPDU.
This limits throughput in cases where there's no need for protection.
Disable this too inclusive protection for now.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 0e3f45a..21ab59c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -127,9 +127,6 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		tx_cmd->pm_frame_timeout = 0;
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		tx_flags |= TX_CMD_FLG_PROT_REQUIRE;
-
 	if (ieee80211_is_data(fc) && len > mvm->rts_threshold &&
 	    !is_multicast_ether_addr(ieee80211_get_DA(hdr)))
 		tx_flags |= TX_CMD_FLG_PROT_REQUIRE;
-- 
1.8.3.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45791 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932659AbbIUVBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:57 +0300
Message-Id: <1442869141-31637-17-git-send-email-luca@coelho.fi> (sfid-20150921_230149_788014_22EB624E)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 17/21] iwlwifi: mvm: remove pointless cfg_phy_cnt length check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the driver can never configure the data here, this field
will always be reported as 0 by the firmware. Even if this was
not the case, however, it wouldn't matter since the extra data
would be added beyond the end of the phy_info structure we use
in the driver, so wouldn't harm anything in this code either.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 623c219..0a6d47c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -298,13 +298,6 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 		return;
 	}
 
-	if ((unlikely(phy_info->cfg_phy_cnt > 20))) {
-		IWL_DEBUG_DROP(mvm, "dsp size out of range [0,20]: %d\n",
-			       phy_info->cfg_phy_cnt);
-		kfree_skb(skb);
-		return;
-	}
-
 	/*
 	 * Keep packets with CRC errors (and with overrun) for monitor mode
 	 * (otherwise the firmware discards them) but mark them as bad.
-- 
2.5.1


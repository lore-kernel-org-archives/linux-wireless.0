Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:51685 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaEVHYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:11 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so3114711wes.15
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:10 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/11] iwlwifi: mvm: set the MAC_FILTER_IN_BEACON flag also for P2P
Date: Thu, 22 May 2014 10:23:49 +0300
Message-Id: <1400743435-702-5-git-send-email-egrumbach@gmail.com> (sfid-20140522_092729_999257_5C44DFFA)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

There doesn't seem to be a good reason for not enabling the
MAC_FILTER_IN_BEACON flag for P2P client, as we do for station.

This can prevent potential, hard-to-reproduce problems during
association.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 28549ba..fed012f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -724,8 +724,7 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 		/* Allow beacons to pass through as long as we are not
 		 * associated, or we do not have dtim period information.
 		 */
-		if (!vif->p2p)
-			cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
+		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
 
 		/*
 		 * The DTIM count counts down, so when it is N that means N
-- 
1.8.3.2


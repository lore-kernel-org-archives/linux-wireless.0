Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34809 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaIOFK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:10:57 -0400
Received: by mail-wi0-f172.google.com with SMTP id e4so3437919wiv.17
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:10:56 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/12] iwlwifi: mvm: set MAC_FILTER_IN_BEACON correctly for STA/P2P client
Date: Mon, 15 Sep 2014 08:10:39 +0300
Message-Id: <1410757848-1827-3-git-send-email-egrumbach@gmail.com> (sfid-20140915_071101_200771_68A80237)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In commit cad3f08c (iwlwifi: mvm: enable MAC_FILTER_IN_BEACON when
forced_assoc_off is set) the code to set the MAC_FILTER_IN_BEACON flag
was accidentally moved to the main block of the if statement, while it
should be in the else block instead.  Move it to the right place.

Fixes: cad3f08c23de ("iwlwifi: mvm: enable MAC_FILTER_IN_BEACON when forced_assoc_off is set")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 0e523e2..8242e68 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -721,11 +721,6 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 	    !force_assoc_off) {
 		u32 dtim_offs;
 
-		/* Allow beacons to pass through as long as we are not
-		 * associated, or we do not have dtim period information.
-		 */
-		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
-
 		/*
 		 * The DTIM count counts down, so when it is N that means N
 		 * more beacon intervals happen until the DTIM TBTT. Therefore
@@ -759,6 +754,11 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 		ctxt_sta->is_assoc = cpu_to_le32(1);
 	} else {
 		ctxt_sta->is_assoc = cpu_to_le32(0);
+
+		/* Allow beacons to pass through as long as we are not
+		 * associated, or we do not have dtim period information.
+		 */
+		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
 	}
 
 	ctxt_sta->bi = cpu_to_le32(vif->bss_conf.beacon_int);
-- 
1.9.1


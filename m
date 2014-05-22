Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:45135 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaEVHYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:10 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so3065402wev.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:08 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/11] iwlwifi: mvm: enable MAC_FILTER_IN_BEACON when forced_assoc_off is set
Date: Thu, 22 May 2014 10:23:48 +0300
Message-Id: <1400743435-702-4-git-send-email-egrumbach@gmail.com> (sfid-20140522_092727_449382_F6E40ED8)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Set the MAC_FILTER_IN_BEACON flag in iwl_mvm_mac_ctxt_cmd_sata() also
when forced_assoc_off is set, so it's aligned with when we are not
associated.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 2c51e40..28549ba 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -713,14 +713,6 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 					IEEE80211_P2P_OPPPS_CTWINDOW_MASK);
 		ctxt_sta = &cmd.p2p_sta.sta;
 	} else {
-		/* Allow beacons to pass through as long as we are not
-		 * associated, or we do not have dtim period information.
-		 */
-		if (!vif->bss_conf.assoc || !vif->bss_conf.dtim_period)
-			cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
-		else
-			cmd.filter_flags &= ~cpu_to_le32(MAC_FILTER_IN_BEACON);
-
 		ctxt_sta = &cmd.sta;
 	}
 
@@ -729,6 +721,12 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 	    !force_assoc_off) {
 		u32 dtim_offs;
 
+		/* Allow beacons to pass through as long as we are not
+		 * associated, or we do not have dtim period information.
+		 */
+		if (!vif->p2p)
+			cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
+
 		/*
 		 * The DTIM count counts down, so when it is N that means N
 		 * more beacon intervals happen until the DTIM TBTT. Therefore
-- 
1.8.3.2


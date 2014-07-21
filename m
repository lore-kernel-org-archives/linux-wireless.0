Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:34897 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbaGUSPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 14:15:07 -0400
Received: by mail-we0-f173.google.com with SMTP id q58so8109780wes.32
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 11:15:06 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] iwlwifi: mvm: pass beacons from foreign APs
Date: Mon, 21 Jul 2014 21:14:58 +0300
Message-Id: <1405966498-4936-2-git-send-email-egrumbach@gmail.com> (sfid-20140721_201514_054148_3FCC6CFC)
In-Reply-To: <53CD5785.80408@gmail.com>
References: <53CD5785.80408@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

In AP mode, configure the fw to pass beacons from
foreign APs, in order to be able to set the ht
protection IE properly.

Add the same filters in case of GO (which didn't have
any configured filter_flags, probably by mistake)

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 725ba49..8b79081 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1072,8 +1072,12 @@ static int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
 	/* Fill the common data for all mac context types */
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
 
-	/* Also enable probe requests to pass */
-	cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
+	/*
+	 * pass probe requests and beacons from other APs (needed
+	 * for ht protection)
+	 */
+	cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST |
+					MAC_FILTER_IN_BEACON);
 
 	/* Fill the data specific for ap mode */
 	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd.ap,
@@ -1094,6 +1098,13 @@ static int iwl_mvm_mac_ctxt_cmd_go(struct iwl_mvm *mvm,
 	/* Fill the common data for all mac context types */
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
 
+	/*
+	 * pass probe requests and beacons from other APs (needed
+	 * for ht protection)
+	 */
+	cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST |
+					MAC_FILTER_IN_BEACON);
+
 	/* Fill the data specific for GO mode */
 	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd.go.ap,
 				     action == FW_CTXT_ACTION_ADD);
-- 
1.8.3.2


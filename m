Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42106 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbeHRLex (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:34:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:40 +0300
Message-Id: <20180818082750.28717-7-luca@coelho.fi> (sfid-20180818_102815_376750_C94CBA20)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 06/16] iwlwifi: mvm: remove duplicate if in iwl_mvm_setup_connection_keep()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We repeated the same if twice in a row.  Remove the second one and
move the code block into the previous one.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 47ceffbfd9af..799ee015ef84 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1503,6 +1503,7 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 			.conf.cipher = gtkdata.cipher,
 			.conf.keyidx = status->gtk.key_index,
 		};
+		__be64 replay_ctr;
 
 		switch (gtkdata.cipher) {
 		case WLAN_CIPHER_SUITE_CCMP:
@@ -1524,11 +1525,9 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 		if (IS_ERR(key))
 			return false;
 		iwl_mvm_set_key_rx_seq(mvm, key, status);
-	}
 
-	if (status->num_of_gtk_rekeys) {
-		__be64 replay_ctr =
-			cpu_to_be64(le64_to_cpu(status->replay_ctr));
+		replay_ctr = cpu_to_be64(le64_to_cpu(status->replay_ctr));
+
 		ieee80211_gtk_rekey_notify(vif, vif->bss_conf.bssid,
 					   (void *)&replay_ctr, GFP_KERNEL);
 	}
-- 
2.18.0

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42626 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726637AbeHUI2k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 04:28:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 08:09:41 +0300
Message-Id: <20180821050952.31603-7-luca@coelho.fi> (sfid-20180821_071010_700599_985FEC0E)
In-Reply-To: <20180821050952.31603-1-luca@coelho.fi>
References: <20180821050952.31603-1-luca@coelho.fi>
Subject: [PATCH v2 06/17] iwlwifi: mvm: remove duplicate if in iwl_mvm_setup_connection_keep()
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

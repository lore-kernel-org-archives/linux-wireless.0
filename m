Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56861 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751340AbbJELkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 07:40:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>, <stable@vger.kernel.org>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 14:40:41 +0300
Message-Id: <1444045246-9946-3-git-send-email-luca@coelho.fi> (sfid-20151005_134059_253411_4F8B0AC7)
In-Reply-To: <1444044666.27220.5.camel@coelho.fi>
References: <1444044666.27220.5.camel@coelho.fi>
Subject: [PATCH 3/8] iwlwifi: mvm: fix D3 firmware PN programming
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code to send the RX PN data (for each TID) to the firmware
has a devastating bug: it overwrites the data for TID 0 with
all the TID data, leaving the remaining TIDs zeroed. This will
allow replays to actually be accepted by the firmware, which
could allow waking up the system.

Cc: <stable@vger.kernel.org> [3.1+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 9578b9d..5761876 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -293,12 +293,12 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 			u8 *pn = seq.ccmp.pn;
 
 			ieee80211_get_key_rx_seq(key, i, &seq);
-			aes_sc->pn = cpu_to_le64((u64)pn[5] |
-						 ((u64)pn[4] << 8) |
-						 ((u64)pn[3] << 16) |
-						 ((u64)pn[2] << 24) |
-						 ((u64)pn[1] << 32) |
-						 ((u64)pn[0] << 40));
+			aes_sc[i].pn = cpu_to_le64((u64)pn[5] |
+						   ((u64)pn[4] << 8) |
+						   ((u64)pn[3] << 16) |
+						   ((u64)pn[2] << 24) |
+						   ((u64)pn[1] << 32) |
+						   ((u64)pn[0] << 40));
 		}
 		data->use_rsc_tsc = true;
 		break;
-- 
2.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933651AbcCIRqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/21] iwlwifi: mvm: don't try to offload AES-CMAC in AP/IBSS modes
Date: Wed,  9 Mar 2016 19:45:49 +0200
Message-Id: <1457545550-30677-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_185949_731221_DA1E0FFE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware/hardware only supports checking AES-CMAC on RX, not
using it on TX. For station mode this is fine, since it's the only
thing it will ever do. For AP mode, it never receives such frames,
but must be able to transmit them. This is currently broken since
we try to enable them for hardware crypto (for RX only) and then
treat them as TX_CMD_SEC_EXT, leading to FIFO underruns during TX
so the frames never go out to the air.

To fix this, simply use software on TX in AP (and IBSS) mode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 39b9c38..76e649c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2686,8 +2686,12 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 			 * GTK on AP interface is a TX-only key, return 0;
 			 * on IBSS they're per-station and because we're lazy
 			 * we don't support them for RX, so do the same.
+			 * CMAC in AP/IBSS modes must be done in software.
 			 */
-			ret = 0;
+			if (key->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
+				ret = -EOPNOTSUPP;
+			else
+				ret = 0;
 			key->hw_key_idx = STA_KEY_IDX_INVALID;
 			break;
 		}
-- 
2.5.0


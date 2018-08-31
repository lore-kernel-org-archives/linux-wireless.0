Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45760 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbeHaOFe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:05:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:12 +0300
Message-Id: <20180831095614.14099-15-luca@coelho.fi> (sfid-20180831_115855_600916_0D1C46D0)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 14/16] iwlwifi: mvm: Support TKIP on gen2 data path
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Make the adjustments for gen2 TX and RX of TKIP packets.  Strip MIC on
RX.  Don't add IV space and keep the MIC space zeroed on TX.

Devices that support gen2 data path support TKIP only in station mode.
In all other modes, fall back to SW encryption. Do this early in the
set_key() callback so that the key flags would not be incorrectly set.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 11 +++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     |  9 ++++++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 134bb9fd21a4..b55a2e4a0024 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3151,8 +3151,15 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+		if (!mvm->trans->cfg->gen2) {
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+			key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+		} else if (vif->type == NL80211_IFTYPE_STATION) {
+			key->flags |= IEEE80211_KEY_FLAG_PUT_MIC_SPACE;
+		} else {
+			IWL_DEBUG_MAC80211(mvm, "Use SW encryption for TKIP\n");
+			return -EOPNOTSUPP;
+		}
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_GCMP:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 89b4b882ef80..894dd6379b9a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -283,6 +283,10 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 		    !(status & IWL_RX_MPDU_RES_STATUS_TTAK_OK))
 			return 0;
 
+		if (mvm->trans->cfg->gen2 &&
+		    !(status & RX_MPDU_RES_STATUS_MIC_OK))
+			stats->flag |= RX_FLAG_MMIC_ERROR;
+
 		*crypt_len = IEEE80211_TKIP_IV_LEN;
 		/* fall through if TTAK OK */
 	case IWL_RX_MPDU_STATUS_SEC_WEP:
@@ -294,8 +298,11 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 				IWL_RX_MPDU_STATUS_SEC_WEP)
 			*crypt_len = IEEE80211_WEP_IV_LEN;
 
-		if (pkt_flags & FH_RSCSR_RADA_EN)
+		if (pkt_flags & FH_RSCSR_RADA_EN) {
 			stats->flag |= RX_FLAG_ICV_STRIPPED;
+			if (mvm->trans->cfg->gen2)
+				stats->flag |= RX_FLAG_MMIC_STRIPPED;
+		}
 
 		return 0;
 	case IWL_RX_MPDU_STATUS_SEC_EXT_ENC:
-- 
2.18.0

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbbGTTnV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 15:43:21 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: sara.sharon@intel.com, Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 05/10] iwlwifi: mvm: pretend to have CSUM OFFLOAD
Date: Mon, 20 Jul 2015 22:42:59 +0300
Message-Id: <1437421384-19884-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150720_214328_669456_85482FDA)
In-Reply-To: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This allows to debug the LSO flows.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index b8ee312..70d4697 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -103,6 +103,7 @@
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
 #define IWL_MVM_RS_DISABLE_P2P_MIMO		0
 #define IWL_MVM_TOF_IS_RESPONDER		0
+#define IWL_MVM_SW_CSUM_OFFLOAD			0
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE_TW   1
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index a5bebbb..2be6f32 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -436,6 +436,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 
+	if (IWL_MVM_SW_CSUM_OFFLOAD)
+		hw->netdev_features |= NETIF_F_IP_CSUM | NETIF_F_TSO |
+			NETIF_F_TSO6 | NETIF_F_IPV6_CSUM;
+	/* allow these to be toggled by user */
+	hw->netdev_hw_features = hw->netdev_features;
+
 	hw->queues = mvm->first_agg_queue;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
 	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FEC |
-- 
2.1.4


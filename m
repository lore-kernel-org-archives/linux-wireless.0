Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62703 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3HUGEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:04:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 1/8] iwlwifi: mvm: correctly configure MCAST in AP mode
Date: Wed, 21 Aug 2013 09:04:19 +0300
Message-Id: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130821_080435_765866_3BBC7EC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 86a91ec757338edbce51de5dabd7afb0366f485c upstream.

The AP mode needs to use the MCAST fifo for the MCAST
frames sent after the DTIM. This fifo needs to be
configured with the same parameters as the VOICE FIFO.

A separate SCD queue is mapped to this fifo - the cab_queue
(cab stands for Content After Beacon). This queue isn't
connected to any station, but rather to the MAC context.
This queue should (and is already) be set as the MCAST
queue - this is part of the of MAC context command.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h |    8 +++++++-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |    6 +++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |    1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
index d68640e..98b1feb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
@@ -71,7 +71,13 @@
 #define MAC_INDEX_MIN_DRIVER	0
 #define NUM_MAC_INDEX_DRIVER	MAC_INDEX_AUX
 
-#define AC_NUM	4 /* Number of access categories */
+enum iwl_ac {
+	AC_BK,
+	AC_BE,
+	AC_VI,
+	AC_VO,
+	AC_NUM,
+};
 
 /**
  * enum iwl_mac_protection_flags - MAC context flags
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index b2cc3d9..3b69045 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -362,7 +362,7 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		break;
 	case NL80211_IFTYPE_AP:
 		iwl_trans_ac_txq_enable(mvm->trans, vif->cab_queue,
-					IWL_MVM_TX_FIFO_VO);
+					IWL_MVM_TX_FIFO_MCAST);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
@@ -550,6 +550,10 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 		cmd->ac[i].fifos_mask = BIT(iwl_mvm_ac_to_tx_fifo[i]);
 	}
 
+	/* in AP mode, the MCAST FIFO takes the EDCA params from VO */
+	if (vif->type == NL80211_IFTYPE_AP)
+		cmd->ac[AC_VO].fifos_mask |= BIT(IWL_MVM_TX_FIFO_MCAST);
+
 	if (vif->bss_conf.qos)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_UPDATE_EDCA);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 9f46b23..8086231 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -88,6 +88,7 @@ enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_BE,
 	IWL_MVM_TX_FIFO_VI,
 	IWL_MVM_TX_FIFO_VO,
+	IWL_MVM_TX_FIFO_MCAST = 5,
 };
 
 extern struct ieee80211_ops iwl_mvm_hw_ops;
-- 
1.7.10.4


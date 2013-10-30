Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab3J3UcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 16:32:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/9] iwlwifi: mvm: capture the FCS in monitor mode
Date: Wed, 30 Oct 2013 22:31:33 +0200
Message-Id: <1383165097-4445-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131030_213219_705913_80B758A2)
In-Reply-To: <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
References: <527143AA.5070900@gmail.com>
 <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This can be useful when using the device as a sniffer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 8 +++++++-
 drivers/net/wireless/iwlwifi/mvm/rx.c       | 6 +++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index ab5a7ac..f41f9b0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -719,7 +719,9 @@ static int iwl_mvm_mac_ctxt_cmd_listener(struct iwl_mvm *mvm,
 	cmd.filter_flags = cpu_to_le32(MAC_FILTER_IN_PROMISC |
 				       MAC_FILTER_IN_CONTROL_AND_MGMT |
 				       MAC_FILTER_IN_BEACON |
-				       MAC_FILTER_IN_PROBE_REQUEST);
+				       MAC_FILTER_IN_PROBE_REQUEST |
+				       MAC_FILTER_IN_CRC32);
+	mvm->hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
 
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
 }
@@ -1122,6 +1124,10 @@ int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	}
 
 	mvmvif->uploaded = false;
+
+	if (vif->type == NL80211_IFTYPE_MONITOR)
+		mvm->hw->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index a4af501..3a1f398 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -300,10 +300,14 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		return 0;
 	}
 
+	/*
+	 * Keep packets with CRC errors (and with overrun) for monitor mode
+	 * (otherwise the firmware discards them) but mark them as bad.
+	 */
 	if (!(rx_pkt_status & RX_MPDU_RES_STATUS_CRC_OK) ||
 	    !(rx_pkt_status & RX_MPDU_RES_STATUS_OVERRUN_OK)) {
 		IWL_DEBUG_RX(mvm, "Bad CRC or FIFO: 0x%08X.\n", rx_pkt_status);
-		return 0;
+		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 	}
 
 	/* This will be used in several places later */
-- 
1.8.3.2


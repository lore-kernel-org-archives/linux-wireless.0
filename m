Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1144 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965050AbbBCHPE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:04 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/19] iwlwifi: mvm: improve TDLS ch-sw state machine
Date: Tue,  3 Feb 2015 09:14:29 +0200
Message-Id: <1422947678-16917-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081511_436226_A173BF22)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Add a response-received state and add more limits on allowed requests
in each state of the connection. Previously ch-switch requests from
other peers could interrupt an outgoing active ch-switch. Also stale
packets from the current peer could disrupt the channel switch state.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h  |  1 +
 drivers/net/wireless/iwlwifi/mvm/tdls.c | 48 +++++++++++++++++++++++----------
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 7773ffc..fc80b7b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -532,6 +532,7 @@ enum {
 enum iwl_mvm_tdls_cs_state {
 	IWL_MVM_TDLS_SW_IDLE = 0,
 	IWL_MVM_TDLS_SW_REQ_SENT,
+	IWL_MVM_TDLS_SW_RESP_RCVD,
 	IWL_MVM_TDLS_SW_REQ_RCVD,
 	IWL_MVM_TDLS_SW_ACTIVE,
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/tdls.c b/drivers/net/wireless/iwlwifi/mvm/tdls.c
index c0e00ba..ea1831c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tdls.c
@@ -228,6 +228,8 @@ iwl_mvm_tdls_cs_state_str(enum iwl_mvm_tdls_cs_state state)
 		return "IDLE";
 	case IWL_MVM_TDLS_SW_REQ_SENT:
 		return "REQ SENT";
+	case IWL_MVM_TDLS_SW_RESP_RCVD:
+		return "RESP RECEIVED";
 	case IWL_MVM_TDLS_SW_REQ_RCVD:
 		return "REQ RECEIVED";
 	case IWL_MVM_TDLS_SW_ACTIVE:
@@ -325,17 +327,27 @@ iwl_mvm_tdls_check_action(struct iwl_mvm *mvm,
 			ret = -EINVAL;
 		break;
 	case IWL_MVM_TDLS_SW_REQ_SENT:
+		/* only allow requests from the same peer */
+		if (!same_peer)
+			ret = -EBUSY;
+		else if (type == TDLS_SEND_CHAN_SW_RESP_AND_MOVE_CH &&
+			 !peer_initiator)
+			/*
+			 * We received a ch-switch request while an outgoing
+			 * one is pending. Allow it if the peer is the link
+			 * initiator.
+			 */
+			ret = -EBUSY;
+		else if (type == TDLS_SEND_CHAN_SW_REQ)
+			/* wait for idle before sending another request */
+			ret = -EBUSY;
+		break;
+	case IWL_MVM_TDLS_SW_RESP_RCVD:
 		/*
-		 * We received a ch-switch request while an outgoing one is
-		 * pending. Allow it to proceed if the other peer is the same
-		 * one we sent to, and we are not the link initiator.
+		 * we are waiting for the FW to give an "active" notification,
+		 * so ignore requests in the meantime
 		 */
-		if (type == TDLS_SEND_CHAN_SW_RESP_AND_MOVE_CH) {
-			if (!same_peer)
-				ret = -EBUSY;
-			else if (!peer_initiator) /* we are the initiator */
-				ret = -EBUSY;
-		}
+		ret = -EBUSY;
 		break;
 	case IWL_MVM_TDLS_SW_REQ_RCVD:
 		/* as above, allow the link initiator to proceed */
@@ -349,9 +361,12 @@ iwl_mvm_tdls_check_action(struct iwl_mvm *mvm,
 		}
 		break;
 	case IWL_MVM_TDLS_SW_ACTIVE:
-		/* we don't allow initiations during active channel switch */
-		if (type == TDLS_SEND_CHAN_SW_REQ)
-			ret = -EINVAL;
+		/*
+		 * the only valid request when active is a request to return
+		 * to the base channel by the current off-channel peer
+		 */
+		if (type != TDLS_MOVE_CH || !same_peer)
+			ret = -EBUSY;
 		break;
 	}
 
@@ -473,6 +488,8 @@ iwl_mvm_tdls_config_channel_switch(struct iwl_mvm *mvm,
 					     type == TDLS_SEND_CHAN_SW_REQ ?
 					     IWL_MVM_TDLS_SW_REQ_SENT :
 					     IWL_MVM_TDLS_SW_REQ_RCVD);
+	} else {
+		iwl_mvm_tdls_update_cs_state(mvm, IWL_MVM_TDLS_SW_RESP_RCVD);
 	}
 
 out:
@@ -657,12 +674,15 @@ iwl_mvm_tdls_recv_channel_switch(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	enum iwl_tdls_channel_switch_type type;
 	unsigned int delay;
+	const char *action_str =
+		params->action_code == WLAN_TDLS_CHANNEL_SWITCH_REQUEST ?
+		"REQ" : "RESP";
 
 	mutex_lock(&mvm->mutex);
 
 	IWL_DEBUG_TDLS(mvm,
-		       "Received TDLS ch switch action %d from %pM status %d\n",
-		       params->action_code, params->sta->addr, params->status);
+		       "Received TDLS ch switch action %s from %pM status %d\n",
+		       action_str, params->sta->addr, params->status);
 
 	/*
 	 * we got a non-zero status from a peer we were switching to - move to
-- 
1.9.1


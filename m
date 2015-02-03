Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965287AbbBCHPE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:04 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/19] iwlwifi: mvm: ignore stale TDLS ch-switch responses
Date: Tue,  3 Feb 2015 09:14:30 +0200
Message-Id: <1422947678-16917-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081516_600599_FB5282BB)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

During out-of-channel activities (e.g. scan) TDLS ch-switch responses from
a peer are kept in FW. These packets arrive only after the out-of-channel
activity is complete, which can be in the order of several seconds.

Since TDLS ch-sw has no dialog-token-like mechanism for distinguishing
sessions, use the GP2 time of the incoming ch-switch response to discern
validity. For this purpose record the GP2 time of an outgoing TDLS ch-sw
request and compare to the Rx time of the ch-sw response.
The methods works in practice since the GP2 time of FW-deferred Rx is
accurate and contains the real Rx timestamp.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h  |  3 +++
 drivers/net/wireless/iwlwifi/mvm/tdls.c | 15 +++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index fc80b7b..ed09726 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -798,6 +798,9 @@ struct iwl_mvm {
 			struct cfg80211_chan_def chandef;
 			struct sk_buff *skb; /* ch sw template */
 			u32 ch_sw_tm_ie;
+
+			/* timestamp of last ch-sw request sent (GP2 time) */
+			u32 sent_timestamp;
 		} peer;
 	} tdls_cs;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tdls.c b/drivers/net/wireless/iwlwifi/mvm/tdls.c
index ea1831c..a87b506 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tdls.c
@@ -64,6 +64,8 @@
 #include <linux/etherdevice.h>
 #include "mvm.h"
 #include "time-event.h"
+#include "iwl-io.h"
+#include "iwl-prph.h"
 
 #define TU_TO_US(x) (x * 1024)
 #define TU_TO_MS(x) (TU_TO_US(x) / 1000)
@@ -250,6 +252,11 @@ static void iwl_mvm_tdls_update_cs_state(struct iwl_mvm *mvm,
 		       iwl_mvm_tdls_cs_state_str(state));
 	mvm->tdls_cs.state = state;
 
+	/* we only send requests to our switching peer - update sent time */
+	if (state == IWL_MVM_TDLS_SW_REQ_SENT)
+		mvm->tdls_cs.peer.sent_timestamp =
+			iwl_read_prph(mvm->trans, DEVICE_SYSTEM_TIME_REG);
+
 	if (state == IWL_MVM_TDLS_SW_IDLE)
 		mvm->tdls_cs.cur_sta_id = IWL_MVM_STATION_COUNT;
 }
@@ -302,7 +309,7 @@ out:
 static int
 iwl_mvm_tdls_check_action(struct iwl_mvm *mvm,
 			  enum iwl_tdls_channel_switch_type type,
-			  const u8 *peer, bool peer_initiator)
+			  const u8 *peer, bool peer_initiator, u32 timestamp)
 {
 	bool same_peer = false;
 	int ret = 0;
@@ -341,6 +348,9 @@ iwl_mvm_tdls_check_action(struct iwl_mvm *mvm,
 		else if (type == TDLS_SEND_CHAN_SW_REQ)
 			/* wait for idle before sending another request */
 			ret = -EBUSY;
+		else if (timestamp <= mvm->tdls_cs.peer.sent_timestamp)
+			/* we got a stale response - ignore it */
+			ret = -EINVAL;
 		break;
 	case IWL_MVM_TDLS_SW_RESP_RCVD:
 		/*
@@ -399,7 +409,8 @@ iwl_mvm_tdls_config_channel_switch(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	ret = iwl_mvm_tdls_check_action(mvm, type, peer, peer_initiator);
+	ret = iwl_mvm_tdls_check_action(mvm, type, peer, peer_initiator,
+					timestamp);
 	if (ret)
 		return ret;
 
-- 
1.9.1


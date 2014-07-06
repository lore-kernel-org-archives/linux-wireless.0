Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53899 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaGFJgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:31 -0400
Received: by mail-wg0-f41.google.com with SMTP id k14so461298wgh.24
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:30 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/40] iwlwifi: mvm: wait for d0i3 exit in add interface flow
Date: Sun,  6 Jul 2014 12:35:42 +0300
Message-Id: <1404639376-3792-6-git-send-email-egrumbach@gmail.com> (sfid-20140706_113636_394411_20A909B7)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch makes sure there're no target accesses in the add
interface flow before d0i3 exit completes.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 40 ++++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5e425d3..7dde944 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -243,6 +243,21 @@ iwl_mvm_unref_all_except(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref)
 	}
 }
 
+static int iwl_mvm_ref_sync(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
+{
+	iwl_mvm_ref(mvm, ref_type);
+
+	if (!wait_event_timeout(mvm->d0i3_exit_waitq,
+				!test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status),
+				HZ)) {
+		WARN_ON_ONCE(1);
+		iwl_mvm_unref(mvm, ref_type);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static void iwl_mvm_reset_phy_ctxts(struct iwl_mvm *mvm)
 {
 	int i;
@@ -559,9 +574,6 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		iwl_mvm_ref(mvm, IWL_MVM_REF_TX_AGG);
-		tx_agg_ref = true;
-
 		/*
 		 * for tx start, wait synchronously until D0i3 exit to
 		 * get the correct sequence number for the tid.
@@ -570,12 +582,11 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 		 * by the trans layer (unlike commands), so wait for
 		 * d0i3 exit in these cases as well.
 		 */
-		if (!wait_event_timeout(mvm->d0i3_exit_waitq,
-			  !test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status), HZ)) {
-			WARN_ON_ONCE(1);
-			iwl_mvm_unref(mvm, IWL_MVM_REF_TX_AGG);
-			return -EIO;
-		}
+		ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_TX_AGG);
+		if (ret)
+			return ret;
+
+		tx_agg_ref = true;
 		break;
 	default:
 		break;
@@ -904,6 +915,15 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	int ret;
 
 	/*
+	 * make sure D0i3 exit is completed, otherwise a target access
+	 * during tx queue configuration could be done when still in
+	 * D0i3 state.
+	 */
+	ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_ADD_IF);
+	if (ret)
+		return ret;
+
+	/*
 	 * Not much to do here. The stack will not allow interface
 	 * types or combinations that we didn't advertise, so we
 	 * don't really have to check the types.
@@ -1017,6 +1037,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
  out_unlock:
 	mutex_unlock(&mvm->mutex);
 
+	iwl_mvm_unref(mvm, IWL_MVM_REF_ADD_IF);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e067d97..6fe93a7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -230,6 +230,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_USER,
 	IWL_MVM_REF_TX,
 	IWL_MVM_REF_TX_AGG,
+	IWL_MVM_REF_ADD_IF,
 	IWL_MVM_REF_EXIT_WORK,
 
 	IWL_MVM_REF_COUNT,
-- 
1.8.3.2


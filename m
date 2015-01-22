Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbbAVUdt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:49 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/38] iwlwifi: mvm: rs: allow to disable MIMO for P2P only
Date: Thu, 22 Jan 2015 22:32:59 +0200
Message-Id: <1421958809-3371-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213403_495086_F681F93B)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to work around interoperability bugs with devices
that don't hanle MIMO properly.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 2d8e7e3..f98f3ef 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -101,7 +101,7 @@
 #define IWL_MVM_FW_BCAST_FILTER_PASS_ALL	0
 #define IWL_MVM_QUOTA_THRESHOLD			8
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
-#define IWL_MVM_RS_DISABLE_MIMO			0
+#define IWL_MVM_RS_DISABLE_P2P_MIMO		0
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE_TW   1
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 4747224..57a6094 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2763,7 +2763,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			lq_sta->stbc = true;
 	}
 
-	if (IWL_MVM_RS_DISABLE_MIMO)
+	if (IWL_MVM_RS_DISABLE_P2P_MIMO && sta_priv->vif->p2p)
 		lq_sta->active_mimo2_rate = 0;
 
 	lq_sta->max_legacy_rate_idx =
-- 
1.9.1


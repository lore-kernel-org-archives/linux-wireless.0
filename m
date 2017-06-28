Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35882 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751804AbdF1UON (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:14:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:11 +0300
Message-Id: <20170628201330.9432-13-luca@coelho.fi> (sfid-20170628_221452_922311_D77C24EC)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 12/31] iwlwifi: mvm: change sta_id to u8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

The sta_id variable is used as an index in an array, should be unsigned.
Found by Klocwork.

Fixes: 9f9af3d7d303 ("iwlwifi: mvm: re-aggregate shared queue after unsharing")
Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 02f35a929606..9ec427966533 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -398,7 +398,7 @@ static int iwl_mvm_get_queue_agg_tids(struct iwl_mvm *mvm, int queue)
 	struct iwl_mvm_sta *mvmsta;
 	unsigned long tid_bitmap;
 	unsigned long agg_tids = 0;
-	s8 sta_id;
+	u8 sta_id;
 	int tid;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -989,7 +989,7 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
 {
 	struct ieee80211_sta *sta;
 	struct iwl_mvm_sta *mvmsta;
-	s8 sta_id;
+	u8 sta_id;
 	int tid = -1;
 	unsigned long tid_bitmap;
 	unsigned int wdg_timeout;
-- 
2.11.0

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42652 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbcCBH5m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:42 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/43] iwlwifi: mvm: remove unused field in iwl_mvm_tid_data
Date: Wed,  2 Mar 2016 09:56:28 +0200
Message-Id: <1456905404-14435-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085953_211065_596CCA86)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 69c7fda40921c125eeeef6a827f6270ac6aa1baa removed the
users of iwl_mvm_tid_data.reduced_tpc. Due to a conflict,
I forgot to commit the hunk that removed the field itself.
Do this know.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index db701ca..1a8f69a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -258,8 +258,6 @@ enum iwl_mvm_agg_state {
  *	This is basically (last acked packet++).
  * @rate_n_flags: Rate at which Tx was attempted. Holds the data between the
  *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
- * @reduced_tpc: Reduced tx power. Holds the data between the
- *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
  * @amsdu_in_ampdu_allowed: true if A-MSDU in A-MPDU is allowed.
  * @state: state of the BA agreement establishment / tear down.
  * @txq_id: Tx queue used by the BA session
@@ -274,7 +272,6 @@ struct iwl_mvm_tid_data {
 	u16 next_reclaimed;
 	/* The rest is Tx AGG related */
 	u32 rate_n_flags;
-	u8 reduced_tpc;
 	bool amsdu_in_ampdu_allowed;
 	enum iwl_mvm_agg_state state;
 	u16 txq_id;
-- 
2.5.0


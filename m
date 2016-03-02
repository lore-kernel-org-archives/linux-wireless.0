Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34250 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbcCBH4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:56:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/43] iwlwifi: mvm: set the correct descriptor size for tracing
Date: Wed,  2 Mar 2016 09:56:05 +0200
Message-Id: <1456905404-14435-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085656_822343_A914900F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The 9000 series uses a diffrent sized descriptor. Update the
relevant tracing field.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ec36046..3661a9d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -479,8 +479,11 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	if (iwl_mvm_has_new_rx_api(mvm)) {
 		op_mode->ops = &iwl_mvm_ops_mq;
+		trans->rx_mpdu_cmd_hdr_size = sizeof(struct iwl_rx_mpdu_desc);
 	} else {
 		op_mode->ops = &iwl_mvm_ops;
+		trans->rx_mpdu_cmd_hdr_size =
+			sizeof(struct iwl_rx_mpdu_res_start);
 
 		if (WARN_ON(trans->num_rx_queues > 1))
 			goto out_free;
@@ -572,7 +575,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	iwl_trans_configure(mvm->trans, &trans_cfg);
 
 	trans->rx_mpdu_cmd = REPLY_RX_MPDU_CMD;
-	trans->rx_mpdu_cmd_hdr_size = sizeof(struct iwl_rx_mpdu_res_start);
 	trans->dbg_dest_tlv = mvm->fw->dbg_dest_tlv;
 	trans->dbg_dest_reg_num = mvm->fw->dbg_dest_reg_num;
 	memcpy(trans->dbg_conf_tlv, mvm->fw->dbg_conf_tlv,
-- 
2.5.0


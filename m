Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:54050 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICT4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:47 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so9013141wes.8
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:46 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/36] iwlwifi: mvm: disable tx aggregation on low latency vifs
Date: Wed,  3 Sep 2014 22:56:00 +0300
Message-Id: <1409774184-24665-12-git-send-email-egrumbach@gmail.com> (sfid-20140903_215652_144509_83E70C7A)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Aggregations hit latency so disable it by default on
low latency vifs for now. Enable control over this behavior and
allow control over the max frames in an AMPDU in low latency
vifs via debugfs.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 4 ++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     | 2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c     | 1 +
 drivers/net/wireless/iwlwifi/mvm/rs.c      | 8 +++++++-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 1fcbc23..f85d4f4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1447,6 +1447,10 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 		goto err;
 #endif
 
+	if (!debugfs_create_u8("low_latency_agg_frame_limit", S_IRUSR | S_IWUSR,
+			       mvm->debugfs_dir,
+			       &mvm->low_latency_agg_frame_limit))
+		goto err;
 	if (!debugfs_create_u8("ps_disabled", S_IRUSR,
 			       mvm->debugfs_dir, &mvm->ps_disabled))
 		goto err;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d6b00b9..08cb26d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -727,6 +727,8 @@ struct iwl_mvm {
 
 	/* system time of last beacon (for AP/GO interface) */
 	u32 ap_last_beacon_gp2;
+
+	u8 low_latency_agg_frame_limit;
 };
 
 /* Extract MVM priv from op_mode and _hw */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 610dbcb..e3be34f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -415,6 +415,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		mvm->first_agg_queue = 12;
 	}
 	mvm->sf_state = SF_UNINIT;
+	mvm->low_latency_agg_frame_limit = 1;
 
 	mutex_init(&mvm->mutex);
 	mutex_init(&mvm->d0i3_suspend_mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index b7a1efc..940e0d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2855,9 +2855,15 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 	 * Tx Fifo so that it can start a transaction in the same TxOP. This
 	 * basically allows the firmware to send bursts.
 	 */
-	if (iwl_mvm_vif_low_latency(mvmvif))
+	if (iwl_mvm_vif_low_latency(mvmvif)) {
 		lq_cmd->agg_frame_cnt_limit--;
 
+		if (mvm->low_latency_agg_frame_limit)
+			lq_cmd->agg_frame_cnt_limit =
+				min(lq_cmd->agg_frame_cnt_limit,
+				    mvm->low_latency_agg_frame_limit);
+	}
+
 	if (mvmsta->vif->p2p)
 		lq_cmd->flags |= LQ_FLAG_USE_RTS_MSK;
 
-- 
1.9.1


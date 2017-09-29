Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36152 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752177AbdI2Qoe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:44:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:06 +0300
Message-Id: <20170929164423.23666-2-luca@coelho.fi> (sfid-20170929_200758_842169_5E9DECC0)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 01/18] iwlwifi: mvm: don't send identical PHY_CTXT_CMD
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we have an AP which supports HT and a single HT
station is connected, we change the min_width from
NL80211_CHAN_WIDTH_20_NOHT to NL80211_CHAN_WIDTH_20. This
of course has no implication on the channel width but still
sends a command to the firmware.
Remember the last width that was sent and refrain from
sending unnecessary commands to the firmware.

Sending a PHY_CTXT_CMD to the firmware has a cost since it
recalculates the presence on the medium and because of that
it closes the transmit queues for a short while.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 14 ++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c |  1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d7530474c1d3..d6180463e92f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3406,10 +3406,24 @@ static void iwl_mvm_change_chanctx(struct ieee80211_hw *hw,
 		return;
 
 	mutex_lock(&mvm->mutex);
+
+	/* we are only changing the min_width, may be a noop */
+	if (changed == IEEE80211_CHANCTX_CHANGE_MIN_WIDTH) {
+		if (phy_ctxt->width == ctx->min_def.width)
+			goto out_unlock;
+
+		/* we are just toggling between 20_NOHT and 20 */
+		if (phy_ctxt->width <= NL80211_CHAN_WIDTH_20 &&
+		    ctx->min_def.width <= NL80211_CHAN_WIDTH_20)
+			goto out_unlock;
+	}
+
 	iwl_mvm_bt_coex_vif_change(mvm);
 	iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &ctx->min_def,
 				 ctx->rx_chains_static,
 				 ctx->rx_chains_dynamic);
+
+out_unlock:
 	mutex_unlock(&mvm->mutex);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index e8be5104b909..2867683f1aa0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -147,6 +147,8 @@ struct iwl_mvm_phy_ctxt {
 	u16 color;
 	u32 ref;
 
+	enum nl80211_chan_width width;
+
 	/*
 	 * TODO: This should probably be removed. Currently here only for rate
 	 * scaling algorithm
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 7ee8e9077baf..305cd56bf746 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -272,6 +272,7 @@ int iwl_mvm_phy_ctxt_changed(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt,
 	}
 
 	ctxt->channel = chandef->chan;
+	ctxt->width = chandef->width;
 	return iwl_mvm_phy_ctxt_apply(mvm, ctxt, chandef,
 				      chains_static, chains_dynamic,
 				      action, 0);
-- 
2.14.1

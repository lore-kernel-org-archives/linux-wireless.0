Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3E0C49EA2
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jun 2021 11:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECF461374
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jun 2021 11:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhFLLew (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 12 Jun 2021 07:34:52 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:47570 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231196AbhFLLev (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 Jun 2021 07:34:51 -0400
Received: from [192.130.48.226] (helo=kveik.superpark.guest)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1ls1sf-001V8i-HJ; Sat, 12 Jun 2021 14:32:51 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Sat, 12 Jun 2021 14:32:38 +0300
Message-Id: <iwlwifi.20210612142637.e9ac313f70f3.I713b9d109957df7e7d9ed0861d5377ce3f8fccd3@changeid>
X-Mailer: git-send-email 2.32.0.rc2
In-Reply-To: <20210612113245.691117-1-luca@coelho.fi>
References: <20210612113245.691117-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/12] iwlwifi: mvm: don't change band on bound PHY contexts
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When we have a P2P Device active, we attempt to only change the
PHY context it uses when we get a new remain-on-channel, if the
P2P Device is the only user of the PHY context.

This is fine if we're switching within a band, but if we're
switching bands then the switch implies a removal and re-add
of the PHY context, which isn't permitted by the firmware while
it's bound to an interface.

Fix the code to skip the unbind/release/... cycle only if the
band doesn't change (or we have old devices that can switch the
band on the fly as well.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 8fff558ac821..80dd4506f205 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3838,6 +3838,7 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct cfg80211_chan_def chandef;
 	struct iwl_mvm_phy_ctxt *phy_ctxt;
+	bool band_change_removal;
 	int ret, i;
 
 	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d, %d)\n", channel->hw_value,
@@ -3918,19 +3919,30 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
 
 	/*
-	 * Change the PHY context configuration as it is currently referenced
-	 * only by the P2P Device MAC
+	 * Check if the remain-on-channel is on a different band and that
+	 * requires context removal, see iwl_mvm_phy_ctxt_changed(). If
+	 * so, we'll need to release and then re-configure here, since we
+	 * must not remove a PHY context that's part of a binding.
 	 */
-	if (mvmvif->phy_ctxt->ref == 1) {
+	band_change_removal =
+		fw_has_capa(&mvm->fw->ucode_capa,
+			    IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT) &&
+		mvmvif->phy_ctxt->channel->band != chandef.chan->band;
+
+	if (mvmvif->phy_ctxt->ref == 1 && !band_change_removal) {
+		/*
+		 * Change the PHY context configuration as it is currently
+		 * referenced only by the P2P Device MAC (and we can modify it)
+		 */
 		ret = iwl_mvm_phy_ctxt_changed(mvm, mvmvif->phy_ctxt,
 					       &chandef, 1, 1);
 		if (ret)
 			goto out_unlock;
 	} else {
 		/*
-		 * The PHY context is shared with other MACs. Need to remove the
-		 * P2P Device from the binding, allocate an new PHY context and
-		 * create a new binding
+		 * The PHY context is shared with other MACs (or we're trying to
+		 * switch bands), so remove the P2P Device from the binding,
+		 * allocate an new PHY context and create a new binding.
 		 */
 		phy_ctxt = iwl_mvm_get_free_phy_ctxt(mvm);
 		if (!phy_ctxt) {
-- 
2.32.0.rc2


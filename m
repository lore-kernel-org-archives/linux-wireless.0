Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:33030 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3KXUHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:04 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so2948778wes.26
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:03 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/29] iwlwifi: mvm: fix ht protection flags
Date: Sun, 24 Nov 2013 22:06:28 +0200
Message-Id: <1385323606-3603-11-git-send-email-egrumbach@gmail.com> (sfid-20131124_210712_926222_DCA7DDEA)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

The HT protection flags have been a mess for a long time,
this patch fixes all this.

The proper source of information for this is the
protection in the HT operation mode IE which is
propagated to bss_conf by mac80211.

1) No need to set the HT protection flags when the link
   doesn't support HT.
2) We need to set the TGG protection when ERP is active.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |   51 ++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   11 ++++++
 2 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index f41f9b0..fb93961 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -488,6 +488,40 @@ static void iwl_mvm_ack_rates(struct iwl_mvm *mvm,
 	*ofdm_rates = ofdm;
 }
 
+static void iwl_mvm_mac_ctxt_set_ht_flags(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *vif,
+					 struct iwl_mac_ctx_cmd *cmd)
+{
+	/* for both sta and ap, ht_operation_mode hold the protection_mode */
+	u8 protection_mode = vif->bss_conf.ht_operation_mode &
+				 IEEE80211_HT_OP_MODE_PROTECTION;
+	/* The fw does not distinguish between ht and fat */
+	u32 ht_flag = MAC_PROT_FLG_HT_PROT | MAC_PROT_FLG_FAT_PROT;
+
+	IWL_DEBUG_RATE(mvm, "protection mode set to %d\n", protection_mode);
+	/*
+	 * See section 9.23.3.1 of IEEE 80211-2012.
+	 * Nongreenfield HT STAs Present is not supported.
+	 */
+	switch (protection_mode) {
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONE:
+		break;
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+		cmd->protection_flags |= cpu_to_le32(ht_flag);
+		break;
+	case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
+		/* Protect when channel wider than 20MHz */
+		if (vif->bss_conf.chandef.width > NL80211_CHAN_WIDTH_20)
+			cmd->protection_flags |= cpu_to_le32(ht_flag);
+		break;
+	default:
+		IWL_ERR(mvm, "Illegal protection mode %d\n",
+			protection_mode);
+		break;
+	}
+}
+
 static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
 					struct iwl_mac_ctx_cmd *cmd,
@@ -495,6 +529,8 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct ieee80211_chanctx_conf *chanctx;
+	bool ht_enabled = !!(vif->bss_conf.ht_operation_mode &
+			     IEEE80211_HT_OP_MODE_PROTECTION);
 	u8 cck_ack_rates, ofdm_ack_rates;
 	int i;
 
@@ -573,16 +609,13 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 			cmd->protection_flags |=
 				cpu_to_le32(MAC_PROT_FLG_SELF_CTS_EN);
 	}
-
-	/*
-	 * I think that we should enable these 2 flags regardless the HT PROT
-	 * fields in the HT IE, but I am not sure. Someone knows whom to ask?...
-	 */
-	if (vif->bss_conf.chandef.width != NL80211_CHAN_WIDTH_20_NOHT) {
+	IWL_DEBUG_RATE(mvm, "use_cts_prot %d, ht_operation_mode %d\n",
+		       vif->bss_conf.use_cts_prot,
+		       vif->bss_conf.ht_operation_mode);
+	if (vif->bss_conf.chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_TGN);
-		cmd->protection_flags |= cpu_to_le32(MAC_PROT_FLG_HT_PROT |
-						     MAC_PROT_FLG_FAT_PROT);
-	}
+	if (ht_enabled)
+		iwl_mvm_mac_ctxt_set_ht_flags(mvm, vif, cmd);
 
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 0cc9c1e..f892f58 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -990,6 +990,17 @@ iwl_mvm_bss_info_changed_ap_ibss(struct iwl_mvm *mvm,
 				 struct ieee80211_bss_conf *bss_conf,
 				 u32 changes)
 {
+	enum ieee80211_bss_change ht_change = BSS_CHANGED_ERP_CTS_PROT |
+					      BSS_CHANGED_HT |
+					      BSS_CHANGED_BANDWIDTH;
+	int ret;
+
+	if (changes & ht_change) {
+		ret = iwl_mvm_mac_ctxt_changed(mvm, vif);
+		if (ret)
+			IWL_ERR(mvm, "failed to update MAC %pM\n", vif->addr);
+	}
+
 	/* Need to send a new beacon template to the FW */
 	if (changes & BSS_CHANGED_BEACON) {
 		if (iwl_mvm_mac_ctxt_beacon_changed(mvm, vif))
-- 
1.7.9.5


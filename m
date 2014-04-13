Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48683 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaDMTUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:49 -0400
Received: by mail-wi0-f181.google.com with SMTP id hm4so3127833wib.14
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:48 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/47] iwlwifi: mvm: deprecate -7 firmware
Date: Sun, 13 Apr 2014 22:19:41 +0300
Message-Id: <1397416802-32403-26-git-send-email-egrumbach@gmail.com> (sfid-20140413_213515_517650_1FE21CBF)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This firmware is not supported any more.
A few code paths specific to old firmware can be removed.
We can now assume that a few TLV flags are always set since
we won't load firmware that didn't support the corresponding
features. This will be done in a separate patch.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c     | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 5 +----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 7 ++-----
 drivers/net/wireless/iwlwifi/mvm/sf.c       | 3 ---
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index c42d80c..3ab21ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -75,8 +75,8 @@
 #define IWL3160_UCODE_API_OK	8
 
 /* Lowest firmware API version supported */
-#define IWL7260_UCODE_API_MIN	7
-#define IWL3160_UCODE_API_MIN	7
+#define IWL7260_UCODE_API_MIN	8
+#define IWL3160_UCODE_API_MIN	8
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 9ccec10..7110ec2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -667,12 +667,9 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 	if (vif->bss_conf.qos)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_UPDATE_EDCA);
 
-	/* Don't use cts to self as the fw doesn't support it currently. */
 	if (vif->bss_conf.use_cts_prot) {
 		cmd->protection_flags |= cpu_to_le32(MAC_PROT_FLG_TGG_PROTECT);
-		if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 8)
-			cmd->protection_flags |=
-				cpu_to_le32(MAC_PROT_FLG_SELF_CTS_EN);
+		cmd->protection_flags |= cpu_to_le32(MAC_PROT_FLG_SELF_CTS_EN);
 	}
 	IWL_DEBUG_RATE(mvm, "use_cts_prot %d, ht_operation_mode %d\n",
 		       vif->bss_conf.use_cts_prot,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 01b4228..39e4ffe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -309,11 +309,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		BIT(NL80211_IFTYPE_P2P_CLIENT) |
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_P2P_GO) |
-		BIT(NL80211_IFTYPE_P2P_DEVICE);
-
-	/* IBSS has bugs in older versions */
-	if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 8)
-		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_P2P_DEVICE) |
+		BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
diff --git a/drivers/net/wireless/iwlwifi/mvm/sf.c b/drivers/net/wireless/iwlwifi/mvm/sf.c
index 8401627..aa819e6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -237,9 +237,6 @@ int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *changed_vif,
 		.sta_vif_ap_sta_id = IWL_MVM_STATION_COUNT,
 	};
 
-	if (IWL_UCODE_API(mvm->fw->ucode_ver) < 8)
-		return 0;
-
 	/*
 	 * Ignore the call if we are in HW Restart flow, or if the handled
 	 * vif is a p2p device.
-- 
1.8.3.2


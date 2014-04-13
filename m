Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65015 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbaDMTVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:00 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so7502059wgh.16
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:59 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_BF_UPDATED flag
Date: Sun, 13 Apr 2014 22:19:48 +0300
Message-Id: <1397416802-32403-33-git-send-email-egrumbach@gmail.com> (sfid-20140413_213516_108656_2763F52A)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       | 2 --
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 +--
 drivers/net/wireless/iwlwifi/mvm/power.c    | 3 +--
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 04eac6e..f87ab69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -79,7 +79,6 @@
  *	offload profile config command.
  * @IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS: D3 image supports up to six
  *	(rather than two) IPv6 addresses
- * @IWL_UCODE_TLV_FLAGS_BF_UPDATED: new beacon filtering API
  * @IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID: not sending a probe with the SSID element
  *	from the probe request template.
  * @IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API: modified D3 API to allow keeping
@@ -107,7 +106,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
 	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
 	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
-	IWL_UCODE_TLV_FLAGS_BF_UPDATED		= BIT(11),
 	IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID	= BIT(12),
 	IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API	= BIT(14),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL	= BIT(15),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 39e4ffe..c455722 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -824,8 +824,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_remove_mac;
 
 	if (!mvm->bf_allowed_vif &&
-	    vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
-	    mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BF_UPDATED){
+	    vif->type == NL80211_IFTYPE_STATION && !vif->p2p) {
 		mvm->bf_allowed_vif = mvmvif;
 		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
 				     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index ab92a63..dba760f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -843,8 +843,7 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BF_UPDATED) ||
-	    vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
 	ret = iwl_mvm_beacon_filter_send_cmd(mvm, &cmd, flags);
-- 
1.8.3.2


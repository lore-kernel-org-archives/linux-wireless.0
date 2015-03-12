Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbbCLNFD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:03 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/49] iwlwifi: nvm: init correct nvm channel list for 8000 devices
Date: Thu, 12 Mar 2015 15:03:55 +0200
Message-Id: <1426165474-25586-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140515_265144_CBC1EB22)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arikx.nemtsov@intel.com>

Otherwise the regulatory data will mistakenly contain only 7000 series
channels.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 7 ++++---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 8870377..5959329 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -709,12 +709,13 @@ static u32 iwl_nvm_get_regdom_bw_flags(const u8 *nvm_chan,
 }
 
 struct ieee80211_regdomain *
-iwl_parse_nvm_mcc_info(struct device *dev, int num_of_ch, __le32 *channels,
-		       u16 fw_mcc)
+iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
+		       int num_of_ch, __le32 *channels, u16 fw_mcc)
 {
 	int ch_idx;
 	u16 ch_flags, prev_ch_flags = 0;
-	const u8 *nvm_chan = iwl_nvm_channels; /* TODO: 8000 series differs */
+	const u8 *nvm_chan = cfg->device_family == IWL_DEVICE_FAMILY_8000 ?
+			     iwl_nvm_channels_family_8000 : iwl_nvm_channels;
 	struct ieee80211_regdomain *regd;
 	int size_of_regd;
 	struct ieee80211_reg_rule *rule;
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index c2fa930..1b3990d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -90,7 +90,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
  * the regdomain returned here with kfree.
  */
 struct ieee80211_regdomain *
-iwl_parse_nvm_mcc_info(struct device *dev, int num_of_ch, __le32 *channels,
-		       u16 fw_mcc);
+iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
+		       int num_of_ch, __le32 *channels, u16 fw_mcc);
 
 #endif /* __iwl_nvm_parse_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 0da8787..5dc3a94 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -325,7 +325,7 @@ struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 		goto out_unlock;
 	}
 
-	regd = iwl_parse_nvm_mcc_info(mvm->trans->dev,
+	regd = iwl_parse_nvm_mcc_info(mvm->trans->dev, mvm->cfg,
 				      __le32_to_cpu(resp->n_channels),
 				      resp->channels,
 				      __le16_to_cpu(resp->mcc));
-- 
1.9.1


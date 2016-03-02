Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbcCBH5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:41 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/43] iwlwifi: mvm: Set global RRM capability
Date: Wed,  2 Mar 2016 09:56:31 +0200
Message-Id: <1456905404-14435-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085953_649763_2A768CB8)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Allow to publish RRM capabilities without the need to support a minimal
capability set. Since some RRM features(e.g. neighbor report) are fw
independent, set this capability unconditionally.

Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 85ea5a8..4c2449b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -610,6 +610,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 			IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT))
 		hw->wiphy->features |= NL80211_FEATURE_WFA_TPC_IE_IN_PROBES;
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_RRM);
+
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.5.0


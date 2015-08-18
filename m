Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbbHRH6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/26] iwlwifi: mvm: support TDLS wider-bandwidth
Date: Tue, 18 Aug 2015 10:57:30 +0300
Message-Id: <1439884656-18146-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100110_495602_06BBCF5B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When TDLS support is declared by the FW, set the bit indicating wider-BW
support as well.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 08dd674..537a157 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -641,6 +641,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 			IWL_UCODE_TLV_CAPA_TDLS_SUPPORT)) {
 		IWL_DEBUG_TDLS(mvm, "TDLS supported\n");
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
+		ieee80211_hw_set(hw, TDLS_WIDER_BW);
 	}
 
 	if (fw_has_capa(&mvm->fw->ucode_capa,
-- 
2.1.4


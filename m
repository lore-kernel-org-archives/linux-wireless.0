Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaL3OUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:04 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/33] iwlwifi: mvm: consider d0i3_disable in iwl_mvm_is_d0i3_supported()
Date: Tue, 30 Dec 2014 16:18:54 +0200
Message-Id: <1419949148-24046-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154349_964216_F75D396E)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Consider the iwlwifi module param d0i3_disable when
considering whether d0i3 is supported.

(There is currently no need to differentiate between
supported and enabled, so keep the function as-is)

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 33a674a..b2100b4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -851,6 +851,7 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 {
 	return mvm->trans->cfg->d0i3 &&
 	       mvm->trans->d0i3_mode != IWL_D0I3_MODE_OFF &&
+	       !iwlwifi_mod_params.d0i3_disable &&
 	       (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
 }
 
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45798 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932687AbbIUVBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:55 +0300
Message-Id: <1442869141-31637-15-git-send-email-luca@coelho.fi> (sfid-20150921_231005_680658_49DADE43)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 15/21] iwlwifi: mvm: make sure AP is operating for ToF
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's possible for an AP interface to be UP but not actually
operating (i.e. not beaconing etc.) - in this case it can't
actually do ToF, so check for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tof.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tof.c b/drivers/net/wireless/iwlwifi/mvm/tof.c
index 380972f..7ae0bd8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tof.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tof.c
@@ -178,7 +178,8 @@ int iwl_mvm_tof_responder_cmd(struct iwl_mvm *mvm,
 	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT))
 		return -EINVAL;
 
-	if (vif->p2p || vif->type != NL80211_IFTYPE_AP) {
+	if (vif->p2p || vif->type != NL80211_IFTYPE_AP ||
+	    !mvmvif->ap_ibss_active) {
 		IWL_ERR(mvm, "Cannot start responder, not in AP mode\n");
 		return -EIO;
 	}
-- 
2.5.1


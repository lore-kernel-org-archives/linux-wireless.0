Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:32936 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaEUJsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 05:48:01 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] iwlwifi: mvm: disable beacon filtering
Date: Wed, 21 May 2014 12:47:54 +0300
Message-Id: <1400665674-18525-1-git-send-email-egrumbach@gmail.com> (sfid-20140521_114805_924384_AA2182F7)
In-Reply-To: <537C7603.6080701@gmail.com>
References: <537C7603.6080701@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This feature has been causing trouble - disable it for now.

Cc: <stable@vger.kernel.org> [3.13+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b41dc84..8735ef1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -826,7 +826,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_remove_mac;
 
-	if (!mvm->bf_allowed_vif &&
+	if (!mvm->bf_allowed_vif && false &&
 	    vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BF_UPDATED){
 		mvm->bf_allowed_vif = mvmvif;
-- 
1.8.3.2


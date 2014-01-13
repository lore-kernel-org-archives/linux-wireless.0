Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49695 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaAMUWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:19 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so418155eek.17
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:19 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/18] iwlwifi: mvm: reset Thermal Throttling's SMPS request upon disassociation
Date: Mon, 13 Jan 2014 22:21:52 +0200
Message-Id: <1389644517-22807-13-git-send-email-egrumbach@gmail.com> (sfid-20140113_212227_501399_B33D7E62)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The request of SMPS issued by the Thermal Throttling code
was not reset when we disassociated - fix that.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 797b4d9..e843080 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -944,6 +944,8 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				IWL_ERR(mvm, "failed to update power mode\n");
 		}
 		iwl_mvm_bt_coex_vif_change(mvm);
+		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_TT,
+				    IEEE80211_SMPS_AUTOMATIC);
 	} else if (changes & BSS_CHANGED_BEACON_INFO) {
 		/*
 		 * We received a beacon _after_ association so
-- 
1.7.9.5


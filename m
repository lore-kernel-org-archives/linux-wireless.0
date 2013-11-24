Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52196 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3KXUHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:00 -0500
Received: by mail-wg0-f48.google.com with SMTP id z12so2985661wgg.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:06:59 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/29] iwlwifi: mvm: disconnect on disconnection wakeup event
Date: Sun, 24 Nov 2013 22:06:25 +0200
Message-Id: <1385323606-3603-8-git-send-email-egrumbach@gmail.com> (sfid-20131124_210711_646482_96490BA7)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

When waking up from d3 due to disconnection event
(e.g. because of beacon loss), we should disconnect
immediately.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 096cf80..d9eb68e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1533,10 +1533,16 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 	struct iwl_mvm_d3_gtk_iter_data gtkdata = {
 		.status = status,
 	};
+	u32 disconnection_reasons =
+		IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_MISSED_BEACON |
+		IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH;
 
 	if (!status || !vif->bss_conf.bssid)
 		return false;
 
+	if (le32_to_cpu(status->wakeup_reasons) & disconnection_reasons)
+		return false;
+
 	/* find last GTK that we used initially, if any */
 	gtkdata.find_phase = true;
 	ieee80211_iter_keys(mvm->hw, vif,
-- 
1.7.9.5


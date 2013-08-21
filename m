Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22170 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab3HUGEq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:04:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3.10 6/8] iwlwifi: mvm: unregister leds when registration failed
Date: Wed, 21 Aug 2013 09:04:24 +0300
Message-Id: <1377065066-13030-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130821_080458_511518_C9ECF604)
In-Reply-To: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit b7327d89ae694a89f9934d428bde520b77b31 upstream.

This was missing and prevented any further attempts
to load the module.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b7e95b0..f7545e0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -243,7 +243,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (ret)
 		return ret;
 
-	return ieee80211_register_hw(mvm->hw);
+	ret = ieee80211_register_hw(mvm->hw);
+	if (ret)
+		iwl_mvm_leds_exit(mvm);
+
+	return ret;
 }
 
 static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
-- 
1.7.10.4


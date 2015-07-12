Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20159 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbbGLRIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/10] iwlwifi: mvm: Avoid accessing Null pointer when setting igtk
Date: Sun, 12 Jul 2015 20:08:12 +0300
Message-Id: <1436720900-18588-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_190836_441130_76E09804)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Sometimes when setting an igtk key the station maybe NULL.
In the of case igtk the function will skip to the end, and
try to print sta->addr, if sta is Null - we will access a
Null pointer.

Avoid accessing a Null pointer when setting a igtk key &
the sta == NULL, and print a default MAC address instead.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index d68dc69..26f076e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1401,6 +1401,7 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
 	u8 sta_id;
 	int ret;
+	static const u8 __maybe_unused zero_addr[ETH_ALEN] = {0};
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1467,7 +1468,7 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 end:
 	IWL_DEBUG_WEP(mvm, "key: cipher=%x len=%d idx=%d sta=%pM ret=%d\n",
 		      keyconf->cipher, keyconf->keylen, keyconf->keyidx,
-		      sta->addr, ret);
+		      sta ? sta->addr : zero_addr, ret);
 	return ret;
 }
 
-- 
2.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab3BLQCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/15] iwlwifi: mvm: fix locking in iwl_mvm_ipv6_addr_change
Date: Tue, 12 Feb 2013 17:01:59 +0100
Message-Id: <1360684927-1367-7-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170222_413914_5D6FAB92)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

inet6_dev->lock can be taken from a timer. Disabled bottom
halves when we take it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 9a95c37..5b2c675 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -97,14 +97,14 @@ void iwl_mvm_ipv6_addr_change(struct ieee80211_hw *hw,
 	struct inet6_ifaddr *ifa;
 	int idx = 0;
 
-	read_lock(&idev->lock);
+	read_lock_bh(&idev->lock);
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		mvmvif->target_ipv6_addrs[idx] = ifa->addr;
 		idx++;
 		if (idx >= IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS)
 			break;
 	}
-	read_unlock(&idev->lock);
+	read_unlock_bh(&idev->lock);
 
 	mvmvif->num_target_ipv6_addrs = idx;
 }
-- 
1.8.0


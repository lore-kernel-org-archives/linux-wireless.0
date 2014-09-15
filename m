Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60020 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaIOFNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:17 -0400
Received: by mail-wi0-f179.google.com with SMTP id q5so1364692wiv.12
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:16 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Max Stepanov <Max.Stepanov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/28] iwlwifi: mvm: add MVM_FW_MCAST_FILTER_PASS_ALL option
Date: Mon, 15 Sep 2014 08:12:40 +0300
Message-Id: <1410757980-2138-8-git-send-email-egrumbach@gmail.com> (sfid-20140915_071324_856548_9D712695)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

Add MVM_FW_MCAST_FILTER_PASS_ALL option to iwl-dbg-cfg.ini configuration file
to enable/disable FW multicast filtering.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index dd00e8f..cb48656 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -86,5 +86,6 @@
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
 #define IWL_MVM_BT_COEX_CORUNNING		1
 #define IWL_MVM_BT_COEX_MPLUT			1
+#define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index bcfb03c..089d7b3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1200,14 +1200,15 @@ static u64 iwl_mvm_prepare_multicast(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mcast_filter_cmd *cmd;
 	struct netdev_hw_addr *addr;
-	int addr_count = netdev_hw_addr_list_count(mc_list);
-	bool pass_all = false;
+	int addr_count;
+	bool pass_all;
 	int len;
 
-	if (addr_count > MAX_MCAST_FILTERING_ADDRESSES) {
-		pass_all = true;
+	addr_count = netdev_hw_addr_list_count(mc_list);
+	pass_all = addr_count > MAX_MCAST_FILTERING_ADDRESSES ||
+		   IWL_MVM_FW_MCAST_FILTER_PASS_ALL;
+	if (pass_all)
 		addr_count = 0;
-	}
 
 	len = roundup(sizeof(*cmd) + addr_count * ETH_ALEN, 4);
 	cmd = kzalloc(len, GFP_ATOMIC);
-- 
1.9.1


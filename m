Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:51920 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726354AbeIFH4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 03:56:40 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <davem@davemloft.net>, <johannes.berg@intel.com>,
        <emmanuel.grumbach@intel.com>, <luciano.coelho@intel.com>,
        <linuxwifi@intel.com>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] iwlwifi: Use kmemdup instead of duplicating it in iwl_parse_nvm_mcc_info
Date: Thu, 6 Sep 2018 11:20:59 +0800
Message-ID: <20180906032059.11160-1-yuehaibing@huawei.com> (sfid-20180906_052338_581299_356C6EF0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace calls to kzalloc followed by a memcpy with a direct call to
kmemdup.

Patch found using coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: fix a typo 'reg' --> 'regd'
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 27db4a3..bd91657 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1113,14 +1113,12 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	regd_to_copy = sizeof(struct ieee80211_regdomain) +
 		valid_rules * sizeof(struct ieee80211_reg_rule);
 
-	copy_rd = kzalloc(regd_to_copy, GFP_KERNEL);
+	copy_rd = kmemdup(regd, regd_to_copy, GFP_KERNEL);
 	if (!copy_rd) {
 		copy_rd = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 
-	memcpy(copy_rd, regd, regd_to_copy);
-
 out:
 	kfree(regdb_ptrs);
 	kfree(regd);
-- 
2.7.0

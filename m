Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11664 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725981AbeIFHrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 03:47:55 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <davem@davemloft.net>, <johannes.berg@intel.com>,
        <emmanuel.grumbach@intel.com>, <luciano.coelho@intel.com>,
        <linuxwifi@intel.com>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] iwlwifi: Use kmemdup instead of duplicating it in iwl_parse_nvm_mcc_info
Date: Thu, 6 Sep 2018 11:13:22 +0800
Message-ID: <20180906031322.17748-1-yuehaibing@huawei.com> (sfid-20180906_051457_506621_056DC383)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace calls to kmalloc followed by a memcpy with a direct call to
kmemdup.

Patch found using coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
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
+	copy_rd = kmemdup(reg, regd_to_copy, GFP_KERNEL);
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

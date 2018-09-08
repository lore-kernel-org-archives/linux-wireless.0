Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:51019 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726587AbeIHTKt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Sep 2018 15:10:49 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <davem@davemloft.net>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] wireless: remove unnecessary condition check before kfree
Date: Sat, 8 Sep 2018 22:12:35 +0800
Message-ID: <1536415955-33776-1-git-send-email-zhongjiang@huawei.com> (sfid-20180908_162514_404097_5E7EC1C1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kfree has taken the null pointer into account. Just remove the
redundant condition check before kfree.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5ad5b9f..dc87e3d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1086,7 +1086,7 @@ int reg_reload_regdb(void)
 	}
 
 	rtnl_lock();
-	if (!IS_ERR_OR_NULL(regdb))
+	if (!IS_ERR(regdb))
 		kfree(regdb);
 	regdb = db;
 	rtnl_unlock();
@@ -3920,7 +3920,7 @@ void regulatory_exit(void)
 		kfree(reg_request);
 	}
 
-	if (!IS_ERR_OR_NULL(regdb))
+	if (!IS_ERR(regdb))
 		kfree(regdb);
 
 	free_regdb_keyring();
-- 
1.7.12.4

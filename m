Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:43314 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726498AbeIHSix (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Sep 2018 14:38:53 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <davem@davemloft.net>, <arend.vanspriel@broadcom.com>,
        <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <kvalo@codeaurora.org>
CC: <chi-hsien.lin@cypress.com>, <wright.feng@cypress.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>, <netdev@vger.kernel.org>
Subject: [PATCH] brcm80211: remove redundant condition check before debugfs_remove_recursive
Date: Sat, 8 Sep 2018 21:40:43 +0800
Message-ID: <1536414043-32146-1-git-send-email-zhongjiang@huawei.com> (sfid-20180908_155309_430389_07811C26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

debugfs_remove_recursive has taken IS_ERR_OR_NULL into account. So just
remove the condition check before debugfs_remove_recursive.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c
index 2fe1f68..3bd54f1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c
@@ -62,8 +62,7 @@ int brcms_debugfs_attach(struct brcms_pub *drvr)
 
 void brcms_debugfs_detach(struct brcms_pub *drvr)
 {
-	if (!IS_ERR_OR_NULL(drvr->dbgfs_dir))
-		debugfs_remove_recursive(drvr->dbgfs_dir);
+	debugfs_remove_recursive(drvr->dbgfs_dir);
 }
 
 struct dentry *brcms_debugfs_get_devdir(struct brcms_pub *drvr)
-- 
1.7.12.4

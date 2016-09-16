Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57033 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbcIPJjQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 05:39:16 -0400
From: Colin King <colin.king@canonical.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH][V2] mwifiex: fix null pointer deference when adapter is null
Date: Fri, 16 Sep 2016 10:37:31 +0100
Message-Id: <20160916093731.23346-1-colin.king@canonical.com> (sfid-20160916_113922_199506_0D68EB3D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

If adapter is null the error exit path in mwifiex_shutdown_sw is
to down the semaphore sem and print some debug via mwifiex_dbg.
However, passing a NULL adapter to mwifiex_dbg causes a null
pointer deference when accessing adapter->dev.  This fix checks
for a null adapter at the start of the function and to exit
without the need to up the semaphore and we also skip the debug
to avoid the null pointer dereference.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 9b2e98c..2478ccd 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1369,12 +1369,12 @@ mwifiex_shutdown_sw(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	struct mwifiex_private *priv;
 	int i;
 
+	if (!adapter)
+		goto exit_return;
+
 	if (down_interruptible(sem))
 		goto exit_sem_err;
 
-	if (!adapter)
-		goto exit_remove;
-
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	mwifiex_deauthenticate(priv, NULL);
 
@@ -1430,10 +1430,10 @@ mwifiex_shutdown_sw(struct mwifiex_adapter *adapter, struct semaphore *sem)
 		rtnl_unlock();
 	}
 
-exit_remove:
 	up(sem);
 exit_sem_err:
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
+exit_return:
 	return 0;
 }
 
-- 
2.7.4

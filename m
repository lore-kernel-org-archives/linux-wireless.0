Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lucky1.263xmail.com ([211.157.147.132]:36414 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbdGFHu6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 03:50:58 -0400
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] mwifiex: fix compile warning of unused variable
Date: Thu,  6 Jul 2017 15:50:33 +0800
Message-Id: <1499327433-70786-1-git-send-email-shawn.lin@rock-chips.com> (sfid-20170706_095105_011566_9E337295)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We got a compile warning shows below:

drivers/net/wireless/marvell/mwifiex/sdio.c: In function
'mwifiex_sdio_remove':
drivers/net/wireless/marvell/mwifiex/sdio.c:377:6: warning: variable
'ret' set but not used [-Wunused-but-set-variable]

Per the code, it didn't check if mwifiex_sdio_read_fw_status
finish successfully. We should at least check the return of
mwifiex_sdio_read_fw_status, otherwise the following check of
firmware_stat and adapter->mfg_mode is pointless as the device
is probably dead.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/net/wireless/marvell/mwifiex/sdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index f81a006..fd5183c 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -390,7 +390,8 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
 
 	ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
-	if (firmware_stat == FIRMWARE_READY_SDIO && !adapter->mfg_mode) {
+	if (!ret && firmware_stat == FIRMWARE_READY_SDIO &&
+	    !adapter->mfg_mode) {
 		mwifiex_deauthenticate_all(adapter);
 
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
-- 
1.9.1

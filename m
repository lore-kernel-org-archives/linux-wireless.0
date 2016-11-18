Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34231 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751689AbcKRIoL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 03:44:11 -0500
Received: by mail-pg0-f67.google.com with SMTP id e9so19713755pgc.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 00:44:11 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Fri, 18 Nov 2016 00:44:03 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/7] mwifiex: Removed unused mwifiex_private* 'priv' variable
Message-ID: <ad72403d4d99a1b13ea7f99b0ea992b23aa2ea09.1479458373.git.kirtika@google.com> (sfid-20161118_094415_152192_5EDFF41C)
References: <cover.1479458373.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479458373.git.kirtika@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit bec568ff5107 removed the last remaining usage of struct
mwifiex_private* priv in mwifiex_fw_dpc(), by removing the call to
mwifiex_del_virtual_intf().
Compiling mwifiex/ with W=1 gives the following warning, fix it.
mwifiex/main.c: In function ‘mwifiex_fw_dpc’:
mwifiex/main.c:520:26: warning: variable ‘priv’ set but not used [-Wunused-but-set-variable]

Fixes: bec568ff5107 ("mwifiex: failure path handling in mwifiex_add_virtual_intf()")
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 2478ccd..fff96be 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -517,7 +517,6 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 {
 	int ret;
 	char fmt[64];
-	struct mwifiex_private *priv;
 	struct mwifiex_adapter *adapter = context;
 	struct mwifiex_fw_image fw;
 	struct semaphore *sem = adapter->card_sem;
@@ -575,8 +574,6 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 			goto err_init_fw;
 	}

-	priv = adapter->priv[MWIFIEX_BSS_ROLE_STA];
-
 	if (!adapter->wiphy) {
 		if (mwifiex_register_cfg80211(adapter)) {
 			mwifiex_dbg(adapter, ERROR,
--
2.8.0.rc3.226.g39d4020

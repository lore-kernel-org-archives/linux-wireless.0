Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34583 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbcKRIqB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 03:46:01 -0500
Received: by mail-pf0-f195.google.com with SMTP id y68so13208444pfb.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 00:46:01 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Fri, 18 Nov 2016 00:45:54 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH 5/7] mwifiex: Remove unused 'pm_flag' variable
Message-ID: <41391bae10a957d9146b25d6919a2d69f4b5e2f0.1479458373.git.kirtika@google.com> (sfid-20161118_094604_590773_FD7F59D0)
References: <cover.1479458373.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479458373.git.kirtika@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex_sdio_resume() intializes pm_flag, just like mwifiex_sdio_suspend(), but
does not use it. Compiling with W=1 gives the following warning, fix it.
mwifiex/sdio.c: In function ‘mwifiex_sdio_resume’:
mwifiex/sdio.c:234:16: warning: variable ‘pm_flag’ set but not used [-Wunused-but-set-variable]

sdio_get_host_pm_caps() is just an acessor, so the call to it is safe to
remove.
The unused variable seems to be present since 5e6e3a92b9a4 which introduced
mwifiex_sdio_resume().

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: Bing Zhao <bzhao@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 8718950..41ec59d7 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -231,10 +231,8 @@ static int mwifiex_sdio_resume(struct device *dev)
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
-	mmc_pm_flag_t pm_flag = 0;

 	if (func) {
-		pm_flag = sdio_get_host_pm_caps(func);
 		card = sdio_get_drvdata(func);
 		if (!card || !card->adapter) {
 			pr_err("resume: invalid card or adapter\n");
--
2.8.0.rc3.226.g39d4020

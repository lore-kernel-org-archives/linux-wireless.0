Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33854 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934630AbcKXB0b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 20:26:31 -0500
Received: by mail-pg0-f67.google.com with SMTP id e9so2201532pgc.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2016 17:26:31 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Wed, 23 Nov 2016 17:26:06 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 5/7] mwifiex: Remove unused 'pm_flag' variable
Message-ID: <56d02b0bc8845cf71da212aa006ee15eb95023c9.1479950323.git.kirtika@google.com> (sfid-20161124_022635_152738_C3583A7E)
References: <cover.1479950323.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479950323.git.kirtika@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex_sdio_resume() intializes pm_flag, just like
mwifiex_sdio_suspend(), but does not use it. Compiling with W=1 gives
the following warning, fix it.
mwifiex/sdio.c: In function ‘mwifiex_sdio_resume’:
mwifiex/sdio.c:234:16: warning: variable ‘pm_flag’ set but not used [-Wunused-but-set-variable]

sdio_get_host_pm_caps() is just an acessor, so the call to it is safe
to remove. The unused variable seems to be present since
5e6e3a92b9a4 which introduced mwifiex_sdio_resume().

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: Bing Zhao <bzhao@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 0d00db5..6c9f16e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -186,9 +186,7 @@ static int mwifiex_sdio_resume(struct device *dev)
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
-	mmc_pm_flag_t pm_flag = 0;
 
-	pm_flag = sdio_get_host_pm_caps(func);
 	card = sdio_get_drvdata(func);
 	if (!card || !card->adapter) {
 		dev_err(dev, "resume: invalid card or adapter\n");
-- 
2.8.0.rc3.226.g39d4020

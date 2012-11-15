Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:34600 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283Ab2KOX7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 18:59:52 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@laptop.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, "3.0+" <stable@vger.kernel.org>
Subject: [PATCH 3.7] mwifiex: report error to MMC core if we cannot suspend
Date: Thu, 15 Nov 2012 15:58:48 -0800
Message-Id: <1353023928-16983-2-git-send-email-bzhao@marvell.com> (sfid-20121116_005957_629054_00C7AE0A)
In-Reply-To: <1353023928-16983-1-git-send-email-bzhao@marvell.com>
References: <1353023928-16983-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When host_sleep_config command fails we should return error to
MMC core to indicate the failure for our device.

The misspelled variable is also removed as it's redundant.

Cc: "3.0+" <stable@vger.kernel.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4fbbd61..5a1c1d0 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -161,7 +161,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
 	mmc_pm_flag_t pm_flag = 0;
-	int hs_actived = 0;
 	int i;
 	int ret = 0;
 
@@ -188,12 +187,14 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	adapter = card->adapter;
 
 	/* Enable the Host Sleep */
-	hs_actived = mwifiex_enable_hs(adapter);
-	if (hs_actived) {
-		pr_debug("cmd: suspend with MMC_PM_KEEP_POWER\n");
-		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	if (!mwifiex_enable_hs(adapter)) {
+		dev_err(adapter->dev, "cmd: failed to suspend\n");
+		return -EFAULT;
 	}
 
+	dev_dbg(adapter->dev, "cmd: suspend with MMC_PM_KEEP_POWER\n");
+	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+
 	/* Indicate device suspended */
 	adapter->is_suspended = true;
 
-- 
1.7.0.2


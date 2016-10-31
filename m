Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36666 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761999AbcJaIDB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 04:03:01 -0400
Received: by mail-pf0-f193.google.com with SMTP id n85so8104494pfi.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2016 01:03:01 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 10/12] mwifiex: sdio: don't check for NULL sdio_func
Date: Mon, 31 Oct 2016 16:02:18 +0800
Message-Id: <1477900940-10549-10-git-send-email-huxinming820@marvell.com> (sfid-20161031_090309_377394_8CD986CD)
In-Reply-To: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
References: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

sdio_func is retrieved via container_of() and should never be NULL.
Checking for NULL just makes the logic more confusing than necessary.
Stop doing that.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 40 +++++++++++------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 375d0a5..8f0f072 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -231,15 +231,10 @@ static int mwifiex_sdio_resume(struct device *dev)
 	struct mwifiex_adapter *adapter;
 	mmc_pm_flag_t pm_flag = 0;
 
-	if (func) {
-		pm_flag = sdio_get_host_pm_caps(func);
-		card = sdio_get_drvdata(func);
-		if (!card || !card->adapter) {
-			pr_err("resume: invalid card or adapter\n");
-			return 0;
-		}
-	} else {
-		pr_err("resume: sdio_func is not specified\n");
+	pm_flag = sdio_get_host_pm_caps(func);
+	card = sdio_get_drvdata(func);
+	if (!card || !card->adapter) {
+		dev_err(dev, "resume: invalid card or adapter\n");
 		return 0;
 	}
 
@@ -320,23 +315,18 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	mmc_pm_flag_t pm_flag = 0;
 	int ret = 0;
 
-	if (func) {
-		pm_flag = sdio_get_host_pm_caps(func);
-		pr_debug("cmd: %s: suspend: PM flag = 0x%x\n",
-			 sdio_func_id(func), pm_flag);
-		if (!(pm_flag & MMC_PM_KEEP_POWER)) {
-			pr_err("%s: cannot remain alive while host is"
-				" suspended\n", sdio_func_id(func));
-			return -ENOSYS;
-		}
+	pm_flag = sdio_get_host_pm_caps(func);
+	pr_debug("cmd: %s: suspend: PM flag = 0x%x\n",
+		 sdio_func_id(func), pm_flag);
+	if (!(pm_flag & MMC_PM_KEEP_POWER)) {
+		dev_err(dev, "%s: cannot remain alive while host is"
+			" suspended\n", sdio_func_id(func));
+		return -ENOSYS;
+	}
 
-		card = sdio_get_drvdata(func);
-		if (!card) {
-			dev_err(dev, "suspend: invalid card\n");
-			return 0;
-		}
-	} else {
-		pr_err("suspend: sdio_func is not specified\n");
+	card = sdio_get_drvdata(func);
+	if (!card) {
+		dev_err(dev, "suspend: invalid card\n");
 		return 0;
 	}
 
-- 
1.8.1.4

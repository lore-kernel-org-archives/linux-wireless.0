Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34989 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754303AbcKJL6D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 06:58:03 -0500
Received: by mail-pf0-f195.google.com with SMTP id i88so3963286pfk.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2016 03:58:03 -0800 (PST)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH RESEND v2 09/11] mwifiex: sdio: don't check for NULL sdio_func
Date: Thu, 10 Nov 2016 19:57:10 +0800
Message-Id: <1478779032-5165-9-git-send-email-huxinming820@marvell.com> (sfid-20161110_125817_602808_C2FD6C56)
In-Reply-To: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

sdio_func is retrieved via container_of() and should never be NULL.
Checking for NULL just makes the logic more confusing than necessary.
Stop doing that.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 40 +++++++++++------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 4c4b012..bee7326 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -190,15 +190,10 @@ static int mwifiex_sdio_resume(struct device *dev)
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
 
@@ -274,23 +269,18 @@ static int mwifiex_sdio_suspend(struct device *dev)
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

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37967 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753046AbcKRODj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 09:03:39 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v4 09/11] mwifiex: sdio: don't check for NULL sdio_func
Date: Fri, 18 Nov 2016 19:30:32 +0530
Message-ID: <1479477634-27841-9-git-send-email-akarwar@marvell.com> (sfid-20161118_150355_477209_D55D3AFE)
In-Reply-To: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
References: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

sdio_func is retrieved via container_of() and should never be NULL.
Checking for NULL just makes the logic more confusing than necessary.
Stop doing that.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v4: Same as v1, v2, v3
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 40 +++++++++++------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 69542f8..0d00db5 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -188,15 +188,10 @@ static int mwifiex_sdio_resume(struct device *dev)
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
 
@@ -272,23 +267,18 @@ static int mwifiex_sdio_suspend(struct device *dev)
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
1.9.1

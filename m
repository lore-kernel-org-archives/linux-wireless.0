Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16208 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbbLaO0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 09:26:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBVEOxKj012993
	for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2015 06:26:39 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 20327phmm6-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2015 06:26:39 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/4] mwifiex: increase priority for critical message
Date: Thu, 31 Dec 2015 06:24:14 -0800
Message-ID: <1451571855-29449-3-git-send-email-akarwar@marvell.com> (sfid-20151231_152713_033904_9FEAC464)
In-Reply-To: <1451571855-29449-1-git-send-email-akarwar@marvell.com>
References: <1451571855-29449-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch increase the priority for some critical
messages.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 6 +++---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 57750f5..5e15464 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2148,14 +2148,14 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
 	struct mwifiex_adapter *adapter;
 
 	if (!pdev) {
-		pr_debug("info: %s: pdev is NULL\n", (u8 *)pdev);
+		pr_err("info: %s: pdev is NULL\n", __func__);
 		goto exit;
 	}
 
 	card = pci_get_drvdata(pdev);
 	if (!card || !card->adapter) {
-		pr_debug("info: %s: card=%p adapter=%p\n", __func__, card,
-			 card ? card->adapter : NULL);
+		pr_err("info: %s: card=%p adapter=%p\n", __func__, card,
+		       card ? card->adapter : NULL);
 		goto exit;
 	}
 	adapter = card->adapter;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 024306a..ec1e8c3 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -796,8 +796,8 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 
 	card = sdio_get_drvdata(func);
 	if (!card || !card->adapter) {
-		pr_debug("int: func=%p card=%p adapter=%p\n",
-			 func, card, card ? card->adapter : NULL);
+		pr_err("int: func=%p card=%p adapter=%p\n",
+		       func, card, card ? card->adapter : NULL);
 		return;
 	}
 	adapter = card->adapter;
-- 
1.8.1.4


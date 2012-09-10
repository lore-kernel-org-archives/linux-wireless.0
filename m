Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63911 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab2IJOSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 10:18:23 -0400
Received: by qcro28 with SMTP id o28so1007734qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 07:18:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 22:18:22 +0800
Message-ID: <CAPgLHd-BBRkmvQTri50OAc+F2Z20rPLhR_hd3CTeUgRoYqrSoQ@mail.gmail.com> (sfid-20120910_161857_880839_BA051F82)
Subject: [PATCH v3] NFC: pn544_hci: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, Larry.Finger@lwfinger.net, kvalo@adurom.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/nfc/pn544_hci.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index aa71807..ed3918c 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -341,13 +341,17 @@ flush:
 static irqreturn_t pn544_hci_irq_thread_fn(int irq, void *dev_id)
 {
 	struct pn544_hci_info *info = dev_id;
-	struct i2c_client *client = info->i2c_dev;
+	struct i2c_client *client;
 	struct sk_buff *skb = NULL;
 	int r;
 
-	BUG_ON(!info);
-	BUG_ON(irq != info->i2c_dev->irq);
+	if (WARN_ON_ONCE(!info))
+		return IRQ_NONE;
+
+	if (WARN_ON_ONCE(irq != info->i2c_dev->irq))
+		return IRQ_NONE;
 
+	client = info->i2c_dev;
 	dev_dbg(&client->dev, "IRQ\n");
 
 	if (info->hard_fault != 0)



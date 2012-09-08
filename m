Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48016 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2IHNTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2012 09:19:45 -0400
Received: by qcro28 with SMTP id o28so272921qcr.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2012 06:19:44 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 8 Sep 2012 21:19:44 +0800
Message-ID: <CAPgLHd97e_ZyJFwSbCyCYMy4jwVVib5x4=A9UbTXuw+AiyJ3jA@mail.gmail.com> (sfid-20120908_152020_961970_FEE863CA)
Subject: [PATCH v3] NFC: pn544_hci: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com
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
 drivers/nfc/pn544_hci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index aa71807..e42b100 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -341,13 +341,16 @@ flush:
 static irqreturn_t pn544_hci_irq_thread_fn(int irq, void *dev_id)
 {
 	struct pn544_hci_info *info = dev_id;
-	struct i2c_client *client = info->i2c_dev;
+	struct i2c_client *client;
 	struct sk_buff *skb = NULL;
 	int r;
 
-	BUG_ON(!info);
-	BUG_ON(irq != info->i2c_dev->irq);
+	if (!info || irq != info->i2c_dev->irq) {
+		WARN_ON_ONCE(1);
+		return IRQ_NONE;
+	}
 
+	client = info->i2c_dev;
 	dev_dbg(&client->dev, "IRQ\n");
 
 	if (info->hard_fault != 0)



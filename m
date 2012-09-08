Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33327 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2IHBxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 21:53:45 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so128834qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 18:53:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 8 Sep 2012 09:53:45 +0800
Message-ID: <CAPgLHd_gF6X91JPGZK0f7vhSAK+d74YfbcvPn+givzMr=44+Sw@mail.gmail.com> (sfid-20120908_035349_259647_2748BF1B)
Subject: [PATCH v2] NFC: pn544_hci: move the dereference below the NULL test
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
 drivers/nfc/pn544_hci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index aa71807..7b20f2d 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -341,13 +341,14 @@ flush:
 static irqreturn_t pn544_hci_irq_thread_fn(int irq, void *dev_id)
 {
 	struct pn544_hci_info *info = dev_id;
-	struct i2c_client *client = info->i2c_dev;
+	struct i2c_client *client;
 	struct sk_buff *skb = NULL;
 	int r;
 
 	BUG_ON(!info);
 	BUG_ON(irq != info->i2c_dev->irq);
 
+	client = info->i2c_dev;
 	dev_dbg(&client->dev, "IRQ\n");
 
 	if (info->hard_fault != 0)



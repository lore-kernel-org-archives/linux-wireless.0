Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57148 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2IGGvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 02:51:48 -0400
Received: by mail-qa0-f53.google.com with SMTP id s11so1913741qaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2012 23:51:47 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 7 Sep 2012 14:51:47 +0800
Message-ID: <CAPgLHd8yH37C=mRWinWM4FGQaWTvH0r69PFEgJCNZL2DdZAS1A@mail.gmail.com> (sfid-20120907_085155_207855_1E33D689)
Subject: [PATCH] NFC: move the dereference below the NULL test
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
 drivers/nfc/nfcwilink.c | 4 ++--
 drivers/nfc/pn544_hci.c | 3 ++-
 drivers/nfc/pn544.c     | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index e7fd493..1a47190 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -352,8 +352,6 @@ static long nfcwilink_receive(void *priv_data, struct sk_buff *skb)
 	struct nfcwilink *drv = priv_data;
 	int rc;
 
-	nfc_dev_dbg(&drv->pdev->dev, "receive entry, len %d", skb->len);
-
 	if (!skb)
 		return -EFAULT;
 
@@ -362,6 +360,8 @@ static long nfcwilink_receive(void *priv_data, struct sk_buff *skb)
 		return -EFAULT;
 	}
 
+	nfc_dev_dbg(&drv->pdev->dev, "receive entry, len %d", skb->len);
+
 	/* strip the ST header
 	(apart for the chnl byte, which is not received in the hdr) */
 	skb_pull(skb, (NFCWILINK_HDR_LEN-1));

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

diff --git a/drivers/nfc/pn544.c b/drivers/nfc/pn544.c
index 724f65d..33696d6 100644
--- a/drivers/nfc/pn544.c
+++ b/drivers/nfc/pn544.c
@@ -288,11 +288,12 @@ static int pn544_fw_read(struct i2c_client *client, u8 *buf, int buflen)
 static irqreturn_t pn544_irq_thread_fn(int irq, void *dev_id)
 {
 	struct pn544_info *info = dev_id;
-	struct i2c_client *client = info->i2c_dev;
+	struct i2c_client *client;
 
 	BUG_ON(!info);
 	BUG_ON(irq != info->i2c_dev->irq);
 
+	client = info->i2c_dev;
 	dev_dbg(&client->dev, "IRQ\n");
 
 	mutex_lock(&info->read_mutex);


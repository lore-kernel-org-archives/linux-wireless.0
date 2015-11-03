Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:62528
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbbKCNGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 08:06:52 -0500
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <sameo@linux.intel.com>
CC: <robert.dolca@intel.com>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@ml01.01.org>, <dan.carpenter@oracle.com>,
	<festevam@gmail.com>, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] NFC: fdp: i2c: Check for NULL prior to dereference
Date: Tue, 3 Nov 2015 10:52:27 -0200
Message-ID: <1446555147-15717-1-git-send-email-fabio.estevam@freescale.com> (sfid-20151103_140656_620697_6DF34C84)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter reported the following:

"The patch a06347c04c13: "NFC: Add Intel Fields Peak NFC solution
driver" from Oct 22, 2015, leads to the following Smatch complaint:

drivers/nfc/fdp/i2c.c:216 fdp_nci_i2c_irq_thread_fn()
         warn: variable dereferenced before check 'phy' (see line 213)

drivers/nfc/fdp/i2c.c
   212
   213          client = phy->i2c_dev;
                         ^^^^^
Dereference.

   214          dev_dbg(&client->dev, "%s\n", __func__);
   215
   216          if (!phy || irq != phy->i2c_dev->irq) {
                    ^^^^
Check.

   217                  WARN_ON_ONCE(1);
   218                  return IRQ_NONE;
"

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/nfc/fdp/i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 532db28..a5d7332 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -210,14 +210,14 @@ static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 	struct sk_buff *skb;
 	int r;
 
-	client = phy->i2c_dev;
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	if (!phy || irq != phy->i2c_dev->irq) {
 		WARN_ON_ONCE(1);
 		return IRQ_NONE;
 	}
 
+	client = phy->i2c_dev;
+	dev_dbg(&client->dev, "%s\n", __func__);
+
 	r = fdp_nci_i2c_read(phy, &skb);
 
 	if (r == -EREMOTEIO)
-- 
1.9.1


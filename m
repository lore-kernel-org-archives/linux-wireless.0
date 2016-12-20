Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35686 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932646AbcLTVJM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 16:09:12 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] nfc: fdp: fix NULL pointer dereference
Date: Tue, 20 Dec 2016 21:09:04 +0000
Message-Id: <1482268144-14028-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20161220_220930_227732_7D93E942)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are checking phy after dereferencing it. We can print the debug
information after checking it. If phy is NULL then we will get a good
stack trace to tell us that we are in this irq handler.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/nfc/fdp/i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 5e797d5..712936f 100644
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

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:54162 "EHLO
        mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751940AbcL1RmI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 12:42:08 -0500
From: Andrey Rusalin <arusalin@dev.rtsoft.ru>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, michael.thalmeier@hale.at,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andrey Rusalin <arusalin@dev.rtsoft.ru>
Subject: [PATCH 1/3] NFC: pn533: change order of free_irq and dev unregistration
Date: Wed, 28 Dec 2016 20:10:57 +0300
Message-Id: <1482945059-12249-2-git-send-email-arusalin@dev.rtsoft.ru> (sfid-20161228_184214_853630_6876AA71)
In-Reply-To: <1482945059-12249-1-git-send-email-arusalin@dev.rtsoft.ru>
References: <1482945059-12249-1-git-send-email-arusalin@dev.rtsoft.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change order of free_irq and dev unregistration.
It fixes situation when device already unregistered and
an interrupt happens and nobody can handle it.

Signed-off-by: Andrey Rusalin <arusalin@dev.rtsoft.ru>
---
 drivers/nfc/pn533/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 5de5a49..e2848e4 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -242,10 +242,10 @@ static int pn533_i2c_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
-	pn533_unregister_device(phy->priv);
-
 	free_irq(client->irq, phy);
 
+	pn533_unregister_device(phy->priv);
+
 	return 0;
 }
 
-- 
2.7.4

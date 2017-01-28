Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33523 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdA1Ncw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 08:32:52 -0500
Received: by mail-lf0-f65.google.com with SMTP id x1so28035588lff.0
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jan 2017 05:31:33 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH fix?] bcma: use (get|put)_device when probing/removing device driver
Date: Sat, 28 Jan 2017 14:31:22 +0100
Message-Id: <20170128133122.12360-1-zajec5@gmail.com> (sfid-20170128_143257_708476_487FC950)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This allows tracking device state and e.g. makes devm work as expected.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Cc: Stable <stable@vger.kernel.org>
---
Kalle: this issue is in bcma since /ever/, so I'm Cc-ing stable without
pointing any version.

If someone reviewes (you or anyone) you may consider taking it as 3.10 fix.
Can someone confirm this patch is OK?
---
 drivers/bcma/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 2c1798e38abd..38688236b3cd 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -633,8 +633,11 @@ static int bcma_device_probe(struct device *dev)
 					       drv);
 	int err = 0;
 
+	get_device(dev);
 	if (adrv->probe)
 		err = adrv->probe(core);
+	if (err)
+		put_device(dev);
 
 	return err;
 }
@@ -647,6 +650,7 @@ static int bcma_device_remove(struct device *dev)
 
 	if (adrv->remove)
 		adrv->remove(core);
+	put_device(dev);
 
 	return 0;
 }
-- 
2.11.0

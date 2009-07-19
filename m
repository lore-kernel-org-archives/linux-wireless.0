Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:40984 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZGST0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 15:26:17 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] p54spi: fix potential null deref in p54spi.c
Date: Sun, 19 Jul 2009 21:26:13 +0200
Cc: Max Filippov <jcmvbkbc@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
References: <alpine.DEB.2.00.0907171607280.12306@bicker>
In-Reply-To: <alpine.DEB.2.00.0907171607280.12306@bicker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907192126.13207.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <error27@gmail.com>

Fix a potential NULL dereference bug during 
error handling in p54spi_probe.

This bug was discovered by smatch:
(http://repo.or.cz/w/smatch.git).

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
On Sunday 19 July 2009 13:53:57 Dan Carpenter wrote:

> We can't use dev_err() becuase "priv" is NULL.
yep, but that's my fault and not Micheal's.

> Found by smatch (http://repo.or.cz/w/smatch.git).
> regards,
> dan carpenter
what about this alternative?
it retains the dev_err by simply moving to the spi_device *spi
which comes from spi-subsystem and is initialized?

Regards,
	Chr
---
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index d5f181a..eef5329 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -600,7 +600,7 @@ static int __devinit p54spi_probe(struct spi_device *spi)
 
 	hw = p54_init_common(sizeof(*priv));
 	if (!hw) {
-		dev_err(&priv->spi->dev, "could not alloc ieee80211_hw");
+		dev_err(&spi->dev, "could not alloc ieee80211_hw");
 		return -ENOMEM;
 	}
 



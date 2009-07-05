Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46765 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZGEWrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 18:47:03 -0400
Received: by fxm18 with SMTP id 18so3543968fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jul 2009 15:47:05 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
Date: Mon, 6 Jul 2009 02:46:58 +0400
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200907040053.05654.chunkeey@web.de> <200907051600.55958.chunkeey@web.de> <200907052316.30207.jcmvbkbc@gmail.com>
In-Reply-To: <200907052316.30207.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907060246.59188.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > hmm, looks like someone tries to skb_push on a NULL skb. hmmmm,
> > can you please enable ksym, it's a bit hard to see the obvious bug here.

> [ 1612.708465] skb_over_panic: text:bf000544 len:88 put:88 head:c78f4000 data:c78f4020 tail:0xc78f4078 end:0xc78f4020 dev:<NULL>

I see here valid skb with size 0x20, where we try to put 88 more bytes.
That's because p54spi_probe calls __dev_alloc_skb before p54spi_request_firmware.

It's working with the following change:

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index ab5b9b8..ff73a64 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -651,11 +651,6 @@ static int __devinit p54spi_probe(struct spi_device *spi)
 	priv->common.stop = p54spi_op_stop;
 	priv->common.tx = p54spi_op_tx;
 
-	skb = __dev_alloc_skb(priv->common.rx_mtu, GFP_KERNEL);
-	if (!skb)
-		goto err_free_common;
-	skb_queue_tail(&priv->rx_pool, skb);
-
 	ret = p54spi_request_firmware(hw);
 	if (ret < 0)
 		goto err_free_common;
@@ -664,6 +659,11 @@ static int __devinit p54spi_probe(struct spi_device *spi)
 	if (ret)
 		goto err_free_common;
 
+	skb = __dev_alloc_skb(priv->common.rx_mtu, GFP_KERNEL);
+	if (!skb)
+		goto err_free_common;
+	skb_queue_tail(&priv->rx_pool, skb);
+
 	ret = p54_register_common(hw, &priv->spi->dev);
 	if (ret)
 		goto err_free_common;


Still cannot stress-test it: it hangs in IBSS mode (I suspect rate control)
and it cannot initialize mesh: firmware doesn't respond after beacon submission.

Does mesh work now with USB/PCI?

Thanks.
-- Max

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39491 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1KSW5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 17:57:00 -0500
Received: by bke11 with SMTP id 11so4925646bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 14:56:58 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [RFC] p54spi: don't DMA onto the stack
Date: Sat, 19 Nov 2011 23:56:54 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
References: <20111116235120.4c60c066@milhouse> <201111191859.17554.chunkeey@googlemail.com> <201111200215.35385.jcmvbkbc@gmail.com>
In-Reply-To: <201111200215.35385.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201111192356.54667.chunkeey@googlemail.com> (sfid-20111119_235708_464716_FE5E8211)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 19 November 2011 23:15:34 Max Filippov wrote:
> > On Thursday 17 November 2011 00:15:42 Michael Büsch wrote:
> > > On Thu, 17 Nov 2011 00:12:03 +0100
> > > Christian Lamparter <chunkeey@googlemail.com> wrote:
> > > > BTW: I always wondered if it would make sense to have a
> > > > cached rx skb ready in p54spi_rx(). This way we don't
> > > > have to do DMA onto the stack [which is really ugly and
> > > > possibly illegal] and might even get a better rx
> > > > performance. I could write the code but as you know I don't
> > > > have the hardware to test it.
> > > 
> > > I'll test it, if you can come up with a patch.
> > ---
> > [RFC] p54spi: don't DMA onto the stack
> > 
> > DMA transfers should not be done onto the kernel stack.
> 
> What about p54spi_read32, it does the same thing?
AFAIK no, p54spi_read32 and p54spi_write16/32 uses PIO.
Of course, I don't know 100% just the docs from johannes' says so :-D.

> I have tested this patch, it works, no measurable rx speed boost though
> (~6.1Mbit/sec in iperf as either server or client).
I guess that number comes from unicast plain udp testing, right. Do you
know if the performance can be improved by setting the mtu to 2274
[ifconfig wlanX mtu 2274] on both client and AP/server?

> > -	if (len <= READAHEAD_SZ) {
> > -		memcpy(skb_put(skb, len), rx_head + 1, len);
> > +	if (len <= READAHEAD) {
> > +		skb_put(skb, len);
> >  	} else {
> > -		memcpy(skb_put(skb, READAHEAD_SZ), rx_head + 1, READAHEAD_SZ);
> > +		skb_put(skb, READAHEAD);
> >  		p54spi_spi_read(priv, SPI_ADRS_DMA_DATA,
> > -				skb_put(skb, len - READAHEAD_SZ),
> > -				len - READAHEAD_SZ);
> > +				skb_put(skb, len - READAHEAD),
> > +				len - READAHEAD);
> >  	}
> 
> I have also tested this patch without this (READAHEAD_SZ) kludge.
> It appears to work now.
well, there's one more thing: what happens when there's just
a single read. .e.g.: 
---
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 2d5cf5b..bdbae3d 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -339,22 +339,56 @@ static void p54spi_int_ready(struct p54s_priv *priv)
 	}
 }
 
+static int p54spi_alloc_rx_skb(struct p54s_priv *priv)
+{
+	if (priv->rx_cache != NULL)
+		return 0;
+
+	/*
+	 * Add extra space for spi rx header and reserve some space since the
+	 * firmware may insert up to 4 padding bytes after the lmac header,
+	 * but it does not amend the size of SPI data transfer. Such packets
+	 * has correct data size in header, thus referencing past the end of
+	 * allocated skb. Reserve extra 4 bytes for this case
+	 */
+#define RX_EXTRA_SPACE (sizeof(__le16) + sizeof(struct p54_rx_data) + 4)
+
+	priv->rx_cache = dev_alloc_skb(priv->common.rx_mtu + RX_EXTRA_SPACE);
+	if (!priv->rx_cache)
+		return -ENOMEM;
+
+	/* reserve space for spi transfer size */
+	skb_reserve(priv->rx_cache, 2);
+	return 0;
+}
+
 static int p54spi_rx(struct p54s_priv *priv)
 {
 	struct sk_buff *skb;
+	__le16 *rx_head;
+	int err;
 	u16 len;
-	u16 rx_head[2];
-#define READAHEAD_SZ (sizeof(rx_head)-sizeof(u16))
+
+#define READAHEAD (sizeof(__le16))
 
 	if (p54spi_wakeup(priv) < 0)
 		return -EBUSY;
 
-	/* Read data size and first data word in one SPI transaction
+	err = p54spi_alloc_rx_skb(priv);
+	if (err)
+		return err;
+
+	/*
+	 * Read data size and first data word in one SPI transaction
 	 * This is workaround for firmware/DMA bug,
 	 * when first data word gets lost under high load.
 	 */
-	p54spi_spi_read(priv, SPI_ADRS_DMA_DATA, rx_head, sizeof(rx_head));
-	len = rx_head[0];
+	skb = priv->rx_cache;
+	rx_head = (__le16 *)(unsigned long)(priv->rx_cache->data -
+					    sizeof(__le16));
+	p54spi_spi_read(priv, SPI_ADRS_DMA_DATA, rx_head, RX_EXTRA_SPACE +
+			priv->common.rx_mtu);
+	len = le16_to_cpu(rx_head[0]);
 
 	if (len == 0) {
 		p54spi_sleep(priv);
@@ -362,36 +396,33 @@ static int p54spi_rx(struct p54s_priv *priv)
 		return 0;
 	}
 
-	/* Firmware may insert up to 4 padding bytes after the lmac header,
-	 * but it does not amend the size of SPI data transfer.
-	 * Such packets has correct data size in header, thus referencing
-	 * past the end of allocated skb. Reserve extra 4 bytes for this case */
-	skb = dev_alloc_skb(len + 4);
-	if (!skb) {
+	if (len >= (RX_EXTRA_SPACE + priv->common.rx_mtu - 4)) {
 		p54spi_sleep(priv);
-		dev_err(&priv->spi->dev, "could not alloc skb");
-		return -ENOMEM;
+		dev_err(&priv->spi->dev, "rx request larger than max rx mtu\n");
+		return 0;
 	}
 
-	if (len <= READAHEAD_SZ) {
-		memcpy(skb_put(skb, len), rx_head + 1, len);
-	} else {
-		memcpy(skb_put(skb, READAHEAD_SZ), rx_head + 1, READAHEAD_SZ);
-		p54spi_spi_read(priv, SPI_ADRS_DMA_DATA,
-				skb_put(skb, len - READAHEAD_SZ),
-				len - READAHEAD_SZ);
-	}
+	/*
+	 * Put additional bytes to compensate for the possible
+	 * alignment-caused truncation.
+	 */
+	skb_put(skb, len + 4);
 	p54spi_sleep(priv);
-	/* Put additional bytes to compensate for the possible
-	 * alignment-caused truncation */
-	skb_put(skb, 4);
 
-	if (p54_rx(priv->hw, skb) == 0)
-		dev_kfree_skb(skb);
+	if (p54_rx(priv->hw, skb) == 0) {
+		/* skb was not used up, can be recycled */
+		skb_reset_tail_pointer(skb);
+		skb_trim(skb, 0);
+	} else {
+		/* get next skb ready */
+		priv->rx_cache = NULL;
+		return p54spi_alloc_rx_skb(priv);
+	}
 
 	return 0;
 }
-
+#undef RX_EXTRA_SPACE
+#undef READAHEAD
 
 static irqreturn_t p54spi_interrupt(int irq, void *config)
 {
@@ -666,6 +697,8 @@ static int __devinit p54spi_probe(struct spi_device *spi)
 	if (ret)
 		goto err_free_common;
 
+	p54spi_alloc_rx_skb(priv);
+
 	ret = p54_register_common(hw, &priv->spi->dev);
 	if (ret)
 		goto err_free_common;
@@ -691,6 +724,7 @@ static int __devexit p54spi_remove(struct spi_device *spi)
 
 	mutex_destroy(&priv->mutex);
 
+	kfree_skb(priv->rx_cache);
 	p54_free_common(priv->hw);
 
 	return 0;

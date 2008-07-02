Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47923 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbYGBQzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 12:55:00 -0400
Message-ID: <486BB332.6000703@lwfinger.net> (sfid-20080702_185505_871837_D7351577)
Date: Wed, 02 Jul 2008 11:56:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Adrian Bunk <bunk@kernel.org>, dhowells@redhat.com,
	linville@tuxdriver.com, mb@bu3sch.de, stefano.brivio@polimi.it,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: + drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init.patch
 added to -mm tree
References: <200807020835.m628Zx2e007473@imap1.linux-foundation.org>
In-Reply-To: <200807020835.m628Zx2e007473@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akpm@linux-foundation.org wrote:
> The patch titled
>      drivers/net/wireless/b43legacy/dma.c: remove the switch in b43legacy_dma_init()
> has been added to the -mm tree.  Its filename is
>      drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init.patch
> 
> ------------------------------------------------------
> Subject: drivers/net/wireless/b43legacy/dma.c: remove the switch in b43legacy_dma_init()
> From: Adrian Bunk <bunk@stusta.de>
> 
> The gcc 3.4 fork used to compile the MN10300 port emits unwanted
> __ucmpdi2() calls for this switch on a 64bit value.
> 
> Fix it by transforming the switch to equivalent "if ... else if ..."
> statements.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Stefano Brivio <stefano.brivio@polimi.it>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/wireless/b43legacy/dma.c |   16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff -puN drivers/net/wireless/b43legacy/dma.c~drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init drivers/net/wireless/b43legacy/dma.c
> --- a/drivers/net/wireless/b43legacy/dma.c~drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init
> +++ a/drivers/net/wireless/b43legacy/dma.c
> @@ -1027,19 +1027,15 @@ int b43legacy_dma_init(struct b43legacy_
>  	enum b43legacy_dmatype type;
>  
>  	dmamask = supported_dma_mask(dev);
> -	switch (dmamask) {
> -	default:
> -		B43legacy_WARN_ON(1);
> -	case DMA_30BIT_MASK:
> +
> +	if (dmamask == DMA_30BIT_MASK)
>  		type = B43legacy_DMA_30BIT;
> -		break;
> -	case DMA_32BIT_MASK:
> +	else if (dmamask == DMA_32BIT_MASK)
>  		type = B43legacy_DMA_32BIT;
> -		break;
> -	case DMA_64BIT_MASK:
> +	else if (dmamask == DMA_64BIT_MASK)
>  		type = B43legacy_DMA_64BIT;
> -		break;
> -	}
> +	else
> +		B43legacy_WARN_ON(1);
>  
>  	err = ssb_dma_set_mask(dev->dev, dmamask);
>  	if (err) {
> _

Andrew,

When I received your E-mail, I wondered why there was not a similar
"fix" for b43. It was then I discovered how much b43 and b43legacy had
diverged while I wasn't looking. I have no objections to your patch;
however, I wonder if it might be better to fix b43legacy in the same
way that b43 was changed. I have prepared and tested such a fix (shown
below). The only problem with this is that the patch is much more
intrusive than Adrian's and there may be a problem getting it into
2.6.26 before it is released, but then I do not think that you intend to
send the -mm patch to 2.6.26.

What do you think is the best route to go?

Larry

=================================================

Index: linux-2.6/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/dma.c
+++ linux-2.6/drivers/net/wireless/b43legacy/dma.c
@@ -860,6 +860,18 @@ static u64 supported_dma_mask(struct b43
  	return DMA_30BIT_MASK;
  }

+static enum b43legacy_dmatype dma_mask_to_engine_type(u64 dmamask)
+{
+	if (dmamask == DMA_30BIT_MASK)
+		return B43legacy_DMA_30BIT;
+	if (dmamask == DMA_32BIT_MASK)
+		return B43legacy_DMA_32BIT;
+	if (dmamask == DMA_64BIT_MASK)
+		return B43legacy_DMA_64BIT;
+	B43legacy_WARN_ON(1);
+	return B43legacy_DMA_30BIT;
+}
+
  /* Main initialization function. */
  static
  struct b43legacy_dmaring *b43legacy_setup_dmaring(struct b43legacy_wldev *dev,
@@ -1019,6 +1031,43 @@ void b43legacy_dma_free(struct b43legacy
  	dma->tx_ring0 = NULL;
  }

+static int b43legacy_dma_set_mask(struct b43legacy_wldev *dev, u64 mask)
+{
+	u64 orig_mask = mask;
+	bool fallback = 0;
+	int err;
+
+	/* Try to set the DMA mask. If it fails, try falling back to a
+	 * lower mask, as we can always also support a lower one. */
+	while (1) {
+		err = ssb_dma_set_mask(dev->dev, mask);
+		if (!err)
+			break;
+		if (mask == DMA_64BIT_MASK) {
+			mask = DMA_32BIT_MASK;
+			fallback = 1;
+			continue;
+		}
+		if (mask == DMA_32BIT_MASK) {
+			mask = DMA_30BIT_MASK;
+			fallback = 1;
+			continue;
+		}
+		b43legacyerr(dev->wl, "The machine/kernel does not support "
+		       "the required %u-bit DMA mask\n",
+		       (unsigned int)dma_mask_to_engine_type(orig_mask));
+		return -EOPNOTSUPP;
+	}
+	if (fallback) {
+		b43legacyinfo(dev->wl, "DMA mask fallback from %u-bit to %u-"
+			"bit\n",
+			(unsigned int)dma_mask_to_engine_type(orig_mask),
+			(unsigned int)dma_mask_to_engine_type(mask));
+	}
+
+	return 0;
+}
+
  int b43legacy_dma_init(struct b43legacy_wldev *dev)
  {
  	struct b43legacy_dma *dma = &dev->dma;
@@ -1028,21 +1077,8 @@ int b43legacy_dma_init(struct b43legacy_
  	enum b43legacy_dmatype type;

  	dmamask = supported_dma_mask(dev);
-	switch (dmamask) {
-	default:
-		B43legacy_WARN_ON(1);
-	case DMA_30BIT_MASK:
-		type = B43legacy_DMA_30BIT;
-		break;
-	case DMA_32BIT_MASK:
-		type = B43legacy_DMA_32BIT;
-		break;
-	case DMA_64BIT_MASK:
-		type = B43legacy_DMA_64BIT;
-		break;
-	}
-
-	err = ssb_dma_set_mask(dev->dev, dmamask);
+	type = dma_mask_to_engine_type(dmamask);
+	err = b43legacy_dma_set_mask(dev, dmamask);
  	if (err) {
  #ifdef CONFIG_B43LEGACY_PIO
  		b43legacywarn(dev->wl, "DMA for this device not supported. "

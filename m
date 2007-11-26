Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44916
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXKZQT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:19:59 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V4] b43: Changes to enable BCM4311 rev 02 with wireless core revision 13
Date: Mon, 26 Nov 2007 17:18:24 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <474aed86.NapeoirOR+JdWZ7d%Larry.Finger@lwfinger.net>
In-Reply-To: <474aed86.NapeoirOR+JdWZ7d%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711261718.25240.mb@bu3sch.de> (sfid-20071126_162005_293509_7789226A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 November 2007 17:00:06 Larry Finger wrote:
>  static int alloc_ringmemory(struct b43_dmaring *ring)
>  {
>  	struct device *dev = ring->dev->dev->dev;
> +	gfp_t flags = GFP_KERNEL;
>  
> +	/* The specs call for 4K buffers for 30- and 32-bit DMA with 4K
> +	 * alignment and 8K buffers for 64-bit DMA with 8K alignment. Testing
> +	 * has shown that 4K is sufficient for the latter as long as the buffer
> +	 * does not cross an 8K boundary.
> +	 *
> +	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
> +	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
> +	 * which accounts for the GFP_DMA flag below.
> +	 */
> +	if (ring->dma64)
> +		flags = GFP_DMA;

???


-- 
Greetings Michael.

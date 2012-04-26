Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46067 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2DZNaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 09:30:18 -0400
Received: by iadi9 with SMTP id i9so1574624iad.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 06:30:17 -0700 (PDT)
Date: Thu, 26 Apr 2012 09:29:00 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 08/21] cw1200: wsm.*, implementation of device
 high-level interface.
Message-ID: <20120426132900.GA23011@localhost> (sfid-20120426_153329_859696_B3AC0CE7)
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
 <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
 <1330720003-15866-9-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330720003-15866-9-git-send-email-dmitry.tarnyagin@stericsson.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 02, 2012 at 09:26:30PM +0100, Dmitry Tarnyagin wrote:
> WSM is a message interface between the host and the device.
> The patch defines and implements WSM abstraction layer.

Hi!

I just started reading through this driver and had a few comments/
questions; apologies in advance if they've been changed in more
recent versions.

> +void wsm_lock_tx(struct cw1200_common *priv)
> +{
> +	wsm_cmd_lock(priv);
> +	if (atomic_add_return(1, &priv->tx_lock) == 1) {
> +		if (wsm_flush_tx(priv))
> +			wsm_printk(KERN_DEBUG "[WSM] TX is locked.\n");
> +	}
> +	wsm_cmd_unlock(priv);
> +}

Can you explain how tx_lock works and how it's different from existing
locking primitives?  As a newcomer I find it surprising that two different
callers could call wsm_lock_tx{_async}() and neither of them would wait,
but maybe that's just a naming thing.

> +void wsm_buf_init(struct wsm_buf *buf)
> +{
> +	BUG_ON(buf->begin);
> +	buf->begin = kmalloc(SDIO_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);

Does your platform really need GFP_DMA?  It's a no-op on many platforms
and on x86 it will restrict this to low 16 MB of physical memory.

> +	if (size & (SDIO_BLOCK_SIZE - 1)) {
> +		size &= SDIO_BLOCK_SIZE;
> +		size += SDIO_BLOCK_SIZE;
> +	}

This looks odd, should you use round_up(size, SDIO_BLOCK_SIZE) instead?
For example, if size = 2 * SDIO_BLOCK_SIZE + 1, it'll silently truncate
to SDIO_BLOCK_SIZE.  This code is in a couple of places.

-- 
Bob Copeland %% www.bobcopeland.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49731 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab1KSWPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 17:15:41 -0500
Received: by bke11 with SMTP id 11so4904539bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 14:15:39 -0800 (PST)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFC] p54spi: don't DMA onto the stack
Date: Sun, 20 Nov 2011 02:15:34 +0400
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
References: <20111116235120.4c60c066@milhouse> <20111117001542.68459372@milhouse> <201111191859.17554.chunkeey@googlemail.com>
In-Reply-To: <201111191859.17554.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201111200215.35385.jcmvbkbc@gmail.com> (sfid-20111119_231544_691500_8E1BB15C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thursday 17 November 2011 00:15:42 Michael Büsch wrote:
> > On Thu, 17 Nov 2011 00:12:03 +0100
> > Christian Lamparter <chunkeey@googlemail.com> wrote:
> > > BTW: I always wondered if it would make sense to have a
> > > cached rx skb ready in p54spi_rx(). This way we don't
> > > have to do DMA onto the stack [which is really ugly and
> > > possibly illegal] and might even get a better rx
> > > performance. I could write the code but as you know I don't
> > > have the hardware to test it.
> > 
> > I'll test it, if you can come up with a patch.
> ---
> [RFC] p54spi: don't DMA onto the stack
> 
> DMA transfers should not be done onto the kernel stack.

What about p54spi_read32, it does the same thing?

I have tested this patch, it works, no measurable rx speed boost though
(~6.1Mbit/sec in iperf as either server or client).

[...snip...]

> -	if (len <= READAHEAD_SZ) {
> -		memcpy(skb_put(skb, len), rx_head + 1, len);
> +	if (len <= READAHEAD) {
> +		skb_put(skb, len);
>  	} else {
> -		memcpy(skb_put(skb, READAHEAD_SZ), rx_head + 1, READAHEAD_SZ);
> +		skb_put(skb, READAHEAD);
>  		p54spi_spi_read(priv, SPI_ADRS_DMA_DATA,
> -				skb_put(skb, len - READAHEAD_SZ),
> -				len - READAHEAD_SZ);
> +				skb_put(skb, len - READAHEAD),
> +				len - READAHEAD);
>  	}

I have also tested this patch without this (READAHEAD_SZ) kludge.
It appears to work now.

Thanks.
-- Max

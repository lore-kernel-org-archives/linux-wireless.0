Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39415 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab1KTNYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 08:24:47 -0500
Received: by bke11 with SMTP id 11so5386279bke.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 05:24:45 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [RFC] p54spi: don't DMA onto the stack
Date: Sun, 20 Nov 2011 14:24:41 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
References: <20111116235120.4c60c066@milhouse> <201111192356.54667.chunkeey@googlemail.com> <201111200448.55662.jcmvbkbc@gmail.com>
In-Reply-To: <201111200448.55662.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201111201424.41956.chunkeey@googlemail.com> (sfid-20111120_142502_000605_D2128AFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 20 November 2011 01:48:55 Max Filippov wrote:
> > > > [RFC] p54spi: don't DMA onto the stack
> > > > 
> > > > DMA transfers should not be done onto the kernel stack.
> > > 
> > > What about p54spi_read32, it does the same thing?
> > AFAIK no, p54spi_read32 and p54spi_write16/32 uses PIO.
> 
> Initial p54spi_rx transfer with the kludge in place is 4 bytes long as well.
> 
> > Of course, I don't know 100% just the docs from johannes' says so :-D.
> 
> That's right, drivers/spi/omap2_mcspi.c says that:
> 
> /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
>  * cache operations; better heuristics consider wordsize and bitrate.
>  */                 
> #define DMA_MIN_BYTES           160

so omap2_mcspi.c might paper of a bug right here and nobody never noticed
it. Of course, if we had bothered to read Documentation/spi/spi-summary in
the first place then we might not need a paper bag now...

qoute: "
  - I/O buffers use the usual Linux rules, and must be DMA-safe.
    You'd normally allocate them from the heap or free page pool.
    Don't use the stack, or anything that's declared "static".

  - The spi_message and spi_transfer metadata used to glue those
    I/O buffers into a group of protocol transactions.  These can
    be allocated anywhere it's convenient, including as part of
    other allocate-once driver data structures.  Zero-init these.
"

> > > > -	if (len <= READAHEAD_SZ) {
> > > > -		memcpy(skb_put(skb, len), rx_head + 1, len);
> > > > +	if (len <= READAHEAD) {
> > > > +		skb_put(skb, len);
> > > >  	} else {
> > > > -		memcpy(skb_put(skb, READAHEAD_SZ), rx_head + 1, READAHEAD_SZ);
> > > > +		skb_put(skb, READAHEAD);
> > > >  		p54spi_spi_read(priv, SPI_ADRS_DMA_DATA,
> > > > -				skb_put(skb, len - READAHEAD_SZ),
> > > > -				len - READAHEAD_SZ);
> > > > +				skb_put(skb, len - READAHEAD),
> > > > +				len - READAHEAD);
> > > >  	}
> > > 
> > > I have also tested this patch without this (READAHEAD_SZ) kludge.
> > > It appears to work now.
> > well, there's one more thing: what happens when there's just
> > a single read. .e.g.: 
> 
> [...snip...]
> 
> Highly unstable link and lots of "rx request of zero bytes" in the dmesg log.
Ok, that's a dead end then. BTW, what's your opinion on the subject. Should
we alloc a bufffer on demand or have one which is "big enough" always
around?

Regards,
	Christian

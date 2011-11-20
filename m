Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41410 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab1KTAtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 19:49:01 -0500
Received: by bke11 with SMTP id 11so4983596bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 16:48:59 -0800 (PST)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFC] p54spi: don't DMA onto the stack
Date: Sun, 20 Nov 2011 04:48:55 +0400
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
References: <20111116235120.4c60c066@milhouse> <201111200215.35385.jcmvbkbc@gmail.com> <201111192356.54667.chunkeey@googlemail.com>
In-Reply-To: <201111192356.54667.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201111200448.55662.jcmvbkbc@gmail.com> (sfid-20111120_014906_853717_AACBD670)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Saturday 19 November 2011 23:15:34 Max Filippov wrote:
> > > On Thursday 17 November 2011 00:15:42 Michael Büsch wrote:
> > > > On Thu, 17 Nov 2011 00:12:03 +0100
> > > > Christian Lamparter <chunkeey@googlemail.com> wrote:
> > > > > BTW: I always wondered if it would make sense to have a
> > > > > cached rx skb ready in p54spi_rx(). This way we don't
> > > > > have to do DMA onto the stack [which is really ugly and
> > > > > possibly illegal] and might even get a better rx
> > > > > performance. I could write the code but as you know I don't
> > > > > have the hardware to test it.
> > > > 
> > > > I'll test it, if you can come up with a patch.
> > > ---
> > > [RFC] p54spi: don't DMA onto the stack
> > > 
> > > DMA transfers should not be done onto the kernel stack.
> > 
> > What about p54spi_read32, it does the same thing?
> AFAIK no, p54spi_read32 and p54spi_write16/32 uses PIO.

Initial p54spi_rx transfer with the kludge in place is 4 bytes long as well.

> Of course, I don't know 100% just the docs from johannes' says so :-D.

That's right, drivers/spi/omap2_mcspi.c says that:

/* use PIO for small transfers, avoiding DMA setup/teardown overhead and
 * cache operations; better heuristics consider wordsize and bitrate.
 */                 
#define DMA_MIN_BYTES           160

> > I have tested this patch, it works, no measurable rx speed boost though
> > (~6.1Mbit/sec in iperf as either server or client).
> I guess that number comes from unicast plain udp testing, right. Do you
> know if the performance can be improved by setting the mtu to 2274
> [ifconfig wlanX mtu 2274] on both client and AP/server?

~6.7Mbit/sec
 
> > > -	if (len <= READAHEAD_SZ) {
> > > -		memcpy(skb_put(skb, len), rx_head + 1, len);
> > > +	if (len <= READAHEAD) {
> > > +		skb_put(skb, len);
> > >  	} else {
> > > -		memcpy(skb_put(skb, READAHEAD_SZ), rx_head + 1, READAHEAD_SZ);
> > > +		skb_put(skb, READAHEAD);
> > >  		p54spi_spi_read(priv, SPI_ADRS_DMA_DATA,
> > > -				skb_put(skb, len - READAHEAD_SZ),
> > > -				len - READAHEAD_SZ);
> > > +				skb_put(skb, len - READAHEAD),
> > > +				len - READAHEAD);
> > >  	}
> > 
> > I have also tested this patch without this (READAHEAD_SZ) kludge.
> > It appears to work now.
> well, there's one more thing: what happens when there's just
> a single read. .e.g.: 

[...snip...]

Highly unstable link and lots of "rx request of zero bytes" in the dmesg log.

Thanks.
-- Max

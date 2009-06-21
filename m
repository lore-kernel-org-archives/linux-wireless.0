Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:61398 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZFUKS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 06:18:26 -0400
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>
Subject: Re: [PATCH 1/6] crc-itu-t: add bit-reversed calculation
Date: Sun, 21 Jun 2009 12:18:25 +0200
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net, Stephen Rothwell <sfr@canb.auug.org.au>,
	Sergey Lapin <slapin@ossfans.org>,
	Darren Salt <linux@youmustbejoking.demon.co.uk>
References: <1244021629-18409-1-git-send-email-dbaryshkov@gmail.com> <1244033004.21215.4.camel@deadeye> <20090621082921.GA12749@doriath.ww600.siemens.net>
In-Reply-To: <20090621082921.GA12749@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200906211218.25709.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[non-HTML reply, sorry about that]

On Sunday 21 June 2009, Dmitry Eremin-Solenikov wrote:
> Hi,
> 
> 
> On Wed, Jun 03, 2009 at 01:43:24PM +0100, Ben Hutchings wrote:
> > On Wed, 2009-06-03 at 13:33 +0400, Dmitry Eremin-Solenikov wrote:
> > [...] 
> > > +/**
> > > + * crc_itu_t_bitreversed - Compute the CRC-ITU-T for the data buffer;
> > > + * the buffer content is assumed to be bit-reversed
> > [...]
> > 
> > This short description spills onto two lines which is invalid and breaks
> > the generation of docs.  Sorry to point this out after recommending the
> > patch to you.
> > 
> > I've changed the description to "crc_itu_t_bitreversed - Compute the
> > CRC-ITU-T for a bit-reversed data buffer" all on one line.
> 
> Just another not w.r.t. this patch: one should add 'select BITREVERSE'
> to this Kconfig entry, as it depends on bitreversing stuff.

What also might be interesting,  have you checked the crc-ccitt algorithm?
I had come across a crc_itu_t with bitreverse implementation in the past as
well, and I could simplify the implementation by using crc-ccit and only call
bitreverse on the last output. So something like:

u16 crc = crc_ccitt(~0, data, len);
u16 crc_itu_t = swab16(crc);

Instead of bitreverse for every step, only a single  byteswap was needed.
You need to check if this indeed works for your driver, but this would
reduce the number of times bitrev is called, and also prevents the BITREV
dependency for the crc implementation.

Ivo

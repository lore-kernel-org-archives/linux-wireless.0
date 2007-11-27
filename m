Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756862AbXK0Sk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 13:40:57 -0500
Date: Tue, 27 Nov 2007 10:39:40 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
Message-ID: <20071127103940.314c7844@freepuppy.rosehill> (sfid-20071127_184103_402085_0CB0A184)
In-Reply-To: <474C50D7.5010901@zytor.com>
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au>
	<1195893216.4149.186.camel@johannes.berg>
	<20071124133200.GA27531@gondor.apana.org.au>
	<1195912176.4149.194.camel@johannes.berg>
	<20071124141319.GA27819@gondor.apana.org.au>
	<4748855C.5090103@linux-foundation.org>
	<474C50D7.5010901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Nov 2007 09:16:07 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Stephen Hemminger wrote:
> > Herbert Xu wrote:
> >> On Sat, Nov 24, 2007 at 02:49:36PM +0100, Johannes Berg wrote:
> >>  
> >>> Right. I just didn't think that would be a valid value for an
> >>> architecture to set.
> >>>     
> >>
> >> OK.  Let me clarify this a bit more.  We require at least one
> >> of the following rules to be met:
> >>
> >> * the IPv4/IPv6 header is aligned by 8 bytes on reception;
> >> * or the platform provides unaligned exception handlers.
> >>
> >> So if your platform violates both rules then it won't work with
> >> the IP stack, simple as that.  Fortunately I don't think such a
> >> platform exists currently on Linux.
> >>
> >> Cheers,
> >>   
> > 
> > Then what about hardware that can't dma ethernet to non-aligned address.
> > Sky2 hardware breaks if DMA is not 8 byte aligned.  IMHO the IP stack 
> > should handle any alignment, and do the appropriate memove if the CPU requires 
> > alignment.
> 
> I wrote a patch for the IP stack to realign packets if necessary at one 
> point.  I should dredge it up again and submit it for collective flamage.
> 
> 	-hpa
> 

Is there any standard kernel config define for "this platform can't do
unaligned accesses"?

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

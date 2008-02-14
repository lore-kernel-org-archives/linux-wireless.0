Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:49079 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYBNEVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 23:21:16 -0500
Date: Wed, 13 Feb 2008 23:20:07 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: ath5k: reset for 5424-based card
Message-ID: <20080214042007.GA24186@hash.localnet> (sfid-20080214_042120_277883_2C8CA48F)
References: <20080201040358.GA13428@hash.localnet> <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com> <20080201225345.GA15922@hash.localnet> <40f31dec0802011748i5a1b8aaftf42f7798762cca3d@mail.gmail.com> <20080203014559.GA20177@hash.localnet> <40f31dec0802050113w6f332a00ja7c9ad849f80e2e0@mail.gmail.com> <20080210162155.GA10894@hash.localnet> <40f31dec0802101105o61442683ia6b56c264a9af556@mail.gmail.com> <20080211150012.GA15956@hash.localnet> <40f31dec0802112318q281ef27eg2ec0c1df441ed097@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802112318q281ef27eg2ec0c1df441ed097@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 12, 2008 at 09:18:05AM +0200, Nick Kossifidis wrote:
> > Not sure, I'll try them again.  Are the other traces for other cards
> > online somewhere?
> 
> Nope i have them all gathered on my laptop, you 'll sure find some
> posted on ath5k-devel list. I'll send you a b-only trace from one of
> my cards (a 5413) to check it out ;-)
> 
> We are working on a way to have all dumps uploaded somewhere...

Okay that would be good.  I was basically searching for differences by
hooking ath_hw_reg_write with a printk, sorting that, and diffing it
with a sorted file of "reg_address:value" extracted from the traces.
Would be useful to run the same scripts over other cards' dumps...

> 
> > -                               AR5K_DMASIZE_512B);
> > +                               AR5K_DMASIZE_128B);
> >         }
> 
> Have you tried 256 ? Also have you tried only setting lower dma size for rx ?

I did a few times, but not enough to definitively say which works and 
which doesn't.  I'll try to get it repeatedly starting up correctly when
I get some free time, and from there I should be able to figure out 
what's actually needed and what is noise.

> > +               ath5k_hw_reg_write(ah, 0x001e1e1e, AR5K_TXPC);
> 
> Remove TXPC and see what happens...

Sure, I'll give that a go as well.

-- 
Bob Copeland %% www.bobcopeland.com 


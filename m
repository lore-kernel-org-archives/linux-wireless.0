Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:34103 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbYBCBrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 20:47:09 -0500
Date: Sat, 2 Feb 2008 20:45:59 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: ath5k: reset for 5424-based card
Message-ID: <20080203014559.GA20177@hash.localnet> (sfid-20080203_014714_041647_E783DCEC)
References: <20080131155901.GA7997@hash.localnet> <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com> <20080201040358.GA13428@hash.localnet> <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com> <20080201225345.GA15922@hash.localnet> <40f31dec0802011748i5a1b8aaftf42f7798762cca3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802011748i5a1b8aaftf42f7798762cca3d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 02, 2008 at 03:48:34AM +0200, Nick Kossifidis wrote:
> > Yeah I have an AP but it's broadcom based.  I'll try to do the traces this
> > weekend.
> >
> 
> Thanx ;-)

Ok, so I did -b and -g traces.  That branch is a little out of date, so 
I wound up downgrading to 2.6.22.

I don't have an a-capable AP, so how might I get a/turboa/turbog traces?
Do I use wlanconfig from the madwifi docs like so:

   $ iwpriv ath0 mode 1
   $ wlanconfig ath0 create wlandev wifi0 wlanmode ap

What mode # is used for turbo a/g?

I put the tarballs at http://bobcopeland.com/ath5k/

> Great info ! Your card sends the RXORN interrupt (Rx overrun), at
> least we know what the problem is ;-)
> 
> How about your signal strength ?

Looks fine, I think:
    Quality=89/100  Signal level=-39 dBm  Noise level=-96 dBm

> That's ok since we haven't added initvals/rfbuffer tables for your
> card so phy isn't initialized propertly (this is the first problem we
> should fix so we can be sure that rx overrun is not phy-related).

OK, well I guess that info is in the tarballs.  I poked around in the
code, and it looks like my tables are similar to 5413 with maybe a 
couple of extra registers.  But I'll await your analysis. :)

> 1472         if (ah->ah_version != AR5K_AR5210) {
> 1473                 /*HIU = Host Interface Unit (PCI etc)*/
> 1474                 if (unlikely(data & (AR5K_ISR_HIUERR)))
> 1475                         *interrupt_mask |= AR5K_INT_FATAL;
> 
> 
> Change AR5K_ISR_HIUERR with AR5K_ISR_RXORN

It does get rid of the message, but other than not seeing the printk
any more, it doesn't seem to help things much. 
 
Good luck on the exams! 

-- 
Bob Copeland %% www.bobcopeland.com 


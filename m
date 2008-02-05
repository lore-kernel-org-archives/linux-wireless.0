Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:59232 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYBEJNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 04:13:41 -0500
Received: by an-out-0708.google.com with SMTP id d31so600971and.103
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2008 01:13:36 -0800 (PST)
Message-ID: <40f31dec0802050113w6f332a00ja7c9ad849f80e2e0@mail.gmail.com> (sfid-20080205_091349_608791_5A60907B)
Date: Tue, 5 Feb 2008 11:13:35 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: ath5k: reset for 5424-based card
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080203014559.GA20177@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080131155901.GA7997@hash.localnet>
	 <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com>
	 <20080201040358.GA13428@hash.localnet>
	 <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com>
	 <20080201225345.GA15922@hash.localnet>
	 <40f31dec0802011748i5a1b8aaftf42f7798762cca3d@mail.gmail.com>
	 <20080203014559.GA20177@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Ok, so I did -b and -g traces.  That branch is a little out of date, so
> I wound up downgrading to 2.6.22.
>
> I don't have an a-capable AP, so how might I get a/turboa/turbog traces?
> Do I use wlanconfig from the madwifi docs like so:
>
>    $ iwpriv ath0 mode 1
>    $ wlanconfig ath0 create wlandev wifi0 wlanmode ap
>
> What mode # is used for turbo a/g?
>

turbog doesn't work, turboa is 4 i think, don't worry about turbo
modes, just try to get a regdump for a and it'll be fine (check out
initvals to be sure if you like that you are on a mode) ;-)

> I put the tarballs at http://bobcopeland.com/ath5k/
>

Great, thanx a lot ;-)

> > Great info ! Your card sends the RXORN interrupt (Rx overrun), at
> > least we know what the problem is ;-)
> >
> > How about your signal strength ?
>
> Looks fine, I think:
>     Quality=89/100  Signal level=-39 dBm  Noise level=-96 dBm
>

It's fine, that's cool it seems phy is ok (and hopefully is the same
with 5413 as i thought), it must be some mac settings related to pci-e
that result rx overrun, i've spotted some registers but i'll need to
spend some time on it and right now that's not possible ;-(

> > That's ok since we haven't added initvals/rfbuffer tables for your
> > card so phy isn't initialized propertly (this is the first problem we
> > should fix so we can be sure that rx overrun is not phy-related).
>
> OK, well I guess that info is in the tarballs.  I poked around in the
> code, and it looks like my tables are similar to 5413 with maybe a
> couple of extra registers.  But I'll await your analysis. :)
>

Might be some other part of reset/attach that we miss, i'll look on it asap ;-)

> > 1472         if (ah->ah_version != AR5K_AR5210) {
> > 1473                 /*HIU = Host Interface Unit (PCI etc)*/
> > 1474                 if (unlikely(data & (AR5K_ISR_HIUERR)))
> > 1475                         *interrupt_mask |= AR5K_INT_FATAL;
> >
> >
> > Change AR5K_ISR_HIUERR with AR5K_ISR_RXORN
>
> It does get rid of the message, but other than not seeing the printk
> any more, it doesn't seem to help things much.
>
> Good luck on the exams!
>

Thanx a lot and thanx for the traces ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

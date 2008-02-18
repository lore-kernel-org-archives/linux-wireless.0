Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:40594 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYBSAAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 19:00:55 -0500
Date: Mon, 18 Feb 2008 18:59:49 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: ath5k: reset for 5424-based card
Message-ID: <20080218235949.GA4305@hash.localnet> (sfid-20080219_000059_939165_496EA436)
References: <20080201040358.GA13428@hash.localnet> <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com> <20080201225345.GA15922@hash.localnet> <40f31dec0802011748i5a1b8aaftf42f7798762cca3d@mail.gmail.com> <20080203014559.GA20177@hash.localnet> <40f31dec0802050113w6f332a00ja7c9ad849f80e2e0@mail.gmail.com> <20080210162155.GA10894@hash.localnet> <40f31dec0802101105o61442683ia6b56c264a9af556@mail.gmail.com> <20080211150012.GA15956@hash.localnet> <40f31dec0802112318q281ef27eg2ec0c1df441ed097@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802112318q281ef27eg2ec0c1df441ed097@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I spent a bunch of reboots on trying to narrow down what needs to stay
and what can go.  Driver is still a little flaky for this card; I'd say
about one third of the time I do an insmod the card gets hung and I need
to reboot.  That makes it harder to rule certain changes in/out.

Also, the calibration stuff will hang more than half the time if we
reset everything but the CTL_PCI.  I've gone back to just resetting _PCU 
and _BASEBAND for now.  Maybe this wants a card-specific flag, or like
Jiri's patch just skip the second reset?

> Have you tried 256 ? Also have you tried only setting lower dma size for rx ?

512 for tx definitely did not work.  Will try 256 and let you know.

> > +       if (ah->ah_mac_srev >= AR5K_SREV_VER_AR2424) {
> > +               ath5k_hw_reg_write(ah, 0x000100aa, 0x8118);
> > +               ath5k_hw_reg_write(ah, 0x00003210, 0x811c);
> > +               ath5k_hw_reg_write(ah, 0x00000052, 0x8108);
> > +               ath5k_hw_reg_write(ah, 0x001e1e1e, AR5K_TXPC);
> 
> Remove TXPC and see what happens...

Yep TXPC can absolutely go.  0x8118 can probably go away too.  Still unsure 
about 811c/8108.

> > +               ath5k_hw_reg_write(ah, 0x00000004, 0x8120);

It never worked without this one.

-- 
Bob Copeland %% www.bobcopeland.com 


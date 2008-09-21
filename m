Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43477 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYIUAVW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 20:21:22 -0400
Subject: Re: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for
	Motorola 7010 variant of BCM4306
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Buesch <mb@bu3sch.de>, bbullins@triad.rr.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1221945075.3023.14.camel@johannes.berg>
References: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net>
	 <200809201744.55571.mb@bu3sch.de> <1221943895.3023.1.camel@johannes.berg>
	 <43e72e890809201359kb65f3d3qb618129ae6b528f4@mail.gmail.com>
	 <1221944575.3023.10.camel@johannes.berg>
	 <43e72e890809201405u63f57680u63ce0329c8cd31a2@mail.gmail.com>
	 (sfid-20080920_230522_937343_EF72BDF9)  <1221945075.3023.14.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 20 Sep 2008 17:19:11 -0700
Message-Id: <1221956351.15866.1.camel@localhost.localdomain> (sfid-20080921_022127_596403_D90B994F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-09-20 at 23:11 +0200, Johannes Berg wrote:
> On Sat, 2008-09-20 at 14:05 -0700, Luis R. Rodriguez wrote:
> 
> > >> > Does anyone actually make laptops that use these bluetooth coexistence
> > >> > pins? All CSR bluetooth chips do it automatically I'm told, maybe we
> > >> > should just kill them completely.
> > >>
> > >> Regardless of the wireless card? Or just for bcm?
> > >
> > > Well just for b43(legacy), but out of curiosity, does any BT chip use
> > > these pins anyway? Well I guess _somebody_ has to buy BCMs BT chips,
> > > but ...
> > 
> > BCM BT chips? I thought you said CSR?
> 
> Well the thing is, BCM wifi chips have these IO pins that tell the BT
> chip what the wifi chip is doing. But CSR chips for instance don't care,
> they just check what the wifi chip is doing on the antenna. So those
> don't use those IO pins.

Marvell SD 8686 have these pins too; I have at least one sample of such
a setup.  Not that I have had time yet to implement it...  but this sort
of thing exists of course.

Dan

> Hence, I'm wondering if there's any use in the IO pins at all. But they
> must have added them for a reason, presumably because their own BT chips
> can use those inputs...
> 
> Anyway, mostly just idly wondering, since most of the time it works fine
> and the EEPROM is actually done right I guess we should keep them on.
> 
> johannes


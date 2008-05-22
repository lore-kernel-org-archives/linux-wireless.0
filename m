Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:41571 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbYEVX2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 19:28:25 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K1A007PGMIYLEI1@mta5.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Thu, 22 May 2008 19:28:11 -0400 (EDT)
Date: Thu, 22 May 2008 19:28:10 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -	2.6.26-rc1
 kernel
In-reply-to: <1ba2fa240805221550p774708f9h7aab016a24202cff@mail.gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
Message-id: <1211498890.4595.22.camel@X61.NetworkingUnlimited.com> (sfid-20080523_012829_351055_092D5D59)
MIME-version: 1.0
Content-type: text/plain
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
 <1210617467.3792.4.camel@X61.DFGI.com>
 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
 <1211495615.4595.14.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805221550p774708f9h7aab016a24202cff@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > Applied patch to today's
> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> > and I can confirm that wpa_supplicant v0.6.3 again works on the A band.
> >
> > FWIW, however, I still have some issues:
> >
> > 1 - Roaming from 3com to NetGear takes about 5 minutes before iwlist
> > scan sees the A/N channel on the NetGear AP. Roaming from NetGear to
> > 3com, however, the 3com AP is seen on the first scan after losing
> > contact.
> 
> What channel is NG?, what is the beacon period.

Primary is 36, secondary is 40. (3com is 48). Beacon period is not a
settable parameter on the Netgear and is not documented (3com is set to
default 100ms).

> We'll soon release a new uCode that should speed up a bit scanning on A band.

That would be nice, we need several orders of magnitude improvement
here...

> > 2 - The NetGear is allegedly 11n, but shows up as standard A (or G) in
> > iwconfig et al. Highest data rate listed by iwlist is 54 on A, 48 on G.
> 
> wext doesn't report 11n rates and probably never will, it doesn't mean
> there is no 11n connection.

When I have nothing better to do I'll have to try some performance
testing :-) 

> Currently I don't have some non crypto interface looking into it.
> 
> > 3 - Booting Windows, the 4965 does see the NetGear as 802.11n, so I
> > can't blame it on the hardware...
> >
> No you cant :)
> 
> > 4 - I won't guarantee it is not a configuration issue on my part...
> > attached is the ".config" file used to compile the kernel.
> >
> Looks good.
> 
> Tomas

Thanks, I appreciate all your good work and support.

Vince

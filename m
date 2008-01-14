Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:40941 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbYANDqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 22:46:10 -0500
Received: by an-out-0708.google.com with SMTP id d31so411155and.103
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 19:46:09 -0800 (PST)
Message-ID: <40f31dec0801131946r66e761age0e6e89c81a91e3f@mail.gmail.com> (sfid-20080114_034614_767791_50A9474C)
Date: Mon, 14 Jan 2008 05:46:08 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: Antenna software diversity
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801140018.43316.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200801140004.21251.IvDoorn@gmail.com>
	 <1200266014.5887.33.camel@johannes.berg>
	 <200801140018.43316.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/14, Ivo van Doorn <ivdoorn@gmail.com>:
> Hi,
>
> > > However I would like to know if this is something should remain inside
> > > the driver, or if it should be moved into mac80211. Possibly integrated
> > > into the rate selection module, or otherwise as a seperate module which
> > > could allow the user to select a prefered antenna selection method similar
> > > as to how he can select the prefered rate algorithm.
> >
> > I guess it would be useful for other drivers inside mac80211. Not sure
> > whether it should be in the rate control algorithm or not.
>
> My personal preference would be making it a seperate module.
>
> > If it is in the rate control algorithm it could keep track of antenna
> > per-station to optimise the link to the station (obviously the station
> > still has to be in range for both antennae when it sends a frame, but
> > one could in theory achieve better data rates to the station with the
> > better antenna). On the other hand, I guess nobody would want to
> > implement such a thing anyway.
> >
> > I think a basic implementation within mac80211 would be sufficient if
> > any other drivers need it.
>
> Well at least rt2x00 need it, I searched a bit through the other drivers
> and couldn't find software diversity related code. So either it is not needed
> for them, or they didn't implement it (yet).
>

In ath5k we support hw diversity but we can also force rx and tx
antenna through software (if we disable hw diversity -well it needs
some more work but it can be done, currently hw diversity is on by
default), it would be nice if someone could set the tx/rx antenna
through mac80211 (we wont have to create a driver-specific control for
that). Also in Madwifi we have software diversity (when hw diversity
is off or not supported) because some cards have misplaced stickers
etc and users tend to plug in the antenna on the non-default port
(aux) + some other cards even have bad antenna info on their eeprom,
so we check from what antenna we received more packets and we switch
to that (making it the default antenna). Anything that provides such
functionality would be nice.

In any case it would be great if there was an antenna control module
or something like that, drivers can set a capability bit (eg. supports
hw diversity, supports sw diversity, supports manual antenna setting)
and users will have a way to enable/disable hw/sw diversity or
manually set tx and rx antennas.

> > > The ANTENNA_SEL_DIVERSITY would in this case be hardware diversity unless
> > > the driver has indicated that software diversity is in action, through a flag in
> > > ieee80211_hw.
> >
> > Of course, with 11n all that is moot. Or does 11n hw use diversity for
> > legacy frames?
>
> No idea, I still have to check how rt2800pci and rt2800usb handle antenna configuration.
>

I'm not sure but it seems for 5416/5418 chips we still have diversity
controls (when i call HAL functions to enable/disable hw diversity
they still set the related registers), also there is still a field in
tx descriptor about tx antenna and the default rx antenna  register.
We don't have .n support yet in Madwifi so these are only used for
legacy operation. I can't test this further because i don't want to
open my brand new macbook yet and start pluging/unpluging antennas.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

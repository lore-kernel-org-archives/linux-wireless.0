Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:30567 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbYAMXSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 18:18:51 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2032945fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 15:18:50 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Antenna software diversity
Date: Mon, 14 Jan 2008 00:18:43 +0100
Cc: linux-wireless@vger.kernel.org
References: <200801140004.21251.IvDoorn@gmail.com> <1200266014.5887.33.camel@johannes.berg>
In-Reply-To: <1200266014.5887.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801140018.43316.IvDoorn@gmail.com> (sfid-20080113_231900_142911_A22D6B67)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > However I would like to know if this is something should remain inside
> > the driver, or if it should be moved into mac80211. Possibly integrated
> > into the rate selection module, or otherwise as a seperate module which
> > could allow the user to select a prefered antenna selection method similar
> > as to how he can select the prefered rate algorithm.
> 
> I guess it would be useful for other drivers inside mac80211. Not sure
> whether it should be in the rate control algorithm or not.

My personal preference would be making it a seperate module.

> If it is in the rate control algorithm it could keep track of antenna
> per-station to optimise the link to the station (obviously the station
> still has to be in range for both antennae when it sends a frame, but
> one could in theory achieve better data rates to the station with the
> better antenna). On the other hand, I guess nobody would want to
> implement such a thing anyway.
> 
> I think a basic implementation within mac80211 would be sufficient if
> any other drivers need it.

Well at least rt2x00 need it, I searched a bit through the other drivers
and couldn't find software diversity related code. So either it is not needed
for them, or they didn't implement it (yet).

> > In mac80211 this would mean that the antenna_sel should probably become
> > an enum looking like this:
> > 
> > enum antenna_sel {
> > 	ANTENNA_SEL_DEFAULT,
> > 	ANTENNA_SEL_A,
> > 	ANTENNA_SEL_B,
> > 	ANTENNA_SEL_DIVERSITY,
> > };
> > 
> > I am not really a fan of the ANTENNA_SEL_DEFAULT, but this is already present
> > in the current mac80211 implementation. So to remove that, we could use some
> > method for the driver to let the default antenna known to mac80211, probably
> > through an extra field in ieee80211_hw perhaps.
> 
> Sounds like a good plan, that way we could maybe even report what
> antenna is used to userland.

Exactly :)

> > The ANTENNA_SEL_DIVERSITY would in this case be hardware diversity unless
> > the driver has indicated that software diversity is in action, through a flag in
> > ieee80211_hw.
> 
> Of course, with 11n all that is moot. Or does 11n hw use diversity for
> legacy frames?

No idea, I still have to check how rt2800pci and rt2800usb handle antenna configuration.

Ivo

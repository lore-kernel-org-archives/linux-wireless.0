Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58169 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab1CAN0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 08:26:19 -0500
Received: by fxm17 with SMTP id 17so4786251fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 05:26:17 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 0/9 v2] DFS/radar state/userspace handling
Date: Tue, 1 Mar 2011 14:26:01 +0100
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	nbd@openwrt.org, dubowoj@neratec.com, zefir.kurtisi@neratec.com,
	simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de> <201103011407.13171.bernhard.schmidt@saxnet.de> <1298985321.6015.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1298985321.6015.18.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201103011426.01753.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, March 01, 2011 14:15:21 Johannes Berg wrote:
> On Tue, 2011-03-01 at 14:07 +0100, Bernhard Schmidt wrote:
> 
> > Sorry about that.. it should have read:
> > "..that states are *now* global and no per wiphy.."
> > 
> > What I mean with that is that the interference flag/reporting, as
> > well as the NOL is shared between all wiphys contrary to the previous
> > version.
> 
> Oh, ok.
> 
> > > Finally, I think your code split is a little hard to understand. Is
> > > there really any point in adding the code bit by bit into both cfg80211
> > > and mac80211 at the same time? I'd rather see a few patches to make
> > > cfg80211 complete and then implement it all in mac80211.
> > 
> > I tried to group them by functionality and not by subsystem. But if
> > you prefer that I can make a large blob for cfg80211.
> 
> No, splitting them up seems alright, I just wouldn't split up the
> mac80211 bits across. You'll also find that when it comes to advertising
> capabilities, you need mac80211 to advertise them to cfg80211, and then
> you only want to advertise it once all functionality is in place.

I see, so, basically, given there is an alternative for [PATCH 1/9]
(get_channel) the only thing touching mac80211 is [PATCH 3/9], so, am
I doing the right thing?

> Now, for applying it might later make sense to just have a single patch
> adding it, but it doesn't really matter as long as the code isn't really
> used anyway since no driver advertises the capability.
> 
> > > Which brings me to another point -- there's no way to detect from
> > > userspace whether or not this is all available.
> > 
> > True, the only thing available right now is checking the error code
> > for CAC_START. I'll fix that.
> 
> One thing to keep in mind: I don't typically trust drivers, that is if
> they don't advertise something cfg80211 won't allow it even if it might
> still succeed. For example, if the driver doesn't advertise IBSS, but
> would still permit adding IBSS, cfg80211 doesn't allow it. This makes
> things more consistent and makes driver authors realise right away that
> they need to advertise things.

Got it, will add some kind of "radar-capability" flag for drivers.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de

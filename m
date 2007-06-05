Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:57216 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761575AbXFEOAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 10:00:04 -0400
Date: Tue, 5 Jun 2007 16:00:01 +0200
From: David Lamparter <lists@diac24.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stephan Maka <stephan@spaceboyz.net>
Subject: Re: nl80211 status? (implying cfg80211 status)
Message-ID: <20070605140001.GB5221@charon.n2.diac24.net>
References: <20070604193034.GA16350@charon.n2.diac24.net> <1181040798.8274.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1181040798.8274.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > As far as I understand, the first thing to tackle is converting
> > everything to cfg80211 and making wext call cfg80211 functions,
> > putting all the compatibility cruft into that layer while at it.
> 
> I wouldn't necessarily start with that.

Hmm, true, converting wext isn't really needed first. Does making
cfg80211 usable make a better candidate for first work? As far as I can
tell, the only thing mac80211 implements for cfg80211 is interface
creation / deletion...

> >  So that means, at least a PHY configuration command (am I missing
> > something or is there none yet?) with attributes to specify channel &
> > co.
> 
> Oh, heh, that does indeed seem to be missing...

I'd propose two additional commands:

- NL80211_CMD_GET_WIPHY [_CFG]
- NL80211_CMD_SET_WIPHY [_CFG]

which would be invoked with a NL80211_ATTR_WIPHY and setting/getting
NL80211_ATTR_WIPHY_NAME, NL80211_ATTR_CHANNEL and NL80211_ATTR_PHYMODE.

NL80211_CMD_RENAME_WIPHY could be dropped and replaced by
NL80211_CMD_SET_WIPHY. There seems to be no "get name" command yet,
so that will be covered too.

(actually NL80211_CMD_SET_WIPHY would be backwards compatible with
NL80211_RENAME_WIPHY since the latter is invoked with the same attributes)

The NEWNAME notify-command could be renamed and used for channel / phymode
notifications too.

> Not sure what you mean here. The NL80211_CMD_ASSOCIATE command as I see
> it is modeled after the 802.11 mlme interface, nl80211.h says:
> 
> > * @NL80211_CMD_ASSOCIATE: associate with the given parameters
> >  *      (%NL80211_ATTR_SSID is mandatory, %NL80211_ATTR_TIMEOUT_TU,
> >  *      %NL80211_ATTR_BSSID, %NL80211_ATTR_CHANNEL, %NL80211_ATTR_PHYMODE,
> >  *      and %NL80211_ATTR_IE may be given)
> 
> Hence, here we also have the ability to set the phy mode/channel. We
> still need an explicit command for that though for monitor interfaces.

Yes, thats what I meant for interface configuration. However, I don't
think NL80211_ATTR_CHANNEL and NL80211_ATTR_PHYMODE belong here - if
something is capable of using more than one channel, it really should
have more phys, not more interfaces...

> Do I look dead yet? No way. Proprietary/custom driver extensions live in
> debugfs. If you need something that's generally useful, we can add it to
> nl80211/cfg80211, otherwise you get to feel the pain of having it in
> debugfs.

Ah, I didn't think of that. Full ACK.

> Oh, I very much agree, nl80211 isn't frozen yet (except for that tiny
> part that's in mainline already). And all of nl80211 API are the numbers
> in the nl80211.h header file that userspace gets to see, so...

Phew. The only thing nl80211.h contains in mainline is enum nl80211_iftype.
So the possibility to make generic getter/setters out of the NAME commands
is still there...

David


(Stephan: sorry, forgot to Cc: you)

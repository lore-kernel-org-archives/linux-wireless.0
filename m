Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39004 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbZGMRxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 13:53:30 -0400
Subject: Re: nl80211 and wext interoperability
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1247163342.22527.2.camel@johannes.local>
References: <1247139797.2144.27.camel@johannes.local>
	 <43e72e890907091053s59ed356er22c59944efec9a01@mail.gmail.com>
	 <1247163342.22527.2.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 13:53:38 -0400
Message-Id: <1247507618.4369.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-09 at 20:15 +0200, Johannes Berg wrote:
> On Thu, 2009-07-09 at 10:53 -0700, Luis R. Rodriguez wrote:
> > On Thu, Jul 9, 2009 at 4:43 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> > > Hi!
> > >
> > > With the recent work I've done in cfg80211 for nl80211 and wext, we've
> > > mostly removed wext code everywhere. The only thing missing right now is
> > > the key support, and I think then we can declare cfg80211's wext compat
> > > layer pretty much done in terms of what mac80211 had -- orinoco will
> > > need the sensitivity (or AP density) thing but I'm not sure how we
> > > should do that since it's a value that is hardware dependent -- we'll
> > > need to have very good discovery code for the allowed values (unlike
> > > wext where you can set 0..3 and don't know what that means). Anyway,
> > > that wasn't the point of this email.
> > >
> > > Currently, if you use wpa_supplicant -Dwext and -Dnl80211 mixed,
> > > -Dnl80211 gets confused because -Dwext will set a 32-byte random SSID to
> > > "disconnect".
> > 
> > When do we disconnect like this? Upon initialization of wpa_supplicant
> > -Dwext -Dnl80211 ?
> 
> When you shut down wpa_supplicant -Dwext it does that.

Mainly because there's no way to tell WEXT drivers to "stop whatever
you're doing and just be idle"...

The supplicant clears out the keys on TERM anyway, and in some cases
(iwlagn) the driver will keep trying to reassociate internally, and if
the keys aren't there, the AP will keep rejecting it, which just means
you're spamming the air and the AP continuously, and then when you
re-start the supplicant, you get a constant stream of WEXT disconnect
events because the AP keeps rejecting you, and the supplicant freaks
out.

So, forcing a random SSID/BSSID combo is the best way (with WEXT) to
tell the driver to just stop trying to associate to anything.

Dan



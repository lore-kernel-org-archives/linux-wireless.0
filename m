Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34622 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbYLKB15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 20:27:57 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: [RFC] b43: rework rfkill code
Date: Thu, 11 Dec 2008 02:27:25 +0100
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Matthew Garrett" <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
References: <20081210150935.GA10927@srcf.ucam.org> <1228922997.15837.6.camel@johannes.berg> <646765f40812101632u76847935l2405482aabe1c1f8@mail.gmail.com>
In-Reply-To: <646765f40812101632u76847935l2405482aabe1c1f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812110227.26909.mb@bu3sch.de> (sfid-20081211_022801_816857_11217738)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 11 December 2008 01:32:37 Julian Calaby wrote:
> On Thu, Dec 11, 2008 at 02:29, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2008-12-10 at 15:09 +0000, Matthew Garrett wrote:
> >
> >> The final change is that I removed the code for changing the wireless
> >> state in response to the txpower configuration in mac80211. Right now, I
> >> can't see any way for this to work correctly - if the user disables the
> >> radio via rfkill, mac80211 doesn't flag the radio as disabled. As a
> >> result, the next time the configuration callback is called, b43
> >> reenables the radio again, even though the user has explicitly disabled
> >> it. I don't think any of the other drivers handle this case, so I'm not
> >> really sure what the best way to handle this in future is. The current
> >> situation certainly seems broken.
> >
> > We're going to have to integrate rfkill with mac80211, but nobody cares.
> 
> What strikes me, watching this from the outside - is that rfkill and
> power saving seem to be doing essentially the same thing: temporarily
> powering down the radio / card.

I think it's essentially a different thing.
rfkill means -> turn off the radio; no matter what.
PS means -> turn off the radio for whatever amount of microseconds and periodically
wake up to see what's up.
PS-core also takes place in the firmware of the device, where rfkill is a much higher layer thing.

-- 
Greetings, Michael.

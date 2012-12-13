Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35907 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab2LMU2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 15:28:24 -0500
Date: Thu, 13 Dec 2012 12:31:45 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ben Greear <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/6] wifi: Don't spam logs with 'Found new beacon'
 messages.
Message-ID: <20121213203145.GP15974@pogo> (sfid-20121213_212830_642522_0A5B5A38)
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
 <1355349295-30960-2-git-send-email-greearb@candelatech.com>
 <1355350115.9708.21.camel@jlt4.sipsolutions.net>
 <50C901FC.3040306@candelatech.com>
 <1355350635.9708.23.camel@jlt4.sipsolutions.net>
 <1355350801.9708.24.camel@jlt4.sipsolutions.net>
 <1355351067.9708.27.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1355351067.9708.27.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2012 at 11:24:27PM +0100, Johannes Berg wrote:
> On Wed, 2012-12-12 at 23:20 +0100, Johannes Berg wrote:
> > On Wed, 2012-12-12 at 23:17 +0100, Johannes Berg wrote:
> > > On Wed, 2012-12-12 at 14:15 -0800, Ben Greear wrote:
> > > > On 12/12/2012 02:08 PM, Johannes Berg wrote:
> > > > > On Wed, 2012-12-12 at 13:54 -0800, greearb@candelatech.com wrote:
> > > > >> From: Ben Greear <greearb@candelatech.com>
> > > > >>
> > > > >> We saw logs fill with this (at very high speeds):
> > > > >>
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > > > >>
> > > > >> Signed-off-by: Ben Greear <greearb@candelatech.com>
> > > > >> ---
> > > > >>   net/wireless/reg.c |   11 ++++++-----
> > > > >>   1 files changed, 6 insertions(+), 5 deletions(-)
> > > > >>
> > > > >> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > > > >> index 6e53089..8aa7867 100644
> > > > >> --- a/net/wireless/reg.c
> > > > >> +++ b/net/wireless/reg.c
> > > > >> @@ -2067,11 +2067,12 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
> > > > >>   	if (!reg_beacon)
> > > > >>   		return -ENOMEM;
> > > > >>
> > > > >> -	REG_DBG_PRINT("Found new beacon on "
> > > > >
> > > > > Why not just disable the config option for it if you don't care?
> > > > 
> > > > I don't mind seeing it, just don't want thousands of them in my logs
> > > > in a very short amount of time.  Maybe I was just hitting some
> > > > other bug, and there is no valid reason for this to ever spam?
> > > 
> > > Quite likely, since I think it's supposed to happen only once for each
> > > channel unless you reset the regulatory (but that would cause more
> > > messages? I think?)
> > 
> > Ah, no, I get it. It is related to your many interfaces :-)
> > 
> > The thing is that when a beacon comes in it schedules a work item, and
> > that work item only sets the beacon_found to true. Now since you have a
> > ton of interfaces each beacon can be processed many times, and you get a
> > ton of work items, and ... ouch.

As explained below indeed you should only see this once for one channel
even if your box has a billion interfaces, but Johannes is right that we
won't be able to reap benefits of the check that annotates this was an
already established beacon hint until the work item gets processed and
since its a scheduled task we can potentially alloc quite a lot of beacon
hints for the same channel if you have a lot of interfaces.

I'll post a patch for this, please test.

> Or if you're not world roaming.. this is really bad, we alloc all those
> beacon hint structs just to not do anything with them,

Indeed, we don't annotate the beacon hint as found if we are not world
roaming. I'll look to annotate this, patch to follow after the first one.

> I wonder if they even get leaked or added to reg_beacon_list (but that's
> about the same)

We get beacon hints added to the reg_beacon_list if the channel fits
the area where we allow it given that we allow for future devices to
pop up and we want them to learn from the exisitng device's information.
We can certainly change this if we want.

  Luis

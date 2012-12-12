Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2LLWTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 17:19:38 -0500
Message-ID: <1355350801.9708.24.camel@jlt4.sipsolutions.net> (sfid-20121212_231941_234616_99AEDE06)
Subject: Re: [RFC 2/6] wifi: Don't spam logs with 'Found new beacon'
 messages.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Dec 2012 23:20:01 +0100
In-Reply-To: <1355350635.9708.23.camel@jlt4.sipsolutions.net> (sfid-20121212_231701_848012_2B205976)
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
	 <1355349295-30960-2-git-send-email-greearb@candelatech.com>
	 (sfid-20121212_225535_981449_212B81FE) <1355350115.9708.21.camel@jlt4.sipsolutions.net>
	 <50C901FC.3040306@candelatech.com>
	 <1355350635.9708.23.camel@jlt4.sipsolutions.net>
	 (sfid-20121212_231701_848012_2B205976)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 23:17 +0100, Johannes Berg wrote:
> On Wed, 2012-12-12 at 14:15 -0800, Ben Greear wrote:
> > On 12/12/2012 02:08 PM, Johannes Berg wrote:
> > > On Wed, 2012-12-12 at 13:54 -0800, greearb@candelatech.com wrote:
> > >> From: Ben Greear <greearb@candelatech.com>
> > >>
> > >> We saw logs fill with this (at very high speeds):
> > >>
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> > >>
> > >> Signed-off-by: Ben Greear <greearb@candelatech.com>
> > >> ---
> > >>   net/wireless/reg.c |   11 ++++++-----
> > >>   1 files changed, 6 insertions(+), 5 deletions(-)
> > >>
> > >> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > >> index 6e53089..8aa7867 100644
> > >> --- a/net/wireless/reg.c
> > >> +++ b/net/wireless/reg.c
> > >> @@ -2067,11 +2067,12 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
> > >>   	if (!reg_beacon)
> > >>   		return -ENOMEM;
> > >>
> > >> -	REG_DBG_PRINT("Found new beacon on "
> > >
> > > Why not just disable the config option for it if you don't care?
> > 
> > I don't mind seeing it, just don't want thousands of them in my logs
> > in a very short amount of time.  Maybe I was just hitting some
> > other bug, and there is no valid reason for this to ever spam?
> 
> Quite likely, since I think it's supposed to happen only once for each
> channel unless you reset the regulatory (but that would cause more
> messages? I think?)

Ah, no, I get it. It is related to your many interfaces :-)

The thing is that when a beacon comes in it schedules a work item, and
that work item only sets the beacon_found to true. Now since you have a
ton of interfaces each beacon can be processed many times, and you get a
ton of work items, and ... ouch.

Not sure how the locking works here so can't really suggest a fix right
now.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3DKJPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 05:15:14 -0400
Message-ID: <1365671709.8272.31.camel@jlt4.sipsolutions.net> (sfid-20130411_111519_684774_1419C804)
Subject: Re: [PATCH v4] mac80211:  Optimize sta lookup for many VIFs
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Apr 2013 11:15:09 +0200
In-Reply-To: <5164517C.1050304@candelatech.com>
References: <1364572823-28071-1-git-send-email-greearb@candelatech.com>
	  (sfid-20130329_170033_026763_9F6C74DD) <1365501048.8465.13.camel@jlt4.sipsolutions.net>
	 <5164517C.1050304@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-09 at 10:35 -0700, Ben Greear wrote:
> On 04/09/2013 02:50 AM, Johannes Berg wrote:
> > On Fri, 2013-03-29 at 09:00 -0700, greearb@candelatech.com wrote:
> >> From: Ben Greear <greearb@candelatech.com>
> >>
> >> The sta_info hash is designed to deal with an AP
> >> with lots of stations associated, or a station interface
> >> connected to a single AP.
> >
> > Given your other hash patches, does this even make sense still?
> 
> This handles the TX side for station VIFs.  The more complicated
> hashing handles the rx logic.  I could use the hash
> for the tx side, though performance is likely a small bit
> worse since you have to deal with the hash logic.

Well, for the TX side in your particular case the vhash should always
just find the right station first, so basically it's the same, no? I
mean, if you used the new hash in the TX code, it would basically do the
same the some_sta thing does, assuming your hash spreads well, no?

> And, if the more complicated RFC hashing patch has no upstream
> chance anyway, then if the 'some-sta' patch is acceptable,
> I'd still be interested in seeing it upstream.

Well I'm debating (with myself mostly) ... The some_sta seems
reasonable, but still a big ugly and like a special case. I'd rather not
merge the vhash because of the various overheads, so you'd probably want
to maintain that out of tree anyway. It seems to me that the vhash
should address your other case pretty much just as well, so then if you
maintain that anyway I wouldn't have to merge the some_sta patch ... I
guess I'd kinda prefer that :-)

johannes


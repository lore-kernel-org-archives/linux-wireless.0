Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26959 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1CUQ0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 12:26:50 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000029385.msg
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 18:25:46 +0200
Subject: Re: new utility kernel module for detecting cores in newer chipsets
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	George Kashperko <george@znau.edu.ua>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTimaRXjzbYP53uHYfJaiX6Z1iy5Qm14g+w_OiJEs@mail.gmail.com>
References: <20110319214234.GA5152@kroah.com>
	 <1300573336.11949.25.camel@maggie> <20110319234524.GA7493@kroah.com>
	 <op.vsmyhmei3ri7v4@arend-laptop> <20110320145421.GA13962@kroah.com>
	 <op.vsnd1a1i3ri7v4@arend-laptop> <20110320162200.GA17030@kroah.com>
	 <op.vsng7q1j3ri7v4@arend-laptop> <20110320185216.GD19375@kroah.com>
	 <AANLkTimEGR-8zhbMQpcAzYkuZ8fHkhj1bOQrb3rShfsP@mail.gmail.com>
	 <20110321140505.GA7321@kroah.com>
	 <AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
	 <op.vso77ddp3ri7v4@arend-laptop>
	 <AANLkTimaRXjzbYP53uHYfJaiX6Z1iy5Qm14g+w_OiJEs@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Mar 2011 18:25:36 +0200
Message-Id: <1300724736.3866.33.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 2011/3/21 Arend van Spriel <arend@broadcom.com>:
> > On Mon, 21 Mar 2011 15:27:49 +0100, Rafał Miłecki <zajec5@gmail.com> wrote:
> >
> >> The case is, we discussed ssb/ai driver layout few days ago. George
> >> shared idea of layout I agree with, nobody shared any objections. If
> >> everything goes fine, we should have nicely modularized driver/project
> >> supporting Broadcom's buses.
> >
> > Hi Rafał,
> >
> > Does this give us one module supporting both buses or does it provide two
> > kernel modules (my preference)? I did ask you and George this question
> > earlier but I seem to have missed the response from you or George.
> 
> I'm still waiting for George to respond and share his code.
> 
> 
> >> In this situation I'm not really interested is simple ai driver
> >> stripped from brcm80211. According to me, it would led to harder
> >> maintenance and harder implementation of support for such a driver in
> >> b43.
> >
> > I can imagine from b43 perspective the only good implementation would be to
> > stick with the current b43<->ssb interface. So what will you do when another
> > type of SoC interconnect is introduced. Forcing that in the same API as
> > well? If you and George propose a new carefully considered API covering the
> > functional capabilities of the current (and possibly future) interconnect
> > buses I am all for that.
> >
> > To summarize this, my main issue (and Michael's, I think) is with the
> > dependency being imposed between ai and ssb. Having two completely
> > independent modules really makes more sense.
> 
> This really depends on new interconnect. If it will be totally
> different, I'll vote for totally different driver. In case of SSB and
> AI, driver layout is similar, it seems George managed to write sth
> nice.
> 
> George?
Hi there. Much surprised with such a resonance on the topic. Sorry for
being so late with participating with discussion - work background
requires me sometimes to move around alot - this week is the time for
trips.
If you extremely hurry with that I will make my testings sources
available lately this evening as soon as get to my workpad. But just to
warn you its not that I planned for final "release" just glue I used to
work edge things out. As for final code I plan to finish with it next
weekends - yet again I will move al lot this week and will have much
time to think on the subject but not actually work on it.

Yet again sorry for making you wait.

Now back to subject. I curious about sertain things I see here which
make the most contradictary ones. That ones regarding why AI and SB
should be separate modules etc.
Would be much appreciated if you hear my mind on that (under hear I mean
not just read). Some time ago here in earlier AI rfcs' threads I already
tried to cover the reason why am I sure they should not just share
single code base but also be coupled together.
AI and SB interconnects are really totally diffeent hardware base. But
they stick to the single architecture model. Very much the same as PCI
and PCIE are (see what I'm trying to do here?). This model is not AI or
SB exclusive and in short looks like following (here I'm sorry for
making you read the things you know already, but I do it just because I
see that ones of you see on subject through Broadcom SDK while others do
the same through linux/ssb):
Bus devices coupled under the entity we tend to call cores. The cores
managed from the system bus side with means of the host. The cores
managed from the backplane side with means of agents. The core devices
exposed to system and managed with same drivers regardless the
backplane. The agents system dont supposted to know about and doing the
same enable/disable/reset but in somewhat different way. The fact is (as
at least I see it) that here we want to keep things apart just because
one set of agents is called SB (or e. g. PCI) while the other is called
AXI (or lets say PCIE).
Yes, linux/ssb model design can't cover this. The linux/bcmb (or hnd as
I finally named it - grrr really dont like these 3 letters -.-) might do
better as it is designed to do that. Btw in way which is completely
different from ssb and Broadcom SDK one.

Here much sorry need to get back to work. Will be back late in evening.

Have nice day,
George



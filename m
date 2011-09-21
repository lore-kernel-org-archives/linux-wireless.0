Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f42.google.com ([209.85.215.42]:37329 "EHLO
	mail-ew0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1IUUBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 16:01:49 -0400
Received: by ewy1 with SMTP id 1so2113923ewy.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 13:01:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<20110920132203.GB7800@tuxdriver.com>
	<20110920140020.GA11386@kroah.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
Date: Wed, 21 Sep 2011 22:01:45 +0200
Message-ID: <CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com> (sfid-20110921_220153_945786_FDE6634B)
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch #2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/21 Brett Rudley <brudley@broadcom.com>:
>> On Tue, Sep 20, 2011 at 09:22:03AM -0400, John W. Linville wrote:
>> > On Tue, Sep 20, 2011 at 06:03:38AM -0700, Greg KH wrote:
>> > > On Mon, Sep 19, 2011 at 02:25:48PM -0700, Franky Lin wrote:
>> > > > Code clean up for fullmac.
>> > >
>> > > Ok, this is the 7th patch series since the last round of "how do we
>> get
>> > > our driver into mainline" happened.
>> > >
>> > > And while code is great and nice, I still haven't seen any real
>> answers
>> > > to all of the questions that were asked of the Broadcom driver team
>> > > during that review by the linux-wireless developers about how things
>> > > will be handled properly due to the overlap in functionality with the
>> > > existing "real" driver in the tree.
>> > >
>> > > So, can you please start answering these questions?  I'm loath to
>> keep
>> > > accepting patches until that all gets straightened out as it
>> potentially
>> > > wastes my, and your, time by doing so.
>> > >
>> > > In other words, I'm not going to apply any more patches until this
>> gets
>> > > resolved.  Consider this patchset dropped from my to-apply queue for
>> now
>> > > because of that.
>> >
>> > I think most of the outstanding series from Broadcom are
>> > (almost?) exclusively for their fullmac driver, which has not overlap
>> > with b43.  We should be moving forward toward getting the fullmac
>> > driver into wireless-next.
>>
>> Ok, that's great, but again, no one from Broadcom has said what their
>> plans are, only sent lots of patches, which while wonderful, has caused
>> some confusion on my and other parts.
>>
>> greg k-h
>
> Our original plan was to remain a separate driver from b43. We were aware of it and all the good work that had been done to create it and we had no intention of interfering with it.  At that point there had not been very much recent movement in b43 and it did not support any of our AXI based chips.  We figured that ssb vs AXI was a good dividing line and there would be no conflict, and there wasn't initially.

The first obvious problem is that there are SSB and BCMA (aka AXI)
cards using N-PHY. That resulted in PHY code duplication between b43
and brcmsmac. And since we already supported N-PHY in b43, adding bcma
support automatically gave us BCM43224 and BCM43225 support. That of
course means duplicated supported for the same hardware.


> Internally, prior to releasing to staging tree, development had gone quickly and it didn't take long at all to get the driver up and running.  We did not anticipate that things would go somewhat slower in the staging tree and a year (and hundreds of patches) later we are still there.  During that year b43 got some limited support for the same new chips brcmsmac already had, into its driver.  So now, here we are... both drivers supporting the new chips and b43 also supporting the old.
>
> We have seen the requests for us to add AXI based chipset support into b43.  I don't think that will happen in a substantial way:
> - Our driver is already stable and performance is better than b43 in terms of AXI chips.  B43 seems quite raw: its full of TODO and FIXME notes and performance is 1/10th of brcmsmac on our testing. Spending another round of time and effort on b43 to get it to the place where smac already is, seems redundant and unattractive.

Well, I guess you were comparing brcmsmac working in 802.11n mode vs.
b43 workin in 802.11g mode? When I was comparing both drivers in
802.11g mode, they were similar in performance. Please see my tests at
http://zajec.net/ . If that's true, we can also say b43 is ∞ faster
than brcmsmac... if you compare AP or monitor mode.


> - Much of brcmsmac code comes from our internal source which has whole organizations charged with testing it for compliance, compatibility, performance, etc. We understand that that is of no direct consequence but since brcmsmac code is a direct descendent of that code, much of that background still applies. Switching to b43 would mean throwing all that infrastructure and testing away and going with a driver that has none of that (that I know of).

Yes, I'm aware you may be not so comfortable with differences between
internal driver and b43.
However you're already at the place, when you can not just copy&paste
code from your internal driver to brcmsmac. You have to adopt in
anyway. Are there really so many differences if you look at b43? DMA
is something you probably don't need to touch. PHY code should be
portable to b43 in the same way it is to brcmsmac. The biggest problem
is to touch some general things, not PHY-directly-related. And even in
that code we share a lot of code. Our code is based on RE of your
driver. It has to be similar.


> - Most of the recent b43 additions support comes from a single person doing reverse engineering. brcmsmac has a few software people working on it directly and hundreds of people working on it indirectly (through the internal version) including engineers working on firmware, RTL, testing, etc.

You're doing much harder job and obviously you need much more people.
I just implement the driver, without testing hardware for various
possible configurations, etc. That's the only explanation how we've
achieved such a good state. We copied init/config values from your
driver, didn't invent them ourself.


> - B43 team has made the case several times that it has more features than brcmsmac.  A reminder: We were specifically asked NOT to add features while in staging tree and we have held back on features to honor that request.  AP, IBSS, 40 Mhz, using bcma, hw crypto and others, are all features we have been waiting to do.   We also have a backlog of several new chips we want to add.  And of course, we will would be adding future chips and features as they come out.

Well, you spent a lot of time on cleaning brcmsmac, I spent a lot of
time on adding support for new hardware. I believe now we both are at
similar stage from reaching fully functional, feature-full driver. 1:1
for both of us ;)


> We invested a year trying to be good Linux citizens, laying out our initial plans, following the rules, working transparently, folding in feedback, submitting hundreds of patches in plain sight of everyone and now folks are asking about our plan.  Our plan is get the brcmsmac and brcmfmac into mainline and keep following that up with new features, new chips and continuing support.

Well, you were submitting patches, but you weren't discussing anything
with us. That's really important in being a good citizens.
How many times have I asked about the firmware? How many times about
access to the hardware? How many times about the future? Really, I was
trying hard to cooperate, you just were ignoring all of that :|
We've now finally made you respond to the questions about the future,
but you still ignore my fw questions and hw requests.
This of course resulted in the complex situation we have now.


> Other than barely supporting one of our chips first in mainline, I would really like to understand what are the benefits and justifications of using b43 over brcmsmac for AXI based chips in the long run.  Can someone explain them?

What I don't like about brcmsmac?
1) Not modularized, bcma support built in and duplicated with bcma module
2) Poor quality code
3) Duplication of a lot of code with bcma&b43. Not just PHY code, but
also more general functions, DMA support, MAC, etc.


I don't know what more I can propose now.

We can of course continue our work without differences. I'll add
support for more cards and make it stable, meanwhile you will finally
clean your driver. What then? We will have 2 driver supporting same
hardware with comparable quality. Having 2 mainline drivers for the
same hw is not really a good option. Will we keep brcmsmac in staging
just to receive new PHY support from you and keep copying it to b43?
Doesn't sound to optimistic. How else do you see the future?

-- 
Rafał

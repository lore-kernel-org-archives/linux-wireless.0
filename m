Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50755 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1IVGyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 02:54:05 -0400
Received: by wyg34 with SMTP id 34so2661734wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 23:54:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<20110920132203.GB7800@tuxdriver.com>
	<20110920140020.GA11386@kroah.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
	<CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
Date: Thu, 22 Sep 2011 08:54:03 +0200
Message-ID: <CACna6rw+svsXJ4N_8h2a0YLyRw7T5cggZzLWzBsjd=0RxVWJrg@mail.gmail.com> (sfid-20110922_085410_197602_94FA1214)
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

W dniu 22 września 2011 00:12 użytkownik Brett Rudley
<brudley@broadcom.com> napisał:
>> > Our original plan was to remain a separate driver from b43. We were
>> aware of it and all the good work that had been done to create it and we
>> had no intention of interfering with it.  At that point there had not
>> been very much recent movement in b43 and it did not support any of our
>> AXI based chips.  We figured that ssb vs AXI was a good dividing line and
>> there would be no conflict, and there wasn't initially.
>>
>> The first obvious problem is that there are SSB and BCMA (aka AXI)
>> cards using N-PHY. That resulted in PHY code duplication between b43
>> and brcmsmac. And since we already supported N-PHY in b43, adding bcma
>> support automatically gave us BCM43224 and BCM43225 support. That of
>> course means duplicated supported for the same hardware.
>
> Agree, when you created bcma, it did duplicate HW support already in brcmsmac.  Why didn't you address that then?

bcma is not the issue, it had to be created anyway. We can not accept
one driver handling all the BCMA/AXI cores (80211, ethernet, whatever
else). And you, I believe brcmsmac has to switch to bcma.


> Also, brcmsmac realizes that there are tweaks and features specific to each chip and to each revision of each phy.  While they are of the same family, each version has its own feature set and settings.
>
> But b43 got 224/5 so called support 'automaticly' simply by adding AXI access.

Chips tweaks mostly lays in bus code, which is bcma in this case. As
for PHY code, you've not even cared to take a look at our phy_n.c! But
you're commenting that anyway.
BCM43224 and BCM43225 are nothing special, there are N-PHY rev 6.
We've code for revs 1-6 from the beginning. That's how we got support
for that cards "automaticly". I was here since "ever", we just got to
add BCMA/AXI support.


>> > Internally, prior to releasing to staging tree, development had gone
>> quickly and it didn't take long at all to get the driver up and running.
>>  We did not anticipate that things would go somewhat slower in the
>> staging tree and a year (and hundreds of patches) later we are still
>> there.  During that year b43 got some limited support for the same new
>> chips brcmsmac already had, into its driver.  So now, here we are... both
>> drivers supporting the new chips and b43 also supporting the old.
>> >
>> > We have seen the requests for us to add AXI based chipset support into
>> b43.  I don't think that will happen in a substantial way:
>> > - Our driver is already stable and performance is better than b43 in
>> terms of AXI chips.  B43 seems quite raw: its full of TODO and FIXME
>> notes and performance is 1/10th of brcmsmac on our testing. Spending
>> another round of time and effort on b43 to get it to the place where smac
>> already is, seems redundant and unattractive.
>>
>> Well, I guess you were comparing brcmsmac working in 802.11n mode vs.
>> b43 workin in 802.11g mode?
>
> I just loaded the two drivers on my machine and ran iperf.  Are users expected to do something else?  802.11N APs are not esoteric equipment anymore, sorry.

[irony, yes]
Monitor mode is nothing esoteric anymore. I've compared b43 with
brcmsmac. b43 is 100000000 times faster (compared to 0 b/s).


>> Yes, I'm aware you may be not so comfortable with differences between
>> internal driver and b43.
>> However you're already at the place, when you can not just copy&paste
>> code from your internal driver to brcmsmac. You have to adopt in
>> anyway. Are there really so many differences if you look at b43? DMA
>> is something you probably don't need to touch. PHY code should be
>> portable to b43 in the same way it is to brcmsmac. The biggest problem
>> is to touch some general things, not PHY-directly-related. And even in
>> that code we share a lot of code. Our code is based on RE of your
>> driver. It has to be similar.
>
> If they are so similar why do you think b43 is better?

I've said what I don't like currently in brcmsmac. I've also said both
drivers should be equal in next few months. Nothing really more to
add, it's not about flamewar. Plus Michael commented this nicely.


>> > - Most of the recent b43 additions support comes from a single person
>> doing reverse engineering. brcmsmac has a few software people working on
>> it directly and hundreds of people working on it indirectly (through the
>> internal version) including engineers working on firmware, RTL, testing,
>> etc.
>>
>> You're doing much harder job and obviously you need much more people.
>> I just implement the driver, without testing hardware for various
>> possible configurations, etc. That's the only explanation how we've
>> achieved such a good state. We copied init/config values from your
>> driver, didn't invent them ourself.
>
> Speaking of init values, I noticed you have init values but no others after that during runtime.  We don't drive our chips
> without proper periodic calibrations.

You really got to ignore previous thread about going mainline.
That issue was already pointed to me, and I've already started sending
patches for that.


>> Well, you spent a lot of time on cleaning brcmsmac, I spent a lot of
>> time on adding support for new hardware. I believe now we both are at
>> similar stage from reaching fully functional, feature-full driver. 1:1
>> for both of us ;)
>>
>
>
>> Well, you were submitting patches, but you weren't discussing anything
>> with us. That's really important in being a good citizens.
>> How many times have I asked about the firmware? How many times about
>> access to the hardware? How many times about the future? Really, I was
>> trying hard to cooperate, you just were ignoring all of that :|
>> We've now finally made you respond to the questions about the future,
>> but you still ignore my fw questions and hw requests.
>> This of course resulted in the complex situation we have now.
>>
>
> Do you think were in the smokey back room making deals or something?  All our patches are out in the open.
> We have tried to be as transparent as possible.
> We responded and integrated all (almost all?) feedback that we got on our patches.
> We published our TODO list and updated it several times throughout devel cycle.

I didn't comment your patches. Maybe I've said sth about amount of
them, but it's your choice to spend your time on cleaning, cleaning,
cleaning, I'm find with that.


> We helped you with bcma.   You asked us to send you an Arasan board which are hard to get and cost
> about $1k, I can't do that.  I handed out 4313 and 43224 boards like candy early on to anyone who asked.

I don't remember you saying finally "Sorry, we won't be able to donate
you with that". Will re-check.
Still, you refused to share BCM4331 (which is already available on
market, and even hackish-supported by b43). Same for BCM43227 and
BCM43228. I didn't even care to ask for some SSLPN card (which is also
available on the market in some routers, can find proves).
Oh, and you still didn't care too much about our firmware requests.


>> > Other than barely supporting one of our chips first in mainline, I
>> would really like to understand what are the benefits and justifications
>> of using b43 over brcmsmac for AXI based chips in the long run.  Can
>> someone explain them?
>>
>> What I don't like about brcmsmac?
>> 1) Not modularized, bcma support built in and duplicated with bcma module
>
> As discussed numerous times:
> We have been in staging and no new features is the rule. We have bcma code waiting to be released.

Please, do this soon. When merge window for 3.2 will open, you'll
receive all recent bcma code. If there is anything missing in bcma you
need, *please report that* (or provide patches).
I believe this is part of cleaning, nothing like new features. You'll
simply drop a lot of duplicated code by switching to bcma.


>> 2) Poor quality code
>
>> 3) Duplication of a lot of code with bcma&b43. Not just PHY code, but
>> also more general functions, DMA support, MAC, etc.
>
> Seriously? Again? You keep bringing this up. Do you understand that there was no bcma when we released to staging and that we
> were asked not to add new features while in staging?   It would be nice if you could acknowledge that.
>
> But other than the one line comment on code, you still haven't answered the question of why you think b43 is a better driver.

-- 
Rafał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47241 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab2FNQ0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:26:45 -0400
Received: by ghrr11 with SMTP id r11so1522245ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 09:26:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120613204230.474d1b6c@milhouse>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339168600.5748.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
	<4FD21C6B.5000402@lwfinger.net>
	<1339170182.5748.7.camel@jlt3.sipsolutions.net>
	<1339170287.5748.8.camel@jlt3.sipsolutions.net>
	<1339170510.5748.9.camel@jlt3.sipsolutions.net>
	<1339170742.5748.10.camel@jlt3.sipsolutions.net>
	<CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com>
	<1339171159.5748.11.camel@jlt3.sipsolutions.net>
	<CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
	<4FD22727.7000500@lwfinger.net>
	<1339180580.5748.32.camel@jlt3.sipsolutions.net>
	<1339180948.5748.35.camel@jlt3.sipsolutions.net>
	<1339182289.5748.36.camel@jlt3.sipsolutions.net>
	<1339576294.4519.17.camel@jlt3.sipsolutions.net>
	<CAHsu+b9soGKgZmqWLU=-v0zOG0v_Arf8DFoCn1EQ7-86Mg_CdQ@mail.gmail.com>
	<1339602402.4519.48.camel@jlt3.sipsolutions.net>
	<20120613204230.474d1b6c@milhouse>
Date: Thu, 14 Jun 2012 18:26:43 +0200
Message-ID: <CAHsu+b_ue7LknbwMCdYsK6pQ8XxwjCL8Ham3xLucaaXZab69-g@mail.gmail.com> (sfid-20120614_183108_174169_72B9411F)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2012 at 8:42 PM, Michael Büsch <m@bues.ch> wrote:
> On Wed, 13 Jun 2012 17:46:42 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> On Wed, 2012-06-13 at 17:39 +0200, Andre Heider wrote:
>> > On Wed, Jun 13, 2012 at 10:31 AM, Johannes Berg
>> > <johannes@sipsolutions.net> wrote:
>> > > On Fri, 2012-06-08 at 21:04 +0200, Johannes Berg wrote:
>> > >
>> > >> Ahrg, b43 only sets fw.opensource too late ... this moves it:
>> > >> http://p.sipsolutions.net/00c0056dc206e247.txt
>> > >
>> > > Has anyone tested this?
>> >
>> > Sorry, missed that one.
>> > I get this crash with that patch: http://i.imgur.com/2CMzA.png
>>
>> Huh, that doesn't make a lot of sense to me, I don't move any
>> locking ...
>
> This just seems to be a follow-up oops and the original one scrolled off screen.

Indeed, the framebuffer showed up too late on TV and I didn't even notice ;)

pause_on_oops=30 made that easier, and the offender is
drivers/net/wireless/b43/main.c:5294 from the patch:
wldev->qos_enabled = true;

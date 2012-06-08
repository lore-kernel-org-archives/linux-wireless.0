Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760925Ab2FHPQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 11:16:43 -0400
Message-ID: <1339168600.5748.2.camel@jlt3.sipsolutions.net> (sfid-20120608_171646_505962_FAA5EE88)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Andre Heider <a.heider@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Fri, 08 Jun 2012 17:16:40 +0200
In-Reply-To: <1339168452.5748.0.camel@jlt3.sipsolutions.net> (sfid-20120608_171420_397861_867305D6)
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	 <1339014959.4523.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	 <1339053364.4517.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	 <20120607180325.7752b3c0@milhouse>
	 <1339094215.4630.7.camel@jlt3.sipsolutions.net>
	 <1339102567.4630.8.camel@jlt3.sipsolutions.net>
	 <4FD11B47.10002@lwfinger.net>
	 <CAHsu+b9=4i1oSni1onKAKqH4FZ26nye=7GifnnJO-6c5gCaWpQ@mail.gmail.com>
	 <1339136879.5832.1.camel@jlt3.sipsolutions.net>
	 <1339137689.5832.2.camel@jlt3.sipsolutions.net>
	 <CAHsu+b9uyohfFG46R7QHht6tD3MVUzk4_LJeXp+CC2bRv=NihA@mail.gmail.com>
	 <1339167160.4901.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com>
	 (sfid-20120608_170415_375251_68B65A73) <1339168452.5748.0.camel@jlt3.sipsolutions.net>
	 (sfid-20120608_171420_397861_867305D6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 17:14 +0200, Johannes Berg wrote:
> On Fri, 2012-06-08 at 17:04 +0200, Andre Heider wrote:
> 
> > >> > http://p.sipsolutions.net/854d460da251f9d6.txt
> > >>
> > >> Sorry, still not loading any firmware.
> > >
> > > So you're going to have to tell me what happens :-)
> > 
> > Well, nothing ;)
> > 
> > I just see this in dmesg:
> > 
> > [    1.012107] b43-sdio mmc1:0001:1: Chip ID 14e4:4318
> > [    1.018765] ssb: Found chip with id 0x4318, rev 0x02 and package 0x02
> > [    1.096506] ssb: chipcommon status is 0x0
> > [    1.105314] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
> > 
> > Hence the device doesn't get up and there's no way for me to interact
> > with the system.
> 
> Ok, well, bugger :-)
> 
> Can you go to main.c and print out the return value of
> ieee80211_register_hw()? I have a feeling that's where the failure is
> though I don't really know why.

No, wait, I do know why. Sorry!

Try this new version of the patch:
http://p.sipsolutions.net/3f75b09af68fd455.txt

If my hunch is right then we need to figure out how to not allow
off-channel or something.

johannes


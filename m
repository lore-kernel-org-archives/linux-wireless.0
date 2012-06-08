Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab2FHQ4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 12:56:11 -0400
Message-ID: <1339174568.5748.20.camel@jlt3.sipsolutions.net> (sfid-20120608_185615_556276_475F709A)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Andre Heider <a.heider@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Fri, 08 Jun 2012 18:56:08 +0200
In-Reply-To: <CAHsu+b_J5CsTdbGn=epwx3A+zJ6Nw8rmuVRjZEwMMsaeGOycpQ@mail.gmail.com> (sfid-20120608_185426_510343_5E4D2A3F)
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
	 <1339168452.5748.0.camel@jlt3.sipsolutions.net>
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
	 <1339171694.5748.12.camel@jlt3.sipsolutions.net>
	 <CAHsu+b-fZQ0auLAd_8rqaoNfLF-2UghRrB7S7qgu1RrqesbW4Q@mail.gmail.com>
	 <1339173704.5748.19.camel@jlt3.sipsolutions.net>
	 <CAHsu+b_J5CsTdbGn=epwx3A+zJ6Nw8rmuVRjZEwMMsaeGOycpQ@mail.gmail.com>
	 (sfid-20120608_185426_510343_5E4D2A3F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 18:54 +0200, Andre Heider wrote:
> On Fri, Jun 8, 2012 at 6:41 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2012-06-08 at 18:16 +0200, Andre Heider wrote:
> >
> >> >> [   17.597307] wlan0: authenticate with d8:5d:4c:9c:31:14
> >> >> [   17.638399] wlan0: send auth to d8:5d:4c:9c:31:14 (try 1/3)
> >> >> [   17.851085] wlan0: send auth to d8:5d:4c:9c:31:14 (try 2/3)
> >> >> [   18.063086] wlan0: send auth to d8:5d:4c:9c:31:14 (try 3/3)
> >> >> [   18.275081] wlan0: authentication with d8:5d:4c:9c:31:14 timed out
> >> >>
> >> >> Tried it 3 times, always times out.
> >
> > I missed one a use of queue_mapping, try this:
> >
> > http://p.sipsolutions.net/cc1fc9799ad3c015.txt
> 
> Unfortunately still the authentication timeout.

I'm out of ideas then, you had the right queue to start with so this
probably just fixed a corner case, but ... I have no idea where else a
bug could lurk.

Maybe you can first make sure the frames actually make it to the air,
using some other device as a sniffer?

johannes


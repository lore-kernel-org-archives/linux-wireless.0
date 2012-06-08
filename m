Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761278Ab2FHPiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 11:38:50 -0400
Message-ID: <1339169927.5748.5.camel@jlt3.sipsolutions.net> (sfid-20120608_173854_360746_29537190)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Andre Heider <a.heider@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Fri, 08 Jun 2012 17:38:47 +0200
In-Reply-To: <CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com> (sfid-20120608_172503_149994_C06790C0)
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
	 (sfid-20120608_172503_149994_C06790C0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 17:25 +0200, Andre Heider wrote:


> [    9.654251] b43-phy0 debug: Adding Interface type 2
> [   11.371154] b43-phy0 ERROR: MAC suspend failed

That doesn't make much sense to me, the code paths related to that
shouldn't have changed, unless somehow some frame goes to the wrong
queue which would seem strange ...

Maybe you could print out what queues the frames go to or something ...
I don't even know what's happening in those seconds between those two
messages so I can't really help you much.

Regardless, I fixed some bugs in my patch related to mcast:
http://p.sipsolutions.net/4e1aec97842e0f72.txt

johannes


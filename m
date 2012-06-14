Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab2FNQiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:38:04 -0400
Message-ID: <1339691877.9786.0.camel@jlt3.sipsolutions.net> (sfid-20120614_183808_321382_4DFC7DF5)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Andre Heider <a.heider@gmail.com>
Cc: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Thu, 14 Jun 2012 18:37:57 +0200
In-Reply-To: <CAHsu+b_ue7LknbwMCdYsK6pQ8XxwjCL8Ham3xLucaaXZab69-g@mail.gmail.com> (sfid-20120614_182647_613518_EB710054)
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
	 <CAHsu+b_ue7LknbwMCdYsK6pQ8XxwjCL8Ham3xLucaaXZab69-g@mail.gmail.com>
	 (sfid-20120614_182647_613518_EB710054)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-14 at 18:26 +0200, Andre Heider wrote:

> > This just seems to be a follow-up oops and the original one scrolled off screen.
> 
> Indeed, the framebuffer showed up too late on TV and I didn't even notice ;)
> 
> pause_on_oops=30 made that easier, and the offender is
> drivers/net/wireless/b43/main.c:5294 from the patch:
> wldev->qos_enabled = true;

Ok ... seems wldev doesn't exist then? Doesn't make any sense to me, but
I don't understand the code ... not that it matters, try this:

http://p.sipsolutions.net/9c830800d14f3ff8.txt

johannes


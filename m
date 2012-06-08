Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2FHSiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 14:38:16 -0400
Message-ID: <1339180693.5748.33.camel@jlt3.sipsolutions.net> (sfid-20120608_203819_464348_F34341B0)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Andre Heider <a.heider@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Date: Fri, 08 Jun 2012 20:38:13 +0200
In-Reply-To: <CAHsu+b8M=KGyp9PL5hJ6cxgF=1kGXHoUt7idLA+UD+UqoJW6uA@mail.gmail.com> (sfid-20120608_202844_443710_C05C013D)
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
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
	 <4FD22727.7000500@lwfinger.net>
	 <1339172904.5748.18.camel@jlt3.sipsolutions.net>
	 <20120608183339.78a7fcbd@milhouse> <4FD239AA.9090708@lwfinger.net>
	 <1339178163.5748.27.camel@jlt3.sipsolutions.net>
	 <1339179084.5748.29.camel@jlt3.sipsolutions.net>
	 <CAHsu+b8M=KGyp9PL5hJ6cxgF=1kGXHoUt7idLA+UD+UqoJW6uA@mail.gmail.com>
	 (sfid-20120608_202844_443710_C05C013D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 20:28 +0200, Andre Heider wrote:

> > Maybe these two patches work:
> >
> > http://p.sipsolutions.net/b8912f8cad4cb3b2.txt
> > http://p.sipsolutions.net/ad2677233e6917e8.txt
> >
> > still kinda hack like it always was, but ...
> 
> Those don't apply clean on 48d212a2eec, resolved a conflict, but
> device worked and I could login ;)

Ok, so I guess that confirms that somehow PIO breaks when we configure
QoS parameters or something .. bit strange, but hey.

> But as soon as I ran `dmesg` (over ssh+wlan) I got a kernel crash. It
> scrolled by too fast, but alot of b43 stuff starting with
> __netif_schedule. Unsure if its because of these patches or unrelated.

Could be related, or not.

I still dislike the way b43 plays with this stuff at runtime, and
Michael pointed out a flaw in my patch too, so we can't apply these
anyway...

johannes


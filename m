Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:61360 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbXG3WwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 18:52:06 -0400
Date: Tue, 31 Jul 2007 00:52:05 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Message-ID: <20070730225205.GA17252@deine-taler.de>
References: <20070730023128.99E927B409F@zog.reactivated.net> <200707292021.37845.flamingice@sourmilk.net> <20070730145125.GC6586@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070730145125.GC6586@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:

> On Sun, Jul 29, 2007 at 08:21:31PM -0700, Michael Wu wrote:
> > On Sunday 29 July 2007 19:31, Daniel Drake wrote:
> > > This patch adds debug output to mac80211 operations. This is
> > > intended to sort out the issues with the interface semantics.
> > >
> > Ugh. I really hate enter/exit and especially these since they are open coded. 
> > What do you need clarified about mac80211 interface semantics?
> 
> I agree, these are a bit ugly.  Do you intend them to be permanent?

Guys, actually I looked into iwl-base.c and there are also leave
and enter statements for exactly the same mac80211 operations. I
would appreciate, if somebody could explain me the difference.

Please notify that the messages will only be compiled into the
driver if ZD1211_DEBUG is set. I could agree to take them out,
after we have fixed the multiple interface issues, but right now
they help to make the logfile quite readable. They help also to
check my understanding of the struct ieee80211_ops functions.

Asked what I don't understand about the mac80211 interfaces, I
have following questions:

Why does WIPHY has only a single MAC address?

Though ZD1211 has only one RF chip and one baseband processor --
which represents a single PHY device in my opinion -- it can
support two MAC addresses. Sure MAC80211 can give different IP
addresses to different interfaces, but currently I'm not sure, how
they relate to the address in the WIPHY.

What about add_interface/remove_interfaces and monitor interfaces?

There seems to be difference between "hard" and "soft" monitor
mode. Currently I'm not sure what the semantics is. There seems to
be also calls to add_interface/remote_interface with if_id -1. I
guess that means something like all interfaces. The expected
behaviour is not documented for that case. 

Cheers,

Uli

-- 
Uli Kunitz

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2GIH7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 03:59:09 -0400
Message-ID: <1341820743.4455.1.camel@jlt3.sipsolutions.net> (sfid-20120709_095913_791491_90DE4259)
Subject: Re: [RFC 1/3] mac80211: make scan_sdata pointer usable with RCU
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 09:59:03 +0200
In-Reply-To: <CA+XVXfdo7agXE9Osxzmda2ZWi-xQ6pvP66zktdiDJq3P6PULgg@mail.gmail.com> (sfid-20120708_182724_613583_12D08BC1)
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
	 <1341608733-7503-2-git-send-email-johannes@sipsolutions.net>
	 <CA+XVXfdo7agXE9Osxzmda2ZWi-xQ6pvP66zktdiDJq3P6PULgg@mail.gmail.com>
	 (sfid-20120708_182724_613583_12D08BC1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-08 at 19:27 +0300, Arik Nemtsov wrote:
> On Sat, Jul 7, 2012 at 12:05 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Making the scan_sdata pointer usable with RCU makes
> > it possible to dereference it in the RX path to see
> > if a received frame actually matches the interface
> > that is scanning. This is just preparations, making
> > the pointer __rcu.
> 
> I noticed no synchronize_rcu() in the start/stop scan calls. Good/bad idea?

Well, start() certainly wouldn't need it since you'd only get NULL :-)

stop() in theory could use it, but it doesn't actually matter because as
long as the interface still exists the pointer is valid. We don't free
the interface in scan stop, so we don't need to make sure that the
pointer is cleared before we continue. And in the case that we *do* in
fact clear the interface (when it's going down) we have synchronize_rcu
already in those code paths due to say the interface list with RCU
protection.

johannes


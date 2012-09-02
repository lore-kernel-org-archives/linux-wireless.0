Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab2IBXRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 19:17:32 -0400
Message-ID: <1346627885.10113.11.camel@jlt4.sipsolutions.net> (sfid-20120903_011812_969648_653D1A16)
Subject: Re: [PATCH] carl9170: connect to 11w protected networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Mon, 03 Sep 2012 01:18:05 +0200
In-Reply-To: <201209030053.28945.chunkeey@googlemail.com> (sfid-20120903_005335_540855_3166FD85)
References: <E1T89yV-0007Cn-JT@debian64.localnet>
	 <1346622503.10113.2.camel@jlt4.sipsolutions.net>
	 <201209030053.28945.chunkeey@googlemail.com>
	 (sfid-20120903_005335_540855_3166FD85)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-03 at 00:53 +0200, Christian Lamparter wrote:
> > > While the documentation hints that there's some
> > > hardware support for offloading MFP "decryption",
> > > this simple implementation relies on the mac80211
> > > stack to do the actual crypto operations.
> > 
> > Maybe we need to clarify the documentation...
> 
> Something like a special section about converting
> drivers of legacy devices like this one, or more
> general?

Sorry, I got confused. I was thinking of clarifying the *mac80211*
documentation about why the flag exists and what the caveats are that I
described below.

> > You should verify that unicast management frames are properly encrypted
> > and decrypted by the hardware (or punted to software on RX like you do
> > on TX). The danger is that the hardware corrupts CCMP encrypted RX mgmt
> > frames and software can't recover.

> At least for AR9170, there's a bit which tells the
> hardware not do decrypt any management frames: 
> 	AR9170_MAC_ENCRYPTION_MGMT_RX_SOFTWARE
> 
> Of course, this 'very' patch sets it. Also,
> in case of carl9170, it was easy to verify as
> the device can easily establish BA sessions with
> the 11w ap and the action mgmt frames are
> properly encrypted on both sides.

Ok, cool! Just making sure ... :-)

johannes


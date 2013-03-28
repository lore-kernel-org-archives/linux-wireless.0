Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab3C1WoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 18:44:16 -0400
Message-ID: <1364510646.10397.81.camel@jlt4.sipsolutions.net> (sfid-20130328_234420_090207_9B266E24)
Subject: Re: [RFC V2] cfg80211: introduce critical protocol indication from
 user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Date: Thu, 28 Mar 2013 23:44:06 +0100
In-Reply-To: <1364510577.3226.7.camel@dcbw.foobar.com>
References: <1364472669-5629-1-git-send-email-arend@broadcom.com>
	 <1364487476.10397.23.camel@jlt4.sipsolutions.net>
	 <5154B347.9080904@broadcom.com>
	 <1364506118.10397.29.camel@jlt4.sipsolutions.net>
	 <1364510577.3226.7.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-28 at 17:42 -0500, Dan Williams wrote:

> > Well, you can do DHCP a second or so, I'd think? And EAPOL much quicker,
> > of course. I don't really see any reasonable minimum time? We might want
> > to enforce a max though, maybe.
> 
> Not quite.  A lot is dependent on the server itself, and I've had users
> on university and corporate networks report it sometimes takes 30 to 60
> seconds for the whole DHCP transaction to complete (DISCOVER, REQUEST,
> OFFER, ACK).  Sometimes there's a NAK in there if the server doesn't
> like your lease, which means you need another round-trip.  So in many
> cases, it's a couple round-trips and each of these packets may or may
> not get lost in noisy environments.

Oh, yes, of course. However, we're talking about optimising the good
cases, not the bad ones. Think of it this way: if it goes fast, we
shouldn't make it slow by putting things like powersave or similar in
the way. If it's slow, then it'll still work, just slower. But when
"slower" only means a few hundred milliseconds, it doesn't matter if
everything takes forever (30-60 secs)

johannes


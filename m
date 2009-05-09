Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41479 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbZEIItd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2009 04:49:33 -0400
Subject: IPV6 testing... Re: [PATCH] ath9k: Fix FIF_BCN_PRBRESP_PROMISC
 handling
From: David Woodhouse <dwmw2@infradead.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20090506000410.GC3436@tesla>
References: <20090506000410.GC3436@tesla>
Content-Type: text/plain
Date: Sat, 09 May 2009 09:49:30 +0100
Message-Id: <1241858970.2910.63.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-05 at 17:04 -0700, Luis R. Rodriguez wrote:
> This is a port of commit
> 91ed19f5f66a7fe544f0ec385e981f43491d1d5a
> for 2.6.29.
> 
> Without this after scanning your device will set
> the association ID to something bogus and what is
> being reported is multicast/broadcast frame are not
> being received. For details see this bug report:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=498502
> 
> From the original commit:
> 
> So that a new created IBSS network
> doesn't break on the first scan.
> 
> It seems to Sujith and me that this
> stupid code unnecessary, too.
> 
> So remove it...
> 
> Reported-by: David Woodhouse <dwmw2@infradead.org>
> Tested-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Jouni Malinen <Jouni.Malinen@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Btw, people ought to be _really_ embarrassed by this. It shows that you
never even bothered to try a simple IPv6 ping to/from a machine with
this driver.

You should _ALWAYS_ test network drivers with IPv6; it exercises
multicast paths that Legacy IP won't usually touch.

A simple 'ping6 -I wlan0 fe80::217:c4ff:fe5e:dd55' doesn't even need any
infrastructure or prior setup (except for looking in 'ifconfig' to see
the link-local IPv6 address of the interface you want to ping, since my
father's laptop is unlikely to be on your local link).

And running radvd with a simple config like this is also trivial, and
lets you verify that the machines on the subnet really do pick up
addresses and routes. It doesn't need an IPv6 connection to the outside
world; the fec0::/16 addresses it advertises are site-local:

	interface eth0
	{
		AdvSendAdvert on;
		MinRtrAdvInterval 30;
		MaxRtrAdvInterval 100;
		prefix fec0::/64
		{
			AdvOnLink on;
			AdvAutonomous on;
			AdvRouterAddr off;
		};
	};

For that matter, setting up a real tunnel to somewhere like sixxs.net or
he.net (or just using 6to4) is fairly bloody trivial too.

There's no excuse for shipping stuff that fails even the most basic
testing.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


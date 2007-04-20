Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993319AbXDTTqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2007 15:46:11 -0400
Subject: Re: [PATCH] wext: allow wext users without rtnl
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <20070418140451.075370fc@freekitty>
References: <1176825010.3902.28.camel@johannes.berg>
	 <20070418140451.075370fc@freekitty>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SQP5H63wxw5KyFAx8m6z"
Date: Fri, 20 Apr 2007 21:48:41 +0200
Message-Id: <1177098521.5902.20.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SQP5H63wxw5KyFAx8m6z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-04-18 at 14:04 -0700, Stephen Hemminger wrote:

> NACK Conditional locking is bad design.
> Either lock or not, make up your mind and fix the devices.

Ok looking at this again.

We essentially have the problem that all wext users assume that the rtnl
is held during wext calls, which is mostly required right now because
they are being passed a netdev pointer and no reference is taken. Also,
there shouldn't be multiple wext calls in progress at the same time.

In cfg80211, I decided that holding the rtnl would be mostly pointless
since configuration of a wireless device can't race against the other
config ioctls that could be done. I'd have to look at the details to see
if changing the interface mac address and setting a BSSID on it could
clash.

Hence, since cfg80211 doesn't hold rtnl, to avoid ABBA style deadlocks
wext entry points to the code need to be changed to not hold rtnl
either. Or cfg80211 needs to be changed to hold rtnl.

I'm not entirely opposed to making cfg80211 hold rtnl for configuration,
it just seems pointless to block configuration of different devices
against each other when even a for a single item it shouldn't matter.
Then again, holding rtnl in cfg80211 would simplify some things because
we could pass in a netdev pointer instead of the ifindex for example.

If you think I can justify holding rtnl in cfg80211 I'm certainly
willing to change that. Global locks are just too suspicious to me ;)

johannes

--=-SQP5H63wxw5KyFAx8m6z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGKRkX/ETPhpq3jKURAuJpAKCk9p7jhe7Z8CHtqcc+iEIJAFUAggCfbr9C
tlDDBOPvc1rhvIYWjM2fA4E=
=wzZw
-----END PGP SIGNATURE-----

--=-SQP5H63wxw5KyFAx8m6z--


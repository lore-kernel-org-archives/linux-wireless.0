Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731AbXHGJtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:49:09 -0400
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070806212300.GA14347@deine-taler.de>
References: <1186178959.13315.30.camel@johannes.berg>
	 <46B3B2AD.1040509@gentoo.org> <20070804074616.GA17144@deine-taler.de>
	 <1186395427.28655.56.camel@johannes.berg>
	 <20070806212300.GA14347@deine-taler.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6zIywMl3flLdLJjqa32C"
Date: Tue, 07 Aug 2007 11:46:42 +0200
Message-Id: <1186480002.4067.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6zIywMl3flLdLJjqa32C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 23:23 +0200, Ulrich Kunitz wrote:

> I don't think so enable_phy/disable_phy is open and stop.=20

True. I don't really care what those are named :)

> A bunch
> of parameters are already set with a single function, only config
> and config_interface need to be replaced by parameter-specific
> functions. Reset should be removed.=20

Not sure what reset is for.

> add_interface() and
> remove_interface() are comparable to my enable_mac() and
> disable_mac() as you discovered.=20

Aha, but they're not fully compatible. First of all, you were talking
about multiple MACs which isn't something we're going to support
(multiple MAC addresses yes). Secondly, a WDS and AP interface will be
running with the same MAC address but have quite different
configuration. Thirdly, always doing lookups by MAC address (even if it
were possible which it is not due to WDS vs AP) is rather inefficient.

> Tell the driver on the real interface, which packets it should
> report to the mac80211 stack.=20

That's what I proposed.

> Don't bother the driver with virtual
> interfaces. The stack should handle it completely transparently.

What I'm trying to explain to you is that basically you cannot do that.
AP vs WDS interfaces, lookups by MAC address, beaconing, ...

> Don't call the driver before open() or after stop() is called.

Do we do that? In any case, it's rather orthogonal to the issue at hand.

johannes

--=-6zIywMl3flLdLJjqa32C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuD+C/ETPhpq3jKURAqRIAJ4tl6NbqKd2hxGrBLb2InpapFAJPACePo95
XtXXtwxCGOcKSxDyua1zj8Y=
=4VSF
-----END PGP SIGNATURE-----

--=-6zIywMl3flLdLJjqa32C--


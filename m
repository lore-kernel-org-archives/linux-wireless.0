Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60765 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbXFVP3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 11:29:12 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <467BDCB1.1010604@warmcat.com>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621143558.68fc8e4a@griffin.suse.cz>
	 <1182429920.21939.1.camel@johannes.berg>
	 <20070621151441.500d62d5@griffin.suse.cz>
	 <20070622154545.29eeebdb@griffin.suse.cz>  <467BDCB1.1010604@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-veIBgfr4Z9YJcenR6VHi"
Date: Fri, 22 Jun 2007 17:30:21 +0200
Message-Id: <1182526221.21939.94.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-veIBgfr4Z9YJcenR6VHi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-22 at 15:29 +0100, Andy Green wrote:

> > I have a new idea. Maybe it will turn out to have fatal design or
> > implementation problems, but anyway.

> But for any nontrivial use, you need to capture RX and not blindly
> inject, and so you have a monitor mode interface up anyway.  The
> footprint in the political networking space is less if it just goes in
> as a monitor mode TX action.

In addition, we still have the problem with receiving encrypted eapol
frames etc. that we really need to see unencrypted but can't make it to
the network interface.

I'm still for using netlink. It's just a socket too after all, and
what's the conceptual difference between packing network packets into
other packets or packing them into netlink messages? I don't see why
people are so dead set against using nl80211 for the userspace MLME
needs including frame stuff.

johannes

--=-veIBgfr4Z9YJcenR6VHi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGe+sN/ETPhpq3jKURAnwWAKCluN/UHs5CgOo7ItjGdlpQOtGLmACeKmw3
eH3lffeZuzxqmytYwEQWBQU=
=HPx2
-----END PGP SIGNATURE-----

--=-veIBgfr4Z9YJcenR6VHi--


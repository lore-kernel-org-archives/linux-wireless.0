Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXIMHOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 03:14:37 -0400
Subject: Re: zd-mac80211: Fix TX status reports.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: Tomas Winkler <tomasw@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070913055608.GA8297@deine-taler.de>
References: <200709082341.31720.mb@bu3sch.de>
	 <200709111220.31700.mb@bu3sch.de> <1189506596.6161.14.camel@johannes.berg>
	 <200709111252.30291.mb@bu3sch.de> <1189508230.6161.18.camel@johannes.berg>
	 <20070911223258.GA31400@deine-taler.de>
	 <1ba2fa240709120140l56c21269p8254c790edda42b1@mail.gmail.com>
	 <1189587273.6161.36.camel@johannes.berg>
	 <1189587391.6161.38.camel@johannes.berg>
	 <20070913055608.GA8297@deine-taler.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HT2niczuYrlETi+GWTt6"
Date: Thu, 13 Sep 2007 09:15:54 +0200
Message-Id: <1189667754.6161.81.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HT2niczuYrlETi+GWTt6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-13 at 07:56 +0200, Ulrich Kunitz wrote:

> This is a valid point. However stopping the whole AP would not be
> necessary, because the stop is only required for a particular
> destination address. The destination address is available from the
> TX retry failed interrupt.

True, but there's currently no way to ensure that unless you want to
silently drop the second packet, you can only stop the whole queue or
accept all packets, not stop a single destination mac address from
getting frames.

> I would however still recommend to verify, whether rate-selection
> algorithms could work with statistics only.

That very much depends on the algorithm. "simple" can probably work with
statistics only, but algorithms such as "minstrel" or "SampleRate" will
need more detailed information. But we need a framework for indicating
hw capabilities to the rate control algorithms anyway, so this can be
part of that framework and the more advanced algorithms just won't work
with zd1211 then. "minstrel" also requires multiple retry rates per
packet.

johannes

--=-HT2niczuYrlETi+GWTt6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6OOq/ETPhpq3jKURAoqAAKCsOujn00F+EJJN23xoyejvr+k+TACeI2+C
SusHH4oMUQbAHGPCJqJLi0A=
=AQdl
-----END PGP SIGNATURE-----

--=-HT2niczuYrlETi+GWTt6--


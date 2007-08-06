Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbXHFILu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 04:11:50 -0400
Subject: Re: mac80211 driver interface semantics
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <46B30828.3000507@warmcat.com>
References: <46B27729.5030406@gentoo.org>
	 <20070803052935.GA12683@deine-taler.de>  <46B2E06F.4090706@warmcat.com>
	 <1186134894.4647.24.camel@johannes.berg>  <46B3032C.5040306@warmcat.com>
	 <1186137166.4647.34.camel@johannes.berg>  <46B304FF.3000305@warmcat.com>
	 <1186137715.4647.36.camel@johannes.berg>  <46B30828.3000507@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RnPj+Ll/zPCpq7tDiyzC"
Date: Mon, 06 Aug 2007 08:44:18 +0200
Message-Id: <1186382658.21957.45.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RnPj+Ll/zPCpq7tDiyzC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 11:49 +0100, Andy Green wrote:

> ''Because if you have both a hard monitor and a regular interface
> (monitor_during_oper allowed) then we will never check the CRC on frames
> that enter the networking path and can get corrupted TCP packets in etc.'=
'
>=20
> If the rest of the networking stack didn't trust the packet anyway and
> confirms the IP-level checksum, then it can make its own opinion about
> the packet.

Maybe it helps if I add that the FCS covers more of the packet than the
IP checksum; hence, if the FCS fails due to a bit in the area the IP
checksum does not cover we will not ACK the packet and get a
retransmission, but the IP checksum will check out as good and we'll
have a duplicate packet.

johannes

--=-RnPj+Ll/zPCpq7tDiyzC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtsNC/ETPhpq3jKURAmZIAJ4l1iaYEfxRsn/UK4wDF95lLTM2YQCfd0+I
3bc1nrLJ4cWdsqcDeXytUvQ=
=Bahp
-----END PGP SIGNATURE-----

--=-RnPj+Ll/zPCpq7tDiyzC--


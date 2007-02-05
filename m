Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33006 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbXBERx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 12:53:29 -0500
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200702051245.35452.flamingice@sourmilk.net>
References: <20070131013717.GA28076@tuxdriver.com>
	 <200701302146.05289.flamingice@sourmilk.net>
	 <1170325092.2236.17.camel@johannes.berg>
	 <200702051245.35452.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-A03yEjQN+YPU1yYzDUau"
Date: Mon, 05 Feb 2007 18:49:55 +0100
Message-Id: <1170697795.3572.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-A03yEjQN+YPU1yYzDUau
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-05 at 12:45 -0500, Michael Wu wrote:

> Okay then, let's not use fake frames then.=20

:)

> Let's make monitor interfaces=20
> resemble monitoring ethernet a little more by reporting both RXed frames =
and=20
> TXed frames. *BSD does this too and it makes running ethereal on monitor=20
> interfaces much more useful.=20

We do this right now afaik.

> TX frame reporting can be done simply in the=20
> ieee80211_tx_status call, allowing the TX status to be reported on real=20
> frames.=20

I don't quite understand this comment. TX status reporting should go via
nl80211.

> Doing this is actually somewhat orthogonal to packet injection via netlin=
k or=20
> monitor interface, but if we are reporting TXed frames with a radiotap=20
> header, we might as well allow frame injection with a radiotap frame for=20
> consistency.

Well, it hasn't got much merit because for anything useful you'll need
to get state information on nl80211.

johannes

--=-A03yEjQN+YPU1yYzDUau
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFx25D/ETPhpq3jKURAnpkAJwKd9oD1vGg1TrA0NI+C8gK9IR8BACeIbwg
od7BuU5xH1HcXZ1IL0iZaoM=
=lgEP
-----END PGP SIGNATURE-----

--=-A03yEjQN+YPU1yYzDUau--


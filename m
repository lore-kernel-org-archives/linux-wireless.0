Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbXHTMaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 08:30:21 -0400
Subject: Re: [PATCH] Add iwlwifi wireless drivers (resend)
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1ba2fa240708200510o3caab2e8uf477ee2fe3da8b7f@mail.gmail.com>
References: <1187328536.5763.137.camel@debian.sh.intel.com>
	 <1187349981.23489.162.camel@johannes.berg>
	 <1187578610.5763.232.camel@debian.sh.intel.com>
	 <1187608932.6090.87.camel@johannes.berg>
	 <1ba2fa240708200510o3caab2e8uf477ee2fe3da8b7f@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3wWiy2SkFg7rhCGX0zqD"
Date: Mon, 20 Aug 2007 14:29:43 +0200
Message-Id: <1187612983.6090.108.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3wWiy2SkFg7rhCGX0zqD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 15:10 +0300, Tomas Winkler wrote:

> iwlwifi has notion of 'station' in driver and firmware. The whole
> instance of station including keys has to be removed on association
> lost. We need get at least mac address of the station that has lost
> association into driver to do that. There is not comfortable interface
> right now mac80211 to do that. The same goes for association process
> where station has to be added we use rate scale init for that right
> now.

Thanks for the explanation.

> There is some table_notification handler but it only updates driver
> about number of stations.

Right. In a recent patch I removed functionality for setting a NULL key
to the hardware for such STAs and remarked something along the lines of
"If hardware needs that, we should not abuse the set_key() function to
notify it of new STAs"

Seems that is the case with your hardware as well as some atheros
hardware the code was initially written for. I'm sure we're willing to
consider patches that extend the sta_table_notification() handle to
include the MAC address of the station that was added/removed.

> There was a whole discussion we led about if rate scale algorithm and
> notion of station should separated from the driver or not. I'm not
> sure it was closed yet.

I only recall the rate scaling vs. driver but nothing about STAs.

johannes

--=-3wWiy2SkFg7rhCGX0zqD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyYk3/ETPhpq3jKURAlXPAJ4idYcPrkvRbHVkT2/867hvtreWtACgu/LA
W5K45ENKALVhiYABFuGa80k=
=QjMa
-----END PGP SIGNATURE-----

--=-3wWiy2SkFg7rhCGX0zqD--


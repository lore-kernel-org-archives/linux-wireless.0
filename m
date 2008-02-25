Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbYBYUrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 15:47:07 -0500
Subject: Re: mac80211: sta info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <20080222155704.GD3067@tuxdriver.com>
References: <1203677069.26341.52.camel@johannes.berg>
	 <20080222143745.GB3067@tuxdriver.com>
	 <1203693409.7082.30.camel@johannes.berg>
	 <20080222155704.GD3067@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4ynaM8pjIrwH4aA6qtbF"
Date: Mon, 25 Feb 2008 21:46:53 +0100
Message-Id: <1203972413.13162.163.camel@johannes.berg> (sfid-20080225_204711_987639_0B95C763)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4ynaM8pjIrwH4aA6qtbF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-22 at 10:57 -0500, John W. Linville wrote:
> On Fri, Feb 22, 2008 at 04:16:49PM +0100, Johannes Berg wrote:
> >=20
> > > > Hence, I think we can actually get away without more locking if we
> > > > protect the flags better. Should we use a spinlock or the atomic
> > > > set_bit()/clear_bit()/etc. operations?
> > >=20
> > > Using the atomic operations seems appropriate to me.
> >=20
> > Right, but I figured if we could get rid of the AMPDU spinlocks and jus=
t
> > use a single one in total (for flags as well) then that'd be of benefit
> > too; even with the dynamic allocation strategy (see other mail) we'd no=
t
> > need to allocate two more spinlocks for ampdu.
>=20
> Yes, I thought that was behind your question.  I'll let Ron comment
> on the AMPDU spinlock usage.

Ok so the mesh code came with a spinlock too, the AMPDU code has two.

Ron/Tomas, does the ampdu MLME really need two spinlocks?

Does anybody have any objections to just having a *single* spinlock per
sta_info and using that everywhere and protect the flags with it too?

johannes

--=-4ynaM8pjIrwH4aA6qtbF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8MpPKVg1VMiehFYAQJuyxAAlXWc2zZ4KOPM0uwojFJmi+WC02da2OhB
dsPTukG3FxnlAUDk2trV/77WNbNgsEOFrbtZnplTRRSAm+UyAdNKU6mlPmKxfKx/
aGbpda9fyejvyuZL+qoIQKnajeMGtHEjvLibmwG3uvypdDZenrsYeXYtUe/oCuWE
injW2Tiy83vRCcdlkx9HErnPzmaSSjzzQQLYKooUkh0/biZ7NpXLAS9t31KugyVv
jfB/Mf8aB+BJGxE7oGk/3kVV6ihQhSNUXeiHSxzwfqEUIoXvpkF6VaObvWpvg6Wh
loBTVqgxykTbFX/kjwxMKJr03jT/4nvsx+RGXxoOLxwy5iBGFUsoQp+opMf4ibyP
N1QPJVqhj5LPppxnrMYtclPdsUdFV+KxuEIhgsJN9ivk1la7HBF5EKc/aaGWIZ5B
UGmY8M3Qg9KQOlEmGWthiKaEF1I4iiqcu7YdxkhsQ5HnRn8KwqOfV/mznKgZqZ9K
ijOv60BX5/cDsFPdsmPZnSyImCL7SlyibH5iaYrTrry479DCQnS99wXiMGC+nuXL
wo/lJDUeVIGdTfSEVeISepFONceaBwSMpGCb9qyQzzy9sqZYV61lXaXzLaUXiim2
L2/e525abbvATzu0tdadmpbt+tvWRCFcvN+9HZsUKgX1Y1LMHwa9U4tdxqidRM+v
Uhl6oY2TofM=
=haa5
-----END PGP SIGNATURE-----

--=-4ynaM8pjIrwH4aA6qtbF--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYGWOxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 10:53:39 -0400
Subject: Re: [PATCH] rfkill: detect bogus double-registering
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1216775046-9506-2-git-send-email-hmh@hmh.eng.br> (sfid-20080723_030420_536317_B0B0AFE0)
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
	 <1216775046-9506-2-git-send-email-hmh@hmh.eng.br>
	 (sfid-20080723_030420_536317_B0B0AFE0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e2Wy80cCesW9cmZZevRs"
Date: Wed, 23 Jul 2008 05:41:59 +0200
Message-Id: <1216784519.13587.4.camel@johannes.berg> (sfid-20080723_165345_327186_E54D9BB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e2Wy80cCesW9cmZZevRs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	list_for_each_entry(p, &rfkill_list, node) {
> +		if (p =3D=3D rfkill)
> +			return -EEXIST;
> +		set_bit(p->type, &seen);

You should WARN_ON so it can get fixed.

johannes

--=-e2Wy80cCesW9cmZZevRs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIhqiEAAoJEKVg1VMiehFYxnwP/RIXDooSJ+zrYEW2R/AWbbnj
plbRhckvLFlSPZSH8N4/v867qS9zo3e/fV0KcZUjQSsCaeWwFZ4ttRD5LZ7KjMYo
WssdSW9QAnGGKIGdY+hlDz0D4GpwGmJz/d4UOH/TmkJGKvJ03b0qho78DM+0FunX
cLARUiojTf0Bi+kslEGOOnQWxjrFUPZm3VDiL8yhg2nkF0xX0qimsWLfWqylKBQq
grEftS5H01LTbsME2gpRFeBpEWXhLuw6PMch46BvXnBBf1mLUrhbozGwoTwt17jY
YSxEzcQYnyD8GC9wssRN9n90iMCTlINJ5KczCV8pvN8dK1CgsEkfCazGKoo6L8EJ
tY0uP93tJvGIXiSvCEp//v4q0eu04ukNW/RMajJzjeQQnklM7lS5AFELXgOHypnl
fj43OEXkaxuQtNQNVOXOT8TMGzmFeAggc/UEI5SbW8EQpDo5D40krmeEycl5wV+/
Kj7SoluLVStVeVxGrjUiVD3nNMuiTlTyS6ORuUxvzDavjyNpwXh++aOW8gmjdbLG
D/pZ4z5yq49/c7U499M4tQHlDynKDMbOt0kYlwyFAsdm/90hEJNd7ra9Qlj+2M7c
PpW1kUZVS5BVydG4DQiFpzatUaKjRN3sXOGjcMQn/of7g+fA4sI1cDegcsIkzQz4
Qf85N9srhSHLnTPO5W2q
=3bSv
-----END PGP SIGNATURE-----

--=-e2Wy80cCesW9cmZZevRs--


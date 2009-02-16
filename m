Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53264 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZBPJPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:15:17 -0500
Subject: Re: [PATCH 06/10] cfg80211: propagate -ENOMEM during
	regulatory_init()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
In-Reply-To: <43e72e890902160109i386d78bydd36f182ed3e6dcd@mail.gmail.com> (sfid-20090216_101014_517565_73E5101A)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-7-git-send-email-lrodriguez@atheros.com>
	 <1234695674.4219.50.camel@johannes.local>
	 <43e72e890902160018r40d8c694qa1da55c9fa7ec376@mail.gmail.com>
	 <1234774345.4219.106.camel@johannes.local>
	 <43e72e890902160109i386d78bydd36f182ed3e6dcd@mail.gmail.com>
	 (sfid-20090216_101014_517565_73E5101A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b4/7ayp9B58GQKjm36mO"
Date: Mon, 16 Feb 2009 10:15:09 +0100
Message-Id: <1234775709.4219.111.camel@johannes.local> (sfid-20090216_101521_714935_F94BCAE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b4/7ayp9B58GQKjm36mO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 01:09 -0800, Luis R. Rodriguez wrote:

> We're strictly checking just for ENOMEMs which if you are getting will
> get you into problems anyway so might as well propagate that
> information.
>=20
> kobject_uevent_env() can fail for a short set of other non-memory
> related issues and those are the cases we are ignoring here including
> the possible call to call_usermodehelper() during early boot (which
> I'm not even sure how likely it is, Greg?).
>=20
> >, and then how is it different from crda
> > failing in userspace to warrant stopping cfg80211 from moving on?
>=20
> This is based on the premise that we are simply bailing out for all
> conditions on the creation of a udev event but that is not the case --
> prior to this we were disregarding -ENOMEMs which I do not believe is
> correct. Why wouldn't you want to propagate that?

Dunno, it just seems pointless to check for an error condition that
covers so few of the possible ways to fail here.

johannes

--=-b4/7ayp9B58GQKjm36mO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmS6aAAoJEKVg1VMiehFYkPMP+gLmxU5HId6R0HxxilDdQUzO
lkn1fl5OAcszIwKs9puawjFguGz3fCkAhLPDtTF6OTExno6JLmzug4K3N+q/xCW6
Hpk2kfI/mdZcINQEVrzA6CxqzgXt/NgafpvQDMNsN+AaBwvUTTFLQRBMhO+Nqj7Z
Q2mOuR3XuaEm/T94kx/QBpKyteGElCpUD8+AjrxFNtoGQDS/OkBCyZ3LRrjUMaEX
YkvKlX3pb2Vn/isD4h/4Sz/wFzICn6aFGJ1Meo3kF03rcWS8h5X9NwJ+wjX2Nj4n
Z2Q+J9VPTo5m7kF9siKCdzraAuxQqt92H/OQSiTz2+r81Ts2dON0yuH5NCYLqi30
tamzP45UTXQHKDv2FdFhV2RfnLNlXjXyjzLolZ7KAUMHt0zkAr+4bEneu0jsZwu5
FXDMTVALxJu9a9slfYnQuX928ASq8v0ekpf1owwdOvW19zeZzB30UNwtc2NhGhiz
Yol917T1LT6h9gnkddmtq7iGm1ip9yRV/qH1+TVshIrRE0kObQ5BP8bwnLHkKOzZ
6C15gTB13yGO+kphhmUp+K399vrd0hPl9Pk39tGq1O0YLHoQ4SV3XHN91uoalaaB
B/5rqaODhqN249VLjeV4UQTIg2E3TBicHtTTKKWezCJRBt5KoSS6rbh7CXif5k4i
V/XwFQMfuCG2u6/hTzBt
=mmJ5
-----END PGP SIGNATURE-----

--=-b4/7ayp9B58GQKjm36mO--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbZGWXAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 19:00:09 -0400
Subject: Re: [PATCH] mac80211: do not trigger beacon loss work if scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rossi.f@inwind.it
In-Reply-To: <1248389904.10342.0.camel@johannes.local>
References: <1248389377-30379-1-git-send-email-lrodriguez@atheros.com>
	 <1248389904.10342.0.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tCcX2cVRkqhsXH+WLZ1+"
Date: Fri, 24 Jul 2009 00:59:38 +0200
Message-Id: <1248389978.10342.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tCcX2cVRkqhsXH+WLZ1+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 00:58 +0200, Johannes Berg wrote:

> > @@ -2187,7 +2187,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned =
long data)
> >  		(struct ieee80211_sub_if_data *) data;
> >  	struct ieee80211_local *local =3D sdata->local;
> > =20
> > -	if (local->quiescing)
> > +	if (local->quiescing || local->sw_scanning || local->hw_scanning)
>=20
> I'd rather have  that check in ieee80211_mgd_probe_ap itself, so it's
> much closer to the source of the problem.

And, incidentally, not racy then.

johannes

--=-tCcX2cVRkqhsXH+WLZ1+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaOtWAAoJEODzc/N7+QmaTaUQAKydAC/CqNQZl+0jEAqiksml
NT4ccnxSihBdf26Bk7j+S8hm4A9LXNzaa/vdMTOJQrZYuCsvmZ1gZS3uLZqvwN2x
cMejHdu+mqtEdYbQjYPhHGugQvBj2gf0V7IYMGHpA1kAz0ch2Ppk+COUkKYzX+IS
egkUI6MBarm5QAegpwSW02qKVjpwoWyp+WIh/GsspZ9O6A75u+UUWaz9pdtuRcv/
RVv7DqBmS59wVckh2M1XJppZguNlx57I8zN7JdANLW1kKVr6FPVMM0ex5U2iyVlb
0C7u7rVQZMwGfPPCdQL73qPQA2u3AfJ8sDC2eH3l1jhh/vf1ZcBmKb8OOwOFa+Jj
LiNVHN+Mab+nO8ubmMCSK573RNkmdMNqC7yOoW+butNkCoXO9vUv0zs1Iv7QU6PY
RV85d/vg2iJ/k9vQQArRViB4MWxTGvC4Qf2Wq/frrPdj99yWj+AzKGZH1KRUJTel
J267L6GlKP2tS+747Q97fsniiVNjxusnSk/Xefa5v1o5JvCu8z+N+u1dJhqzu487
Sh8kdjtryHBLizA4Ng4PUr6ik5ShQ5lSJa/M2MAYV3P5u7rvUsL4EBpee/4I/hMi
7nYXRWZX+dGbYJGVLKDLaduDYJikFk7FQvv0Zguu3q2CzwLy/AaID3orKHOfK1U2
qVuLBsOJfBRGet52xnbT
=N4r8
-----END PGP SIGNATURE-----

--=-tCcX2cVRkqhsXH+WLZ1+--


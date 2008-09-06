Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYIFWZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:25:38 -0400
Subject: Re: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8rDBHwrQGp6Fw/EpTp5W"
Date: Sun, 07 Sep 2008 00:25:30 +0200
Message-Id: <1220739930.21016.6.camel@johannes.berg> (sfid-20080907_002542_014456_D81314E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8rDBHwrQGp6Fw/EpTp5W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>=20
> +static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
> +                                  struct ieee80211_if_sta *ifsta, int de=
auth,
> +                                  int self_disconnected, u16 reason)

I think you should use bool for those two (deauth, self)

> +	rcu_read_unlock();
> +
> +	sta_info_unlink(&sta);

Those need to be the other way around.


> +       ieee80211_set_associated(sdata, ifsta, 0);

This whole set_associated(0) vs. ieee80211_set_disassoc() business seems
fishy to me, can't we just move the set_associated(0) code into
set_disassoc? AFAICT there's only one caller now that calls with (0),
and that's in set_disassoc().

johannes

--=-8rDBHwrQGp6Fw/EpTp5W
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwwNXAAoJEKVg1VMiehFYJ08P/1+XbczK4VID7+tSso50ynnL
0VjWcKE4Tymfs+217kTcWpmLW1fmfIx9bfeC5La6RtL3IJ6M7HrX16TnnOigr/hd
fcfTfqRs7P2ZbuubSdGAdBBYq2XyRqYUyOWwpkPDtTehldFqh+PXYG8LzU+KLLJN
ndooL4TaA7GCQQB3fHFkBObIpMxI0Z2x1I9jdxMXHAEhQ3J17hhMhdi7jcCvEiy6
YUT79QtTdEXgGrIauu5hDs8L8CLZktxsOtimkCpkjrhySt7X9CvYOlYZomA2Ki3w
MlNTxgh2SJk9sly0pA10dJyeSxYGgab92qL6JELrYPYkLouoz2rPeOXWWAXhPyGW
MtPVat55OxTjdvoFzVdcykbQpCcZ1y46I5zcsJKiD10++QqbkzTpXx0GhOFFYTAP
JTjBp8h3DTqAfko/3cz/tVdWSMV1Ti/VE11hJDwybatiRcd+crsAwdsrF75Nno6j
UwFioRX/S3cL27uBhvDwT92iPQjmoE2uoDTJfKrhj4dAQ9O84zzFcVZfcFBJcdY9
F4GG2iE0T+Sdt6TvFDLGi+97DdkXs9xX+YyKDftLV57Qi9bUqe9K8pMZep4+i8pe
CsKXlJCuUpSMofSCi5JteHhf7v3qL0TT5fQLIjSz82kHX7CpuBZab27tPXN/+2s5
ThDC16Yvq64H2ZEkubW8
=dq4Y
-----END PGP SIGNATURE-----

--=-8rDBHwrQGp6Fw/EpTp5W--


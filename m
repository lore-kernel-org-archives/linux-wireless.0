Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbZBZQzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 11:55:24 -0500
Subject: Re: [RFC] nl80211: Authentication and association events
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090226143758.GB24380@jm.kir.nu>
References: <20090218200210.GA13955@jm.kir.nu>
	 <1234988740.4023.51.camel@johannes.local>
	 <20090220192557.GA17914@jm.kir.nu>
	 <1235440527.4455.45.camel@johannes.local>
	 <20090226143758.GB24380@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rGv8kAqVwhwcmeKsMH21"
Date: Thu, 26 Feb 2009 08:48:46 -0800
Message-Id: <1235666926.4099.2.camel@johannes.local> (sfid-20090226_175527_582706_BE58DB4B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rGv8kAqVwhwcmeKsMH21
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-26 at 16:37 +0200, Jouni Malinen wrote:
> On Mon, Feb 23, 2009 at 05:55:27PM -0800, Johannes Berg wrote:
> > On Fri, 2009-02-20 at 21:25 +0200, Jouni Malinen wrote:
> > > +enum nl80211_auth_type {
> > > +	NL80211_AUTHTYPE_UNSPECIFIED,
> >=20
> > This seems a little odd, is that really useful? And if it is, what do w=
e
> > do? Try all?
>=20
> This is not supposed to be used and was there only to follow the
> do-not-use-zero-in-nl80211 policy.. However, it looks like the example I
> used (nl80211_iftype) actually uses the unspecified value or well at
> least it is documented as something that could potentially be used. I
> can just remove this and the _after_last, _max from here since they are
> not really supposed to be used anywhere..

Oh, ok, well you only need to reserve 0 for attribute numbers, not for
attribute values.

> > Should we have some more code in cfg80211 to keep track of the BSSes
> > we're authenticated/the one we're associated to, and have some commands
> > to query those from userspace?
>=20
> It would probably be useful to add this eventually. Whatever is
> requesting the association has most of the information, but it would be
> could to allow other applications have access to it and also remove the
> need to store that in the control application.

I guess we'll kinda need that to have iwconfig print out something useful.

johannes

--=-rGv8kAqVwhwcmeKsMH21
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJpsfsAAoJEKVg1VMiehFYLzAQAJiQXdsFYf37PUlLI9iBfKwP
kMF0ADQRryBbb9T9ySJZ+T/nGmXwN3kbWWRTKP8CNRbscmciRobM6ZN4WaSIC3U1
xdkUsYYoqSdkNidj+fV5ykH3p2GeUMp9oH03jmOsN+AUAzSwUXYy/zNF6FeGtHFa
hlp34Blm/oa8cCC/7j+PmZDv96Xh+lelK01DwGBltJvWoO7YKBMkZlKiSNjJ7qbE
+SxwXeBhJiLoZOSo0Ex1+UCgOVL3EivTOCZyavVw+bWbWQhKOTnYFh9eV1Wb6+LP
7n0GZ7nVU3XgRi3TzNP5P4m2Nc7MnSHpf18rd7BQmILUPWqI3vu75uXK9Iuy/2Yq
YHsoT7TXEHcPsYhwsjGEVpfifpidxdCZ5UmAWLuIIU9YzDsZctAZ2hudyCuJpcI7
T0244bCIaF47fk0n3z80vfOXeTFKDIwtPIgRasmVrsixsrO/ZZTF9faC2I4iD7Wn
BMfBZWvCgOx0AKZPAeFchms1eehjFicHW+HxCYrkk55sdcFkKRb5S6ZevIGY2auJ
k5nzqjycbJwpwXT9oEmpZpfQfLBgHiIKPsfJZ/o54B1auIPF77e4QBSzkaIa7pWn
U5KGpzJu0/U+yW7Qhv+FS1fezJdaLtTlzitmoR4ZvHK5I+kKXnvh8aCq8YnNxszJ
Lvn6TWm95WPBXf7nuF+2
=4SpO
-----END PGP SIGNATURE-----

--=-rGv8kAqVwhwcmeKsMH21--


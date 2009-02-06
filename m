Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZBFUxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 15:53:43 -0500
Subject: Re: turning off IBSS (with wext)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1233953398.3476.11.camel@localhost>
References: <1233928622.4175.9.camel@johannes.local>
	 <1233938496.28437.10.camel@localhost>
	 <1233952826.4175.21.camel@johannes.local>
	 <1233953398.3476.11.camel@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZshPrlbTyi/+R/CLPAX6"
Date: Fri, 06 Feb 2009 21:53:39 +0100
Message-Id: <1233953619.4175.34.camel@johannes.local> (sfid-20090206_215347_399581_A56B6626)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZshPrlbTyi/+R/CLPAX6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-06 at 15:49 -0500, Dan Williams wrote:

> > > >  * wpa_supplicant (or NM?) will try to do SIWMLME(disassoc) in IBSS
> > > >    mode, which seems kinda wrong. Why do we accept it? We send out =
a
> > > >    frame and then do nothing else.
> > > >  * Then I thought "iwconfig wlan1 essid off" - but that fails with
> > > >    -EINVAL due to ieee80211_sta_find_ibss
> > > >=20
> > > > It seems to me that either one of those, or both, should actually t=
urn
> > > > off beaconing.
> > >=20
> > > Either one; the supplicant uses SIWMLME(disassoc) at various times (l=
ike
> > > when leaving a BSS), and NM will sometimes set a NULL SSID when
> > > deactivating the device.
> >=20
> > Fun. Neither one actually works.
>=20
> Yeah; I had to recently patch wpa_supplicant to really disassociate at
> Jouni's suggestion; just telling the driver to disassoc isn't adequate
> in all cases, because some drivers will just try to reassoc.  Instead,
> unlocking the BSSID and setting a bogus SSID will usually actually
> accomplish the disassociation in addition to the MLME disassoc...

To be honest, I'm not sure I like disassoc, it doesn't actually make any
sense since we never associated. OTOH, wext claims we did... It's all a
little fishy. What do you mean by "bogus SSID" here? Hopefully the empty
"off" SSID I had in point 2? If so, I guess I'll make that work, or
something...

johannes

--=-ZshPrlbTyi/+R/CLPAX6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjKNQAAoJEKVg1VMiehFYwtkQAJeO2hbng6uPGjHyphPGENYk
W6rz4kCl4gefIFEitgJzKeGXVqqK8839rcAGxRr1UoLXWak8aQDbkOC59yS0oIbF
Z+eW/A2jEuqeFYWFdp9IJWJYXsuNAPPvjlgzO5dl1UUFkDy7IRnRi+zByV+G364j
o0xJMutkS98lc1YIEIdzOqHaBsj4/c1rV5Tce6I1yimEN+eDZL0yOU4WGt7P5A38
KaVVTfKFRQvfnYNH39s/esM10xVXPDTl+ytuHAFwVFEhibiul5g+r0M1NdyO0Ez/
qZ6t8635ZwveUvCOL1lYvXNuNToLzBUfn2Zi3g7buFEgG6HCWixd68wJmzo5/nFf
EHqZj+KI4hYoiofoF/DRpO9EjCt9OADOcmWFgBDFRfaP+a1YSdsnE062yafnFFqU
S4W0l6PF334y8ICaCAHuZ0GUdsCN5ZeIsDi+BEvT8j9x+3ajX+r29NyF4Tb9r1nj
UhHN7YmG4KE7mRrHoTnnoSsSMY6lGicjLPB9WvHYqCELgDMJLSzwN7wZ/VQ5uG12
BK1WWcfxcwAcHM/ncOyKtDT3gsiRd7VkqVzepf5cUBvAH31ZBwuW4V1YMBHO7vCm
yHMo9CailElT/BqGZBb8Kft2Hv4F21/eWLmVfQVb/n77X5fmjRsnyUjFlvaVPqjv
GyQD/GOOwBTYDZMNQ0hK
=j0O8
-----END PGP SIGNATURE-----

--=-ZshPrlbTyi/+R/CLPAX6--


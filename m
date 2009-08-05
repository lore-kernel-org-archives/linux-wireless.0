Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbZHEFfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:35:47 -0400
Subject: Re: [PATCH] wireless: display wext SSID when connected by cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249450026.4069.111.camel@debian>
References: <1249437950-8059-1-git-send-email-yi.zhu@intel.com>
	 <1249449590.4168.16.camel@johannes.local>
	 <1249450026.4069.111.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+Hb+tfFeNctoSLeKyQNR"
Date: Wed, 05 Aug 2009 07:35:43 +0200
Message-Id: <1249450543.6902.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+Hb+tfFeNctoSLeKyQNR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-05 at 13:27 +0800, Zhu Yi wrote:

> Yeah, I'm lazy to parse the current_bss.pub->information_elements for
> SSID in the first instance. Should we implement some beacon parsing in
> cfg80211 or move ieee802_11_parse_elems from mac80211?

There's ieee80211_bss_get_ie() in cfg80211, which doesn't give you the
length/data in two separate values, but otherwise behaves pretty
similarly. IOW, something like

const u8 *ssid =3D ieee80211_bss_get_ie(bss /* or &bss->pub */, WLAN_EID_SS=
ID);
if (ssid) {
	ssid_len =3D ssid[1];
	ssid_data =3D ssid + 2;
}

johannes

--=-+Hb+tfFeNctoSLeKyQNR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeRosAAoJEODzc/N7+Qma5hMP+wTl+vr+bGS5q2NoWLWtsJtC
PkKVRWvpFoNPc1KK6mzjesLr0LxKOi1pvZaaEsFog6fAOwsFuUgIetjtqpscWTMZ
P4JIGBrk4fAXano/INrTwwiITLDNxv8Hcjr8vYzQxerRFMthUs9SG7iWeul5UhIv
TIMR7iWQRb+VMIbi7RSwNfWQAJQZaI8clhWL3RUaahkxU57dIpytVZp6vhQWIH8w
bE+3dAMc5efWA4+QicSccfseCVZMF+eKR7gVtEDh9GQNO1+BakUmI9+fqyL7HcWb
TykoIjlajUj6gckTSLfVMoJTqmgh6hbKLbsWfIeJY/KNtJVx0RYZauqUyhkJkCg+
5G8IbDkttKC0RfOe++p1A5wZ5X9rXZrnWHY+YcN2XypFkbEUfKNXLHDmWhRiV0fx
LTOMJ8vwEdMZgdFwMwYfZlIwfoCluHiLCzonUUMG/NSyWa85zWCvYql5NsuGRywH
rY1+cd8SJOiyCp0GPS5gd4/6PYyeWsAVS0ZPkGNGwqdJ/BBfFExr3i4swJwqGa1E
qbw0zCN2srF/qlgRpxzwRVqJErC26+QvPquJgT+GZqdHZ6Fw8/sR/DwpufUxlRyT
NkTAceJsDbpdX/kNp3JSIDOli8oocelXaHGhJUgaWwVK5BlV6XBgdarWcyDipf8V
H+hloUU1nW5DlUHoxaZU
=0b/Y
-----END PGP SIGNATURE-----

--=-+Hb+tfFeNctoSLeKyQNR--


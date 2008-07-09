Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44526 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYGIHrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 03:47:46 -0400
Subject: Re: [PATCH 5/6v2] mac80211: rx.c/tx.c remove more users of
	tx/rx_data->fc
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1215558787.476.56.camel@brick> (sfid-20080709_011311_528701_419BB7BC)
References: <1215550044.476.43.camel@brick>
	 (sfid-20080708_224734_565441_65F98FD9)  <1215552534.3670.20.camel@johannes.berg>
	 <1215553540.476.49.camel@brick>
	 (sfid-20080708_234544_948979_2D1B0842)  <1215554768.3670.22.camel@johannes.berg>
	 <1215555934.476.52.camel@brick>
	 (sfid-20080709_002538_307988_869EF96A)  <1215558277.3670.24.camel@johannes.berg>
	 <1215558787.476.56.camel@brick> (sfid-20080709_011311_528701_419BB7BC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ow+ZHFACDsPwp3Znx959"
Date: Wed, 09 Jul 2008 09:47:00 +0200
Message-Id: <1215589620.3670.33.camel@johannes.berg> (sfid-20080709_094748_972769_AD519078)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ow+ZHFACDsPwp3Znx959
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-08 at 16:13 -0700, Harvey Harrison wrote:
> On Wed, 2008-07-09 at 01:04 +0200, Johannes Berg wrote:
> > On Tue, 2008-07-08 at 15:25 -0700, Harvey Harrison wrote:
> > > Those functions that still use ieee80211_get_hdrlen are moved over
> > > to use the little endian frame control.
> >=20
> > > -	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
> > > -	case IEEE80211_FCTL_TODS:
> > > -		/* BSSID SA DA */
> > > -		memcpy(dst, hdr->addr3, ETH_ALEN);
> > > -		memcpy(src, hdr->addr2, ETH_ALEN);
> > > -
> > > +	switch (hdr->frame_control &
> > > +		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
> > > +	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS):
> > >  		if (unlikely(sdata->vif.type !=3D IEEE80211_IF_TYPE_AP &&
> > >  			     sdata->vif.type !=3D IEEE80211_IF_TYPE_VLAN))
> > >  			return -1;
> > >  		break;
> >=20
> > Looks good, but didn't you just lose all the memcpys?
> >=20
>=20
> See the three lines immediately before the part you quoted.

Oh I see, sorry. Wouldn't it be more efficient to keep it inlined in the
switch though? Or is the compiler actually smart enough to move the
inline into there?

johannes

--=-Ow+ZHFACDsPwp3Znx959
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdGzvAAoJEKVg1VMiehFYIDIP/Rev9foUJxTn/sG4/cTdItbb
ZZdqZjRhYxVH7fz4wHCggso1G4lImauc4IGlPmXGmR2nOhHW814U8afPS7VAZPEP
lfWkig+87vqXNJerCfL4VkVw5MLMgDYOjMK1TsrEy/c4l4kj5ScnEzKSAGe//vAt
0WxEgIG+PhYCPqUZiQjWMRdyIp/BA/874Kyo54XwRv4x3sjf5Xk8K1HypNQ2Q/ge
Zzz5U3CQaQCTXNgBY2YXLiWn/AP+/DyKXPzu1jjPBGlau0Wr0bW8+CQlF6UF/1pn
SWwTLeKV7wFPyiVCRy/9S4yKQjEytgZyZKxcHar+uWisY5iXe56WjrrHsoA7vGx6
V45s+NEsG+r5lNHqKkffii/jLZrr8Nnn3S8MrmFbEkogMAX5xa4DEJEyDYQtNFMe
keWV7FkPJYWvjDTFUf0wrJSiTOwcaFPVCQihtCqLebVHRtMX9ex74RUx0QSsX4Ol
6rrqca6uYFdTQTl6rB0aqkedljNpmUFS47Pnzo0QCY7fHLfoO24TUhDQ9Efj7bk4
38010LEnoLhuRnbVJOXYbQykfPjRZ212B3uAzoIpokt7j3jIbC/fUnP7hGVSRtqZ
sNEoQq+MivpjCVAAR6wBxb+jTGbg+OhnCTqqu8tZ31whEIpICQWwwmnJmUz3srMp
r8Pz11DRQECEdObbTpHm
=KQum
-----END PGP SIGNATURE-----

--=-Ow+ZHFACDsPwp3Znx959--


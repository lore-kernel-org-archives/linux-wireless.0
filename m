Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZA3L15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 06:27:57 -0500
Subject: Re: [PATCH] mac80211: convert to net_device_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <1233314257.30970.6.camel@johannes.local> (sfid-20090130_121747_128792_58F3B8C4)
References: <20090127052926.44d3fd5f@s6510>
	 <1233314257.30970.6.camel@johannes.local>
	 (sfid-20090130_121747_128792_58F3B8C4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sIiM1PbIIO3RcqifSzok"
Date: Fri, 30 Jan 2009 12:27:51 +0100
Message-Id: <1233314871.30970.10.camel@johannes.local> (sfid-20090130_122800_139422_5A6BA1E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sIiM1PbIIO3RcqifSzok
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-30 at 12:17 +0100, Johannes Berg wrote:
> On Tue, 2009-01-27 at 05:29 +1100, Stephen Hemminger wrote:
> > Convert to new net_device_ops in 2.6.28 and later.
> >=20
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>=20
> John, please revert this commit for now, it's breaking monitor mode
> injection (and thus AP mode) because the xmit handler assignment in
> ieee80211_setup_sdata is not effective.

Oh, for reference:

commit e22cab741afdd1e9857ea9fe51e28a6fe3c97b90
Author: Stephen Hemminger <shemminger@vyatta.com>
Date:   Tue Jan 27 05:29:25 2009 +1100

    mac80211: convert to net_device_ops
   =20
    Convert to new net_device_ops in 2.6.28 and later.
   =20
    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
    Acked-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

And yes, it's my fault, sorry!

johannes

--=-sIiM1PbIIO3RcqifSzok
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJguQ1AAoJEKVg1VMiehFYOwUQAMCtAT3zowOJMTRZ6NEOH6kM
kDLSPsb3H07/JWwltkX8h+V3KZchVXWeH/q6t9CgpnZp3FyOjn0AEaA+mffuEnYK
dDQFZuGvgFTyP8F+YBBaMqhOQ3ceDmrxpyHcR9cUH12OftFH6rLK2qAlN0x26b+j
aqLcRtHtfxvGsvL7KOI2hrcN/+WCiOmokKQ4iZrjMf3Cj0atScY6a9Xxs0r4EZAm
r+h1dRfAYErfLec7GCGcWRWwFpfaUdvcOmvw4ycRHVwGPUBVbDo8YEmcZQnMOQLR
RsvEoTWlinebpCTTguuDpJ781jT9bZqpahPL8u56cYy/9hHxIrav0xGRlYr7YfgZ
TSDISphCScHvAdUbCkV39AvBFD9i3OqTUbFRzZBc++Mb6R2O6h2k9Mm44RqrLswq
F8uJ70N01a37bp3ql5RpXC5khdWNdVVqZxuYVm505rM4GpxbIvL6y2GlNa9fNfO9
YqvbQ0UUb2usd4uXfgRepRDRV1Sz46ZmE0FZW03k5/qZqiMtvX6kFsOdRHiHEfaI
Piwe1k9yi9RlpiZ/dhxgNUc3U7KQk632rP346g9RNDcPcyH2wdYgQwRzbwqTfDVC
h/Gvt2VzUG/18ZcPZ1yo/oNxbPSbzMNc5liSTZXoTmD0FQ/cX0xL1DEKCN8u8k1T
AhYUoyu/Kzw2zJR295UD
=ryhI
-----END PGP SIGNATURE-----

--=-sIiM1PbIIO3RcqifSzok--


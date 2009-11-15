Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZKOO1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 09:27:47 -0500
Subject: Re: [PATCH 1/2] mac80211: add private driver flags and ampdu
 length to tx info
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4B000DF5.4020606@openwrt.org>
References: <4AFED564.8030804@openwrt.org>
	 <1258293706.6294.7.camel@johannes.local>  <4B000DF5.4020606@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EwjQ2tISWfsbRpQm9ATM"
Date: Sun, 15 Nov 2009 15:27:43 +0100
Message-ID: <1258295263.32159.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EwjQ2tISWfsbRpQm9ATM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-11-15 at 15:19 +0100, Felix Fietkau wrote:

> >> + * @ampdu_ack_len: number of acked aggregated frames.
> >> + * 	relevant only if ieee80211_tx_status_ampdu was set.
> >=20
> > why lowercase that?
> Sorry, late night vim accident. I'll resend...

same a few lines down too

> >> -	/* 2 byte hole */
> >> -	u8 pad[2];
> >> +	u8 driver_flags;
> >> +	u8 pad;
> >=20
> > The ampdu_len seems ok, but I'm still not convinced this is right.
> > Drivers _should_ have enough space in the driver parts of this struct,
> > and not need flags here. I realise that you do need that because of the
> > RC and other internal things, but maybe you could simply use "pad[0]"
> > for that so not to encourage others to start doing this too?

> If you prefer it using the padding directly, I can change it to that
> too. I don't mind as long as I have space to put that stuff into and
> don't need to use rate_driver_data.

I can't really decide. On the one hand, using pad seems bad, but on the
other hand I'm still hoping this will just be temporary (for some value
thereof). But in that case I fear that we might find somebody else
started using the new field and we need to fix that driver too then...

Thoughts?

johannes


--=-EwjQ2tISWfsbRpQm9ATM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAA/bAAoJEODzc/N7+QmazNsP/AlKbsWa2EVCV/SJqBzekVra
BVAyD+qttXChwrZeMQDzh4qQXD1jn0vN4OnxgwnHBGnfssWe6MkgxAeayDGVh/3F
GHE9nUsHjEJjGIIBOHl44ySZWvqumpvDrqmuvuZOLeIlgVdMMGc3sxC7isOjgEEc
5JKvUlvVPhbHo4fX/+ubOPGgJ8vslEpZSMxuCaguPa3XLZpFY4fw5zZycYN8KSJU
61+LXJ77XRwCyC2t9DjJaS4py2p8zzVKEZu90793bCJCf0+rmLeYCdqSMrpHq+Lz
NA49Pnvr8yB9ujJEfMwc8bV6PQc0lT1cejLluq9Eo9doaSKkAEEwnrRfko0g6bbV
/tp2MhUiUY3YOcMLF4ZSDJCOqnUnzYbsowKNdh3JWLX0Nz3VCkmXEnqxbS7wnGzm
oeuupbDV70PSjUuj+g4NDKQS4FEVuEsI6uVgZf3TmPkjJEixelhA7CHA1U7eURQY
1qscLhh7rcLb2kFeWOGtAfIXnjdY0AV4F5gz7xnAnlqPlSj4817iUDsajwVILcul
KCZ7UqudIibJ3fACHhtFJDuFoTY+AwbJ6E7oNxF+MrQe4i96Y91meMku1zJmjJ5/
IIoqIWiY6c46ieGf4w+n10BuUcl/VTHXUqZRrHnc0LVifOLceo9Q389Ouix/LjGe
/RSxCw8DNX8mLfpPPUDZ
=f+yU
-----END PGP SIGNATURE-----

--=-EwjQ2tISWfsbRpQm9ATM--


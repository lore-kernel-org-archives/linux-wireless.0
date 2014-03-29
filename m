Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:30183 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaC2OYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2014 10:24:00 -0400
Message-ID: <5336D767.7050304@meshcoding.com> (sfid-20140329_152414_740039_75C528A7)
Date: Sat, 29 Mar 2014 15:23:35 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
Subject: Re: TR: [RFC] 802.11s bitrate correction in airtime metric calculation
References: <773DB8A82AB6A046AE0195C68612A31901734186@sbs2003.acksys.local> <773DB8A82AB6A046AE0195C68612A31901734187@sbs2003.acksys.local> <20140328132204.GB18560@localhost>
In-Reply-To: <20140328132204.GB18560@localhost>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hC9VTJs30Swn3T9UhBX5xpnEsGQFT9wRV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hC9VTJs30Swn3T9UhBX5xpnEsGQFT9wRV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

On 28/03/14 14:22, Bob Copeland wrote:
> On Fri, Mar 28, 2014 at 11:15:06AM +0100, Cedric VONCKEN wrote:
>> Hi all,
>>
>> I am currently using 802.11s for a project using openWrt mesh portals.=

>> All mesh points use 802.11a (non HT) and minstrel. Airtime metric uses=
 a
>> "rate"
>> which is ultimately computed using sta->last_tx_rate from minstrel.
>>
>> This last_tx_rate is also updated by minstrel attempts at lower and
>> higher speeds. Even if these occasional attempts are outnumbered by
>> frames at max_tp_rate[0], they cause unexpected airtime metric
>> variations resulting in unneeded mesh path changes.
>> My idea is to use max_tp_rate[0] (from minstrel) instead. This rate is=

>> not subject to minstrel attempts and directly reflects the speed used
>> for the vast majority of the frames.
>=20
> Interesting -- I tried this exact thing once before, but got mixed resu=
lts
> in my testing.
>=20
> Can you share your testing strategy?
>=20
> It's true that last_tx_rate is sub-optimal here, but I feel like using
> max_tp_rate directly is a layering violation.  Many rate controllers
> won't have that concept, and some rate controllers will exist entirely
> in firmware.  So I think perhaps fixing the concept of "last_tx_rate" o=
r
> adding a new "best_tx_rate" field that excludes probes and such might b=
e
> the way forward, rather than calling into the rate controllers.
>=20

Some time ago I raised a similar problem when trying to extract a
reasonable value from the RC algorithm to be used in a new metric for
batman-adv.

I wanted something that could represent the "available bandwidth", so
the first idea was to use "max_tp_rate" and its probability of success.
Unfortunately these two values are meaningful if we are using minstrel,
but mostly meaningless for other RC algorithms, therefore nobody (in
particular Johannes) liked the idea of "exporting" the two separately.

Then we realised that a sort of "estimated throughput/bandwidth" is
something that any RC algorithm can somewhat provide and that can
therefore be exported by a generic RC API[1].

The "expected throughput" should be computed by minstrel as the product
of the max_tp_rate and its probability of success.

I talked a bit about this with Bob on IRC and it seems that this could
be a viable approach for 11s as well (even if it requires a
rearrangement of the way ALM is computed).


I also provided an initial RFC[2] that was then rearranged to follow the
"exported throughput" idea but was never re-sent to the ml.

If you think that this is something that could be helpful for you as
well, I could send the new RFC soon so that we can all discuss on it.


Cheers,


[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/118501
[2] http://article.gmane.org/gmane.linux.kernel.wireless.general/118403

--=20
Antonio Quartulli


--hC9VTJs30Swn3T9UhBX5xpnEsGQFT9wRV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTNtdqAAoJEEKTMo6mOh1V1lsP/jhMHUmxc3iD3q8dJ77UWdz9
ZEzm8biDlC0YOJbcSgHO5RHO/hYS7j287nHI0D9PhrjZ2LYetHx4iq2wZxx9ZZko
7Pxxy/CwE5+rEQYX6esJa8WCGSMXBNz0UlVtD0QtI9/reulzHZ+BLaN0B+AWGKNa
gd+y/nKrBKHdh2ST4vFxeqkRabjgQSVTzNbW1KwJ6XKZNcH/rRn7h3Vy1AC0sT2C
NJnmSJVk5cbizoawx9YLks8wlynZOo4AbeBl7euRnsUTP3jZdm4+XrDICa5va0Cw
Y7ZuhbKRpxdNp4YJy4v2/gPcLulnQYy6k9qm+Y9FVG/1ulfDmMBop3LcNkY+5zEh
inUiSIwiN1HQJod1kxuFlsvI+Jl6/2vJlAzj8+Tg4sibgfAjEJDCUQovDpQ43rKe
1FEJCBLF9cn3pXb3Ps3L6tk0RKyass2XinC5G0hQ6LbRjtuYQHR5VAenyvNYPZRk
xHm+erx5GnPiWaOU7KQbWf1o68bkNqD+fPZ/hjXcIYQsu6qxdKoszaxlKm6Bizav
tDQd57HUInhUeU4hvmL61W2QcVg4fnLYLfDOFgOLdr5QcG0I0IsRtWqEhp0mCY/G
t36kwB//VHaKFeI133xAlMM2cF8PDDS2syh69+oNtNukjE2l24Ft9r/b+ej6bVpy
xggmtXjUz3lL8QDyu0K/
=hQ3D
-----END PGP SIGNATURE-----

--hC9VTJs30Swn3T9UhBX5xpnEsGQFT9wRV--

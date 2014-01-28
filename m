Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:44916 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaA1Ncv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 08:32:51 -0500
Message-ID: <52E7B134.2040404@open-mesh.com> (sfid-20140128_143254_493473_64B18EFA)
Date: Tue, 28 Jan 2014 14:31:32 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Subject: Re: [PATCH RESEND mac80211] cfg80211: fix channel configuration in
 IBSS join
References: <1390913540-2127-1-git-send-email-antonio@meshcoding.com> <87wqhkgszo.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87wqhkgszo.fsf@kamboji.qca.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BdJrLqsqTsbSQFVjt55V6mqVumXKLCcIG"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BdJrLqsqTsbSQFVjt55V6mqVumXKLCcIG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 28/01/14 14:01, Kalle Valo wrote:
>> - Patch is getting resent because I did not CC'd the linux-wireless ma=
iling list in
>> my previous attempt. :)
>=20
> Oh, I missed that. Anyway, in previous version I  commented about
> documenting NULL usage. What do you think about that?

Well documentation is always good :) If it is need I will add it.

However, I'd rather ask you what ath6kl is trying to do in that case,
since it's the only driver invoking cfg80211_ibss_joined() with a zero
BSSID (and now a NULL channel) on IBSS leave.

=46rom the cfg80211 prospective, that call is seen like a notification of=

being connected to a new BSS having zero mac and NULL channel. I don't
see how this can be useful at all, also because after leaving the IBSS I
imagine that no other operation will take place on that vif unless it
reconnects again.


Cheers,


--=20
Antonio Quartulli


--BdJrLqsqTsbSQFVjt55V6mqVumXKLCcIG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS57E4AAoJEEKTMo6mOh1VXyUQAIZf/wLL21VHcX9XGKEwtIGb
9LQqNKHvyRHe2Lxf9pRqhGNu1oySFZf/LB088ejxnak8h47UFriFkqNMIfdQpAIk
Y20p4WSMpbvi8k+7rdd7eX5wCYQewziXF28tYewJRr+t0ii/TbfBU2zURJ4wWJAZ
75W9fg7r6BNuk9R/raEkMSyf95RvcCxd/M6kp7hH+hyqf0+DAge0vhOsM9MhO9OH
sQDrXiDGmGKS3+rOAyzgpVSObRJTFQKIMPTFdiJQO6Pu8iDic7U5cON4s3wgmV59
SNKMIfTOb5ZyOmAQ6hAIDUHMi2pP70c9FveQGxA2E4AQIDA7Ge0kxzKmuoD8v6pG
ubR16N08l9VuDEOyZm7WMcZ4AuIhbRgGEEHKRy5YlY7kZ7zhwCXuMbUg15sHFcbz
L8KNUF0TbzV/WUSshpv75/XvtwZPxGuffJPQVD19HWdUOTX3mghFO2iV7uVJVHAp
kM6zNeN8Rf44DvYvkohUBWkN4IyXLQhCkZvOpv5zxQ3d4HCBR9OzVD4KAfbPP6YM
aYKqH668B5XWBuVlr6Lvy022kKD7io1Z3FGx1iEGXhvaI27NbspxI4fQGARyolOs
GEbnDLRhn/82W2HnyV5oySwDQLNBLQX0UoB+x+UUBzNt//ekhM+Iufr5OGe18xre
DEaV9K+gb30QOsEdE3qP
=ltxt
-----END PGP SIGNATURE-----

--BdJrLqsqTsbSQFVjt55V6mqVumXKLCcIG--

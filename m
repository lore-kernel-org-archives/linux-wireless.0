Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbZD3Lx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 07:53:59 -0400
Subject: Re: [RFC] regulatory information interpretation rules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Richard Farina <sidhayn@gmail.com>
In-Reply-To: <1238065059.4331.28.camel@johannes.local> (sfid-20090326_115820_137341_2C611338)
References: <1237712542.5100.766.camel@johannes.local>
	 (sfid-20090322_100234_495492_0385D4F0)  <1238065059.4331.28.camel@johannes.local>
	 (sfid-20090326_115820_137341_2C611338)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ck2q6Zb7J8de75Ld7Gl5"
Date: Thu, 30 Apr 2009 13:53:21 +0200
Message-Id: <1241092401.29878.1.camel@johannes.local> (sfid-20090430_135404_495596_A4A7DA36)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ck2q6Zb7J8de75Ld7Gl5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-26 at 11:57 +0100, Johannes Berg wrote:

>  4) This is easier to formulate algorithmically:
>     USE_FLAGS =3D 0
>     for k =3D 1 .. n
>         if CENTER in (MIN_k, MAX_k]:
>             USE_FLAGS |=3D FLAGS_k

That wasn't what I intended... What I did intend to say is this:

USE_FLAGS =3D 0
for k =3D 1 .. n
    if (CENTER - BW/2, CENTER + BW/2) intersects (MIN_k, MAX_k]
        USE_FLAGS |=3D FLAGS_k

since we want to take into account all flags even if the channel just
overlaps a little with a specific range.

johannes

--=-Ck2q6Zb7J8de75Ld7Gl5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+ZEuAAoJEKVg1VMiehFYa1oP/1SGfNsOUJHtKwaTADkmdMb4
ruufPSl76EUqacLI+PlZyALXCatBOEsZjJVH7neM7AoihpP+q27blAOoHjc4JqIe
zkIn3iBpoFhVI2KVupiwjy1CsHO+GzYK3IOkwwhr7Z7TWfZOSkeibus3fzFfm6N4
vc1sJ0blMbTUSkvb0sDkCuuIVTIGF77DQbjxGS+KXLy002VE93std2W99eqoQPxJ
r+PQaVH9OAGefQ0tujhQTMd8HTLaqxczyiFV7kMY7E/999VuEMA3xtxrH/K9VuHE
XqevJ1S9wFnvQVyLlc7lkehPEK9LNML7KQd6o2b9vA5jLkWBZx6NtcKuplKhKE4q
OlZY0BkZqZkttCe12v9WQSzTXaJkLO7QqQYueV7yJiGECYqz/WNScrTBo/YuTj56
pxMq5Y24pDa152qRZUR6eatX49nNMopOs0oyv5M+1A4Eoexm/fD7k31gqtV7CVuU
NpLVNiogeBbqZSFlN1iOMWuUiaTk45QtBEhD5burA7RejX6XZok5BZ8cy/g8qCjH
kLNTahbKSd0FLBiIUK39tNWV5VRIjYmrhjld+WkWGDfqDTZd/TGRyDlbesnrht9v
tmnjKV+S2spsWh+NLjnGpb73qZUAukV0O8M0g0QDiCZ1eSwyXU4jPyEnyBpb2wVt
t3XB5CwGnPECNqmOUIYx
=ugzH
-----END PGP SIGNATURE-----

--=-Ck2q6Zb7J8de75Ld7Gl5--


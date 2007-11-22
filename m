Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXKVOyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 09:54:36 -0500
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <rindjon@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <c85cb4470711220649vd83b72lf0e6ae537b359c93@mail.gmail.com> (sfid-20071122_144914_479017_8BEBD1D8)
References: <11956348193070-git-send-email-ron.rindjunsky@intel.com>
	 <1195732107.6323.84.camel@johannes.berg>
	 <c85cb4470711220649vd83b72lf0e6ae537b359c93@mail.gmail.com>
	 (sfid-20071122_144914_479017_8BEBD1D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T+XcWGUIJHiUP7JU/ee/"
Date: Thu, 22 Nov 2007 15:54:28 +0100
Message-Id: <1195743268.4149.11.camel@johannes.berg> (sfid-20071122_145444_120393_E4B13536)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T+XcWGUIJHiUP7JU/ee/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> let me suggest an alternative, which makes use of current ieee80211_is_ea=
pol.
> in regular Rx data frames, code will look like this:
>=20
> +     ieee80211_drop_802_1x_pae(rx, size of current 802.11 hdr);
> +     ieee80211_drop_unencrypted(rx, size of current 802.11 hdr);
>       ieee80211_data_to_8023(rx)
> -     ieee80211_drop_802_1x_pae(rx, size of 802.3 hdr);
> -     ieee80211_drop_unencrypted(rx, size of 802.3 hdr);
>=20
> while in A-MSDU frames code will look like this:
>=20
>      ieee80211_data_to_8023(rx)
> for each internal frame (that is any how in 802.2 form):
> +     ieee80211_drop_802_1x_pae(rx, 0);
> +     ieee80211_drop_unencrypted(rx, 0);
>        move from 802.2 to 802.3
> -     ieee80211_drop_802_1x_pae(rx, size of 802.3 hdr);
> -     ieee80211_drop_unencrypted(rx, size of 802.3 hdr);
>=20
> I thought it makes good use of the infrastructure we made so far, what
> do you think?

Yes, that would work too. I'm not entirely sure about the effect on
eapol handling but I'll sort that out with that patch then. At worst I
get to restructure the code instead of you :)

johannes

--=-T+XcWGUIJHiUP7JU/ee/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0WYIqVg1VMiehFYAQJ43A//Z35TrbwptnMOBTRiMrq3lXJAxXE8dnbQ
bXLYuYXUjLMaEKhAeF2yt8fdwkpdMiw5G9tZ5r8jCbGOscBwmEObQnkgwyEt4upR
uo+VmO/BRNiZSJi/BL7I6ybvYeCGBptLkuv/x40ew9HnGGMWosj+Qwxq04HTYbct
okfWdDMg1TMhQh5jSiT5fLcJ48e/RM32aNXegPKOPRd2uLvNVb7p8DsBTKzmrI+j
UiExZqzzjE016pIx/g8C+24T9WfGTrZQnK9/tGFOAOCe9n9XmZeB7l2eRdtdFqkb
V6WMpTiZv84ik8q4oSnXY6E1DHoB61JvlOj2zLZHAMzafjOhcOMF4xPyDJHPOPhs
pjkPK1yDQwbV8kdv0MeLGcU6c3fY0UGP/CM3YlPXF4O0bQfi+F3EQcskpUr8i6OE
F7pV9MQAdZwqn6YS+wvwNl0b6Ky4D4Owjeaa2+k/5dPoHDukzCZUm7zqeHuhprkG
7dP9U+SKGOXurSbIs9Ds4j4YufbAzwXF54WvMWCB/bwdoPrFgVWX0gO6YB8Qusvu
dSK8f5+FzwHI+D11I7WHgWVvYGyFKyHbwIZCP9RtczGwHRWILIwrumL76XdxGN0R
+iFc6j8dfoeahOoaEl5WMV36/qCRFvRXp0RBtsf4dtNkQNsjB+/0Zx4RaLFkNHPV
SjVZ8LJLS1g=
=qIkJ
-----END PGP SIGNATURE-----

--=-T+XcWGUIJHiUP7JU/ee/--


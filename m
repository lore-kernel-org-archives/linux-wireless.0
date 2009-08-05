Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZHESYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 14:24:06 -0400
Subject: Re: Status of 802.11s in wireless-testing?
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	xxiao <austinxxh-ath9k@yahoo.com>, linux-wireless@vger.kernel.org
In-Reply-To: <445f43ac0908051049wb32ea49r3e8894fd99f4ae60@mail.gmail.com>
References: <2f1373ed0908042145pc83adc5qd968e3bf8d0ce3c7@mail.gmail.com>
	 <175701.5780.qm@web55308.mail.re4.yahoo.com>
	 <20090805165021.GA20338@tuxdriver.com>
	 <1249491866.6902.23.camel@johannes.local>
	 <445f43ac0908051049wb32ea49r3e8894fd99f4ae60@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-l7jh2Oj+7P9WPQnAjxHo"
Date: Wed, 05 Aug 2009 20:23:56 +0200
Message-Id: <1249496636.6902.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l7jh2Oj+7P9WPQnAjxHo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Javier,

> I agree that there is a bug in that would cause a synchronize_rcu() in
> an atomic section when the mpath table grows beyond a certain size.
> The bug was there since the first submission of the mesh code, yes.
>=20
> However, the "bunch of bugs that appear to have been in the code
> forever" are, I believe, regressions.  In particular we've identified:
>  - Airtime Link Metric broken (fix in progress)
>  - Forwarding path broken (fixed here:
> http://marc.info/?l=3Dlinux-wireless&m=3D124698982910794&w=3D2)
>  - mpath pending queue broken (fixed here:
> http://marc.info/?l=3Dlinux-wireless&m=3D124717648406661&w=3D2)
>  - PREQ notification broken (fixed here:
> http://marc.info/?l=3Dlinux-wireless&m=3D124752948320455&w=3D2)
>=20
> We've been busy with those but the synchronize_rcu fix is next in our lis=
t.

I was really only referring to the issue with synchronize_rcu(), and the
two related things where there's GFP_KERNEL that should be GFP_ATOMIC,
although that might have been fixed? It just felt like multiple
issues/places to me that could run into this.

> I also agree with your assessment of the severity of the bug.
> Hopefully we'll get to fix it really soon so we can re-enable mesh
> again.

Yes, that would be great, thanks. I've been meaning to look into this
(if only to understand the mesh code better), but I have little time and
a lot of other things to fix that are still regressions (currently
looking at assoc vs. reassoc for instance).

johannes

--=-l7jh2Oj+7P9WPQnAjxHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKec45AAoJEODzc/N7+QmaOwgP/08oiFa3WcM+Me73SRAG8VYc
vZudJILAWONxgYx0oE67qEg9dvYF4DKjnsUkIzm3HCYiW/TgAhAazRKt3lKs2wIX
vw8rUB8M/jXaIq7rNQ3NkPuAHB9jmkRr6dNM1emvImkiAifeZP/iizwyJHr3vITZ
niWp/NLNdvgU2U3EUDbIPvXeBM4F1Wds5ydrvf48XsCH/Q0h5tPUOqTLntrrqlvA
dk+gU2aQjW07xFUZGEXDnwqt8ygt7pkpPt+wKOgfe0Z7lb//D4C64FcDrshN+DHu
YUneVQLEot4XAHa81XF/7ctq32Jxg5tPFPx+FsE30Kv7AhyueQb2SZWiAmwFaAB2
V/yvCO33spCEkvyEVy+WflTpXwQDl4daLnxfYDV2j/OS0a81SCWefMLRVhr/JCa5
LCMv3WzdRvslXQqDwxH4QFkfLwVp9JXz1BBXi7TcbBF7wEiFkpHGjMpdWvSkHzTm
WzRCnd2am/nnojgibeJbQTg3MdI9tIWIFAq7Uid+yQvwotwlGKoAVuq6r+FdLOFp
uXb0VPkGCgWIsaCeYcAjvvP9tsNgDsrjEnaHWbEMUs+kdrQM/UvIGSJgOJef34b9
+GgnN/n9MY/Bf6DaY6iU5NY165jtV4gesdpsRDciD008LqDjTdUcrIIpA6KZB5aR
Cez9qZ8B1cRI5mu40y55
=FvkK
-----END PGP SIGNATURE-----

--=-l7jh2Oj+7P9WPQnAjxHo--


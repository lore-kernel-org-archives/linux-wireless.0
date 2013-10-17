Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:23834 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3JQOs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:48:56 -0400
Date: Thu, 17 Oct 2013 16:48:24 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH 2/2] mac80211: store the channel in wdev upon ibss_join
Message-ID: <20131017144824.GH2596@neomailbox.net> (sfid-20131017_164859_007858_CBE9053B)
References: <1381790282-1146-1-git-send-email-antonio@meshcoding.com>
 <1381790282-1146-2-git-send-email-antonio@meshcoding.com>
 <1382020588.14410.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
In-Reply-To: <1382020588.14410.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2013 at 04:36:28PM +0200, Johannes Berg wrote:
> On Tue, 2013-10-15 at 00:38 +0200, Antonio Quartulli wrote:
> > From: Antonio Quartulli <antonio@open-mesh.com>
> >=20
> > To allow cfg80211 to use the real channel to pick up the
> > proper (i)bss object, store the used channel in
> > wdev->channel during ibss_join
>=20
> WTF? No, mac80211 can't just randomly modify cfg80211-owned data.

Mh, ok. :)

What about setting wdev->channel in __cfg80211_join_ibss() right after havi=
ng
set wdev->ssid ?
This way we leave mac80211 out and we totally handle this thing in cfg80211
only.


(I think with this change patch 1/2 makes more sense?)

--=20
Antonio Quartulli

--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSX/i4AAoJEADl0hg6qKeOKdMQALIauUMP5s4m+aK1r6/VlwTf
LNILPe/xzBAy/EroJ/+/cor/Z4npGsdRDCiOl1OSRd+1+i/7n9dxpDuBms7zNDwN
bq05u/7/7Qv7O/XpK58X7MxlpQODuQRbDoWpqK7w44aVNawmNWRYjMFMx/hfxoVJ
LJ2nKrfE+QzSlOI4wo+abTg7vP9jOfSyzm/Kbr5L2a3hL91v6zptKsMp2z7ZjmiQ
i8H7QA13kUu3KAFgAN3/zX0gWgfVZSyyUM+HJnJeGwZQYS5Z5GOwCoSvwR2w9scl
b9l2Ye0hKDZJKC/fDEaql2L5W5dVsrMuzfljwNSeNbaqVa/R1jfoinS7tM0gN+QN
PcL6cLsc8ZRoD9pRcmjtvFVJ6O+cHUGmXsM/k8gmbwDO9dyNK4m2hH6nHF+EgpUP
20eODHheSogVrDQ3vs5jPaTokvBBokkJ6A/DN2k9x42PWFYD+FSLgLrC3pwelY2w
lMhyNUQFVla/1qf0+3sQWi7+jQ1kRkmsUvKxLBvBBAva/vqM7nlCI9IUflH7l125
z9iglUSDkZR6fA2qXi8lxdjzURpGx63j6DJKPR1Nvzaqf1OLOGiEDsc1uZErxJcA
tZ50ld+xZOvBHmulv01H+WQgA239fYVQ4L0YSvXM2TnLZ37rwu+GaBOPGmQCgR5h
JmIVb6KbSA7rRj3Ia5rN
=lf3y
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--

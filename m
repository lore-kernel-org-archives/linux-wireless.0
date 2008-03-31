Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:24599 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755708AbYCaSmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 14:42:18 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: adm8211 crypto bug?
Date: Mon, 31 Mar 2008 14:43:51 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1206452558.16475.265.camel@johannes.berg>
In-Reply-To: <1206452558.16475.265.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10323211.r7mkBdfDbI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200803311443.51453.flamingice@sourmilk.net> (sfid-20080331_194221_425541_F4B4F88F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart10323211.r7mkBdfDbI
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 25 March 2008 09:42:38 Johannes Berg wrote:
> static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
>                       struct ieee80211_tx_control *control)
>
> [...]
>         fc =3D le16_to_cpu(hdr->frame_control) & ~IEEE80211_FCTL_PROTECTE=
D;
> [...]
>         len =3D hdrlen + payload_len + FCS_LEN;
>         if (fc & IEEE80211_FCTL_PROTECTED)
>                 len +=3D 8;
> [...]
>
Nope. It's just a cheap hack to disable hw crypto support. I was planning t=
o=20
add hw crypto support back at some point so I just added the |&=20
~IEEE80211_FCTL_PROTECTED| part to disable it without removing the code.

=2DMichael Wu

--nextPart10323211.r7mkBdfDbI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBH8TDnT3Oqt9AH4aERAgytAJ0WDbTiKHo6ja8JdQzPCmXjSQR/HgCfaR/J
xFv1pEiZuJsZ3k92SH4dlh0=
=9RDR
-----END PGP SIGNATURE-----

--nextPart10323211.r7mkBdfDbI--

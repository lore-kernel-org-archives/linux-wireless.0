Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbYDUIVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 04:21:20 -0400
Subject: Re: [PATCH] mac80211: remove unnecessary byteshifts in frame
	control testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1208745209.7941.11.camel@brick> (sfid-20080421_033544_733702_6DA132C4)
References: <1208745209.7941.11.camel@brick>
	 (sfid-20080421_033544_733702_6DA132C4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fqGWZ6P4ADeOt4ceK7Xu"
Date: Mon, 21 Apr 2008 10:20:13 +0200
Message-Id: <1208766013.26186.30.camel@johannes.berg> (sfid-20080421_092123_168955_4E51AFBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fqGWZ6P4ADeOt4ceK7Xu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-04-20 at 19:33 -0700, Harvey Harrison wrote:
> Byteshift the constants rather than the data.

> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index f27d11a..1068965 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -546,16 +546,17 @@ enum ieee80211_back_parties {
>   */
>  static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
>  {
> -	u8 *raw =3D (u8 *) hdr;
> -	u8 tofrom =3D (*(raw+1)) & 3; /* get the TODS and FROMDS bits */
> -
> -	switch (tofrom) {
> -		case 2:
> -			return hdr->addr3;
> -		case 3:
> -			return hdr->addr4;
> +	__le16 fc =3D hdr->frame_control;
> +	fc &=3D __constant_cpu_to_le16(IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMD=
S);

Can you use the non-underscore versions except where necessary (i.e. for
"case ...")

johannes

--=-fqGWZ6P4ADeOt4ceK7Xu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAxOPKVg1VMiehFYAQI9YQ//b6ToHrh3iPq+Jk9sgl23yprhPX08VC8G
4SpBjfpkJG7uRze5VNBFPPH2pJjrOR00tdIR3Zbrt1oT1PyEM8JGwuV+Bdet8B/8
CeXrFb2TDhPKTFbL8elYayebYrKV1nDFX7gW9sNiCGdeCW82or+30+TOkr3AvUjs
WFPSV4TUZxKYRhxPruk/9wnFENYa7h1jFIGI4mEzHWpltehMhUA8V9Wn+sOxZ8FJ
I6sqEnpjdYmjH/6r0oLYtI36AFTO9/gxpWBXvuQIjVis7I3IBkGqvCo2x2RezjIG
y8ceNi4QOnAdvl5H1REOeRm3nywyEkKp5EIQjy5b3hogd3fb2gTMRbDmiMcXMe5Y
NVTbBbWtNVzBlHW1Zx6T7l6mKaSQMn8N3tZ9/pWlr+rcDjTJ6K0ehKSadbEy4uG+
8lUUhDMH4Luvq/yDbGIpMmf+Kb3dX2WAr7UA1qjPyX1nfl7JWwVP24lEIXhMBNmA
vxuc2oOG8SfYtNGwQuSCIBsgpcXOipMkVvDH3sh0xyZ2mjCji5UXYUr1tGutvOHk
ZB44RMQR2Wnsmnl2qZ5Zi7HLzMBIeh2HL28CUO/0LgwdJ+W/mo0HfaeJHmLSIYbj
FD7icWFZ0k0v+aDksAu6jd6V/HVbs0YLKaGSIJoJHc+TNc3HxW+jfsI89dEBLK1W
3JdoVc0RJRI=
=nPr5
-----END PGP SIGNATURE-----

--=-fqGWZ6P4ADeOt4ceK7Xu--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbYHDSGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 14:06:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KQ4Rl-0004UQ-1Y
	for linux-wireless@vger.kernel.org; Mon, 04 Aug 2008 20:06:17 +0200
Subject: Re: [RFC] cfg80211: add PM hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217853236.4721.32.camel@johannes.berg> (sfid-20080804_143447_007277_5390AB33)
References: <1217853236.4721.32.camel@johannes.berg>
	 (sfid-20080804_143447_007277_5390AB33)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P3ch1DzVdxwmcKSiLr9R"
Date: Mon, 04 Aug 2008 19:29:22 +0200
Message-Id: <1217870962.1299.17.camel@johannes.berg> (sfid-20080804_200628_819635_3ED3D738)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P3ch1DzVdxwmcKSiLr9R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 14:33 +0200, Johannes Berg wrote:
> =20

>  struct class ieee80211_class =3D {
>  	.name =3D "ieee80211",
>  	.owner =3D THIS_MODULE,
> @@ -68,6 +96,8 @@ struct class ieee80211_class =3D {
>  #ifdef CONFIG_HOTPLUG
>  	.dev_uevent =3D wiphy_uevent,
>  #endif
> +	.suspend =3D wiphy_suspend,
> +	.resume =3D wiphy_resume,

And it looks like we should be using .pm here.

johannes

--=-P3ch1DzVdxwmcKSiLr9R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlzxvAAoJEKVg1VMiehFY7+QQAJ9e8sRXTbrA3ZLQotkbs23B
xVlX/wXCuEBDKvZoMGR016vgCcqYGrkd9n0HAac+sPMlTeCNXhiqXDpLai751o8I
kOqE653FC/pjyHuaIYnsi/bQqE2WE/ahb96Q6DjZd475fNBQGyvmpvm1s3iVkq6V
N+Ambrb8ZNtS2Hr1McwDZMHprQgmgRh+/riQ02eGaVBS40rSAFnAppridHx84ka+
W0x3OQ8QnDjoKPeEaT7TRuuxqUq7UkALmD94sgXLb48xgbzljOcr5X7jdRqNKabE
j2vKZrloYixlOjvKCu5Y+sua9XnLQcCBbxE6gMAcwcg/0RoOFEjZsjF1t4TqYZjj
hR8mra6fuPB2gcPWmy5AR8fFDQ8vwRYBbrcSKcDMTSuQbRh3NecgbSbAjWOvQA+n
LQOfZCCv2y6hZW4ffcZU7gsEh4vQqlaYVRSl9NFUfuCg3VThG7gSbLRWcE2cWaYt
7kyZHA3QOw83sdIiTD4KbR349ZZt+qLB+vE1JHLZOOI+xkgw24UOgOdixcnIXAhh
ZhI8LCtnaC1whtE1Wv5wgaiTgdW+KBDC5+2jYLTl4tiL8gRsK1Wk2SLnlESjIwGh
ax+hiJ8urTjI/mOtzDpDU9PTHCWdAzqb0tePI4/jz5IfTO2qUp4uWl/t88lgaeeT
auyBlWXcSPVAZfhfhSKy
=FuV1
-----END PGP SIGNATURE-----

--=-P3ch1DzVdxwmcKSiLr9R--


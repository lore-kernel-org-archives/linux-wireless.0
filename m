Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758389AbYILUqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 16:46:30 -0400
Subject: Re: [PATCH V2] mac80211 : Fix mode change hard_start_xmit function
From: Johannes Berg <johannes@sipsolutions.net>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <1221252248-5830-1-git-send-email-abhijeet.kolekar@intel.com> (sfid-20080912_224415_246861_12E7D8D4)
References: <> <1221252248-5830-1-git-send-email-abhijeet.kolekar@intel.com>
	 (sfid-20080912_224415_246861_12E7D8D4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SLxQRJ1sD8pOEGy3Cj6q"
Date: Fri, 12 Sep 2008 22:46:24 +0200
Message-Id: <1221252384.5576.22.camel@johannes.berg> (sfid-20080912_224640_039207_B61E4609)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SLxQRJ1sD8pOEGy3Cj6q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-12 at 13:44 -0700, Abhijeet Kolekar wrote:
> When monitor mode is changed to BSS or IBSS, data trasnfer can not happen
> because proper transmit function is not assigend for BSS ,IBSS mode.
> This patch fixes this problem by assigning the ieee80211_subif_start_xmit
> to device's hard_start_xmit function.

>  	/* and set some type-dependent values */
>  	sdata->vif.type =3D type;
> +	sdata->dev->hard_start_xmit =3D ieee80211_subif_start_xmit;
> =20
>  	/* only monitor differs */
>  	sdata->dev->type =3D ARPHRD_ETHER;

I'd have prefered if you'd put it along with "only monitor mode differs"
but heh :)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-SLxQRJ1sD8pOEGy3Cj6q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIytUdAAoJEKVg1VMiehFYQu4QAKAyEmE9QzEocM89yX3DTuAQ
pyXrIrPhGYD/yY1iApG+CUNMAYhrx9cG+qyv9HMT+O/Kj886YVTEnaXjhr1oOx1f
Kg5YuCYOOw+GxCekczpgItMl5tolFFEKs2ukSolvn14g75JAZXqR+EneDcwDWlTm
LYBEU9QM2sI9cCmJX4xCZwpQHhQMdqAGepm6DWjArO34DiBFRDdM1o2PnIM9G5Az
nVj18vrILwZ9t9aTLpGkyGFDrSRMvp5n91VnIxschC9hpyUZm92vlphCSIc03+hm
kQFIfzUzt/FnPYYQInBK0Hzcz7i8sQyDVMebMFuyvndrcy5T/JDh2a7tw2tqtrsr
xWCvqD24EJKmqopsg0bEPqrSMH/2aZ7tx2uTUBbmWpZzym/CgdV6T97ieASdzq5t
0ntHqEe9DPNIjVoj7/k0nUzzKhv0103b9fCm+bZXxOci1LXDo4fOrDMrTcoNbyCO
acJMDD6wUVQ1Zr51ZljpLVLD+d4jF6gZ+N7RCJNqhwLJFmIVK0QXI2rW7Z3IJAPF
HhASg6gGF01Lhid7GBBfXLOKBn+M63PDnu+P5AuAkA+yk2X/t+UZPY21zHgGopTD
KeARp9Jmh5qPVu4wXyOXyM8eqTD5E5qkMCeLvFm70UexWHuOq7LA5EhWv3i0ouEf
Rj4GIJGZVpdcR5tJ+jMd
=V1eo
-----END PGP SIGNATURE-----

--=-SLxQRJ1sD8pOEGy3Cj6q--


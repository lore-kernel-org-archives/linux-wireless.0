Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZJNX3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 19:29:34 -0400
Subject: Re: [PATCH] mac80211: fix SME warning by removing stale BSS upon
 assoc failure
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ic.felix@gmail.com
In-Reply-To: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com>
References: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vcRgmEkmZnNFNpd5T2Vu"
Date: Thu, 15 Oct 2009 08:28:15 +0900
Message-Id: <1255562895.4095.297.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vcRgmEkmZnNFNpd5T2Vu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-13 at 20:50 -0400, Luis R. Rodriguez wrote:
> If you try to authenticate with an AP we will keep track of the
> AP's BSS and expect to eventually either give up on the AP or complete
> an association cycle with it. If an AP rejects our association though
> mac80211 currently insists on telling cfg80211 a BSS authenticated
> correctly, this is wrong as it leaves a bogus BSS lingering around.

But if assoc fails, it _did_ authenticate correctly.

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1463,11 +1463,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub=
_if_data *sdata,
>  	if (status_code !=3D WLAN_STATUS_SUCCESS) {
>  		printk(KERN_DEBUG "%s: AP denied association (code=3D%d)\n",
>  		       sdata->dev->name, status_code);
>  		list_del(&wk->list);
>  		kfree(wk);
> -		return RX_MGMT_CFG80211_ASSOC;
> +		return RX_MGMT_CFG80211_DEAUTH;

I'm sure this is correct. Maybe cfg80211 doesn't react properly to
getting an assoc frame with non-zero status?

johannes

--=-vcRgmEkmZnNFNpd5T2Vu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK1l6LAAoJEODzc/N7+Qma5A0QALRj/jhvevHsv+5XegglohxM
N592CW1ZJADZATrWmui2h45aD4qYS+VQ0UOv9oiypAZlag7aLL9/CSdwtn3f7LyA
OiV54Iq4d1EjATTMhuDui48TT8ukpw56MoZefXBZOoQAXJT1k/w0BRa3sSGt8BHO
ErnqOqfUzXR6kU8lUJaRZJUX3egy5Xp6cKUEY2CuAXPCRMtqBqAF0P25ux8R3f0c
/XLVbmiBwptJ8BkoNsmYagboAkn9bQSM+upC8eTq0SxKdXRURaV79HwhUlzanWEq
Hs1NfgVtKW8SlTneJLprrn+2+pg1TaRfEMefNnrdyLr5kesZbIcR0zsookBNbHmg
vj+6jOlOKozten0ipWCt87GJQfUPoAfjjUQT17YPTj2qR05UVjfD8UCel+K3IxmP
5syVzO7ad4mUO+qTIpqPsDbc1mRXZeoXs3g2qXTJN3kfdyGTV4EJBbCorsy+LfqM
2hbuC6L8rZrqvpwFPZo7qy0eA1m20oi+l7ho46GvULGmW22A77xwYn7CY/P6Bd7E
JeLAD1elHArJGRUM6agEkWABDA2eJQAK90ioYAJPnjXBuAWyGeXDYUjPZKwqf4Va
gchtbvtZKOoOBPs8ET3jk4hCbPYv+C1z87AE994+UB06g53xjU9xYPuOLDh84nx4
dQptOSxGteTiRXrJt0ac
=zgQn
-----END PGP SIGNATURE-----

--=-vcRgmEkmZnNFNpd5T2Vu--


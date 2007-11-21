Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXKURDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 12:03:38 -0500
Subject: Re: [PATCH] mac80211: remove "bcn_int" and "capab" scan results
	info
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1195664138-21789-1-git-send-email-linville@tuxdriver.com>
References: <1195664138-21789-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QSR+BS7aom+ZdedA/m5W"
Date: Wed, 21 Nov 2007 18:01:15 +0100
Message-Id: <1195664475.12000.54.camel@johannes.berg> (sfid-20071121_170342_522941_3A58FC73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QSR+BS7aom+ZdedA/m5W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-11-21 at 11:55 -0500, John W. Linville wrote:
> These bits were dead code before "mac80211: Remove local->scan_flags"
> (commit 6681dd3fd0e4d36a4547415853e83411baa7b705) and probably should
> have been removed as part of that commit.

I'm all for it. But Jouni complained although this code couldn't be
triggered. I think Jouni's objections will be addressed with nl80211
work though, so maybe we can remove it for now anyway?

johannes

> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 2a321f0..936f1cd 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -3001,31 +3001,6 @@ ieee80211_sta_scan_result(struct net_device *dev,
>  		}
>  	}
> =20
> -	do {
> -		char *buf;
> -
> -		buf =3D kmalloc(100, GFP_ATOMIC);
> -		if (!buf)
> -			break;
> -
> -		memset(&iwe, 0, sizeof(iwe));
> -		iwe.cmd =3D IWEVCUSTOM;
> -		sprintf(buf, "bcn_int=3D%d", bss->beacon_int);
> -		iwe.u.data.length =3D strlen(buf);
> -		current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,
> -						  buf);
> -
> -		memset(&iwe, 0, sizeof(iwe));
> -		iwe.cmd =3D IWEVCUSTOM;
> -		sprintf(buf, "capab=3D0x%04x", bss->capability);
> -		iwe.u.data.length =3D strlen(buf);
> -		current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,
> -						  buf);
> -
> -		kfree(buf);
> -		break;
> -	} while (0);
> -
>  	return current_ev;
>  }
> =20

--=-QSR+BS7aom+ZdedA/m5W
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0RkWqVg1VMiehFYAQLccBAAkZ9A6TDs/i9ep7qzrJMNHBVRg1oPwbF9
VpYRDdy241SOmqRi0Mbx/9CMPsAvFt/lhq5bljUsf/GdN9uOfZ3bbFO1rFHZzRW9
/rXPzPiGNSJjNgGCcrOuYcJLmLKDmsTUW7yi3l4UaI8cmSFmMT8tsSVjtSVzie0y
sGXu90QHOCkY3zruYdNyluSDJl9M90co2NAu833/3iRdzWCVweqXocx4ALuKFw5n
6I+KQzOoVuHHR1GI19WTtz0j5akucvzB57/PRB8SQ/2zUodqZP7qPoD2L8c7ZsTp
dsFONbWTqUgGGKeaY1yElmvja3QNxuc9mzVIO+szU7WJtYh4RqwFl6AW+/pVoXzb
wAr/iD3y8cjNqRDjGuQrMYtRbD5+3ZMIlwAf0tHdJyPRczhP6xqtZKkoTK5qhJCy
nP90ir5XtN3cs54FaxbRiA4LYUh6WdfeIkjJMzfcQieVOQPBldocyVMSdqgxczrj
nfFpYy7Km1r0ObFvw6JCgKn1GFBh/mhkFDy6cQSe3mROZ+7IMcnz98kXBP/lrcaZ
1/i7RmuR5HK0wPGbXmhF6nEoQYPaZnRCSZwSkNlysBiZKEJPr/HAQaS825Ur5Bb1
Y5AiQtBM1IHFUilFNWx46Luol/rfqdkZze2TStMOe+2aVZhKoRdhnRQDkH6r9myJ
j2c8hrX3gq0=
=wHpj
-----END PGP SIGNATURE-----

--=-QSR+BS7aom+ZdedA/m5W--


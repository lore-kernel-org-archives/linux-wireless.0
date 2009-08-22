Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbZHVHsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 03:48:30 -0400
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Rafael Laufer <rlaufer@cs.ucla.edu>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A8EE182.6040709@cs.ucla.edu>
References: <4A8DED03.2050502@cs.ucla.edu>
	 <1250842695.13872.5.camel@johannes.local>
	 <69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>
	 <4A8EE182.6040709@cs.ucla.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ofteyx6smudH+4apRYpW"
Date: Sat, 22 Aug 2009 09:48:28 +0200
Message-Id: <1250927308.23605.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ofteyx6smudH+4apRYpW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 11:03 -0700, Rafael Laufer wrote:

> + * @IEEE80211_TX_CTL_RATE_RADIOTAP: completely internal to mac80211,
> + *	used to indicate that the rate was defined in the received radiotap
> + *	header and therefore the rate control algorithm should not change it.

This should be an internal flag, the driver doesn't care.

> +	/* In monitor mode, if the IEEE80211_RADIOTAP_RATE option is set in=20
> +	 * the received radiotap header, do not call the rate control algorithm=
.
> +	 */

coding style

> +		/* Get the rate parameter from the radiotap header,=20
> +		 * allowing rate selection on a per-packet basis=20
> +		 */

coding style

> +		case IEEE80211_RADIOTAP_RATE:
> +			bitrate =3D (*iterator.this_arg) * 5;
> +			for (i =3D 0; i < sband->n_bitrates; i++) {
> +				if (sband->bitrates[i].bitrate =3D=3D bitrate)
> +					break;
> +			}
> +			if (i !=3D sband->n_bitrates) {
> +				info->control.rates[0].idx =3D i;
> +				info->flags |=3D IEEE80211_TX_CTL_RATE_RADIOTAP;
> +			}

You never set the counter, or any other fields.

>  		/*
>  		 * Please update the file
>  		 * Documentation/networking/mac80211-injection.txt

And you even quote the instructions.

johannes

--=-ofteyx6smudH+4apRYpW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKj6LIAAoJEODzc/N7+Qma9d8QALem5J+nL/99MvxUCyEc3Tc0
m343Y+18ZYnmHYFE/MM0Bijke+6u+keUuLRdEVpI1up6tcH06ZkLTyp/KXN+rchA
02jkiHdRES60/A9v2BUaRGWQ1v2ka/0HqIvm2yiq4/Vw8l5vtPjwYkjVmxgewyd6
ttKLDi2bKD811X7L8X3gwzFhPcAKn9pnWcxLsk+Sj+NFoShPz5iA9MwBykRsZ5Qh
MV3xO6iKDttLvP5G0U7pQWefGqESYTeSpa1IWPVuaeCmkeYyj8zx1Z9SnTFWECXe
cItXSz4mq9ESdTd/IObEc0WDkkDqFoxr3bJ5T3jX5zc+0lPBU0K65PBLhemHojlr
a1IT0tKHrEhxuPc11AdZA5Ocd5cQa4xgIsg7IfDewQmhzbra9Gg12nXQkVJimBAt
C7CYmk2DZ7PYdfQDHNVM4WxjtymFsVMCqY0cjlZjKWd/Vf+GMfBitq6T21uK8yi0
KhJjcqdJi91anLRvYrR2FMHyxu+56hQAnHpiMPYjNN2ViP4nJ2RYv/oJY8Ie8OY6
urlH03+8B3WSH8GibHynSfSoRfNuMUi2v2M7nhp1lYF0mnuM429y1NFCMmuxpdJT
O/GEH8nH0x5z964Hu8h2awppS5Bc610XLEbeRjzDrMyaoWlTxdbu6bbC8GnxriKH
l4RIyJjkyTgbRepaztqO
=/r5V
-----END PGP SIGNATURE-----

--=-ofteyx6smudH+4apRYpW--


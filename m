Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZHLPDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 11:03:44 -0400
Subject: Re: [PATCH 2/3] mac80211: fix dynamic power save for devices which
 have nullfunc support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090812145209.23691.82.stgit@tikku>
References: <20090812145200.23691.17281.stgit@tikku>
	 <20090812145209.23691.82.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IagwoNJVnmpUiVCSNLIh"
Date: Wed, 12 Aug 2009 17:03:09 +0200
Message-Id: <1250089389.26464.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IagwoNJVnmpUiVCSNLIh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-12 at 17:52 +0300, Kalle Valo wrote:

>  static bool is_dynamic_ps_enabled(struct ieee80211_local *local)
>  {
> -	if (!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
> +
> +	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
>  		/* driver doesn't support power save */
>  		return false;

Why the blank line?
=20
> +	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
> +		/* hardware does dynamic power save */
> +		return false;

FWIW, also applies to patch 1, I think I prefer

	/* check if hardware does dynamic power save */
	if (local->hw.flags & ...)
		return false;

(wrt. comment location)

and you should probably rename the function to do_software_dynamic_ps()
or something like that?

johannes

--=-IagwoNJVnmpUiVCSNLIh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKgtmqAAoJEODzc/N7+QmarWMP/iZzcdblry1vf36kwqPB3tVt
CF5Col7JUO3vdHQWsVIR9kp/BMgv0nOhm4ob03ai9OBBeQdha5zG2ZWk9rxvYPmu
MRHGr5jSkD7RMO4B0OUhllWld8zX7CleWoCaDv5MD/db1Tc86N8u+GPBQ9MeldSL
FAxgbX9FlJ4mP+TpgLOgte3npMaDZKp3GEWi4rDz6oqKdF4zG5boavAyxeE+MBmk
oUIC7af9QCTWhtBzJMycWOAES14iEorgTaKvK3PzxHglFYYV02vCl2xpRbk1wH7D
V5Tg4LT1HlrUiWy3mXpjj9t3Y0EuvtV50RxHPgk9BTxRUQOSJmhxBJPvfRP2EUA7
BlcdhuY839DG6XaskGr1XBc2HolMJP93W0ldZbMoi/C3oIFFt6ZmT0a7aUn05bQw
F5ds6tbtCEbHnH0Pu+IYL7f8G9RjUE8s0ymi7FoE5ahtAe+pJ3j6iVy29odture8
seoGe9qODwAdnFryrmoKNfN6pdBeLLrV9R/KzzwDhxaRbdvBdiJcCO7pFhcf42CK
TcRfaiH1uI/UH6RVHAIqNjQk5i1S7nqOuwNpuogH+1/S9/ZnpaCouBRqxDh7/TXY
tq3esXhEQKpSuNe7se5XI4U/xr9trAnONkggpXZ3c0qO/JumiNWi40BL7GsfvuhD
8tWCIMjddT71QbAatXMY
=PHSr
-----END PGP SIGNATURE-----

--=-IagwoNJVnmpUiVCSNLIh--


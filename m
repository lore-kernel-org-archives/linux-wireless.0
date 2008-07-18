Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbYGRIXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 04:23:36 -0400
Subject: Re: [PATCH 05/13] iwlwifi: use dtim_period from association, and
	set listen_interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1216360389-5352-6-git-send-email-yi.zhu@intel.com> (sfid-20080718_075628_051473_4159CBEC)
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
	 <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
	 (sfid-20080718_075628_051473_4159CBEC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dIkq1XcOQzf2dq6NKdfv"
Date: Fri, 18 Jul 2008 10:23:29 +0200
Message-Id: <1216369409.27738.2.camel@johannes.berg> (sfid-20080718_102341_936889_94DE3078)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dIkq1XcOQzf2dq6NKdfv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -828,6 +828,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
>  		hw->ampdu_queues =3D priv->cfg->mod_params->num_of_ampdu_queues;
> =20
>  	hw->conf.beacon_int =3D 100;
> +	hw->conf.listen_interval =3D IWL_CONN_LISTEN_INTERVAL;
> =20

No way. How did those get in there? mac80211 is supposed to control the
config, and you're supposed to use them. That was the whole point of the
discussion we had. Please remove the beacon_int line as well and use the
setting you get instead.

johannes

--=-dIkq1XcOQzf2dq6NKdfv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIgFL9AAoJEKVg1VMiehFYlr0QAMPc+65XFAt36rfkE5d/5zua
fdbAXgRXnvyAPNzgVezT0pJ7p7NGfLUMuizHjFsX0r3V//ZawUlTsmxOrwB7Oifi
Qngp+aUcOJIJbduK4a1CHzOrqQwm/eGHR1Dxl4TU/r6MPCU8chqc6f21piY+vXVT
ELdUW7aqT8jpC67ODs0QlMt/w3i9Mze/Hw2EgdBTKVQLydRUwCzP+xZiTF128kGc
T0pxiBa6wE+5gSY7PyKGi7W/fEqKBt2C5u0uAPmzv6jAC6ItAlLxJxLtDmNYZUVv
Bg0Xd3EVSTcIu8gi1ENaRBaeuI5vu12IdyFdntJrytb3euQOsn8u1jJbvpOcsBrQ
c+BBnpriExLP5wbv5nU9pNjnHTDA3aQQkmX7wN0jAU3GuvKH2I6h37uH45DLcXad
fGSDrEGizmi62BI2TIdN3Khfh92fCwydjokKbtlfFzP/sosaH/sSR9UZABrGSiNz
MKqreks2r0W4fZCUyFzzPe0CPvnLnew06DHaqy8wdz5s35CoQBJTA4yfXE5eTF4i
4V6EQ1q1+A9CcMNWjv7X2b7x4tghCCCjAOP7RZ7JdAuTvWYQGeCjln70YQMqmjMX
+Lx5nRcK8ZsUwMOu24a3XZW8spohl7ms6RlLYOWF94aYWoECMQBZsbHVjm6P3m87
vuDzMzj9SDCBtL48Lb94
=UqAa
-----END PGP SIGNATURE-----

--=-dIkq1XcOQzf2dq6NKdfv--


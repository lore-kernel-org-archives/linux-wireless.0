Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXBMQCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 11:02:50 -0500
Subject: Re: [PATCH 3/4] cfg80211: wext compat code
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>
In-Reply-To: <20070209162829.001594000@sipsolutions.net>
References: <20070209162711.375886000@sipsolutions.net>
	 <20070209162829.001594000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hfstCIMzv2PpcI6tajnh"
Date: Tue, 13 Feb 2007 16:42:57 +0100
Message-Id: <1171381377.10344.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hfstCIMzv2PpcI6tajnh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-09 at 17:27 +0100, johannes@sipsolutions.net wrote:

> +#ifdef CONFIG_CFG80211_WEXT_COMPAT
> +	rtnl_lock();
> +	ret =3D call_cfg80211_wext_ioctl(ifr, cmd);
> +	rtnl_unlock();

No need to take the rtnl here if we change the compat code slightly.

> +static struct cfg80211_config *cfg80211_ensure_pending_cfg(
> +	struct cfg80211_registered_driver *drv)
> +{
> +	struct cfg80211_config *cfg =3D drv->wext_pending_config;
> +	if (!cfg)
> +		cfg =3D kmalloc(sizeof(*cfg)+32, GFP_KERNEL);
> +	if (cfg) {
> +		cfg->ssid =3D (char*)cfg + sizeof(*cfg);
> +		drv->wext_pending_config =3D cfg;

This is a problem. It means that every driver can only have a single
interface that is configurable via wext, or if you try multiple ones
we'll run into a lot of trouble. The solution is to implement a list of
pending configs that each have a netdev pointer in them. Bit icky.

johannes

--=-hfstCIMzv2PpcI6tajnh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0dyB/ETPhpq3jKURAp/oAJ9ZAv9gL/aEyY1j7kxnTL6Ev5czfQCfYKiB
wKt5lYJ257pnR1jcqp9aalo=
=HjhS
-----END PGP SIGNATURE-----

--=-hfstCIMzv2PpcI6tajnh--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZECSFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2009 14:05:30 -0400
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241227946.5192.3.camel@maxim-laptop>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oM3c0UDcEV22PPFjjLG5"
Date: Sun, 03 May 2009 20:05:22 +0200
Message-Id: <1241373922.13562.35.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oM3c0UDcEV22PPFjjLG5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I was taking a look at this, one small request:
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -585,11 +585,14 @@ int cfg80211_wext_siwscan(struct net_device
> *dev,
>                 return -ENETDOWN;
> =20
>         rdev =3D cfg80211_get_dev_from_ifindex(dev->ifindex);
> +      =20
> +       printk("MAC80211: scan requested\n");

Please don't put "mac80211:" printks anywhere else than net/mac80211/,
that's very confusing here. This subsystem is called 'cfg80211' usually.

Anyway, what seems to happen is that mac80211 never responds to the scan
request -- can you describe what you're actually doing?

johannes

--=-oM3c0UDcEV22PPFjjLG5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/dzeAAoJEKVg1VMiehFYeQAQALRrIEEdokREqoeMZH/fLil7
uML3vGt6lMx0uARZoo9k0rESWl5PVe9jTxb0bH38JdOFCtF8ll44nUtJa/fn9lsQ
0RfKXgc2+E1XRb/MlDu/Pcq7PLvOiNuriz1XCD+t9hS63H/EZqKijtlhjAKGRSP3
26i4P55p3IX2H1BX5FJdEyr+whftdMO35GA3JcFrefGEHtl9simmCcighgRFYaTu
2M6D1Uh2bChwZPBuN0hxI3k+KnHHmaGik5H1eFeBoIOZ0EgwyybYnIbkjOO2Y5+e
graUeiGz8QFz4cU7kZUxTJ3fmjJWQ1PTNyIt0yApcyr40fn8PKZWNG6uwMsr06zr
M1Vos8PrjzCXqSn/AVmkK5KVMFVRUQi1Ef3A5gDv/Mll0628PyH9dXBbi4Z4TygK
Yo5efYeY8vO223IDr7oMvBw1RPCbld0tGFkh5H7DCU3/2Ni7u7NIiqYNEUMfuOy3
zvKNB6Nev+EA4wCnusMFdJs9rFYugIv8uUpq+jGgqWwVcc09PMSUhDlo0NuZa6hU
yFwRozrywHtoMqgTfpX9w2Z/eCXlfjC3AHbNUbZVn+q/E84NuqvNcXbhZ4mLuqVq
AD8Roy5McAm325QZLvfq5Edp0ErVOyByd9lXUdY835D4wFuEkR2ff4l9PBXC73rZ
Qmvfeio0zfp7lmAB4gBp
=whCf
-----END PGP SIGNATURE-----

--=-oM3c0UDcEV22PPFjjLG5--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYCCJwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 04:52:35 -0500
Subject: Re: hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1204528099.3087.15.camel@debian.sh.intel.com> (sfid-20080303_070851_717668_24B899FC)
References: <1204190255.3090.165.camel@debian.sh.intel.com>
	 <1204210453.6309.49.camel@johannes.berg>
	 <1204266154.3090.182.camel@debian.sh.intel.com>
	 <1204302356.3938.36.camel@johannes.berg>
	 <1204528099.3087.15.camel@debian.sh.intel.com>
	 (sfid-20080303_070851_717668_24B899FC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-324GWMNrmxbMhgLjiCqX"
Date: Mon, 03 Mar 2008 10:52:25 +0100
Message-Id: <1204537945.3917.38.camel@johannes.berg> (sfid-20080303_095238_509826_47BC121A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-324GWMNrmxbMhgLjiCqX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-03 at 15:08 +0800, Zhu Yi wrote:
> On Fri, 2008-02-29 at 17:25 +0100, Johannes Berg wrote:
> > now that John merged more stuff you should only need the hostapd
> > patch and the allow-ap-vlan-modes patch from my kernel series :)
>=20
> OK. This time is much better. Now I can at least ping my 4965 AP with
> below fix.
>=20
> The removal of mac80211 IEEE80211_CHAN_W_SCAN flag causes channel flag
> incompatibility between hostapd and driver. Hostapd expects
> HOSTAPD_CHAN_W_SCAN (0x1) to be set for the configured channel while 0x1
> means IEEE80211_CHAN_DISABLED in the new mac80211. We should make
> ieee80211_channel_flags and HOSTAPD_CHAN_W_xxx compatible. What do you
> think? I now just workaround the problem with:
>=20
> diff --git a/hostapd/hw_features.c b/hostapd/hw_features.c
> index c58e1e4..8a7b013 100644
> --- a/hostapd/hw_features.c
> +++ b/hostapd/hw_features.c
> @@ -294,8 +294,7 @@ static int select_hw_mode1(struct hostapd_iface
> *iface)
>  	for (j =3D 0; j < iface->current_mode->num_channels; j++) {
>  		struct hostapd_channel_data *chan =3D
>  			&iface->current_mode->channels[j];
> -		if ((chan->flag & HOSTAPD_CHAN_W_SCAN) &&
> -		    (chan->chan =3D=3D iface->conf->channel)) {
> +		if (chan->chan =3D=3D iface->conf->channel) {
>  			ok =3D 1;
>  			break;
>  		}

That's rather odd. ieee80211_channel_flags and HOSTAPD_CHAN_W_xx need
not be compatible because in driver_nl80211.c, phy_info_handler(),
they're translated into each other. What exactly is your setup?

johannes

--=-324GWMNrmxbMhgLjiCqX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8vKWKVg1VMiehFYAQJxew/8Ca57FuDDJTbH9qGwDhYG6wPS3r84PEod
6aqd5/AjDfg/LSBAsf0/UEnAyqqT3QhsCY/NP9G2cbRv+hqbaott2tChEs21f0zW
vIEBalQZ7APpOj0lW6/l1PDCCw9UDVWaIKQIUf8XqdZhJ15nVdedxc0FHyeBDIan
nqJsIYW8VpwiqJ81VJ7dNwsD6OswrqtlGgiQVXwYaKbmT4A/WQBsDacZ8ffMyjh9
50vk8104WOb/M4/8bIaMH3SCPiG2TQBjv5EJBAXY6a0Zxvcr0DAAwbmP1x0Xp+Ht
vPrYF4UVXHjmND74Jm7hn1tE0iK4zpXBcV0j7eltvFT42n3zdWjauhcw+VriCkwp
TnpKjC4djSg5M9YtWZm2+Pmkzfu7ndu9EiJOt6PiEwpLfbEzeGpNQkT6YX5XAeUD
h9icX+ciwOQSqjdbhnvOAk7Gqp1srCbQTd9nuP3vTp/ea2I0w8BGXlJNLElIRLQt
MzB01Kz+HTbPuxsJ1aK7pfnb72hO1T83JHCSchucSDy6PmS+W4b0hra9yY7R7IYI
pCuKyrnIqHdcZe/VQeVUomR4pIevueZKL4TLab2h0fXUnFk9w7ghPGsRsbazqWQm
o/2VFk2zJBD6wTvuZemzcZuZtCMbxA0bugAE2DNxUzQqWspL+jrQCyUoGwXrdquz
f0aozdAWDm0=
=Z3tF
-----END PGP SIGNATURE-----

--=-324GWMNrmxbMhgLjiCqX--


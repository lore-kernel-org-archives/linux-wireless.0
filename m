Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34288 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbZEPMqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 08:46:02 -0400
Subject: Re: [RFC 3/3] orinoco: initiate cfg80211 conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <1242476577-26320-4-git-send-email-kilroyd@googlemail.com>
References: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
	 <1242476577-26320-4-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZtKbDlatM1BPY7pucugc"
Date: Sat, 16 May 2009 14:46:00 +0200
Message-Id: <1242477960.10005.60.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZtKbDlatM1BPY7pucugc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-16 at 13:22 +0100, David Kilroy wrote:

> +/* Supported bitrates. Must agree with hw.c
> + * TODO: are the flags correct? */
> +static const struct ieee80211_rate orinoco_rates[] =3D {
> +	{ .bitrate =3D 10 },
> +	{ .bitrate =3D 20, .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate =3D 55, .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate =3D 110, .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },
> +};

Flags look fine from a protocol POV, I don't know whether your hw
supports short preamble. On the other hand, this is only reported to
userspace, we don't do anything with it in cfg80211.

> +/* Called after orinoco_private is allocated.
> + * Which must we do now? Which do we put off until we have firmware?
> + */

Generally, try to do things as early as possible.

> +void orinoco_wiphy_init(struct wiphy *wiphy, struct orinoco_private *pri=
v)
> +{
> +	/* Setup so that we can recover orinoco_private from wiphy */
> +	ophy_priv(wiphy) =3D priv;
> +
> +	wiphy->privid =3D orinoco_wiphy_privid;
> +
> +	priv->wdev.wiphy =3D wiphy;
> +	priv->wdev.iftype =3D NL80211_IFTYPE_STATION;
> +
> +	set_wiphy_dev(wiphy, priv->dev);
> +}
> +
> +/* Called after firmware is initialised */
> +int orinoco_wiphy_register(struct wiphy *wiphy)
> +{
> +	struct orinoco_private *priv =3D ophy_priv(wiphy);
> +	int i, channels =3D 0;
> +
> +	memcpy(wiphy->perm_addr, priv->ndev->dev_addr, ETH_ALEN);
> +
> +	wiphy->max_scan_ssids =3D 1;
> +
> +	wiphy->interface_modes =3D BIT(NL80211_IFTYPE_STATION);
> +
> +	/* TODO: should we set if we only have demo ad-hoc?
> +	 *       (priv->has_port3)
> +	 */
> +	if (priv->has_ibss)
> +		wiphy->interface_modes |=3D BIT(NL80211_IFTYPE_ADHOC);
> +
> +	memcpy(priv->rates, orinoco_rates, sizeof(orinoco_rates));
> +	priv->band.bitrates =3D priv->rates;
> +	priv->band.n_bitrates =3D ARRAY_SIZE(orinoco_rates);

Is there a need to copy the rates? Normally you should be able to just
do
	priv->band.bitrates =3D orinoco_rates;

> +	/* Only support channels allowed by the card EEPROM */
> +	for (i =3D 0; i < 14; i++) {
> +		if (priv->channel_mask & (1 << i)) {
> +			priv->channels[i].center_freq =3D
> +				ieee80211_dsss_chan_to_freq(i+1);
> +			channels++;
> +		}
> +	}
> +	priv->band.channels =3D priv->channels;
> +	priv->band.n_channels =3D channels;
> +
> +	wiphy->bands[IEEE80211_BAND_2GHZ] =3D &priv->band;
> +	wiphy->signal_type =3D CFG80211_SIGNAL_TYPE_MBM;
> +
> +	return wiphy_register(wiphy);
> +}

When do you load firmware? We try to only load it when the first
interface is brought up, but that's sometimes problematic because then
we don't have enough information.

> +const struct cfg80211_ops orinoco_cfg_ops =3D {
> +
> +};

Heh.

>  #include "orinoco.h"
> @@ -2502,6 +2504,11 @@ static int orinoco_init(struct net_device *dev)
>  	priv->wpa_ie_len =3D 0;
>  	priv->wpa_ie =3D NULL;
> =20
> +	if (orinoco_wiphy_register(priv->wdev.wiphy)) {
> +		err =3D -ENODEV;
> +		goto out;
> +	}
> +
>  	/* Make the hardware available, as long as it hasn't been
>  	 * removed elsewhere (e.g. by PCMCIA hot unplug) */
>  	spin_lock_irq(&priv->lock);
> @@ -2533,12 +2540,26 @@ struct net_device
>  {
>  	struct net_device *dev;
>  	struct orinoco_private *priv;
> +	struct wiphy *wiphy;
> +
> +	/* allocate wiphy
> +	 * NOTE: We only support a single virtual interface, so wiphy
> +	 * and wireless_dev are somewhat synonymous for this device.
> +	 */
> +	wiphy =3D wiphy_new(&orinoco_cfg_ops,
> +			  sizeof(struct orinoco_private *));
> +	if (!wiphy)
> +		return NULL;

You could with little effort, support virtual monitor interfaces by just
passing all frames the firmware gives you to those. Probably not worth
bothering with though.

Other notes:
 * you could easily migrate over orinoco_ioctl_setmode/getmode
 * if we improve the cfg80211 iwrange implementation a little
   and you register which ciphers you support, you can migrate
   over orinoco_ioctl_getiwrange
 * iwencode(ext) should be fairly easy too
 * just get rid of iwnick
 * rts/frag/retry should be easy to migrate
 * what are ibss ports?
 * scan should be easy to port too
 * iwpriv isn't supported by cfg80211

Anyway looks good for a start, though I would maybe build the structures
a little different and not put the wdev into priv since priv is per
hardware.

Generally the layout I recommend would be like this:

+-------------+
|  wiphy      |
+-------------+
|  priv       |  =3D=3D wiphy_priv()
+-------------+

and

+-------------+
|  netdev     |
+-------------+
|  wdev       |  =3D=3D netdev_priv()
+-------------+

For you it doesn't really matter since you can only have one virtual
interface (well in monitor mode you could have multiple but that seems
pointless) -- it's still more in line with what other drivers are doing
though.

johannes

--=-ZtKbDlatM1BPY7pucugc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDrWFAAoJEODzc/N7+QmahCgQAKSHVgjJp1Pa9j4V32M6V+9f
XSX/WgAtar6vcRDsfoJACxnPJeyKsAEHYEKmhrlGpZJZW/rWuHyZvWe0Mx4qOKDc
JK59P5McvzaqS+ahjKg7WZ258H0t61UpYMtvzl+1ZKfBC8Bnz1eLnklg/yyscV49
bf1zSONAYZOJuRbpdrp5i7ZJtGPM2jPDQbCrCMs1E5EPuglFqYAfjzG45xHKIYo/
VP4boprSv91tzoB8WCUMn/C3DNs9m8CP222CEw7qrMaFqZLWh99F2CwNx6xd6zwu
6IYGSw47F3ETEyBQvE9S0wjkQ4TamUDNagc++zpwwtTjmqB2PKYzg73S5Jc4r+La
Cwu5jAxd1CJMy0hdB5JCkWfSUd1d41/zANy32pKP24bBhlUErKong6sL+KcY25qh
z3aKXk65H8VDtBQRUqxY0wHD8k9Q0dQfEC9GKuw7MlfGBFOKjk5TFm9e4LZZuuli
uIer4o3DVnjFi9Sjp/X1GoGXAmW68YcH9+sh0KbHtqpzLw4zZwtm2QE4fZRwNbP5
Gq1QVvRzJcPiVJo7YqEbiYE+YVVNo0+O4+rJaSOVjONWDvRj8GG/40GHk/BCXSHr
rK/wWYNW/wdhqT8fAi484sH76ilhD0GrKTSNsr4HnwSK3Hp3HlzPXJtxvhl8yuIX
q+hZDX+i3ofjO9d/64BA
=MYD8
-----END PGP SIGNATURE-----

--=-ZtKbDlatM1BPY7pucugc--


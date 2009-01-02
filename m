Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbZABKEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 05:04:23 -0500
Subject: Re: [RFC 02/11] mac80211: 802.11w - CCMP for management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081231154203.845811912@w1.fi>
References: <20081231153834.840526845@w1.fi>
	 <20081231154203.845811912@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CqES2cI90Wi04pkf9rX8"
Date: Fri, 02 Jan 2009 11:04:57 +0100
Message-Id: <1230890697.3272.6.camel@johannes> (sfid-20090102_110431_550639_B35B99B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CqES2cI90Wi04pkf9rX8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-31 at 17:38 +0200, Jouni Malinen wrote:

>  /**
> + * ieee80211_is_robust_mgmt_frame - check if frame is a robust managemen=
t frame
> + * @hdr: the frame (buffer must include at least the first octet of payl=
oad)
> + */
> +static inline bool ieee80211_is_robust_mgmt_frame(struct ieee80211_hdr *=
hdr)
> +{
> +	if (ieee80211_is_disassoc(hdr->frame_control) ||
> +	    ieee80211_is_deauth(hdr->frame_control))
> +		return true;
> +
> +	if (ieee80211_is_action(hdr->frame_control)) {
> +		/*
> +		 * Action frames, excluding Public Action frames, are Robust
> +		 * Management Frames.
> +		 */
> +		u8 *category =3D ((u8 *) hdr) + 24;
> +		return *category !=3D WLAN_CATEGORY_PUBLIC;
> +	}
> +
> +	return false;
> +}

Should that be in include/linux/ieee80211.h?

johannes

--=-CqES2cI90Wi04pkf9rX8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJXebGAAoJEKVg1VMiehFY0EcP/Aq4AsXarin7THf3KqmF2FA/
g1/VE9DJUzNeBHAZ5gQHW5SpgKkiAc89VRxLEQqs8LT56YoXNvltdl/ZZTY4jrZ0
I4pPNxNM77/BMnoVl7McrirzzehqYXNCBXQkwO8G7xioaLW3WutUwy27/bAW8hbY
wKcYoaG9c8NahEbblUZO8IBds0iEKmCeNWjOVUqMNxQ1zibnU+hY1qr1daFyzuXC
2SO4aUXEkYdvjGmIaTGOKdHhLdefhBHyWe7VJ2wGa92yoMma8OVZfSTltLBT2l53
CV7r/RuvW+MA5GSdQy6WuNhpJgVcPwiu6UM3bP8ggdbK5Ku1UTQrSMeAIByNuavc
+IO224Z+V5WTd5x4yU5//8Ep5fxYpGpyPo4b4nl1QkQN4XE8oP4RNPsu9LUbdwIH
Cm3XT4XEdwXNAjFazTCp8t0HHiHPeDl2AoomeWK/F8Q45v4AMBsCn2EznzxECelR
003aGMAGADB/1SccSGEwCRr/0n1USh0V1MqnVPlzCNHATFBwWI9B5oksWAg1ZHRF
Q/OcaAxvKMJjnP+5Jbitr9HJL6EU0+6JMrUQI1rTNsBAMdEUhIcAhWXwhLDhzPVz
LN+HmotbFdI1meAoPj+LFRMjD8ZdbKjaH5fPi0/Uw8+KZNfe6OqtJfZME0lPbX0q
GMYqFl0pmvidlrdVG9/p
=smcv
-----END PGP SIGNATURE-----

--=-CqES2cI90Wi04pkf9rX8--


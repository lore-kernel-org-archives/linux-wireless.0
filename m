Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYLVRS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 12:18:29 -0500
Subject: Re: [ath9k-devel] How to enable Monitor mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: yyhymmh@yahoo.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081222121621.66jxpzr6lt8okk4o-cebfxv@webmail.spamcop.net> (sfid-20081222_181621_767424_496AEE78)
References: <690453.5943.qm@web80505.mail.mud.yahoo.com>
	 <20081222121621.66jxpzr6lt8okk4o-cebfxv@webmail.spamcop.net>
	 (sfid-20081222_181621_767424_496AEE78)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-akU01NAgA0DFeaR3GbVv"
Date: Mon, 22 Dec 2008 18:18:28 +0100
Message-Id: <1229966308.4406.4.camel@johannes> (sfid-20081222_181832_870022_34D80DBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-akU01NAgA0DFeaR3GbVv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 12:16 -0500, Pavel Roskin wrote:
> Quoting hwang <yyhymmh@yahoo.com>:
>=20
> > I am first time use ath9k driver. I like to change the card to  =20
> > Monitor mode. Can anyone tell which command does it?
> >
> > I tried to use iwconfig, but failed.
>=20
> Moving discussion from ath9k-devel@lists.ath9k.org to =20
> linux-wireless@vger.kernel.org, as it's a common problem for all =20
> mac80211 based drivers.
>=20
> Following code in net/mac80211/iface.c, ieee80211_if_change_type() =20
> prevents setting monitor mode:
>=20
>          /* Setting ad-hoc mode on non-IBSS channel is not supported. */
>          if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)
>                  return -EOPNOTSUPP;
>=20
> The effect of the code exceeds the effect described by the comment, so =20
> something must be wrong.  I'm not running crda, so I guess I'm in the =20
> "world" domain that doesn't prermit IBSS.  But it should not disable =20
> monitor mode.
>=20
> A simple fix would be:
>=20
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 5abbc3f..b907482 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -699,7 +699,8 @@ int ieee80211_if_change_type(struct =20
> ieee80211_sub_if_data *sdata,
>   		return 0;
>=20
>   	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
> -	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)
> +	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
> +	    type =3D=3D NL80211_IFTYPE_ADHOC)
>   		return -EOPNOTSUPP;
>=20
>   	/*
>=20
> I've tested it, and it actually enables monitor mode.  I remember Luis =20
> mentioning that IEEE80211_CHAN_NO_IBSS means no beacons, so maybe =20
> other modes need to be disabled (AP, maybe mesh), but there are no =20
> beacons sent in the monitor mode.

I haven't gotten around, but that patch is correct. That's how it was
before I moved that code, when I accidentally lost the check.

johannes

--=-akU01NAgA0DFeaR3GbVv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJT8vgAAoJEKVg1VMiehFYQa8P/2PAHvmXFWVenj9uiOpYN3zC
HYik8YwbHSMLGsk2tepTESW8JbnMOvttv6ZZBmqI5gGlDxF2ksntW/SXlveFQysr
O4KNdHzm0D/Bx9SQNAHTlLdygPYphsvOokqCoebA1jMAOTUzvm3lmUFI/WokN74C
nVur5A5niw+Ren9MzUyarjt01yMv08GZf9gpfHaqTe4D8RL5kVxMFYE3wprV/FQ0
VmI0JrTVlhvoHu5n/zcp0Pt4dah/Nmc5UK8CaOv9hhbZzDNrr4VpaGGLihsClH+7
nUwEsqAlCY9oIZE8E4GbDokriBJhWdYN8adYyCclZNearH9UeYvkkokX/fwXIZI4
Nvh6cmy9h825Fycaf+p2g/FB3SyeIMQ+AH8f5LnNpOK4Psb00Uea+3xuZhUiF++q
jnxMOatkEmq8HifTUnkF8sH+TP8QBfuxcfuARxwWD7tTAKAVDIY6LMZwBa3P54EH
yQVLG3VpHwITu974KANmp60+HdcyXeO2bgwk7aWZhKrKdqF8eGJBVHnKIN6sS66Y
BUHOEu/edyf3xr0LuBX2d+6f5KqFr6RiE4uMD0uCLhrWiglBOsPpQfymqaK31cx4
mfNHAPKLvsr8mgD/B72pLM1j7WXqnFQZtTLaz8hr43XMdhCzn+Qny5Xm4+zUVeBG
TlaBCaOZek2CUNp8RYSl
=pyen
-----END PGP SIGNATURE-----

--=-akU01NAgA0DFeaR3GbVv--


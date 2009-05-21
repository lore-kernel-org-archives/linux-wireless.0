Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZEUJc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 05:32:26 -0400
Subject: Re: [PATCH 1/2] wireless: move some utility functions from
 mac80211 to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel.ortiz@intel.com>
In-Reply-To: <1242872340-27417-2-git-send-email-yi.zhu@intel.com>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <1242872340-27417-2-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9TQXvxeSqh4DH6scY/M3"
Date: Thu, 21 May 2009 11:32:22 +0200
Message-Id: <1242898342.5471.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9TQXvxeSqh4DH6scY/M3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-21 at 10:18 +0800, Zhu Yi wrote:

> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -752,6 +752,32 @@ enum wiphy_params_flags {
>  };
> =20
>  /**
> + * enum ieee80211_key_alg - key algorithm
> + * @ALG_WEP: WEP40 or WEP104
> + * @ALG_TKIP: TKIP
> + * @ALG_CCMP: CCMP (AES)
> + * @ALG_AES_CMAC: AES-128-CMAC
> + */
> +enum ieee80211_key_alg {
> +	ALG_WEP,
> +	ALG_TKIP,
> +	ALG_CCMP,
> +	ALG_AES_CMAC,
> +};
> +
> +/**
> + * enum ieee80211_key_len - key length
> + * @LEN_WEP40: WEP 5-byte long key
> + * @LEN_WEP104: WEP 13-byte long key
> + */
> +enum ieee80211_key_len {
> +	LEN_WEP40 =3D 5,
> +	LEN_WEP104 =3D 13,
> +	LEN_CCMP =3D 16,
> +	LEN_TKIP =3D 32,
> +};

This doesn't seem appropriate. ALG_* is purely mac80211 internals, and
shouldn't be in cfg80211's API since cfg80211 uses u32 values as cipher
suite specifiers. Why do you need these?

And if you want to move the key lengths they probably should be in
ieee80211.h, have a proper prefix and also be used within cfg80211
itself...

> +/* Default mapping in classifier to work with default queue setup. */
> +const int ieee802_1d_to_ac[8] =3D { 2, 3, 3, 2, 1, 1, 0, 0 };
> +EXPORT_SYMBOL(ieee802_1d_to_ac);

That seems a little odd, unless we want to specify how the default queue
setup should be ... which seems to make no sense. It probably will be
like this most of the time, but still, should this really be mandated by
cfg80211? There seems to be no reason to do that. I'd rather keep this
in every driver since the drivers may differ, and changing this for
mac80211 is unlikely.

> +int ieee80211_data_to_8023(struct sk_buff *skb, struct net_device *dev,
> +                          enum nl80211_iftype iftype)

Should probably pass in dev->dev_addr instead of dev for this and the
other direction? OTOH, I suppose it only makes sense to be used for a
netdev.


>=20
> +u16 cfg80211_classify80211(struct sk_buff *skb)
> +{
> +       struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
> +
> +       if (!ieee80211_is_data(hdr->frame_control)) {
> +               /* management frames go on AC_VO queue, but are sent
> +                * without QoS control fields */
> +               return 0;
> +       }
> +
> +       if (ieee80211_is_data_qos(hdr->frame_control))
> +               skb->priority =3D cfg80211_classify8021d(skb);
> +       else
> +               skb->priority =3D 0;
> +
> +       return ieee802_1d_to_ac[skb->priority];
> +}
> +EXPORT_SYMBOL(cfg80211_classify80211);

If you pass in suitable information for the ACM downgrade, it seems you
can move over that code too and remove one export. If your device
supports ACM you can always pass in 0 for the ACM bitfield, I think? It
seems a little weird to have this function and then write it in a way
mac80211 can't use it.

johannes

--=-9TQXvxeSqh4DH6scY/M3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFR+jAAoJEODzc/N7+QmaK2MQANPFyScbuMMSxQ5JqUTW2gN5
0XEoKBPXgKo76M7Wq4oqSLfIPopLnOiXqbk8yvwXbPdc0JSyE9QFCMlOudbvA+hk
6YbKCxuMzBFzZU7D3Wo5Yar+b6H39ORJn3Xc3fm2y73G1EGCXvECn5zLLP7k6CeP
Z7X2KI3UCUky0UaCWiOp3fI70zth39jx4XhVDtmSJZy7CPi4MAlRiZjqiGKQ71ga
pS9b2Z6iyZrnGaX3qbq+CSzlnZ9xS+D86p4hpUi/r2DQ7dpJiWL6kB4KJ7CZUyYF
CWo5yFRi1UcRfYzVGt3AHz+o82XShNp3nmILY45l3EjkGbOb/MB8shGi3Eqr98G2
g4WYY4hqWIZQtTYsmRJsJ90rV07Lrz8DsRIhs9FsPcYRCfj/Gt7o68EqbkjxgzO2
ukSSqbiQwi+H1S22c+FQExZxAGyJ4idXM1Vvi96IwxB1EUQ/LntHMIJ0OC6Vc3S4
ZoCBIyEQFKGaWiA7fKfvOzEN3Ub92tsosYJ43IdTaERbKOaaXbwND3DuLGmW12B1
3kJkugwBniXQSHH7lVI7o+Pe6+/s0d7t5xjWd7VbozDLx3rvosmF5JX/+e+ujvUk
R7UzkjIgz0ONcQn5XT9NM8hC/HHb+2zSulgMzvuyBnqqydEBk+5RYaDhj67kBD/E
sQECIIxyJZAIgG/1QDwW
=Lc8H
-----END PGP SIGNATURE-----

--=-9TQXvxeSqh4DH6scY/M3--


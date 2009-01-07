Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbZAGPmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 10:42:53 -0500
Subject: Re: [PATCH] p54: return NETDEV_TX_OK in p54_tx and fix sparse
	warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200901071640.08721.chunkeey@web.de>
References: <200901071640.08721.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yRfHp5fkriJeuUue8z5a"
Date: Wed, 07 Jan 2009 16:43:17 +0100
Message-Id: <1231342997.3545.44.camel@johannes> (sfid-20090107_164257_031400_85F402D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yRfHp5fkriJeuUue8z5a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 16:40 +0100, Christian Lamparter wrote:
> This patch addresses all recent comments from Johannes Berg:
>=20
> 1st: (reference http://marc.info/?l=3Dlinux-wireless&m=3D123124685019631 =
)
> >First off: all those should return NETDEV_TX_OK/BUSY.
> >iwl-agn: returns 0 (=3D=3D NETDEV_TX_OK, but still should be changed)=20
> >[...]
> >p54: same (some paths)
>=20
> 2nd:
> > due to your PS patch ("p54: power save management"), please run sparse:
> > make C=3D2 CF=3D-D__CHECK_ENDIAN__ M=3D...
> > +drivers/net/wireless/p54/p54common.c:1753:8: warning: incorrect type i=
n assignment (different base types)
> > +drivers/net/wireless/p54/p54common.c:1769:29: warning: incorrect type =
in assignment (different base types)
> The cpu_to_le16 ended up in the wrong line... Sorry!
>=20
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/=
p54/p54common.c
> index c4ad148..1702eac 100644
> --- a/drivers/net/wireless/p54/p54common.c
> +++ b/drivers/net/wireless/p54/p54common.c
> @@ -1508,7 +1508,7 @@ static int p54_tx(struct ieee80211_hw *dev, struct =
sk_buff *skb)
>  	queue_delayed_work(dev->workqueue, &priv->work,
>  			   msecs_to_jiffies(P54_TX_FRAME_LIFETIME));
> =20
> -	return 0;
> +	return NETDEV_TX_OK;
> =20
>   err:
>  	skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
> @@ -1750,7 +1750,7 @@ static int p54_set_ps(struct ieee80211_hw *dev)
>  	int i;
> =20
>  	if (dev->conf.flags & IEEE80211_CONF_PS)
> -		mode =3D cpu_to_le16(P54_PSM | P54_PSM_DTIM | P54_PSM_MCBC);
> +		mode =3D P54_PSM | P54_PSM_DTIM | P54_PSM_MCBC;

you also have to declare mode as u16, no?


--=-yRfHp5fkriJeuUue8z5a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZM2TAAoJEKVg1VMiehFYrZQP/0wV006Srj4uiJhjjg5tSiu8
5GOJAl/onTeDhu/3gLTscXnn1YPm6keQtYpLO8ej/LBSwrj8l4pxsliOnuEjJ78A
lwmgElVR+8x1haspHs/J6inxf6nzLfu+3Dp1Gj2638BZ1M9ypzeHd36Lnd935O5G
Uk7kc8VLmFSwvYcbR5F1YHJ5JIv2SW5Gw6RPOWdc0CUXVxRRalnCtjM/21DaTfEU
FbFDmcrIYUjTKHJsc4CQlmaTGSWffe0Q0hk35OwPfTanAcPcyAqTnzik9km/+aXF
b0AFP7lZQbtEyYItuKCOvmv2ueIMHCpr90bFg/9iJtV44p/l/mZIxhh0LdiS4mv/
LujeEQjd2XK4VWQnZecOvy/arllz61itV5rqPjImhlTclaCRc3pwbun2NhVxhsAK
Hd+Qo4Vh/yZBkYwg8lNGqo/fylNaoGyZ0ICFW2uPglh/2ZjuBw/GjcHXY55bmSXA
Hf+PAuMKEkgn68Agjcb+/s6non/jXn8iToiz0s1sg7tgI0MsygxL1HJ8aNF1fjyf
NoF12ze757kV9EPqQ9Js2T1Gwo8RbHMOWkUJWTS/esmOmlBixuQqanpp7yTueYki
hm6AotQuPCD3vdup5iFxEb8but5tcCJOJZdr9Z680F35G2jZAlW+LEq61VMsB62g
qdNpDOSfLyO7FLO7gqwg
=O0vA
-----END PGP SIGNATURE-----

--=-yRfHp5fkriJeuUue8z5a--


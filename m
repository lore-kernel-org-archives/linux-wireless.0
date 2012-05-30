Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:60243 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab2E3Tlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 15:41:39 -0400
Date: Wed, 30 May 2012 21:41:26 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Claudio Pisa <claudio.pisa@uniroma2.it>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: fix flag check for QoS NOACK frames
Message-ID: <20120530194126.GA11340@pandem0nium> (sfid-20120530_214144_428655_21551F38)
References: <1338206785-3222-1-git-send-email-claudio.pisa@uniroma2.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
In-Reply-To: <1338206785-3222-1-git-send-email-claudio.pisa@uniroma2.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Claudio,

thanks for fixing my bugs, that was definitly wrong! :)

Acked-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

Cheers,
	Simon

On Mon, May 28, 2012 at 01:06:25PM +0100, Claudio Pisa wrote:
>=20
> Signed-off-by: Claudio Pisa <claudio.pisa@uniroma2.it>
> ---
>  net/mac80211/tx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index d67d36f..cb17497 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -153,7 +153,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_=
data *tx,
> =20
>  	/* Don't calculate ACKs for QoS Frames with NoAck Policy set */
>  	if (ieee80211_is_data_qos(hdr->frame_control) &&
> -	    *(ieee80211_get_qos_ctl(hdr)) | IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
> +	    *(ieee80211_get_qos_ctl(hdr)) & IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
>  		dur =3D 0;
>  	else
>  		/* Time needed to transmit ACK
> --=20
> 1.7.10.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/Gd+YACgkQrzg/fFk7axZTXACg5cpk+vQHGPbing/Ge2N7i2gU
wrMAoLkTQlFUzlA1fz3Om+ve2QesXmD+
=kodF
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--

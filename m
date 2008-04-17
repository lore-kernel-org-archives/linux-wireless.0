Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYDRMIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 08:08:06 -0400
Subject: Re: [PATCH v4] mac80211: Replace ieee80211_tx_control->key_idx
	with ieee80211_key_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <200804171941.03002.IvDoorn@gmail.com> (sfid-20080417_183653_595777_FF5E34A3)
References: <200804171728.30188.IvDoorn@gmail.com>
	 <200804171759.54830.IvDoorn@gmail.com>
	 <200804171923.41533.IvDoorn@gmail.com>
	 <200804171941.03002.IvDoorn@gmail.com>
	 (sfid-20080417_183653_595777_FF5E34A3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aEXf1Wu5fqo97BHYIMEO"
Date: Fri, 18 Apr 2008 00:02:26 +0200
Message-Id: <1208469746.4066.98.camel@johannes.berg> (sfid-20080418_130820_875484_593012D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aEXf1Wu5fqo97BHYIMEO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> @@ -1936,7 +1936,7 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iw=
l_priv *priv,
>  	struct iwl_wep_key *wepkey;
>  	int keyidx =3D 0;
> =20
> -	BUG_ON(ctl->key_idx > 3);
> +	BUG_ON(ctl->hw_key->hw_key_idx > 3);
> =20
>  	switch (keyinfo->alg) {
>  	case ALG_CCMP:
> @@ -1955,11 +1955,11 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct =
iwl_priv *priv,
>  		break;
> =20
>  	case ALG_WEP:
> -		wepkey =3D &priv->wep_keys[ctl->key_idx];
> +		wepkey =3D &priv->wep_keys[ctl->hw_key->hw_key_idx];
>  		cmd->cmd.tx.sec_ctl =3D 0;
>  		if (priv->default_wep_key) {
>  			/* the WEP key was sent as static */
> -			keyidx =3D ctl->key_idx;
> +			keyidx =3D ctl->hw_key->hw_key_idx;
>  			memcpy(&cmd->cmd.tx.key[3], wepkey->key,
>  							wepkey->key_size);
>  			if (wepkey->key_size =3D=3D WEP_KEY_LEN_128)

All this is rather odd. I think you (Intel) may want to change it to use
hw_key->keyidx and just leave the hw_key_idx alone, it seems to be a
copy of keyidx in iwl4965 but an actual index as it was meant to be used
in iwl3945?

johannes

--=-aEXf1Wu5fqo97BHYIMEO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAfI8aVg1VMiehFYAQJ2dhAAmiBX4fle2r4YHD24BLtJNGS0icIdzhPX
75A70L3aeIY8id+jng86s4T7xNKhV5oxviV4BsGmKOqUomBrwyuV53h2S4M11NHy
DGpr1d+jXgqSVnmdtExLVVHlr5sSySnctGPlm/gkJ+ZGnA5oDEZyo1gqcBlPE4Gc
fBGOjJF63O+aWbTt9tYz1H1ILzz9HcDmrlhmZUaR9gepBfu5vC4Lhpwi7CDbXgqt
r2M2ClW/k3ykLe8MTQnJreXkBYQq1dJ6Qe1iSROv7JDYjKu2GFch+0FjBzaJqPg0
agR80mkX/QmHRO7EjEe9XbZErzx2BPGkqK0NBxpdL4wWoQKuN4kOuZbdbBYqwF6B
FtWvtW4eXNsj0wuR04wYedSJh5dBETrdKwicyPzobflMFF9IgdMJON3HC+QaZVt1
H5K6UdmVJbhoWwAZj0BNUJZqVP7przTPGXNGuV36QXVmFp0iv24JoEfeiQJQWORu
xFlAnMTXGVNF/JT5ag7fnZgiv1+95BBcKxHS6EbiDXjHKGTTsouJ07/9MQBXjkQ7
vsnKSjPfuQhKoL+DyYOKffL3/+lYs+8BwymdTljnSVQOm1sBmHb48jCN4EeTrNUe
UGX1O9wOUE21cnbFF0oB6eWdDAqJ2uutRgR3W6x+6ZFDZX4Zg3Mpfmmy8RHYdxcH
kA8EwmfIAuI=
=8CDo
-----END PGP SIGNATURE-----

--=-aEXf1Wu5fqo97BHYIMEO--


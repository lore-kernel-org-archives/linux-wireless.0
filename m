Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYI3HRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 03:17:55 -0400
Subject: Re: [PATCH RFC] mac80211: change rate control API to allow
	multi-rate retry
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48E17E75.50201@openwrt.org> (sfid-20080930_033823_737779_1604EF6A)
References: <48E17E75.50201@openwrt.org>
	 (sfid-20080930_033823_737779_1604EF6A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-05s+UH77RwQjzMurgt2+"
Date: Tue, 30 Sep 2008 09:17:49 +0200
Message-Id: <1222759069.7064.52.camel@johannes.berg> (sfid-20080930_091800_226945_A4538ABF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-05s+UH77RwQjzMurgt2+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-30 at 03:18 +0200, Felix Fietkau wrote:
> =20
> +/* maximum number of alternate rate retry stages */
> +#define IEEE80211_TX_MAX_ALTRATE	3
> +
> +/**
> + * struct ieee80211_tx_altrate - alternate rate selection/status
> + *
> + * @rate_idx: rate index to attempt to send with
> + * @limit: number of retries before fallback
> + */
> +struct ieee80211_tx_altrate {
> +	s8 rate_idx;
> +	u8 limit;
> +};
> +
>  /**
>   * struct ieee80211_tx_info - skb transmit information
>   *
> @@ -335,14 +349,16 @@
>  			struct ieee80211_key_conf *hw_key;
>  			struct ieee80211_sta *sta;
>  			unsigned long jiffies;
> -			s8 rts_cts_rate_idx, alt_retry_rate_idx;
> +			s8 rts_cts_rate_idx;
>  			u8 retry_limit;
>  			u8 icv_len;
>  			u8 iv_len;
> +			struct ieee80211_tx_altrate retries[IEEE80211_TX_MAX_ALTRATE];

If I'm counting correctly, that struct is now 2 bytes too large, you can
cut out retry_limit I'd think by updating drivers to use
retries[0].limit though. And iv/icv length can both be removed and added
into the key_conf I think.

johannes

--=-05s+UH77RwQjzMurgt2+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4dKZAAoJEKVg1VMiehFYMiMP/1kL8MBJDXsT4v7rzvA5nviE
f8jqw+raIbFu7AqhxHMqoIjWUw6GasFWYNM6XvyI/CXU3gI/o628cOs6ozRHldad
aAgtONdhVDTBejjTa6jg5Nhz36+BLt7SsYlaqgspPqlRnmrsV8+1xoDUIGSJZcVv
aFxgE4qB2Xs4wIUTE5s8skdRXwXz0mh+HaxyWWG/KJckl8Za3MLN+JRr5ljFZvse
zqd5yBhpOG1TpVc3OC/aRhGSF5+uVo2Yuor8GQuTqgsVE5yTcbfap97E9Ls4dI/5
+aQbxu94Fa2K3pYwtpNBJggsQrJtPENFKhrbBNIJuZSA7zpCdYK6r28TKQFeFjVQ
LwDp6FFJ9ZMqtVJvpEFezVi2t0SnC3ijxuNbC1qdwfVpDaFK0HkGFEaBMHAGyNad
TbrKh4JJUZvwyI6x2rFCwwtzY2oRLQuxddghTttKKwFuBa/DEQGWTfcffMO5teY7
7yqq73rNZAMq2kzzBv0S/B4BvyTGoFGUGH5L4VPT6VpSyP3NEpFMdT8oYH7K1z8i
HUuefNyE3WEmJ9T7a+uXxjP+VZBJVLghKw2jwgwqf3YqEvqJvFBgG7jrsDtEVaUn
66PUG3xrs6J2oR7DxwsQ//BSAjhdPz3SWLLQOW2uOR7+3/ZEPHS7l1UiXUATFRKS
nxTMJdi2GiJ78Rm1g5AO
=nG61
-----END PGP SIGNATURE-----

--=-05s+UH77RwQjzMurgt2+--


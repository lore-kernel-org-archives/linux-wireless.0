Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYJ3KtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:49:16 -0400
Subject: Re: [PATCH 4/4] nl80211: Add TX queue parameter configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081029175307.601433193@localhost>
References: <20081029174934.817700763@localhost>
	 <20081029175307.601433193@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XNZ7Kn761wDqpaxLL6B1"
Date: Thu, 30 Oct 2008 11:49:11 +0100
Message-Id: <1225363751.3690.26.camel@johannes.berg> (sfid-20081030_114920_376373_74F0C56C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XNZ7Kn761wDqpaxLL6B1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-29 at 19:49 +0200, Jouni Malinen wrote:

> + * enum nl80211_txq_attr - TX queue parameter attributes
> + * @NL80211_TXQ_ATTR_QUEUE: TX queue identifier (NL80211_TXQ_Q_*)
> + * @NL80211_TXQ_ATTR_TXOP: Maximum burst time in units of 32 usecs, 0 me=
aning
> + *	disabled
> + * @NL80211_TXQ_ATTR_CWMIN: Minimum contention window [a value of the fo=
rm
> + *	2^n-1 in the range 1..32767]
> + * @NL80211_TXQ_ATTR_CWMAX: Maximum contention window [a value of the fo=
rm
> + *	2^n-1 in the range 1..32767]
> + * @NL80211_TXQ_ATTR_AIFS: Arbitration interframe space [0..255]

You have to add the invalid, after_last and max to the kernel-doc too
otherwise it'll warn about it.

> =20
> +struct ieee80211_txq_params {
> +	u8 queue;
> +	u16 txop;
> +	u16 cwmin;
> +	u16 cwmax;
> +	u8 aifs;
> +};

Maybe add some kernel-doc describing the units etc.? And describing
which values are valid for 'queue' (or should that use the enum
VO/VI/...?)

> +	if (info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS]) {
> +		struct ieee80211_txq_params txq_params;
> +		struct nlattr *tb[NL80211_TXQ_ATTR_MAX + 1];
> +
> +		nla_for_each_nested(nl_txq_params,
> +				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
> +				    rem_txq_params) {
> +			nla_parse(tb, NL80211_TXQ_ATTR_MAX,
> +				  nla_data(nl_txq_params),
> +				  nla_len(nl_txq_params),
> +				  txq_params_policy);
> +			result =3D parse_txq_params(tb, &txq_params);
> +			if (result)
> +				goto bad_res;
> +
> +			if (!rdev->ops->set_txq_params) {
> +				result =3D -EOPNOTSUPP;
> +				goto bad_res;
> +			}

Seems you could do that check outside the loop?

Otherwise looks good to me, thanks.

johannes

--=-XNZ7Kn761wDqpaxLL6B1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCZEkAAoJEKVg1VMiehFYpJ8P/jOPCCqV8otdvLmpNMkCpIj0
84ld+fKD5//v1eq6WS3L8VQicU5Sa2qekAvj8MJLtnoyIjIJp1cJmPaVXkvk6iPZ
Vj0t+zz077wCN5a7n8xXeD4JhTxL8AJpZefa6xarGKhNLdoa5+oT+0tKIzgOj1Ut
3vs6MtJ4DRxiAd8KG1L9WhOhgv590eTa5TfKmapl8QEaD8rVuTq69z/zHPPZCsY/
/x7rrSNDHA/agATQSno/HUpdnYY96PdLfALsXXnbK+OY0UTEPV+PzJM4mse12XeE
GWjBEloEbwC+SNlYc/zh9lbvmBu4bfZFMIo0y/Gcsi6LyZnMJyKUkWVQL8Yltotb
dUdbK+TrbcIT5OZOQYuqR6QIgOkKfu20RHFuU+DXq85iJxyivt/OV6cPNyrdXtiM
Mr0gRXDGBEhYGwmfogWl+KsRAO2PWJo9F/gHbekhFlDKpRF70VpexAusqc+5dfIl
Ib/2PWFbZ5M692bvFX6smmai2lhD5PdwYTk5l/+EtQYEqSm/hWHltJUxyG29TyaQ
hN3ICfRPSQmi9wBEEkDfMd6lA8T6ahy8Rfo/ZPR9U1DVgRemdqdZhhR67OHkx7y4
/ZLD/SEACB3hqD4u62rCMLJplDvNwXNICQpWB4A6Cut2AlaLL8b2d+SdxS48XxAk
qO/BthkDn1kw1ZUto4f9
=CVd8
-----END PGP SIGNATURE-----

--=-XNZ7Kn761wDqpaxLL6B1--


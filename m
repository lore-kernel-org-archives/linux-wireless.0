Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZKIX6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:58:21 -0500
Subject: Re: [PATCH v2 11/20] mac80211: implement RANN processing and
 forwarding
From: Johannes Berg <johannes@sipsolutions.net>
To: Rui Paulo <rpaulo@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1257810418-30075-12-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
	 <1257810418-30075-12-git-send-email-rpaulo@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-401AvAWZgaTOtWflki1l"
Date: Tue, 10 Nov 2009 00:57:50 +0100
Message-ID: <1257811070.29454.198.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-401AvAWZgaTOtWflki1l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-09 at 23:46 +0000, Rui Paulo wrote:

> +struct ieee80211_rann_ie {
> +	u8 rann_flags;
> +	u8 rann_hopcount;
> +	u8 rann_ttl;
> +	u8 rann_addr[6];

I'd prefer ETH_ALEN here, but it only changes the code, not the binary,
of course :)

> @@ -826,6 +827,7 @@ struct ieee802_11_elems {
>  	u8 preq_len;
>  	u8 prep_len;
>  	u8 perr_len;
> +	u8 rann_len;
>  	u8 ch_switch_elem_len;

I suspect you can remove rann_len since it's fixed?

> +	case MPATH_RANN:
> +		mhwmp_dbg("sending RANN from %pM\n", orig_addr);
> +		ie_len =3D 17;

The other two I wouldn't care too much about, but please use sizeof()
like you did when parsing the IEs.

johannes

--=-401AvAWZgaTOtWflki1l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+Kx5AAoJEODzc/N7+QmarwwP/2+BVnCeM6Io3juJbMLPgMdl
R7ltlrXF3fTx821KQwewbseElVOAgCgQfYlTDveKkyAz0jzj84oQOtIf3Xgl6vH3
6YN8m1fEynTJAst8yL/LpXNVYZj+wBfDi4g/KPtyCAT+FJvdhC0JH/hCI4jffRyG
M+DZnCWV9BQpznQnpgUkMHEmMyBSydgsW5Y41VWXBLjTuOSV9uD2RC2Q2qNZvGJA
eU03sFRQEkJUmKaDvIUZgY1B1D80QQIjPO5ZfrE9/1Jy8RAFTD9uDflsxHIoS+kW
npWb/veeJHWnykfSayZRVwdmarbSU9buWyTUeH+xq/PFYCAYksuGmMXwjcscAtGS
I65z2KltWR2EIyaSCPFr5NYwvY+f5EsRBidDB8aisec+azeSfNSMmAJi0wJVNcnG
i6lys0ZMgK2kMgSucdwhScLBydE79GmpQwpc0iOVQgaXzhiTUALrm/Cd1BMLi6OK
/ZcI24bXkj+CmfqgFEA0RMUmq9p98I6Ph+TgVyjzKYvk+xCwPBH9vcNBDG2ox5/v
5yxw4AxQMlWx9KXA9ldzRf8vAEgprI0zl/6c74lXSdyVmiJQ9E/dvEV0Eu8p/1fg
PI7gl3Ntfora7gHgJnGkpolrr0jfSIfoeCsm/VbZzFHLLlSWSHqyWdpjY7WUyrgw
0xTqPyawWfRnngxDaP0W
=Bl1t
-----END PGP SIGNATURE-----

--=-401AvAWZgaTOtWflki1l--


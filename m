Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494AbYLKRYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 12:24:50 -0500
Subject: Re: [Patch] nl80211: Add signal strength and bandwith to
	nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812111807.24168.hrogge@googlemail.com> (sfid-20081211_181023_425250_2B9B862F)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812102158.56201.hrogge@googlemail.com>
	 <1228942863.15837.73.camel@johannes.berg>
	 <200812111807.24168.hrogge@googlemail.com>
	 (sfid-20081211_181023_425250_2B9B862F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qvUR9w9qJeVGwj1FxE9A"
Date: Thu, 11 Dec 2008 18:24:08 +0100
Message-Id: <1229016248.8081.44.camel@johannes.berg> (sfid-20081211_182453_408960_4350BF7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qvUR9w9qJeVGwj1FxE9A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 18:07 +0100, Henning Rogge wrote:
> This patch adds signal strength and transmission bitrate
> to the station_info of nl80211.

Ok, this looks good, except a few minor things:

> + * @signal: signal strength of last received package in dBm

I still want to change the docs to read "packet" here ;)

> + * @txrate: current unicast bitrate to this station
>   */
>  struct station_info {
>  	u32 filled;
> @@ -200,6 +238,8 @@ struct station_info {
>  	u16 llid;
>  	u16 plid;
>  	u8 plink_state;
> +	u8 signal;

and I think a u8 isn't the right type. It should be s8.

Can you also send me the corresponding iw patch?

johannes

--=-qvUR9w9qJeVGwj1FxE9A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQUy0AAoJEKVg1VMiehFY8fIP/3XKssJGhO56ZHRU7Uzy0hKe
maGv1oIOa/z6FkbaE0RotjBBujB2g/yyND7BtxibimChVd1NHLOnitp80kaI4sbB
/P4UjUzD1cWaud2bkZeHKxS4puhzVJmoFy5x0kbUk7N+h3dp2IseUCzOAzri0cbH
CChvZvOYquz+QS8H/f1NJkQYWwH/JNhOEZYWQTmXimwpV5jSne18WnZjKDPQ7CrT
Hqz/N5vxnGwI1h0u87QbC2WXy1eWgwJXe0qPaFEpEHHIGs5XlNN9Nikd5h/EHQya
BQ7wG2Gk2qLncPQp6zNwiOUJbWHvUutBOD6uL+oO5uIdIALIoBls7LFVE994o/dd
3/Cnt25r6kUR/SUk3k9tyjW8Hh+aybIdV/Fpj2/ZZIc+jo9efL7t2uhXRPQPFNj6
+Njer8nqz63TGBhJpbgYKsYniVciATSZiMppFfgAecJLI+a2eFi807kOBkvkCVGn
mVEVzPtRJPHp9ino7+VFRvNqJqvjB+6iMTbwxngvNxh4Fzy4VQXTCQcMtj801kT0
0MoWFeJBIjLKliB9zs6DcFYwtvlVSwO512tQaYRyLqTP+EJHPWej1bV/6FjL63WG
tOlkr1l1N8ZQ+HCRkksfn0g214xX334bjwvS1TL4E9WWCDcISM+6o3nqJKpVAJ57
w8RAtZ/v0Oca7KpDLhCc
=mZQ2
-----END PGP SIGNATURE-----

--=-qvUR9w9qJeVGwj1FxE9A--


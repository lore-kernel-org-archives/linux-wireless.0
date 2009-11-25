Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbZKYLgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 06:36:16 -0500
Subject: Re: [RFC PATCH] mac80211: Send null data frame after disabling
 power save in Tx path.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1259132754-18164-1-git-send-email-vnatarajan@atheros.com>
References: <1259132754-18164-1-git-send-email-vnatarajan@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4+/P+QJTYXD1y/R/h1IA"
Date: Wed, 25 Nov 2009 11:21:01 +0100
Message-ID: <1259144461.3491.58.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4+/P+QJTYXD1y/R/h1IA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-25 at 12:35 +0530, Vivek Natarajan wrote:
> For drivers setting IEEE80211_HW_PS_NULLFUNC_STACK, a null data frame
> with PM bit off has to be sent before sending normal data frames.
> If it is done in ps_disable_work, the actual data frame would be
> queued first before this work is executed and hence null data frame
> will be queued later. And also, this null data frame has to be sent
> only after clearing CONF_PS.
> Hence, directly clearing CONF_PS and sending null data frame in
> ieee80211_xmit seems to function properly.
>=20
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  net/mac80211/tx.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 943def2..51f537c 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1433,10 +1433,10 @@ static void ieee80211_xmit(struct ieee80211_sub_i=
f_data *sdata,
> =20
>  	if (need_dynamic_ps(local)) {
>  		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
> -			ieee80211_stop_queues_by_reason(&local->hw,
> -					IEEE80211_QUEUE_STOP_REASON_PS);
> -			ieee80211_queue_work(&local->hw,
> -					&local->dynamic_ps_disable_work);
> +			local->hw.conf.flags &=3D ~IEEE80211_CONF_PS;
> +			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +			if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
> +				ieee80211_send_nullfunc(local, sdata, 0);

Regardless of Kalle's comment I thought I'd point out that you cannot do
this anyway as _hw_config() must be able to sleep.

johannes

--=-4+/P+QJTYXD1y/R/h1IA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDQUKAAoJEODzc/N7+Qma8tMQALmImTMKW5J6MQySxkCIunAe
gGf+WFmr2x07nUZlNCrziVpkIT+6igw9tYrssRf5Qkc8z8C7cDsF/Ur1rtbme8uH
2eCzdA6vxnIaVX6tgOmxXJ3DD6bL8mxcTbrSerc2+hRTFz/Abf6jlZb9IV059wYC
adwTPU+cXkG7A6XJ5Zn3RvCQ+DTZetry/51RiuaH+yRYgT5OC+F8P5nI+2qPLqGa
A8+D61Wky3TQGFkEX+R7LP9ClyBO6NqEF74UiA3SHfspHDeST/kGcN/DPAVVM9V1
tR2V2HpdR+iXq1vwVj2NxMo+b6cnuoc4Y9EMYfNLk5Fy5Kev50e3nWF58Lfe18dc
sQ0lqEye82+r+Vpmf4PsKSkrUV4dOr6N4ZpEjMSmecOGGdNVbw4lUh66MdaxMNAZ
LY1u9rsrnLlpQMk/UPJd1lzP6ls2a2KGoDKNIJFZpkhup3eZXxSeHB2ZXs5Zcp0k
kVTxaOp2SDCrWNPMM6ImRlC5RDpluV4dpyLK0xV9KI8XB3gf+h+WQi5AMIh+wtdG
1VM/gO+wIRkhGKd9/ihi2EYFBo3sYzZTj0YmGNxX+J3rJOve1uLgBgRw3RpKG7/F
Od+zZDYzz2sFFdK/2qPXXLLtE/Qe2CRyyJKEAXfd+SDNzEMjKsvjKqvay73XoI2w
0u0dWLNsp63Andjg2msv
=DP+7
-----END PGP SIGNATURE-----

--=-4+/P+QJTYXD1y/R/h1IA--


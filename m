Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYIQELP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 00:11:15 -0400
Subject: Re: [PATCH] libertas: correct "limited range of data type" warning
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221514062-30679-1-git-send-email-linville@tuxdriver.com>
References: <>  <1221514062-30679-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 17 Sep 2008 00:11:40 -0400
Message-Id: <1221624700.23335.6.camel@localhost.localdomain> (sfid-20080917_061122_117119_BB65A3AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 17:27 -0400, John W. Linville wrote:
> CC [M]  drivers/net/wireless/libertas/wext.o
> drivers/net/wireless/libertas/wext.c: In function =E2=80=98lbs_get_rt=
s=E2=80=99:
> drivers/net/wireless/libertas/wext.c:307: warning: comparison is alwa=
ys
> false due to limited range of data type
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/wext.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wirel=
ess/libertas/wext.c
> index 1156be5..11297dc 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -281,7 +281,7 @@ static int lbs_set_rts(struct net_device *dev, st=
ruct iw_request_info *info,
>  	if (vwrq->disabled)
>  		val =3D MRVDRV_RTS_MAX_VALUE;
> =20
> -	if (val < MRVDRV_RTS_MIN_VALUE || val > MRVDRV_RTS_MAX_VALUE)
> +	if (val > MRVDRV_RTS_MAX_VALUE) /* min rts value is 0 */
>  		return -EINVAL;
> =20
>  	ret =3D lbs_set_snmp_mib(priv, SNMP_MIB_OID_RTS_THRESHOLD, (u16) va=
l);
> @@ -304,8 +304,7 @@ static int lbs_get_rts(struct net_device *dev, st=
ruct iw_request_info *info,
>  		goto out;
> =20
>  	vwrq->value =3D val;
> -	vwrq->disabled =3D ((val < MRVDRV_RTS_MIN_VALUE)
> -			  || (val > MRVDRV_RTS_MAX_VALUE));
> +	vwrq->disabled =3D val > MRVDRV_RTS_MAX_VALUE; /* min rts value is =
0 */
>  	vwrq->fixed =3D 1;
> =20
>  out:

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

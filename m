Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:40972 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030313Ab2CAKUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 05:20:20 -0500
Message-ID: <20120301121953.81953z1rxd2ocpq8@www.81.fi> (sfid-20120301_112024_030703_07187E8C)
Date: Thu, 01 Mar 2012 12:19:53 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 4/4] rndis_wlan: prevent integer overflow in
 indication()
References: <20120229063753.GF18031@elgon.mountain>
In-Reply-To: <20120229063753.GF18031@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dan Carpenter <dan.carpenter@oracle.com>:

> If we pick a high value for "offset" then it could lead to an integer
> overflow and we would get past the check for:
> 	if (offset + len > buflen) { ...

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/rndis_wlan.c  
> b/drivers/net/wireless/rndis_wlan.c
> index 74e2d1b..dfd76e3 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -3043,7 +3043,7 @@ static void  
> rndis_wlan_media_specific_indication(struct usbnet *usbdev,
>  			struct rndis_indicate *msg, int buflen)
>  {
>  	struct ndis_80211_status_indication *indication;
> -	int len, offset;
> +	unsigned int len, offset;
>
>  	offset = offsetof(struct rndis_indicate, status) +
>  			le32_to_cpu(msg->offset);
> @@ -3055,7 +3055,7 @@ static void  
> rndis_wlan_media_specific_indication(struct usbnet *usbdev,
>  		return;
>  	}
>
> -	if (offset + len > buflen) {
> +	if (len > buflen || offset > buflen || offset + len > buflen) {
>  		netdev_info(usbdev->net, "media specific indication, too large to  
> fit to buffer (%i > %i)\n",
>  			    offset + len, buflen);
>  		return;
>
>




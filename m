Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:40824 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030316Ab2CAKTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 05:19:48 -0500
Message-ID: <20120301121935.1627611hqt6w784c@www.81.fi> (sfid-20120301_111951_652375_4C659ABE)
Date: Thu, 01 Mar 2012 12:19:35 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/4] rndis_wlan: remove unneeded variables
References: <20120229063628.GD18031@elgon.mountain>
In-Reply-To: <20120229063628.GD18031@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dan Carpenter <dan.carpenter@oracle.com>:

> We never use the "len" variable.

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/rndis_wlan.c  
> b/drivers/net/wireless/rndis_wlan.c
> index 6d8a986..99fab7d 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -1790,9 +1790,8 @@ static struct ndis_80211_pmkid  
> *remove_pmkid(struct usbnet *usbdev,
>  						struct cfg80211_pmksa *pmksa,
>  						int max_pmkids)
>  {
> -	int i, len, count, newlen, err;
> +	int i, count, newlen, err;
>
> -	len = le32_to_cpu(pmkids->length);
>  	count = le32_to_cpu(pmkids->bssid_info_count);
>
>  	if (count > max_pmkids)
> diff --git a/drivers/net/wireless/rndis_wlan.c  
> b/drivers/net/wireless/rndis_wlan.c
> index 99fab7d..a93cfe2 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -1830,9 +1830,8 @@ static struct ndis_80211_pmkid  
> *update_pmkid(struct usbnet *usbdev,
>  						struct cfg80211_pmksa *pmksa,
>  						int max_pmkids)
>  {
> -	int i, err, len, count, newlen;
> +	int i, err, count, newlen;
>
> -	len = le32_to_cpu(pmkids->length);
>  	count = le32_to_cpu(pmkids->bssid_info_count);
>
>  	if (count > max_pmkids)
>
>




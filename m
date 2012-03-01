Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:49431 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030313Ab2CAKTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 05:19:54 -0500
Message-ID: <20120301121948.27450js7jyojb134@www.81.fi> (sfid-20120301_111957_244011_A2EC052B)
Date: Thu, 01 Mar 2012 12:19:48 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 3/4] rndis_wlan: make some variables unsigned
References: <20120229063657.GE18031@elgon.mountain>
In-Reply-To: <20120229063657.GE18031@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dan Carpenter <dan.carpenter@oracle.com>:

> These variables can never be less than zero because we cap them in
> get_device_pmkids().  Let's make them unsigned here because it's simpler
> to not have to worry about negative numbers when we read the code.

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/rndis_wlan.c  
> b/drivers/net/wireless/rndis_wlan.c
> index a93cfe2..74e2d1b 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -1790,7 +1790,8 @@ static struct ndis_80211_pmkid  
> *remove_pmkid(struct usbnet *usbdev,
>  						struct cfg80211_pmksa *pmksa,
>  						int max_pmkids)
>  {
> -	int i, count, newlen, err;
> +	int i, newlen, err;
> +	unsigned int count;
>
>  	count = le32_to_cpu(pmkids->bssid_info_count);
>
> @@ -1830,7 +1831,8 @@ static struct ndis_80211_pmkid  
> *update_pmkid(struct usbnet *usbdev,
>  						struct cfg80211_pmksa *pmksa,
>  						int max_pmkids)
>  {
> -	int i, err, count, newlen;
> +	int i, err, newlen;
> +	unsigned int count;
>
>  	count = le32_to_cpu(pmkids->bssid_info_count);
>
>
>




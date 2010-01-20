Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab0ATBsO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 20:48:14 -0500
Subject: Re: [PATCH] libertas: Set/clear WPA keys before the WEP ones
From: Dan Williams <dcbw@redhat.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100118231920.GH5176@sortiz.org>
References: <20100118231920.GH5176@sortiz.org>
Content-Type: text/plain
Date: Tue, 19 Jan 2010 17:48:12 -0800
Message-Id: <1263952092.4481.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-01-19 at 00:19 +0100, Samuel Ortiz wrote:
> With the v10 firmware running on 8688 HW, clearing WPA keys after setting the
> WEP key prevents us from being able to associate with WEP APs.
> Swapping the calling order for assoc_helper_wpa_keys() and
> assoc_helper_wep_keys fixes that issue.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Dan Williams <dcbw@redhat.com>

Tested on both sd8686 (v9 fw) and usb8388 (v5 OLPC fw).  Switching
between WEP and WPA-PSK on-the-fly works as expected with this patch.

Though maybe we want to add a comment about this specific issue that
says something like:

/* v10 FW wants WPA keys to be set/cleared after WEP key operations,
 * otherwise it will fail to correctly associate to WEP networks.
 * Other firmware versions don't appear to care.
 */

> ---
>  drivers/net/wireless/libertas/assoc.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
> index 5e650f3..fb3dff0 100644
> --- a/drivers/net/wireless/libertas/assoc.c
> +++ b/drivers/net/wireless/libertas/assoc.c
> @@ -2052,13 +2052,6 @@ void lbs_association_worker(struct work_struct *work)
>  			goto out;
>  	}
>  
> -	if (   test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)
> -	    || test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
> -		ret = assoc_helper_wep_keys(priv, assoc_req);
> -		if (ret)
> -			goto out;
> -	}
> -
>  	if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
>  		ret = assoc_helper_secinfo(priv, assoc_req);
>  		if (ret)
> @@ -2078,6 +2071,14 @@ void lbs_association_worker(struct work_struct *work)
>  			goto out;
>  	}
>  
> +	if (   test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)
> +	    || test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
> +		ret = assoc_helper_wep_keys(priv, assoc_req);
> +		if (ret)
> +			goto out;
> +	}
> +
> +
>  	/* SSID/BSSID should be the _last_ config option set, because they
>  	 * trigger the association attempt.
>  	 */
> -- 
> 1.6.3.3
> 


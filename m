Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34567 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbcCDNlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 08:41:50 -0500
Received: by mail-wm0-f41.google.com with SMTP id p65so20841979wmp.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2016 05:41:49 -0800 (PST)
Date: Fri, 4 Mar 2016 15:41:42 +0200
From: Cihangir Akturk <cakturk@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: drivers: staging: rtl8723au: remove unneeded null test
Message-ID: <20160304134142.GA7697@portege.ulakbim.gov.tr> (sfid-20160304_144153_972048_8B58FE3D)
References: <1457096899-7421-1-git-send-email-cakturk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457096899-7421-1-git-send-email-cakturk@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 04, 2016 at 03:08:19PM +0200, Cihangir Akturk wrote:
> null test on pnetwork removed, because the iterator variable
> list_for_each_entry_safe cannot be null.
> 
> This commit fixes the following error reported by coccinelle:
> 
> drivers/staging/rtl8723au/core/rtw_mlme.c:1621:7-15: ERROR: iterator
> variable bound on line 1620 cannot be NULL
> 
> Signed-off-by: Cihangir Akturk <cakturk@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_mlme.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
> index 3adda55..a786fc4 100644
> --- a/drivers/staging/rtl8723au/core/rtw_mlme.c
> +++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
> @@ -1617,19 +1617,10 @@ rtw_select_candidate_from_queue(struct mlme_priv *pmlmepriv)
>  
>  	spin_lock_bh(&pmlmepriv->scanned_queue.lock);
>  	phead = get_list_head(queue);
> -	list_for_each_entry_safe(pnetwork, ptmp, phead, list) {
> -		if (!pnetwork) {
> -			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
> -				 "%s: return _FAIL:(pnetwork == NULL)\n",
> -				 __func__);
> -			goto exit;
> -		}
> -
> +	list_for_each_entry_safe(pnetwork, ptmp, phead, list)
>  		rtw_check_join_candidate(pmlmepriv, &candidate, pnetwork);
> -	}
> -
> -exit:
>  	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
> +
>  	return candidate;
>  }
>  
> -- 
> 2.1.4
> 

Opps. It seems I've made a mistake by not adding PATCH suffix. Please
ignore this patch, I will resend it in correct format.

Sorry for the noise.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:34491 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474Ab0HJSC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 14:02:56 -0400
Date: Tue, 10 Aug 2010 20:02:58 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] iwm3200wifi: remove comparison to WIFI_IF_NTFY_MAX in
 iwm_ntf_wifi_if_wrapper
Message-ID: <20100810180257.GA2567@sortiz-mobl>
References: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
 <1281461210-3528-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
In-Reply-To: <1281461210-3528-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 10, 2010 at 06:26:50PM +0100, John W. Linville wrote:
> drivers/net/wireless/iwmc3200wifi/rx.c: In function 'iwm_ntf_wifi_if_wrapper':
> drivers/net/wireless/iwmc3200wifi/rx.c:1198: warning: comparison is always true due to limited range of data type
> 
> This is, of course, because the value of WIFI_IF_NTFY_MAX is 0xff and
> hdr->oid is a u8.  This is obviously an attempt to verify the range on
> an input value, but since it has no effect it can simply be removed.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>

Thanks a lot John, you beat me at it.

Cheers,
Samuel.

> ---
>  drivers/net/wireless/iwmc3200wifi/rx.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
> index c02fced..a944893 100644
> --- a/drivers/net/wireless/iwmc3200wifi/rx.c
> +++ b/drivers/net/wireless/iwmc3200wifi/rx.c
> @@ -1195,11 +1195,8 @@ static int iwm_ntf_wifi_if_wrapper(struct iwm_priv *iwm, u8 *buf,
>  	IWM_DBG_NTF(iwm, DBG, "WIFI_IF_WRAPPER cmd is delivered to UMAC: "
>  		    "oid is 0x%x\n", hdr->oid);
>  
> -	if (hdr->oid <= WIFI_IF_NTFY_MAX) {
> -		set_bit(hdr->oid, &iwm->wifi_ntfy[0]);
> -		wake_up_interruptible(&iwm->wifi_ntfy_queue);
> -	} else
> -		return -EINVAL;
> +	set_bit(hdr->oid, &iwm->wifi_ntfy[0]);
> +	wake_up_interruptible(&iwm->wifi_ntfy_queue);
>  
>  	switch (hdr->oid) {
>  	case UMAC_WIFI_IF_CMD_SET_PROFILE:
> -- 
> 1.7.2.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


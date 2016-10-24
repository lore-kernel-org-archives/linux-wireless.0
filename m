Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36810 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934704AbcJXTmO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 15:42:14 -0400
Received: by mail-pf0-f172.google.com with SMTP id e6so104016141pfk.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 12:42:00 -0700 (PDT)
Date: Mon, 24 Oct 2016 12:41:57 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        dmitry.torokhov@gmail.com, briannorris@google.com,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 3/5] mwifiex: do not free firmware dump memory in
 shutdown_drv
Message-ID: <20161024194157.GC968@localhost> (sfid-20161024_214220_905297_5FE61AE3)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-3-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477318892-22877-3-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 24, 2016 at 07:51:30PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> mwifiex_upload_device_dump() already takes care of freeing firmware dump
> memory. Doing the same thing in mwifiex_shutdown_drv() is redundant.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Looks good:

Reviewed-by: Brian Norris <briannorris@chromium.org>

> ---
>  drivers/net/wireless/marvell/mwifiex/init.c | 19 -------------------
>  1 file changed, 19 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
> index 8e5e424..365efb8 100644
> --- a/drivers/net/wireless/marvell/mwifiex/init.c
> +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> @@ -407,8 +407,6 @@ static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
>  static void
>  mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
>  {
> -	int idx;
> -
>  	if (!adapter) {
>  		pr_err("%s: adapter is NULL\n", __func__);
>  		return;
> @@ -426,23 +424,6 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
>  	mwifiex_dbg(adapter, INFO, "info: free cmd buffer\n");
>  	mwifiex_free_cmd_buffer(adapter);
>  
> -	for (idx = 0; idx < adapter->num_mem_types; idx++) {
> -		struct memory_type_mapping *entry =
> -				&adapter->mem_type_mapping_tbl[idx];
> -
> -		if (entry->mem_ptr) {
> -			vfree(entry->mem_ptr);
> -			entry->mem_ptr = NULL;
> -		}
> -		entry->mem_size = 0;
> -	}
> -
> -	if (adapter->drv_info_dump) {
> -		vfree(adapter->drv_info_dump);
> -		adapter->drv_info_dump = NULL;
> -		adapter->drv_info_size = 0;
> -	}
> -
>  	if (adapter->sleep_cfm)
>  		dev_kfree_skb_any(adapter->sleep_cfm);
>  }
> -- 
> 1.9.1
> 

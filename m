Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36142 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZDVR52 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 13:57:28 -0400
Subject: Re: [PATCH] iwl3945: fix section type conflict on powerpc
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1240414421.5198.3.camel@johannes.local>
References: <1240414421.5198.3.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 11:03:33 -0700
Message-Id: <1240423413.29805.40.camel@rc-desk> (sfid-20090422_195731_643585_49F678D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-04-22 at 08:33 -0700, Johannes Berg wrote:
> For some reason on powerpc I get:
> 
> drivers/net/wireless/iwlwifi/iwl3945-base.c:1416: error:
> 	__ksymtab_iwl3945_rx_queue_reset causes a section type conflict
> drivers/net/wireless/iwlwifi/iwl3945-base.c:1416: error:
> 	__ksymtab_iwl3945_rx_queue_reset causes a section type conflict
> 
> The function doesn't need to be exported, and unexporting fixes it,
> so I'm not thinking about what is causing it.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-22 17:16:53.614082341 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-22 17:16:55.382327490 +0200
> @@ -1413,7 +1413,6 @@ void iwl3945_rx_queue_reset(struct iwl_p
>  	rxq->free_count = 0;
>  	spin_unlock_irqrestore(&rxq->lock, flags);
>  }
> -EXPORT_SYMBOL(iwl3945_rx_queue_reset);
>  
>  /*
>   * this should be called while priv->lock is locked
> 
> 

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette



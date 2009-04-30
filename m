Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13624 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765341AbZD3RPn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 13:15:43 -0400
Subject: Re: iwlwifi: remove EXPORT_SYMBOL for static symbol
From: reinette chatre <reinette.chatre@intel.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vget.kernel.org" <netdev@vget.kernel.org>
In-Reply-To: <m24ow6vah1.fsf@igel.home>
References: <m24ow6vah1.fsf@igel.home>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 10:21:59 -0700
Message-Id: <1241112119.10498.11.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-04-30 at 00:58 -0700, Andreas Schwab wrote:
> It does not make sense to apply EXPORT_SYMBOL to a static symbol.  Fixes
> this build error:
> 
> drivers/net/wireless/iwlwifi/iwl3945-base.c:1697: error: __ksymtab_iwl3945_rx_queue_reset causes a section type conflict
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
> This obsoletes 6269b731560d69c5eaa929909891edec39496d71, which was

>From which repo is this commit id? 

> misattributed as a compiler bug.
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- linux-2.6.30-rc4.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-30 08:59:41.000000000 +0200
> +++ linux-2.6.30-rc4/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-30 09:34:14.000000000 +0200
> @@ -1745,7 +1745,6 @@ static void iwl3945_rx_queue_free(struct
>  	rxq->bd = NULL;
>  	rxq->rb_stts  = NULL;
>  }
> -EXPORT_SYMBOL(iwl3945_rx_queue_free);
>  
> 
>  /* Convert linear signal-to-noise ratio into dB */
> 

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette



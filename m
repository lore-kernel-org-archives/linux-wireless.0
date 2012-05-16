Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50889 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506Ab2EPRsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 13:48:08 -0400
Date: Wed, 16 May 2012 13:41:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: add __printf argument checking
Message-ID: <20120516174121.GF3508@tuxdriver.com> (sfid-20120516_194835_983748_71C6E9A7)
References: <1337086877.4546.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1337086877.4546.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This one causes a few warnings here -- can we fix those at the same time as we add this?

  CC      drivers/net/wireless/iwlwifi/iwl-agn-sta.o
drivers/net/wireless/iwlwifi/iwl-agn-sta.c: In function ‘iwl_sta_calc_ht_flags’:
drivers/net/wireless/iwlwifi/iwl-agn-sta.c:238:2: warning: too few arguments for format

  CC      drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.o
drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: In function ‘iwl_rx_handle’:
drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:516:3: warning: format ‘%d’ expects type ‘int’, but argument 6 has type ‘struct iwl_rx_mem_buffer *’
drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:516:3: warning: too few arguments for format

On Tue, May 15, 2012 at 03:01:17PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Joe Perches suggested adding the __printf attribute
> to the __iwl_dbg function to check arguments; add it
> to all of the logging functions (err, warn, info, dbg
> and crit.)
> 
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-debug.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
> index 8376b84..f6bf91c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-debug.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
> @@ -38,10 +38,10 @@ static inline bool iwl_have_debug_level(u32 level)
>  }
>  
>  void __iwl_err(struct device *dev, bool rfkill_prefix, bool only_trace,
> -		const char *fmt, ...);
> -void __iwl_warn(struct device *dev, const char *fmt, ...);
> -void __iwl_info(struct device *dev, const char *fmt, ...);
> -void __iwl_crit(struct device *dev, const char *fmt, ...);
> +		const char *fmt, ...) __printf(4, 5);
> +void __iwl_warn(struct device *dev, const char *fmt, ...) __printf(2, 3);
> +void __iwl_info(struct device *dev, const char *fmt, ...) __printf(2, 3);
> +void __iwl_crit(struct device *dev, const char *fmt, ...) __printf(2, 3);
>  
>  /* No matter what is m (priv, bus, trans), this will work */
>  #define IWL_ERR(m, f, a...) __iwl_err((m)->dev, false, false, f, ## a)
> @@ -52,9 +52,9 @@ void __iwl_crit(struct device *dev, const char *fmt, ...);
>  #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
>  void __iwl_dbg(struct device *dev,
>  	       u32 level, bool limit, const char *function,
> -	       const char *fmt, ...);
> +	       const char *fmt, ...) __printf(5, 6);
>  #else
> -static inline void
> +__printf(5, 6) static inline void
>  __iwl_dbg(struct device *dev,
>  	  u32 level, bool limit, const char *function,
>  	  const char *fmt, ...)
> -- 
> 1.7.10
> 
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

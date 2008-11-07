Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:1254 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYKGSEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 13:04:05 -0500
Received: by yw-out-2324.google.com with SMTP id 9so545601ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2008 10:04:04 -0800 (PST)
Subject: Re: [PATCH 10/13] iwlwifi: move iwl_print_hex_dump to iwl-debug.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1226080726-24860-11-git-send-email-reinette.chatre@intel.com>
References: <> <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-11-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 10:03:59 -0800
Message-Id: <1226081039.11596.20.camel@brick> (sfid-20081107_190410_391297_D8B9A728)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-11-07 at 09:58 -0800, Reinette Chatre wrote:
> From: Winkler, Tomas <tomas.winkler@intel.com>
> 
> This patch moves iwl_print_hex_dump to iwl-debug.h
> where it belongs
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-debug.h |   10 ++++++++++
>  drivers/net/wireless/iwlwifi/iwl-dev.h   |   17 -----------------
>  2 files changed, 10 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
> index 84b7772..0e79a6a 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-debug.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
> @@ -40,6 +40,13 @@ do { if ((priv->debug_level & (level)) && net_ratelimit()) \
>    dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
>  	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
>  
> +#define iwl_print_hex_dump(priv, level, p, len) 			\
> +do {                                            			\
> +	if (priv->debug_level & level)          			\
> +		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
> +			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
> +} while (0)

static inline please.

> +
>  #ifdef CONFIG_IWLWIFI_DEBUGFS
>  struct iwl_debugfs {
>  	const char *name;
> @@ -70,6 +77,9 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
>  #else
>  #define IWL_DEBUG(level, fmt, args...)
>  #define IWL_DEBUG_LIMIT(level, fmt, args...)
> +static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
> +				      void *p, u32 len)
> +{}
>  #endif				/* CONFIG_IWLWIFI_DEBUG */

To keep it in sync with this.

Cheers,

Harvey


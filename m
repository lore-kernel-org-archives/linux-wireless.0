Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39714 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbXKHJDd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 04:03:33 -0500
Subject: Re: [PATCH] WIRELESS:  Use more obvious "is_power_of_2" macro.
From: Zhu Yi <yi.zhu@intel.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711060945510.5429@localhost.localdomain>
References: <Pine.LNX.4.64.0711060945510.5429@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 16:56:58 +0800
Message-Id: <1194512218.31257.308.camel@debian.sh.intel.com> (sfid-20071108_090339_911373_48B49626)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-11-06 at 09:47 -0500, Robert P. J. Day wrote:
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 

NACK. is_power_of_2() cannot do compile time check for
TFD_QUEUE_SIZE_MAX. Furthermore, the runtime check for
TFD_QUEUE_SIZE_MAX is already done by iwl_queue_init().

Thanks,
-yi

> ---
> 
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 4f22a71..53b4b4e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -50,6 +50,7 @@
>  #include <linux/firmware.h>
>  #include <linux/etherdevice.h>
>  #include <linux/if_arp.h>
> +#include <linux/log2.h>
> 
>  #include <net/ieee80211_radiotap.h>
>  #include <net/mac80211.h>
> @@ -343,7 +344,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv,
> 
>  	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
>  	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
> -	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
> +	BUILD_BUG_ON(!is_power_of_2(TFD_QUEUE_SIZE_MAX));
>  	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
> 
>  	iwl_hw_tx_queue_init(priv, txq);
> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> index d60adcb..5f3bcb3 100644
> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> @@ -50,6 +50,7 @@
>  #include <linux/firmware.h>
>  #include <linux/etherdevice.h>
>  #include <linux/if_arp.h>
> +#include <linux/log2.h>
> 
>  #include <net/ieee80211_radiotap.h>
>  #include <net/mac80211.h>
> @@ -342,7 +343,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv,
> 
>  	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
>  	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
> -	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
> +	BUILD_BUG_ON(!is_power_of_2(TFD_QUEUE_SIZE_MAX));
>  	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
> 
>  	iwl_hw_tx_queue_init(priv, txq);
> 

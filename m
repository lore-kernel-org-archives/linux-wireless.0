Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62584 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab1A1QZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:25:11 -0500
Subject: Re: [PATCH 7/8] iwlagn: remove
 CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 08:23:37 -0800
Message-ID: <1296231817.7388.18.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

On Fri, 2011-01-28 at 07:47 -0800, Stanislaw Gruszka wrote:
> This option practically do not change object files size, and only add
> complication for users wanted to play with experimental firmware.
> Someone who want to use or stop to use experimental firmware can
> simply add or remove proper ucode files in /lib/firmware
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/Kconfig   |    6 ------
>  drivers/net/wireless/iwlwifi/iwl-agn.c |    2 --
>  2 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
> index e1e3b1c..4a5c51f 100644
> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -43,12 +43,6 @@ config IWLWIFI_DEBUGFS
>  	  is a low-impact option that allows getting insight into the
>  	  driver's state at runtime.
>  
> -config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
> -        bool "Experimental uCode support"
> -        depends on IWLWIFI && IWLWIFI_DEBUG
> -        ---help---
> -	  Enable use of experimental ucode for testing and debugging.
> -
>  config IWLWIFI_DEVICE_TRACING
>  	bool "iwlwifi device access tracing"
>  	depends on IWLWIFI
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index eb16647..23bf006 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -1610,11 +1610,9 @@ static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
>  	char tag[8];
>  
>  	if (first) {
> -#ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
>  		priv->fw_index = UCODE_EXPERIMENTAL_INDEX;
>  		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
>  	} else if (priv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
> -#endif
>  		priv->fw_index = priv->cfg->ucode_api_max;
>  		sprintf(tag, "%d", priv->fw_index);
>  	} else {

The whole reason has it in Kconfig file is to have user not remove the
experimental uCode from /lib/firmware and not use it.

Also put it in Kconfig file, so it is easy for user to see they are
using experimental option. Agree?

Wey


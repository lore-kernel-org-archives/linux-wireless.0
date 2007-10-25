Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57457 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbXJYJct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:32:49 -0400
Message-ID: <472062BA.6020102@garzik.org> (sfid-20071025_103252_753645_0652AC6D)
Date: Thu, 25 Oct 2007 05:32:42 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 11/30] iwlwifi: using PCI_DEVICE macro
References: <11933037512140-git-send-email-yi.zhu@intel.com> <11933037541699-git-send-email-yi.zhu@intel.com> <11933037553170-git-send-email-yi.zhu@intel.com> <119330375796-git-send-email-yi.zhu@intel.com> <11933037584069-git-send-email-yi.zhu@intel.com> <11933037601236-git-send-email-yi.zhu@intel.com> <11933037613709-git-send-email-yi.zhu@intel.com> <1193303762680-git-send-email-yi.zhu@intel.com> <11933037641168-git-send-email-yi.zhu@intel.com> <11933037663659-git-send-email-yi.zhu@intel.com> <11933037674045-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11933037674045-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
> 
> PCI_DEVICE macro is more concise when using defualt values
> in device definitions
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl-4965.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 62b44a4..d4dc30d 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -2278,8 +2278,8 @@ void iwl_hw_cancel_deferred_work(struct iwl_priv *priv)
>  }
>  
>  struct pci_device_id iwl_hw_card_ids[] = {
> -	{0x8086, 0x4222, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{0x8086, 0x4227, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{PCI_DEVICE(0x8086, 0x4222)},
> +	{PCI_DEVICE(0x8086, 0x4227)},
>  	{0}
>  };
>  
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index 4710f6e..f86a24e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -4680,8 +4680,8 @@ void iwl_hw_cancel_deferred_work(struct iwl_priv *priv)
>  }
>  
>  struct pci_device_id iwl_hw_card_ids[] = {
> -	{0x8086, 0x4229, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{0x8086, 0x4230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{PCI_DEVICE(0x8086, 0x4229)},
> +	{PCI_DEVICE(0x8086, 0x4230)},

FWIW I would recommend

	PCI_VDEVICE(INTEL, 0x4229)

Regards,

	Jeff




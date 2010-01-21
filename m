Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49788 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab0AUSC0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 13:02:26 -0500
Subject: Re: [PATCH 2.6.{32,31}] iwlwifi: power up all devices for EEPROM
 read
From: reinette chatre <reinette.chatre@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1264076545-12223-1-git-send-email-sgruszka@redhat.com>
References: <1264076545-12223-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 10:02:24 -0800
Message-ID: <1264096944.21458.139.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Thu, 2010-01-21 at 04:22 -0800, Stanislaw Gruszka wrote:
> commit f8701fe3aec24fcfb0dfa19aab47904611f96daf upstream

This is strange. As the commit you refer to indicate, it fixes problems
introduced by "iwlwifi: remove power-wasting calls to apm_ops.init()"
and "iwlagn: power up device before initializing EEPROM" - these patches
have only been introduced in 2.6.33, so targeting this patch for earlier
kernels does not seem right.

Note that what the abovementioned patches did was move the device "power
up" routines from probe to be closer to where they are needed
(iwl_eeprom_init) in an effort to optimize power usage. 

In the code you are changing, the above patches are not present, so the
original behavior of device power up during probe is still present.

The 2.6.32 and 2.6.31 code you are changing here adds a device "power
up" call into iwl_eeprom_init. This is not necessary since as you can
see, in iwl3945_pci_probe this exact same call is made right before
iwl_eeprom_init is called.

> 
> On 2.6.31 and 2.6.32 iwl3945 crash during kdump, I discovered
> above upstream commit fix that.

This does not make sense. Was this testing done in the stable kernel
from linux-2.6-stable or perhaps a kernel that had those other power
saving patches backported?

> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> I tested patch on 2.6.32 with iwl3945 - it fix kdump, and on 2.6.31
> with iwl5300 - no regression notice.
> 
>  drivers/net/wireless/iwlwifi/iwl-eeprom.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
> index 18dc3a4..870c0db 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
> @@ -486,6 +486,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
>  	}
>  	e = (__le16 *)priv->eeprom;
>  
> +	priv->cfg->ops->lib->apm_ops.init(priv);
>  	ret = priv->cfg->ops->lib->eeprom_ops.verify_signature(priv);
>  	if (ret < 0) {
>  		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
> @@ -556,6 +557,8 @@ done:
>  err:
>  	if (ret)
>  		iwl_eeprom_free(priv);
> +	/* Reset chip to save power until we load uCode during "up". */
> +	priv->cfg->ops->lib->apm_ops.stop(priv);
>  alloc_err:
>  	return ret;
>  }

Reinette



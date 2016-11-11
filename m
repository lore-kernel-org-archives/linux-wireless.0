Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49242 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754256AbcKKN5E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 08:57:04 -0500
Message-ID: <1478872616.15030.29.camel@coelho.fi> (sfid-20161111_145722_583350_D56C4D23)
From: Luca Coelho <luca@coelho.fi>
To: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Sara Sharon <sara.sharon@intel.com>
Cc: linuxwifi@intel.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2016 15:56:56 +0200
In-Reply-To: <20161010163001.22865-1-j@bitron.ch>
References: <20161010163001.22865-1-j@bitron.ch>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [linuxwifi] [PATCH 1/2] iwlwifi: fix MODULE_FIRMWARE for 6030
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jürg,

On Mon, 2016-10-10 at 18:30 +0200, Jürg Billeter wrote:
> IWL6000G2B_UCODE_API_MAX is not defined. ucode_api_max of
> IWL_DEVICE_6030 uses IWL6000G2_UCODE_API_MAX. Use this also for
> MODULE_FIRMWARE.
> 
> Fixes: 9d9b21d1b616 ("iwlwifi: remove IWL_*_UCODE_API_OK")
> Signed-off-by: Jürg Billeter <j@bitron.ch>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-6000.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> index 0b9f6a7..39335b7 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> @@ -371,4 +371,4 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
>  MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
>  MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
>  MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
> -MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2B_UCODE_API_MAX));
> +MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));

Sorry I had missed these patches because linux-wireless@vger was not
CCed, so it didn't get to patchwork.  I have applied both in our
internal tree and they'll reach the mainline in my next pull-request.

Thanks!

--
Cheers,
Luca.

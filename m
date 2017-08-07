Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45418 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdHGM5L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 08:57:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 1/3] iwlwifi: mvm: Fix a memory leak in an error handling path in 'iwl_mvm_sar_get_wgds_table()'
References: <20170805184743.23650-1-luca@coelho.fi>
        <20170805184743.23650-2-luca@coelho.fi>
Date: Mon, 07 Aug 2017 15:57:05 +0300
In-Reply-To: <20170805184743.23650-2-luca@coelho.fi> (Luca Coelho's message of
        "Sat, 5 Aug 2017 21:47:41 +0300")
Message-ID: <87d187len2.fsf@kamboji.qca.qualcomm.com> (sfid-20170807_145715_167740_47AA181F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
>
> We should free 'wgds.pointer' here as done a few lines above in another
> error handling path.
> It was allocated within 'acpi_evaluate_object()'.
>
> Fixes: c52030a01ccc ("iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power table")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> index 79e7a7a285dc..82863e9273eb 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> @@ -1275,8 +1275,10 @@ static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm)
>  
>  			entry = &wifi_pkg->package.elements[idx++];
>  			if ((entry->type != ACPI_TYPE_INTEGER) ||
> -			    (entry->integer.value > U8_MAX))
> -				return -EINVAL;
> +			    (entry->integer.value > U8_MAX)) {
> +				ret = -EINVAL;
> +				goto out_free;
> +			}

How likely is this leak to happen in real world? To me it looks like
more like a theoretical issue and could have easily waited for 4.14. But
it's fine this time, just something to keep in mind in the future.

-- 
Kalle Valo

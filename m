Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:54945 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752022AbeDRHGn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 03:06:43 -0400
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
To: pillair@codeaurora.org, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
 <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com> (sfid-20180418_090647_445707_6C05A69E)
Date: Wed, 18 Apr 2018 09:06:40 +0200
MIME-Version: 1.0
In-Reply-To: <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

from my point of view powersave should be optional and not forced.

consider :
iw dev <devname> set power_save on/off

so there is already a config option made for that purpose,

Sebastian

Am 17.04.2018 um 14:07 schrieb pillair@codeaurora.org:
> From: Govind Singh <govinds@codeaurora.org>
>
> Enable sta power save in fw for the targets that
> supports idle power save. The idle ps enable command
> will be ignored by the firmware which does not support
> this feature.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> ---
>   drivers/net/wireless/ath/ath10k/mac.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 7e02ca02b28e..1d9222af1bb2 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4679,6 +4679,13 @@ static int ath10k_start(struct ieee80211_hw *hw)
>   		}
>   	}
>   
> +	param = ar->wmi.pdev_param->idle_ps_config;
> +	ret = ath10k_wmi_pdev_set_param(ar, param, 1);
> +	if (ret && ret != -EOPNOTSUPP) {
> +		ath10k_warn(ar, "failed to enable idle_ps_config: %d\n", ret);
> +		goto err_core_stop;
> +	}
> +
>   	__ath10k_set_antenna(ar, ar->cfg_tx_chainmask, ar->cfg_rx_chainmask);
>   
>   	/*


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57872 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaIRQLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 12:11:50 -0400
Message-ID: <541B0445.7040707@candelatech.com> (sfid-20140918_181153_531147_5E05C777)
Date: Thu, 18 Sep 2014 09:11:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/9] ath10k: fix tx/rx chainmask init
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com> <1411046487-19544-2-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1411046487-19544-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2014 06:21 AM, Michal Kazior wrote:
> Firmware reports the number of RF chains so use
> that for initialization of supp_{tx,rx}_chainmask
> instead of using a macro for 3x3 chips.
> 
> This should make tx/rx chainmask reports correct
> for chips other than 3x3.

> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 2c42bd5..772cca5 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2198,6 +2198,9 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
>  		ar->num_rf_chains = WMI_MAX_SPATIAL_STREAM;
>  	}
>  
> +	ar->supp_tx_chainmask = (1 << ar->num_rf_chains) - 1;
> +	ar->supp_rx_chainmask = (1 << ar->num_rf_chains) - 1;

Are there are no chips that support a different number
of tx and rx chains?


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4797 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab1BHPtF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 10:49:05 -0500
Subject: Re: [PATCH] iwl3945: increase plcp check threshold
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20110208090446.GA2490@redhat.com>
References: <20110208090446.GA2490@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 07:47:20 -0800
Message-ID: <1297180040.20613.39.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

On Tue, 2011-02-08 at 01:04 -0800, Stanislaw Gruszka wrote:
> iwl3945: increase plcp check threshold
> 
> Patch fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=654599
> 
> Many users report very low speed problem on 3945 devices,
> this patch fixes problem, but only for some of them.
> 
> For unknown reason, sometimes after hw scanning, device is not able
> to receive frames at high rate. Since plcp health check may request
> hw scan to "reset radio", performance problem start to be observable
> after update kernel to .35, where plcp check was introduced.
> 
> Bug reporter confirmed that increase plcp check threshold fixed
> problem for him.
> 
> Reported-and-tested-by: SilvioTO <silviotoya@yahoo.it>
> Cc: stable@kernel.org  # 2.6.35+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> Patch is oneliner, but does not apply on older kernel versions,
> I will provide -stable patches when fix will land in mainline
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 58213e7..27faa5e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -2775,7 +2775,7 @@ static struct iwl_base_params iwl3945_base_params = {
>  	.use_isr_legacy = true,
>  	.led_compensation = 64,
>  	.broken_powersave = true,
> -	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
> +	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_MAX,
>  	.wd_timeout = IWL_DEF_WD_TIMEOUT,
>  	.max_event_log_size = 512,
>  	.tx_power_by_driver = true,

Do you see any help for 3945 with plcp checking at all?

Wey


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36192 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbcEJHUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 03:20:18 -0400
Date: Tue, 10 May 2016 12:50:05 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: greearb@candelatech.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/21] ath10k: support CT firmware flag.
Message-ID: <20160510072005.GE25626@atheros-ThinkPad-T61> (sfid-20160510_092022_913084_3F42E5D6)
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
 <1462835475-11079-16-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462835475-11079-16-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Mon, May 09, 2016 at 04:11:09PM -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Add placeholder so CT firmware can more easily co-exist with upstream
> kernel.

[shafi] nitpick: good to provide an expansion in commit log as well, so that
if we can easily figure out in git log alone, rather than going through
the change and suggesting that it supports more vif's etc

> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 1 +
>  drivers/net/wireless/ath/ath10k/core.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index fa71d57..49c85c3 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -235,6 +235,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
>  	[ATH10K_FW_FEATURE_SUPPORTS_ADAPTIVE_CCA] = "adaptive-cca",
>  	[ATH10K_FW_FEATURE_MFP_SUPPORT] = "mfp",
>  	[ATH10K_FW_FEATURE_PEER_FLOW_CONTROL] = "peer-flow-ctrl",
> +	[ATH10K_FW_FEATURE_WMI_10X_CT] = "wmi-10.x-CT",
>  };
>  
>  static unsigned int ath10k_core_get_fw_feature_str(char *buf,
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 1a75e2e..dd38f34 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -566,6 +566,9 @@ enum ath10k_fw_features {
>  	 */
>  	ATH10K_FW_FEATURE_PEER_FLOW_CONTROL = 13,
>  
> +	/* Firmware from Candela Technologies, enables more VIFs, etc */
> +	ATH10K_FW_FEATURE_WMI_10X_CT = 31,
> +
>  	/* keep last */
>  	ATH10K_FW_FEATURE_COUNT,
>  };
>
regards,
shafi

> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

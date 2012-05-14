Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:46811 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757199Ab2ENR5C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 13:57:02 -0400
Message-ID: <1337018219.29436.24.camel@joe2Laptop> (sfid-20120514_195706_862769_AD896BA6)
Subject: Re: [PATCH v2] ath6kl: enable enhanced bmiss detection
From: Joe Perches <joe@perches.com>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath6kl-devel@qualcomm.com
Date: Mon, 14 May 2012 10:56:59 -0700
In-Reply-To: <1337017652-3962-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1337017652-3962-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-14 at 10:47 -0700, Thomas Pedersen wrote:
> Enable enhanced bmiss detection if the firmware supports it. This
> feature is only enabled on some firmwares since it comes with a power
> cost.
[]
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
[]
> @@ -2614,6 +2619,30 @@ static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
>  	return 0;
>  }
>  
> +void ath6kl_cfg80211_sta_bmiss_enhance(struct ath6kl_vif *vif, bool enable)
> +{
> +	int err;
> +
> +	if (WARN_ON(!test_bit(WMI_READY, &vif->ar->flag)))
> +		return;
> +
> +	if (vif->nw_type != INFRA_NETWORK)
> +		return;
> +
> +	if (!test_bit(ATH6KL_FW_CAPABILITY_BMISS_ENHANCE,
> +		      vif->ar->fw_capabilities))
> +		return;
> +
> +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s fw bmiss enhance\n",
> +					enable ? "enable" : "disable");
> +	err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
> +					       vif->fw_vif_idx, enable);
> +	if (err)
> +		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
> +			   "failed to %s enhanced bmiss detection: %d\n",
> +			   enable ? "enable" : "disable", err);

Why 2 messages when 1 message might do?

	err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
					       vif->fw_vif_idx, enable);
	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
		   "%s enhanced fw bmiss detection: %s\n",
		   enable ? "enable" : "disable",
		   err ? "OK" : "failed");
 


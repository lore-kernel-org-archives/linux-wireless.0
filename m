Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26962 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab2ENGmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 02:42:35 -0400
Message-ID: <4FB0A931.80309@qca.qualcomm.com> (sfid-20120514_084239_135014_C2A38617)
Date: Mon, 14 May 2012 09:41:53 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: enable enhanced bmiss detection
References: <1336778089-11473-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1336778089-11473-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/2012 02:14 AM, Thomas Pedersen wrote:
> Enable enhanced bmiss detection if the firmware supports it. This
> feature is only enabled on some firmwares since it comes with a power
> cost.
> 
> Also add a few missing command ids to keep the enums straight.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

[...]

> @@ -1512,6 +1513,8 @@ static int ath6kl_cfg80211_change_iface(struct >
wiphy *wiphy,
> 		}
> 	}
>
> +	ath6kl_sta_bmiss_enhance(vif, false);

A comment why you disable the feature is good to have. I'm sure there's
a good reason :)

> +void ath6kl_sta_bmiss_enhance(struct ath6kl_vif *vif, bool enable)
> +{

Please cfg80211 prefix, eg. ath6kl_cfg80211_bmiss_enhance() or something
like that.

> +	int err;
> +
> +	if (WARN_ON(!test_bit(WMI_READY, &vif->ar->flag)))
> +		return;
> +
> +	if (vif->nw_type == INFRA_NETWORK &&
> +	    test_bit(ATH6KL_FW_CAPABILITY_BMISS_ENHANCE,
> +		     vif->ar->fw_capabilities)) {

Less indentation:

if (vif->nw_type != INFRA_NETWORK)
	return;

if (!test_bit(ATH6KL_FW_CAPABILITY_BMISS_ENHANCE,
		     vif->ar->fw_capabilities))
	return;


> +		ath6kl_dbg(ATH6KL_DBG_TRC, enable ? "enable fw bmiss enhance\n"
> +						  : "");

ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s fw bmiss enhance\n",
		enable ? "enable" : "disable");


> +		err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
> +						       vif->fw_vif_idx, enable);
> +		if (err)
> +			ath6kl_dbg(ATH6KL_DBG_TRC,
> +				   "failed to %s enhanced bmiss detection: %d\n",
> +				   enable ? "set" : "disable",
> +				   err);

Use WLAN_CFG here as well.

Kalle

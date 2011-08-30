Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41900 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H3JGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:06:21 -0400
Message-ID: <4E5CA807.4090105@qca.qualcomm.com> (sfid-20110830_110629_561150_36340236)
Date: Tue, 30 Aug 2011 12:06:15 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 04/20] ath6kl: Use change_station() to authorize/unauthorize
 STAs
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-5-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1314620641-24257-5-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> @@ -1804,6 +1804,21 @@ struct wmi_tx_complete_event {
>  
>  /* Used with WMI_AP_SET_NUM_STA_CMDID */
>  
> +/*
> + * Used with WMI_AP_SET_MLME_CMDID
> + */
> +struct wmi_ap_set_mlme_cmd {
> +	u8 mac[ETH_ALEN];
> +	u16 reason;		/* 802.11 reason code */
> +	u8 cmd;			/* operation to perform */
> +/* MLME Commands */
> +#define WMI_AP_MLME_ASSOC       1   /* associate station */
> +#define WMI_AP_DISASSOC         2   /* disassociate station */
> +#define WMI_AP_DEAUTH           3   /* deauthenticate station */
> +#define WMI_AP_MLME_AUTHORIZE   4   /* authorize station */
> +#define WMI_AP_MLME_UNAUTHORIZE 5   /* unauthorize station */
> +} __packed;

Needs an endian annotation for u16. Also defines inside a struct are
IMHO a bit awkward.

Kalle

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44031 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1JKLzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:55:46 -0400
Message-ID: <4E942EBC.9030702@qca.qualcomm.com> (sfid-20111011_135549_875816_C852A49B)
Date: Tue, 11 Oct 2011 14:55:40 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath6kl: Add debugfs control for keepalive and disconnection
 timeout
References: <1318243411-16110-1-git-send-email-jouni@qca.qualcomm.com> <1318243411-16110-5-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1318243411-16110-5-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/2011 01:43 PM, Jouni Malinen wrote:
> The new debugfs files keepalive and disconnect_timeout can be used to
> fetch the current values and to change the values for keepalive and
> disconnect event timeout (both in seconds).

[...]

> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -1940,6 +1940,10 @@ int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 timeout)
>  
>  	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_DISC_TIMEOUT_CMDID,
>  				  NO_SYNC_WMIFLAG);
> +#ifdef CONFIG_ATH6KL_DEBUG
> +	if (ret == 0)
> +		wmi->parent_dev->debug.disc_timeout = timeout;
> +#endif /* CONFIG_ATH6KL_DEBUG */
>  	return ret;
>  }
>  
> @@ -2524,6 +2528,10 @@ int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl)
>  
>  	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_KEEPALIVE_CMDID,
>  				  NO_SYNC_WMIFLAG);
> +#ifdef CONFIG_ATH6KL_DEBUG
> +	if (ret == 0)
> +		wmi->parent_dev->debug.keepalive = keep_alive_intvl;
> +#endif /* CONFIG_ATH6KL_DEBUG */

Similar comment for these two as well. It would better to have the code
in debug.c (or .h) and add functions for providing this information.

Kalle

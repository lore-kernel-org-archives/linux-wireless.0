Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26698 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1H3J0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:26:15 -0400
Message-ID: <4E5CACB2.1060304@qca.qualcomm.com> (sfid-20110830_112618_905007_4085EF0C)
Date: Tue, 30 Aug 2011 12:26:10 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 10/20] ath6kl: Use set_appie command to add Probe Request
 IEs
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-11-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1314620641-24257-11-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -776,6 +776,15 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
>  						  request->ssids[i].ssid);
>  	}
>  
> +	if (request->ie) {
> +		if (ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_PROBE_REQ,
> +					     request->ie, request->ie_len)) {
> +			ath6kl_err("failed to set Probe Request appie for "
> +				   "scan");
> +			return -EIO;
> +		}
> +	}

I would prefer to return the original error code from the wmi call.

Kalle

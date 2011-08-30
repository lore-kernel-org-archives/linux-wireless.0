Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32991 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1H3Jdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:33:53 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Edward Lu <shaol@qca.qualcomm.com>
Message-ID: <4E5CAE7A.8000809@qca.qualcomm.com> (sfid-20110830_113356_380483_01D64B67)
Date: Tue, 30 Aug 2011 12:33:46 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: [PATCH 11/20] ath6kl: Support channel set request for startscan
 command
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-12-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1314620641-24257-12-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> From: Edward Lu <elu@qca.qualcomm.com>
>
> @@ -785,14 +787,33 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
>  		}
>  	}
>  
> +	if (request->n_channels > 0) {
> +		u8 i;
> +
> +		n_channels = (request->n_channels > 127) ?
> +				127 : request->n_channels;

min()

> +
> +		channels = kzalloc(n_channels * sizeof(u16), GFP_KERNEL);
> +		if (channels == NULL) {
> +			ath6kl_err("failed to set scan channels, "
> +				   "scan all channels");

ath6kl_warn() would be more approriate here as the driver can still
continue.

> +			n_channels = 0;
> +		}
> +
> +		for (i = 0; i < n_channels; i++)
> +			channels[i] = request->channels[i]->center_freq;
> +	}
> +
>  	if (ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, 0,
> -				     false, 0, 0, 0, NULL) != 0) {
> +				     false, 0, 0, n_channels, channels) != 0) {
>  		ath6kl_err("wmi_startscan_cmd failed\n");
>  		ret = -EIO;

Again I would prefer to return the error code from the wmi call.

> @@ -1734,8 +1734,10 @@ int ath6kl_wmi_startscan_cmd(struct wmi *wmi, enum wmi_scan_type scan_type,
>  	sc->force_scan_intvl = cpu_to_le32(force_scan_interval);
>  	sc->num_ch = num_chan;
>  
> -	if (num_chan)
> -		memcpy(sc->ch_list, ch_list, num_chan * sizeof(u16));
> +	if (num_chan) {
> +		for (i = 0; i < num_chan; i++)
> +			sc->ch_list[i] = cpu_to_le16(ch_list[i]);
> +	}

if (num_chan) is not needed, the for loop is enough.

Kalle

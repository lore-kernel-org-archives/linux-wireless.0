Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:36018 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754540Ab2DIQAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 12:00:39 -0400
Message-ID: <1333987238.2152.5.camel@joe2Laptop> (sfid-20120409_180042_954499_9198047B)
Subject: Re: [PATCH V2] ath6kl: Fix 4-way handshake failure in AP and P2P GO
 mode
From: Joe Perches <joe@perches.com>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath6kl-devel@qualcomm.com,
	Subramania Sharma <sharmat@qca.qualcomm.com>
Date: Mon, 09 Apr 2012 09:00:38 -0700
In-Reply-To: <1333984880-4328-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <\> <1333984880-4328-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-09 at 20:51 +0530, Vasanthakumar Thiagarajan wrote:
> RSN capability field of RSN IE which is generated (which is what really
> advertised in beacon/probe response) differs from the one generated in
> wpa_supplicant. This inconsistency in rsn IE results in 4-way handshake
> failure. To fix this, configure rsn capability used in wpa_supplicant
> in firmware using a new wmi command, WMI_SET_IE_CMDID. There is a bit
> (ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE) in fw_capabilities to advertise
> this support to driver.
> 
> Signed-off-by: Subramania Sharma <sharmat@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> ---
> 
> V2 - Fix sparse warning due to the way rsn_cap is used
>      to store le16 (Reported by Kalle).
> 
>  drivers/net/wireless/ath/ath6kl/cfg80211.c |   64 ++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath6kl/core.h     |    3 +
>  drivers/net/wireless/ath/ath6kl/wmi.c      |   23 ++++++++++
>  drivers/net/wireless/ath/ath6kl/wmi.h      |   17 +++++++
>  4 files changed, 107 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index 06f12da..98a0046 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -2524,6 +2524,52 @@ static int ath6kl_set_ies(struct ath6kl_vif *vif,
>  	return 0;
>  }
>  
> +static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
> +				u8 *rsn_capab)
> +{
> +	const u8 *rsn_ie;
> +	size_t rsn_ie_len;
> +	u16 cnt;
> +
> +	if (!beacon->tail)
> +		return -EINVAL;
> +
> +	rsn_ie = cfg80211_find_ie(WLAN_EID_RSN, beacon->tail, beacon->tail_len);
> +	if (!rsn_ie)
> +		return -EINVAL;
> +
> +	rsn_ie_len = *(rsn_ie + 1);
> +	/* skip element id and length */
> +	rsn_ie += 2;
> +
> +	/* skip version, group cipher */
> +	if (rsn_ie_len < 6)
> +		return -EINVAL;
> +	rsn_ie +=  6;
> +	rsn_ie_len -= 6;
> +
> +	/* skip pairwise cipher suite */
> +	if (rsn_ie_len < 2)
> +		return -EINVAL;
> +	cnt = *((u16 *) rsn_ie);

Any endian or alignment issues?

> +	rsn_ie += (2 + cnt * 4);
> +	rsn_ie_len -= (2 + cnt * 4);
> +
> +	/* skip akm suite */
> +	if (rsn_ie_len < 2)
> +		return -EINVAL;
> +	cnt = *((u16 *) rsn_ie);
> +	rsn_ie += (2 + cnt * 4);
> +	rsn_ie_len -= (2 + cnt * 4);
> +
> +	if (rsn_ie_len < 2)
> +		return -EINVAL;
> +
> +	memcpy(rsn_capab, rsn_ie, 2);
> +
> +	return 0;
> +}

Maybe 


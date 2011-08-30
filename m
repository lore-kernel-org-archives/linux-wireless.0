Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31353 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1H3Frv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 01:47:51 -0400
Message-ID: <4E5C797F.3090900@qca.qualcomm.com> (sfid-20110830_074755_469456_0A552A67)
Date: Tue, 30 Aug 2011 11:17:43 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/20] ath6kl: Add functionality for starting AP mode
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-2-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1314620641-24257-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 August 2011 05:53 PM, Jouni Malinen wrote:
> Use cfg80211 add/del_beacon callbacks for starting/stopping AP mode and
> set_beacon to update AP configuration (mainly, to update Beacon and
> Probe Response IEs).
>
> Signed-off-by: Jouni Malinen<jouni@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath6kl/cfg80211.c |  176 ++++++++++++++++++++++++++++
>   drivers/net/wireless/ath/ath6kl/core.h     |    2 +
>   drivers/net/wireless/ath/ath6kl/wmi.c      |   46 +++++++
>   drivers/net/wireless/ath/ath6kl/wmi.h      |   20 +++
>   4 files changed, 244 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index 9128aa3..e486c1c 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -1435,6 +1435,178 @@ static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
>   }
>   #endif
>
> +static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
> +			      struct ieee80211_channel *chan,
> +			      enum nl80211_channel_type channel_type)
> +{
> +	struct ath6kl *ar = ath6kl_priv(dev);
> +
> +	if (!test_bit(WLAN_ENABLED,&ar->flag)) {
> +		ath6kl_err("%s: wlan disabled\n", __func__);
> +		return -EIO;
> +	}
> +
> +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: center_freq=%u hw_value=%u\n",
> +		   __func__, chan->center_freq, chan->hw_value);
> +	ar->next_chan = chan->center_freq;
> +
> +	return 0;
> +}
> +
> +static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
> +			    struct beacon_parameters *info, bool add)
> +{
> +	struct ath6kl *ar = ath6kl_priv(dev);
> +	struct ieee80211_mgmt *mgmt;
> +	u8 *ies;
> +	int ies_len;
> +	struct wmi_connect_cmd p;
> +	int i;
> +
> +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: add=%d\n", __func__, add);
> +
> +	if (!test_bit(WMI_READY,&ar->flag))
> +		return -EIO;
> +
> +	if (!test_bit(WLAN_ENABLED,&ar->flag))
> +		return -EIO;

How about calling ath6kl_cfg80211_ready() function to check WMI_READY 
and WLAN_ENABLED status ?

> +
> +	if (ar->next_mode != AP_NETWORK)
> +		return -EOPNOTSUPP;
> +
> +	if (info->beacon_ies&&
> +	    ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_BEACON,
> +				     info->beacon_ies, info->beacon_ies_len))
> +		return -EIO;
[..]

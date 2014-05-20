Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54789 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaETHAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:00:39 -0400
Message-ID: <537AFD8C.2090302@openwrt.org> (sfid-20140520_090056_780416_23D73B9C)
Date: Tue, 20 May 2014 09:00:28 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_hw: Abort transmission for sleeping station
References: <1400480077-18619-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1400480077-18619-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-05-19 08:14, Rajkumar Manoharan wrote:
> The data transmission to the power save station should be aborted
> immediately, whenever the station informs sleep state. Right now
> the frames queued into into hardware are being transmitted until
> the hardware detects the power save station based excessive retries
> of the data frames due to unacknowlegdement. Then remaining frames
> are returned with filetered status and might be retried later by
> driver or mac80211.
> 
> Per WFA certification testing, AP should not send out more than two
> frames after processing nullfunc with PM bit set from associated
> station. To speed up tx filtering, the pending frames in hardware
> queues for given station will be aborted immediately via tx filter
> registers. This transmit filters can be ignored if the descriptor
> is having invalid destination index or clear destination mask set.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/mac.c  | 22 ++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/mac.h  |  1 +
>  drivers/net/wireless/ath/ath9k/main.c |  8 ++++++++
>  drivers/net/wireless/ath/ath9k/reg.h  |  3 ---
>  4 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 8d7b9b6..47d442a 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c

> @@ -1593,6 +1597,8 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
>  			ath9k_del_ps_key(sc, vif, sta);
>  
>  		ret = ath_key_config(common, vif, sta, key);
> +		if (sta && (ret > 0))
> +			((struct ath_node *)sta->drv_priv)->ps_key = ret;
>  		if (ret >= 0) {
>  			key->hw_key_idx = ret;
>  			/* push IV and Michael MIC generation to stack */
> @@ -1607,6 +1613,8 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
>  		break;
>  	case DISABLE_KEY:
>  		ath_key_delete(common, key);
> +		if (sta)
> +			((struct ath_node *)sta->drv_priv)->ps_key = 0;
>  		break;
>  	default:
>  		ret = -EINVAL;
I think this part won't work if you have multiple keys for the same STA.
Also, it will leak the previous ps_key if it was auto-assigned for an
unencrypted sta.

- Felix

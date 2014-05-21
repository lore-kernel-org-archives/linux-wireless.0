Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34489 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaEUM0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 08:26:53 -0400
Message-ID: <537C9B84.7000002@openwrt.org> (sfid-20140521_142707_893495_95081DB6)
Date: Wed, 21 May 2014 14:26:44 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: Handle multiple keys while setting tx filters
References: <1400671759-30499-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1400671759-30499-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-05-21 13:29, Rajkumar Manoharan wrote:
> The keycache index is used to abort transmission for given station
> when it goes to sleep state. But the commit "ath9k_hw: Abort transmission
> for sleeping station" is not handling multi-key station. Fix that.
> 
> Cc: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
>  drivers/net/wireless/ath/ath9k/main.c  | 52 +++++++++++++++++++++++++++-------
>  2 files changed, 42 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 47d442a..89be123 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1494,6 +1498,19 @@ static int ath9k_sta_remove(struct ieee80211_hw *hw,
>  	return 0;
>  }
>  
> +static inline void ath9k_sta_set_tx_filter(struct ath_hw *ah,
> +					   struct ath_node *an,
> +					   bool set)
I'd suggest dropping the 'inline' - just let the compiler figure out if
it's worth inlining.

> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
> +		if (!an->key_idx[i])
> +			continue;
> +		ath9k_hw_set_tx_filter(ah, an->key_idx[i], set);
> +	}
> +}
> +
>  static void ath9k_sta_notify(struct ieee80211_hw *hw,
>  			 struct ieee80211_vif *vif,
>  			 enum sta_notify_cmd cmd,
> @@ -1610,11 +1626,25 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
>  				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
>  			ret = 0;
>  		}
> +		if (an && key->hw_key_idx) {
> +			for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
> +				if (an->key_idx[i])
> +					continue;
> +				an->key_idx[i] = key->hw_key_idx;
I think this should be moved inside the ret >= 0 test.
You also need to add a break here to avoid the WARN_ON below.
Did you test this patch?

> +			}
> +			WARN_ON(i == ARRAY_SIZE(an->key_idx));
> +		}
>  		break;


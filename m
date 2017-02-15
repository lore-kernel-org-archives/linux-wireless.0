Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56262 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751290AbdBOIAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 03:00:30 -0500
Message-ID: <1487145624.4026.7.camel@sipsolutions.net> (sfid-20170215_090033_374851_062C22D6)
Subject: Re: [PATCH v3] ath10k: add support for controlling tx power to a
 station
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, arnagara@codeaurora.org
Date: Wed, 15 Feb 2017 09:00:24 +0100
In-Reply-To: <1486555117-25196-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20170208_130502_380774_EC1BC84A)
References: <1486555117-25196-1-git-send-email-arnagara@qti.qualcomm.com>
         (sfid-20170208_130502_380774_EC1BC84A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-08 at 17:28 +0530, Ashok Raj Nagarajan wrote:
> This patch will add the support to control the transmit power for
> traffic
> to a station associated with the AP. Userspace provide the transmit
> power
> value in mBm units. ath10k firmware expects the value to be in dBm
> and
> hence will convert the value from to dBm before passing down to
> firmware.
> 
> Underlying FW will enforce that the maximum tx power will be based on
> the
> regulatory requirements. If the user given transmit power is greater
> than
> the allowed tx power in the given channel, then the FW will use the
> maximum
> tx power in the same channel.

The firmware command has a bit of a misleading name, but if this really
is the behaviour then all should be OK.

> When 0 is sent to the FW as tx power, it will revert to the automatic
> tx power for the station.

So this is where the 0 comes from, perhaps - but I think it'd be better
to do that translation in the driver.

Come to think of it, you're also missing range-checks entirely, so if I
give you some insane value you'd still send it down - no chance the
firmware will be unhappy?

Also, you should probably accept negative values for the TX power, and
make that an s32 instead of u32 across the patchset.

johannes

> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
> ---
> v3:
> 	- reword commit log
> 	- remove range check for the input from user. (Ben Greear)
> 
>  drivers/net/wireless/ath/ath10k/mac.c | 31
> +++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.h |  1 +
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
> b/drivers/net/wireless/ath/ath10k/mac.c
> index 9977829..3b91468 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5985,6 +5985,32 @@ static int ath10k_mac_tdls_vifs_count(struct
> ieee80211_hw *hw)
>  	return num_tdls_vifs;
>  }
>  
> +static int ath10k_sta_set_txpwr(struct ieee80211_hw *hw,
> +				struct ieee80211_vif *vif,
> +				struct ieee80211_sta *sta)
> +{
> +	struct ath10k *ar = hw->priv;
> +	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
> +	int ret = 0;
> +	u16 txpwr;
> +
> +	txpwr = MBM_TO_DBM(sta->txpwr);
> +
> +	mutex_lock(&ar->conf_mutex);
> +
> +	ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta-
> >addr,
> +					WMI_PEER_USE_FIXED_PWR,
> txpwr);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to set tx power for station
> ret: %d\n",
> +			    ret);
> +		goto out;
> +	}
> +
> +out:
> +	mutex_unlock(&ar->conf_mutex);
> +	return ret;
> +}
> +
>  static int ath10k_sta_state(struct ieee80211_hw *hw,
>  			    struct ieee80211_vif *vif,
>  			    struct ieee80211_sta *sta,
> @@ -7550,6 +7576,7 @@ static void
> ath10k_mac_op_sta_pre_rcu_remove(struct ieee80211_hw *hw,
>  	.set_key			= ath10k_set_key,
>  	.set_default_unicast_key        =
> ath10k_set_default_unicast_key,
>  	.sta_state			= ath10k_sta_state,
> +	.sta_set_txpwr			=
> ath10k_sta_set_txpwr,
>  	.conf_tx			= ath10k_conf_tx,
>  	.remain_on_channel		=
> ath10k_remain_on_channel,
>  	.cancel_remain_on_channel	=
> ath10k_cancel_remain_on_channel,
> @@ -8193,11 +8220,15 @@ int ath10k_mac_register(struct ath10k *ar)
>  		ar->hw->wiphy->iface_combinations =
> ath10k_10x_if_comb;
>  		ar->hw->wiphy->n_iface_combinations =
>  			ARRAY_SIZE(ath10k_10x_if_comb);
> +		wiphy_ext_feature_set(ar->hw->wiphy,
> +				      NL80211_EXT_FEATURE_STA_TX_PWR
> );
>  		break;
>  	case ATH10K_FW_WMI_OP_VERSION_10_4:
>  		ar->hw->wiphy->iface_combinations =
> ath10k_10_4_if_comb;
>  		ar->hw->wiphy->n_iface_combinations =
>  			ARRAY_SIZE(ath10k_10_4_if_comb);
> +		wiphy_ext_feature_set(ar->hw->wiphy,
> +				      NL80211_EXT_FEATURE_STA_TX_PWR
> );
>  		break;
>  	case ATH10K_FW_WMI_OP_VERSION_UNSET:
>  	case ATH10K_FW_WMI_OP_VERSION_MAX:
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h
> b/drivers/net/wireless/ath/ath10k/wmi.h
> index 861c2d8..1ccb6bf 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -5811,6 +5811,7 @@ enum wmi_peer_param {
>  	WMI_PEER_CHAN_WIDTH = 0x4,
>  	WMI_PEER_NSS        = 0x5,
>  	WMI_PEER_USE_4ADDR  = 0x6,
> +	WMI_PEER_USE_FIXED_PWR = 0x8,
>  	WMI_PEER_DUMMY_VAR  = 0xff, /* dummy parameter for STA PS
> workaround */
>  };
>  

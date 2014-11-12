Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44056 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbaKLOEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 09:04:00 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: David Ward <david.ward@ll.mit.edu>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
CC: Martin Hundeb?ll <martin@hundeboll.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] iwlwifi: dvm: Implement sta_rc_update() mac80211
 callback
Date: Wed, 12 Nov 2014 14:01:08 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B562E61@hasmsx107.ger.corp.intel.com> (sfid-20141112_150404_376522_73403476)
References: <1411997268.1663.0@smtp.hundeboll.net>
 <1415773612-8724-1-git-send-email-david.ward@ll.mit.edu>
In-Reply-To: <1415773612-8724-1-git-send-email-david.ward@ll.mit.edu>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Perform rate scaling properly when operating in an IBSS. Prior to this, the
> 5300 and 6205 devices (at least) would only transmit at
> 1 Mbps to other stations in an IBSS. This now allows transmission at HT rates.
> 
> Signed-off-by: David Ward <david.ward@ll.mit.edu>
> ---
>  drivers/net/wireless/iwlwifi/dvm/mac80211.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
> b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
> index 47e64e8..742218d 100644
> --- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
> @@ -940,6 +940,22 @@ static int iwlagn_mac_sta_state(struct
> ieee80211_hw *hw,
>  	return ret;
>  }
> 
> +static void iwlagn_mac_sta_rc_update(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif,
> +				     struct ieee80211_sta *sta, u32 changed) {
> +	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
> +
> +	if (!(changed & IEEE80211_RC_SUPP_RATES_CHANGED))
> +		return;
> +
> +	/* Update rate scaling */
> +	IWL_DEBUG_INFO(priv,
> +		       "Updating rate scaling for station %pM\n",
> +		       sta->addr);
> +	iwl_rs_rate_init(priv, sta, iwl_sta_id(sta)); }
> +
>  static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
>  				      struct ieee80211_vif *vif,
>  				      struct ieee80211_channel_switch
> *ch_switch) @@ -1610,6 +1626,7 @@ const struct ieee80211_ops
> iwlagn_hw_ops = {
>  	.hw_scan = iwlagn_mac_hw_scan,
>  	.sta_notify = iwlagn_mac_sta_notify,
>  	.sta_state = iwlagn_mac_sta_state,
> +	.sta_rc_update = iwlagn_mac_sta_rc_update,

Well - this would be called in other flows as well. For example, when we receive a beacon that changes the bandwidth or alike. I am not sure we want to re-init the rate scale data in this case, and more importantly, I am not sure it will not race with the tx / tx_status path that updates / uses the rate scale data.

>  	.channel_switch = iwlagn_mac_channel_switch,
>  	.flush = iwlagn_mac_flush,
>  	.tx_last_beacon = iwlagn_mac_tx_last_beacon,
> --
> 1.9.1


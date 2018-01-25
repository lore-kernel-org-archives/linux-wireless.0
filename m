Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0054.outbound.protection.outlook.com ([104.47.2.54]:64761
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750994AbeAYTBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 14:01:53 -0500
Subject: Re: [PATCH v3] mac80211: mesh: fix wrong mesh TTL offset calculation
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <8582518b7f032acfa598faf7d26c765b09149e90.1516842930.git.peter.oh@bowerswilkins.com>
Cc: johannes.berg@intel.com
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <d5398ece-5ca2-19ba-7d18-c103283e2e96@bowerswilkins.com> (sfid-20180125_200201_198514_5D8FA508)
Date: Thu, 25 Jan 2018 11:01:40 -0800
MIME-Version: 1.0
In-Reply-To: <8582518b7f032acfa598faf7d26c765b09149e90.1516842930.git.peter.oh@bowerswilkins.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ignore the patch below for now. Just noticed mesh_chansw_params_ie is 
constance.

will come up with new approach.


Thanks,

Peter


On 01/24/2018 05:16 PM, peter.oh@bowerswilkins.com wrote:
> From: Peter Oh <peter.oh@bowerswilkins.com>
>
> mesh TTL offset in Mesh Channel Switch Parameters element depends on
> not only Secondary Channel Offset element, but also affected by
> HT Control field and Wide Bandwidth Channel Switch element.
> Use element structure to correct the miscalculation.
>
> Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
> ---
>   net/mac80211/mesh.c | 17 ++++++-----------
>   1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 73ac607..6a381cb 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -1255,13 +1255,12 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
>   }
>   
>   static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
> -			       struct ieee80211_mgmt *mgmt, size_t len)
> +			       struct ieee80211_mgmt *mgmt, size_t len,
> +			       struct ieee802_11_elems *elems)
>   {
>   	struct ieee80211_mgmt *mgmt_fwd;
>   	struct sk_buff *skb;
>   	struct ieee80211_local *local = sdata->local;
> -	u8 *pos = mgmt->u.action.u.chan_switch.variable;
> -	size_t offset_ttl;
>   
>   	skb = dev_alloc_skb(local->tx_headroom + len);
>   	if (!skb)
> @@ -1269,13 +1268,9 @@ static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
>   	skb_reserve(skb, local->tx_headroom);
>   	mgmt_fwd = skb_put(skb, len);
>   
> -	/* offset_ttl is based on whether the secondary channel
> -	 * offset is available or not. Subtract 1 from the mesh TTL
> -	 * and disable the initiator flag before forwarding.
> -	 */
> -	offset_ttl = (len < 42) ? 7 : 10;
> -	*(pos + offset_ttl) -= 1;
> -	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
> +	elems->mesh_chansw_params_ie->mesh_ttl--;
> +	elems->mesh_chansw_params_ie->mesh_flags &=
> +		~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
>   
>   	memcpy(mgmt_fwd, mgmt, len);
>   	eth_broadcast_addr(mgmt_fwd->da);
> @@ -1323,7 +1318,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
>   
>   	/* forward or re-broadcast the CSA frame */
>   	if (fwd_csa) {
> -		if (mesh_fwd_csa_frame(sdata, mgmt, len) < 0)
> +		if (mesh_fwd_csa_frame(sdata, mgmt, len, &elems) < 0)
>   			mcsa_dbg(sdata, "Failed to forward the CSA frame");
>   	}
>   }

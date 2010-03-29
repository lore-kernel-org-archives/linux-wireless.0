Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab0C2Gan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 02:30:43 -0400
Subject: Re: [PATCH v2] mac80211: Handle mesh action frames in
 ieee80211_rx_h_action
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?Q?=D0=9B=D0=B5=D0=B4=D0=BE=D0=B2=D1=81=D0=BA=D0=B8=D1=85_?=
	 =?UTF-8?Q?=D0=9D=D0=B8=D0=BA=D0=BE=D0=BB=D0=B0=D0=B9_?=
	 =?UTF-8?Q?=D0=92=D0=B0=D0=BB=D0=B5=D1=80=D1=8C=D0=B5=D0=B2=D0=B8=D1=87?=
	<nledovskih@mail.ru>, Steve Derosier <steve@cozybit.com>,
	devel@lists.open80211s.org
In-Reply-To: <1269653791-28478-1-git-send-email-javier@cozybit.com>
References: <368d7bd403c196b9e3a306eb7863a621@localhost>
	 <1269653791-28478-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 08:30:39 +0200
Message-ID: <1269844239.4131.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 18:36 -0700, Javier Cardona wrote:
> This fixes the problem introduced in commit 8404080568613d93ad7cf0a16dfb68
> which broke mesh peer link establishment.
> 
> Also in this patch, moved mesh action codes to a more visible location
> (from mesh.h to ieee80211.h) so they are not overlooked in the future.

Hm, come to think of it, I think it might be useful to split up into two
patches, with the functional change coming _first_ so it can be applied
to -stable?

johannes

> v2 changes:
> 	Added missing break (Johannes)
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  include/linux/ieee80211.h |    2 ++
>  net/mac80211/mesh.c       |    7 ++-----
>  net/mac80211/mesh.h       |    2 --
>  net/mac80211/mesh_hwmp.c  |    4 ++--
>  net/mac80211/mesh_plink.c |    2 +-
>  net/mac80211/rx.c         |    7 ++++++-
>  6 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 1998495..e0f528e 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -1211,6 +1211,8 @@ enum ieee80211_category {
>  	WLAN_CATEGORY_SA_QUERY = 8,
>  	WLAN_CATEGORY_PROTECTED_DUAL_OF_ACTION = 9,
>  	WLAN_CATEGORY_WMM = 17,
> +	WLAN_CATEGORY_MESH_PLINK = 30,		/* Pending ANA approval */
> +	WLAN_CATEGORY_MESH_PATH_SEL = 32,	/* Pending ANA approval */
>  	WLAN_CATEGORY_VENDOR_SPECIFIC_PROTECTED = 126,
>  	WLAN_CATEGORY_VENDOR_SPECIFIC = 127,
>  };
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 61080c5..2669fbf 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -600,10 +600,10 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
>  					  struct ieee80211_rx_status *rx_status)
>  {
>  	switch (mgmt->u.action.category) {
> -	case MESH_PLINK_CATEGORY:
> +	case WLAN_CATEGORY_MESH_PLINK:
>  		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
>  		break;
> -	case MESH_PATH_SEL_CATEGORY:
> +	case WLAN_CATEGORY_MESH_PATH_SEL:
>  		mesh_rx_path_sel_frame(sdata, mgmt, len);
>  		break;
>  	}
> @@ -749,9 +749,6 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
>  
>  	switch (fc & IEEE80211_FCTL_STYPE) {
>  	case IEEE80211_STYPE_ACTION:
> -		if (skb->len < IEEE80211_MIN_ACTION_SIZE)
> -			return RX_DROP_MONITOR;
> -		/* fall through */
>  	case IEEE80211_STYPE_PROBE_RESP:
>  	case IEEE80211_STYPE_BEACON:
>  		skb_queue_tail(&ifmsh->skb_queue, skb);
> diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
> index 85562c5..c88087f 100644
> --- a/net/mac80211/mesh.h
> +++ b/net/mac80211/mesh.h
> @@ -209,8 +209,6 @@ struct mesh_rmc {
>  #define MESH_MAX_MPATHS		1024
>  
>  /* Pending ANA approval */
> -#define MESH_PLINK_CATEGORY	30
> -#define MESH_PATH_SEL_CATEGORY	32
>  #define MESH_PATH_SEL_ACTION	0
>  
>  /* PERR reason codes */
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index ccff613..36141d6 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -131,7 +131,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
>  	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
>  	/* BSSID == SA */
>  	memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
> -	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
> +	mgmt->u.action.category = WLAN_CATEGORY_MESH_PATH_SEL;
>  	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
>  
>  	switch (action) {
> @@ -224,7 +224,7 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
>  	memcpy(mgmt->da, ra, ETH_ALEN);
>  	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
>  	/* BSSID is left zeroed, wildcard value */
> -	mgmt->u.action.category = MESH_PATH_SEL_CATEGORY;
> +	mgmt->u.action.category = WLAN_CATEGORY_MESH_PATH_SEL;
>  	mgmt->u.action.u.mesh_action.action_code = MESH_PATH_SEL_ACTION;
>  	ie_len = 15;
>  	pos = skb_put(skb, 2 + ie_len);
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index 1a29c4a..8517f88 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -171,7 +171,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
>  	memcpy(mgmt->da, da, ETH_ALEN);
>  	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
>  	/* BSSID is left zeroed, wildcard value */
> -	mgmt->u.action.category = MESH_PLINK_CATEGORY;
> +	mgmt->u.action.category = WLAN_CATEGORY_MESH_PLINK;
>  	mgmt->u.action.u.plink_action.action_code = action;
>  
>  	if (action == PLINK_CLOSE)
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 1da57c8..43c0310 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -484,7 +484,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
>  
>  		if (ieee80211_is_action(hdr->frame_control)) {
>  			mgmt = (struct ieee80211_mgmt *)hdr;
> -			if (mgmt->u.action.category != MESH_PLINK_CATEGORY)
> +			if (mgmt->u.action.category != WLAN_CATEGORY_MESH_PLINK)
>  				return RX_DROP_MONITOR;
>  			return RX_CONTINUE;
>  		}
> @@ -1964,6 +1964,11 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>  			goto handled;
>  		}
>  		break;
> +	case WLAN_CATEGORY_MESH_PLINK:
> +	case WLAN_CATEGORY_MESH_PATH_SEL:
> +		if (ieee80211_vif_is_mesh(&sdata->vif))
> +			return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
> +		break;
>  	}
>  
>  	/*



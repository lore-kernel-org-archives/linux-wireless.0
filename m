Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0LMKLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 05:11:08 -0500
Subject: Re: [PATCH 2/2] mac80211: Send mesh non-HWMP path selection frames
 to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1292022251-12616-3-git-send-email-javier@cozybit.com>
References: <1292022251-12616-1-git-send-email-javier@cozybit.com>
	 <1292022251-12616-3-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 11:11:05 +0100
Message-ID: <1292235065.3539.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 15:04 -0800, Javier Cardona wrote:

> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c

I really don't think you should be changing this file in this patch :-)

> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 4fee008..8093439 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1673,6 +1673,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
>  	case NL80211_IFTYPE_AP:
>  	case NL80211_IFTYPE_AP_VLAN:
>  	case NL80211_IFTYPE_P2P_GO:
> +	case NL80211_IFTYPE_MESH_POINT:
>  		if (!ieee80211_is_action(mgmt->frame_control) ||
>  		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)
>  			break;

Might be worthwhile to update the subject to say something along the
lines of allowing send/receive in mesh.

>  struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 80723d8..c38c833 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -126,13 +126,21 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
>  
>  void mesh_ids_set_default(struct ieee80211_if_mesh *sta)
>  {
> -	sta->mesh_pp_id = 0;	/* HWMP */
> -	sta->mesh_pm_id = 0;	/* Airtime */
> +	sta->mesh_pp_id = MESH_PATH_PROTOCOL_HWMP;
> +	sta->mesh_pm_id = MESH_PATH_PROTOCOL_VENDOR;

Doesn't that belong into the other patch? Come to think of it -- maybe
just move the remaining three lines into start_mesh() there, since these
two at least aren't necessary since we will always go through start_mesh
before using the values -- can even remove mesh_ids_set_default.

> +	case WLAN_CATEGORY_MESH_PATH_SEL:
> +		if (!ieee80211_vif_is_mesh(&sdata->vif) ||
> +				!mesh_path_sel_match(sdata,
> +					MESH_PATH_PROTOCOL_HWMP))
> +			break;
> +		goto queue;

I don't think I'd mind an ifdef here since that'd allow simplifying this
code a lot with the function call. Or at least make that an inline I
guess, a real function call for a comparison seems a bit odd. Maybe just
do

static inline bool mesh_path_sel_is_hwmp(sdata)
{
#ifdef CONFIG_MAC80211_MESH
	return sdata->u.mesh.mesh_pp_id == MESH_PATH_PROTOCOL_HWMP;
#endif
	return false;
}

and then you can even remove the !ieee80211_vif_is_mesh check :-)

johannes


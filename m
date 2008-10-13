Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57623 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYJMQj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 12:39:27 -0400
Date: Mon, 13 Oct 2008 12:36:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] wireless: build failure if !CONFIG_MAC80211_MESH
Message-ID: <20081013163642.GA32550@tuxdriver.com> (sfid-20081013_183931_797369_D9715A4D)
References: <20081013081238.2755bd25@extreme> <20081013084503.66cca9f9@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081013084503.66cca9f9@extreme>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think Dave already merged a patch from Ingo to resolve this issue?

On Mon, Oct 13, 2008 at 08:45:03AM -0700, Stephen Hemminger wrote:
> If mac80211 is configured, but MAC80211_MESH is not, then the build fails
> because mesh_path_lookup and mesh_path_add are not defined. 
> Compile tested only, fixes the build, but no idea if breaks something else.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> ---
> Also needed to stub out mpp_path_lookup
> 
> --- a/net/mac80211/mesh.h	2008-10-13 07:57:46.000000000 -0700
> +++ b/net/mac80211/mesh.h	2008-10-13 08:42:31.000000000 -0700
> @@ -225,11 +225,20 @@ void ieee80211_stop_mesh(struct ieee8021
>  int mesh_nexthop_lookup(struct sk_buff *skb,
>  		struct ieee80211_sub_if_data *sdata);
>  void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
> +#ifdef CONFIG_MAC80211_MESH
>  struct mesh_path *mesh_path_lookup(u8 *dst,
>  		struct ieee80211_sub_if_data *sdata);
>  struct mesh_path *mpp_path_lookup(u8 *dst,
>  				  struct ieee80211_sub_if_data *sdata);
> +#else
> +#define mesh_path_lookup(dst,sdata) (NULL)
> +#define mpp_path_lookup(dst,sdata) (NULL)
> +#endif
> +#ifdef CONFIG_MAC80211_MESH
>  int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata);
> +#else
> +#define mpp_path_add(dst, mpp, sdata) (-ENOTSUPP)
> +#endif
>  struct mesh_path *mesh_path_lookup_by_idx(int idx,
>  		struct ieee80211_sub_if_data *sdata);
>  void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
> 

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

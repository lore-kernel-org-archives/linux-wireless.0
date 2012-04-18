Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2DRBau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:30:50 -0400
Message-ID: <1334712616.3725.7.camel@jlt3.sipsolutions.net> (sfid-20120418_033053_999073_C2169F41)
Subject: Re: [PATCH 1/1] mac80211: add function retrieve average rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 18:30:16 -0700
In-Reply-To: <1334343777-20798-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334343777-20798-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-04-13 at 12:02 -0700, wey-yi.w.guy@intel.com wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> Add utility function to provide the average rssi per vif
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  include/net/mac80211.h |    3 +++
>  net/mac80211/util.c    |    8 ++++++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 32cd517..20a2ddd 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -3800,4 +3800,7 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif,
>  
>  int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
>  				struct sk_buff *skb, bool need_basic);
> +
> +int ieee80211_ave_rssi(struct ieee80211_vif *vif);

There should be some documentation here I think, especially about the
point below:

> +int ieee80211_ave_rssi(struct ieee80211_vif *vif)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> +
> +	return ifmgd->ave_beacon_signal;
> +}

This will not return anything useful if the hardware implements beacon
filtering, so it should warn in that case I think. Also in the case
you're calling it on non-managed interface types.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:54402 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756220Ab2KWUjA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:39:00 -0500
Message-ID: <1353703140.28931.19.camel@joe-AO722> (sfid-20121123_213907_535491_DFDD46AE)
Subject: Re: [RFCv2 01/13] {nl,cfg,mac}80211: set beacon interval and DTIM
 period on mesh join
From: Joe Perches <joe@perches.com>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org
Date: Fri, 23 Nov 2012 12:39:00 -0800
In-Reply-To: <1353701934-12752-2-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-2-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:
> Move the default mesh beacon interval and DTIM period to cfg80211 and
> make it accessible to nl80211. This enables setting both values when joining
> an MBSS.

Trivial notes for a couple of patches

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
[]
> @@ -937,6 +939,8 @@ struct mesh_setup {
>  	bool is_authenticated;
>  	bool is_secure;
>  	int mcast_rate[IEEE80211_NUM_BANDS];
> +	u16 beacon_interval;
> +	u8 dtim_period;

It might be better to move the new u8 after the last bool
to avoid unnecessary padding.

 	bool is_secure;
	u8 dtim_period;
	u16 beacon_interval;
  	int mcast_rate[IEEE80211_NUM_BANDS];

and for patch 3/13:

diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
[]
> +void ieee80211_mesh_local_ps_update(struct ieee80211_sub_if_data *sdata)
> +{
[]
> +	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
[]
> +		case NL80211_PLINK_ESTAB:
> +			if (sta->local_ps_mode ==
> +					NL80211_MESH_POWER_LIGHT_SLEEP)
> +				light_sleep_cnt++;
> +			if (sta->local_ps_mode ==
> +					NL80211_MESH_POWER_DEEP_SLEEP)

else if

> +				deep_sleep_cnt++;
> +			break;



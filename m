Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39714 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaE0Qe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 12:34:56 -0400
Message-ID: <5384BEAF.1030803@candelatech.com> (sfid-20140527_183500_010002_12024F87)
Date: Tue, 27 May 2014 09:34:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	cprevotaux@nltinc.com
Subject: Re: [PATCH] mac80211: fix a memory leak on sta rate selection table
References: <1400866194-62234-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1400866194-62234-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2014 10:29 AM, Felix Fietkau wrote:
> Cc: stable@vger.kernel.org
> Reported-by: Christophe Prévotaux <cprevotaux@nltinc.com>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Any idea how far back this should be applied?

Thanks,
Ben

> ---
>  net/mac80211/sta_info.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 632d372..8b42f49 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -227,6 +227,7 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
>   */
>  void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
>  {
> +	struct ieee80211_sta_rates *rates;
>  	int i;
>  
>  	if (sta->rate_ctrl)
> @@ -238,6 +239,10 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
>  		kfree(sta->tx_lat);
>  	}
>  
> +	rates = rcu_dereference_protected(sta->sta.rates, true);
> +	if (rates)
> +		kfree(rates);
> +
>  	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
>  
>  	kfree(sta);
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


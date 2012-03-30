Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2C3GtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 02:49:09 -0400
Message-ID: <1333090147.3908.6.camel@jlt3.sipsolutions.net> (sfid-20120330_084913_777028_504CC6BF)
Subject: Re: [PATCH 2/4] mac80211: Indicate basic rates when adding
 supported rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	thomas@cozybit.com, devel@lists.open80211s.org,
	linville@tuxdriver.com
Date: Fri, 30 Mar 2012 08:49:07 +0200
In-Reply-To: <1333063729-9353-2-git-send-email-ashok@cozybit.com> (sfid-20120330_012929_676293_B238E91B)
References: <1333063729-9353-1-git-send-email-ashok@cozybit.com>
	 <1333063729-9353-2-git-send-email-ashok@cozybit.com>
	 (sfid-20120330_012929_676293_B238E91B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-29 at 16:28 -0700, Ashok Nagarajan wrote:
> and extended supported rates
> 
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/util.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 32f7a3b..a1e2ff5 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1685,6 +1685,7 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
>  	struct ieee80211_supported_band *sband;
>  	int rate;
>  	u8 i, rates, *pos;
> +	u32 basic_rates = vif->bss_conf.basic_rates;
>  
>  	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
>  	rates = sband->n_bitrates;
> @@ -1698,8 +1699,11 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
>  	*pos++ = WLAN_EID_SUPP_RATES;
>  	*pos++ = rates;
>  	for (i = 0; i < rates; i++) {
> +		u8 basic = 0;
> +		if (basic_rates & BIT(i))
> +			basic = 0x80;
>  		rate = sband->bitrates[i].bitrate;
> -		*pos++ = (u8) (rate / 5);
> +		*pos++ = basic | (u8) (rate / 5);
>  	}

I'm not sure you should do this unconditionally with the
vif->bss_conf.basic_rates, for example this code is also used with TDLS
and I have no idea what that should be there -- since we didn't add
anything before maybe it should indeed not have any basic rate bits?

johannes


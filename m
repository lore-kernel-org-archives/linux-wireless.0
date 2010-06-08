Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab0FHMsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 08:48:46 -0400
Subject: Re: [RFC 3/3] mac80211: Store basic rates for bss when joining
 ibss network
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1276000459-1121-4-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276000459-1121-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276000459-1121-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276000459-1121-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276000459-1121-4-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 14:48:38 +0200
Message-ID: <1276001318.3706.130.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-08 at 15:34 +0300, Teemu Paasikivi wrote:
> When joinig a ibss network, basic rates for bss were not stored. When
> network was self created, leaving and (re)joining same network has
> caused basic rates to be left unset. With this patch stored values are
> used.

>  	bss = cfg80211_inform_bss_frame(local->hw.wiphy, local->hw.conf.channel,
>  					mgmt, skb->len, 0, GFP_KERNEL);
> +
> +	ibss = (struct ieee80211_bss *)(bss->priv);

Watch out -- bss can be NULL here if memory allocation fails. It's just
that put_bss(NULL) is valid.

> +	for (i = 0; i < sband->n_bitrates; i++) {
> +		u8 basic = 0x00;
> +		if (basic_rates & BIT(i))
> +			basic = 0x80;
> +
> +		ibss->supp_rates[i] = supp_rates[i] | basic;
> +	}
> +
> +	ibss->supp_rates_len = i;
> +
>  	cfg80211_put_bss(bss);


However this kinda confuses me.

We had a long-standing TODO item on our list at
http://wireless.kernel.org/en/developers/todo-list

"when leaving an IBSS and we were the only member, remove it from
cfg80211's BSS list"

Maybe that would help here too?

However I don't understand the scenario anyway. If you create an IBSS,
you start beaconing and tell cfg80211 about it with a frame that
includes the supported and basic rates. Then you leave, but the BSS
stays around in cfg80211 for 15 seconds. If you re-join within those 15
seconds, the scan results will pick up the old IBSS that no longer
exists, and we "join" it rather than creating it.

However -- joining it will take the basic rates from it. So wouldn't you
get the old basic rates which is fine? What do you mean by "left unset"?

What happens if you join an IBSS that already exists?

johannes


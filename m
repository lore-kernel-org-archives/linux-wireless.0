Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab1J1IM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 04:12:56 -0400
Subject: Re: [wireless-next PATCH 3/5] wifi: Allow overriding some HT
 information.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319778680-11405-3-git-send-email-greearb@candelatech.com> (sfid-20111028_071147_787476_DBCC8CCF)
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 <1319778680-11405-3-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071147_787476_DBCC8CCF)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 10:12:53 +0200
Message-ID: <1319789573.3914.15.camel@jlt3.sipsolutions.net> (sfid-20111028_101259_311268_2036FAA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> * Allow configuring the mcs (/n) rates available.
> * Allow configuration of MAX-A-MSDU
> * Allow configuration of A-MPDU factor & density.
> 
> Users can only remove existing rates.  The MSDU and MPDU
> values can be set to any value allowed by the 802.11n
> specification.

That can't work -- the device might not support it.

I also don't really like the way you pass in some binary "mask" when
it's not really a binary masking operation.

>  struct vif_params {
>  	int use_4addr;
>  	int disable_11n;
>  	int disable_ht40;
> +	struct ieee80211_ht_cap *ht_capa;
> +	struct ieee80211_ht_cap *ht_capa_mask;

Same comments as before again -- this is per connection right?

> @@ -114,6 +115,19 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
>  	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
>  		return;
>  
> +	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
> +	/*
> +	 * This is for an association attempt, and we must
> +	 * advert at least the first 8 rates, even if we
> +	 * will later force the rate control to a lower rate.
> +	 */
> +	ieee80211_apply_htcap_overrides(sdata, &ht_cap, 8);

Yuck, why, why hard-code 8, etc.

johannes


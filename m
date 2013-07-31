Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2361 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3GaJpy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 05:45:54 -0400
Message-ID: <51F8DCBD.6070200@broadcom.com> (sfid-20130731_114557_767237_176919FF)
Date: Wed, 31 Jul 2013 11:45:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Felix Fietkau" <nbd@openwrt.org>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@redhat.com>,
	"John Greene" <jogreene@redhat.com>
Subject: Re: Fwd: [Bug 989269] Connecting to WLAN causes kernel panic
References: <bug-989269-351310-C5h8dsuOxB@bugzilla.redhat.com>
 <51F8CD45.6060108@broadcom.com> <51F8D438.7020304@openwrt.org>
In-Reply-To: <51F8D438.7020304@openwrt.org>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2013 11:09 AM, Felix Fietkau wrote:
> On 2013-07-31 10:39 AM, Arend van Spriel wrote:
>> Hi Felix,
>>
>> How are things in OpenWRT. I wanted to ask you something regarding a
>> defect I am looking at. Since kernel 3.9 several reports have been made
>> about a kernel panic in brcmsmac, ie. a divide-by-zero error.
> 3.9 was the first kernel to support CCK rates in minstrel_ht as
> fallback (in case the link gets very bad). Not sure if that triggers
> anything weird in brcmsmac.

It just might reading this in brcmsmac:

	/*
	 * Currently only support same setting for primary and
	 * fallback rates. Unify flags for each rate into a
	 * single value for the frame
	 */
	use_rts |= txrate[k]->flags & IEEE80211_TX_RC_USE_RTS_CTS
		? true : false;
	use_cts |= txrate[k]->flags & IEEE80211_TX_RC_USE_CTS_PROTECT
		? true : false;

Although this is not directly

>> Debugging the issue shows we end up with a rate with MCS index 110,
>> which is, well, impossible.
> Did you verify that it comes directly from minstrel_ht, or does it show
> up somewhere further down the chain in brcmsmac?

I am pretty sure it is not minstrel_ht. brcmsmac converts the 
information from minstrel_ht into a so-called ratespec format. The 
strange MCS is what I see in the ratespec leading up to the 
divide-by-zero. Next thing to look at is the conversion step. As said 
above the CCK fallback might be the culprit. I mean how brcmsmac deals 
with it is.

>> As brcmsmac gets the rate info from
>> minstrel_ht I was wondering if we have an intergration issue here. I saw
>> around April patches about new API which may have been in the 3.9 time
>> frame and something subtly changed things for brcmsmac.
> The new rate API was added in 3.10, not 3.9. It did add bug that caused
> bogus MCS rates. I've sent a patch for this a while back (shortly
> before 3.10 was released), but it was too late to make it into the
> release. I guess we have to wait for it to be applied through stable -
> no idea why that hasn't happened yet.

Ping Greg? I will give it a try.

Thanks,
Arend

> Here is the fix:
>
> commit 1cd158573951f737fbc878a35cb5eb47bf9af3d5
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Fri Jun 28 21:04:35 2013 +0200
>
>      mac80211/minstrel_ht: fix cck rate sampling
>
>      The CCK group needs special treatment to set the right flags and rate
>      index. Add this missing check to prevent setting broken rates for tx
>      packets.
>
>      Cc: stable@vger.kernel.org # 3.10
>      Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>      Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 5b2d301..f5aed96 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -804,10 +804,18 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
>
>   	sample_group = &minstrel_mcs_groups[sample_idx / MCS_GROUP_RATES];
>   	info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
> +	rate->count = 1;
> +
> +	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
> +		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
> +		rate->idx = mp->cck_rates[idx];
> +		rate->flags = 0;
> +		return;
> +	}
> +
>   	rate->idx = sample_idx % MCS_GROUP_RATES +
>   		    (sample_group->streams - 1) * MCS_GROUP_RATES;
>   	rate->flags = IEEE80211_TX_RC_MCS | sample_group->flags;
> -	rate->count = 1;
>   }
>
>   static void
>
>



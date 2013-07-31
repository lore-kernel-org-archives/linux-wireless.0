Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:36083 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab3GaJqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 05:46:44 -0400
Received: by mail-we0-f182.google.com with SMTP id u55so402828wes.27
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 02:46:43 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <51F8D438.7020304@openwrt.org>
References: <bug-989269-351310-C5h8dsuOxB@bugzilla.redhat.com>
	<51F8CD45.6060108@broadcom.com>
	<51F8D438.7020304@openwrt.org>
Date: Wed, 31 Jul 2013 11:46:43 +0200
Message-ID: <CA+icZUU7RB9=Pr2b8ixZ7CES-4c6Acf+k=M_zD5Z_wEHLt+Niw@mail.gmail.com> (sfid-20130731_114647_405293_D3764E2D)
Subject: Re: Fwd: [Bug 989269] Connecting to WLAN causes kernel panic
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@redhat.com>,
	John Greene <jogreene@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 31, 2013 at 11:09 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2013-07-31 10:39 AM, Arend van Spriel wrote:
>> Hi Felix,
>>
>> How are things in OpenWRT. I wanted to ask you something regarding a
>> defect I am looking at. Since kernel 3.9 several reports have been made
>> about a kernel panic in brcmsmac, ie. a divide-by-zero error.
> 3.9 was the first kernel to support CCK rates in minstrel_ht as
> fallback (in case the link gets very bad). Not sure if that triggers
> anything weird in brcmsmac.
>
>> Debugging the issue shows we end up with a rate with MCS index 110,
>> which is, well, impossible.
> Did you verify that it comes directly from minstrel_ht, or does it show
> up somewhere further down the chain in brcmsmac?
>
>> As brcmsmac gets the rate info from
>> minstrel_ht I was wondering if we have an intergration issue here. I saw
>> around April patches about new API which may have been in the 3.9 time
>> frame and something subtly changed things for brcmsmac.
> The new rate API was added in 3.10, not 3.9. It did add bug that caused
> bogus MCS rates. I've sent a patch for this a while back (shortly
> before 3.10 was released), but it was too late to make it into the
> release. I guess we have to wait for it to be applied through stable -
> no idea why that hasn't happened yet.
>
> Here is the fix:
>
> commit 1cd158573951f737fbc878a35cb5eb47bf9af3d5
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Fri Jun 28 21:04:35 2013 +0200
>
>     mac80211/minstrel_ht: fix cck rate sampling
>

That patch is not in Linus tree yet, so it won't get into stable.

- Sedat -

>     The CCK group needs special treatment to set the right flags and rate
>     index. Add this missing check to prevent setting broken rates for tx
>     packets.
>
>     Cc: stable@vger.kernel.org # 3.10
>     Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 5b2d301..f5aed96 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -804,10 +804,18 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
>
>         sample_group = &minstrel_mcs_groups[sample_idx / MCS_GROUP_RATES];
>         info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
> +       rate->count = 1;
> +
> +       if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
> +               int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
> +               rate->idx = mp->cck_rates[idx];
> +               rate->flags = 0;
> +               return;
> +       }
> +
>         rate->idx = sample_idx % MCS_GROUP_RATES +
>                     (sample_group->streams - 1) * MCS_GROUP_RATES;
>         rate->flags = IEEE80211_TX_RC_MCS | sample_group->flags;
> -       rate->count = 1;
>  }
>
>  static void
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

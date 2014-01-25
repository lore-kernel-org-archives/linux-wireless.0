Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 0.mx.nanl.de ([217.115.11.12]:46008 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaAYQQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jan 2014 11:16:14 -0500
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com [209.85.223.170])
	by mail.nanl.de (Postfix) with ESMTPSA id 578B440208
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jan 2014 16:14:28 +0000 (UTC)
Received: by mail-ie0-f170.google.com with SMTP id u16so4188756iet.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jan 2014 08:16:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390645452-2495-2-git-send-email-janusz.dziedzic@tieto.com>
References: <1390645452-2495-1-git-send-email-janusz.dziedzic@tieto.com> <1390645452-2495-2-git-send-email-janusz.dziedzic@tieto.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sat, 25 Jan 2014 17:15:45 +0100
Message-ID: <CAOiHx=nXngrZMyV4S7mg36+CV5xpDUr=025JrBi6be49YEPVWA@mail.gmail.com> (sfid-20140125_171618_549812_9689E3AB)
Subject: Re: [PATCH v3 2/2] cfg80211: regulatory introduce maximum bandwidth calculation
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	mcgrof@do-not-panic.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Jan 25, 2014 at 11:24 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> In case we will get regulatory request with rule
> where max_bandwidth_khz is set to 0, handle this case
> as a special one.
> Generally
> max_bandwidth_khz == 0 mean we should calculate maximum
> available bandwidth base on all frequency contiguous rules.
> We don't need any chanes in CRDA or internal regulatory.
> In case we need auto calculation we just have to set:
>
> country PL: DFS-ETSI
>         (2402 - 2482 @ 40), (N/A, 20)
>         (5170 - 5250 @ AUTO), (N/A, 20)
>         (5250 - 5330 @ AUTO), (N/A, 20), DFS
>         (5490 - 5710 @ 80), (N/A, 27), DFS
>
> This mean we will calculate maximum bw for rules where
> AUTO (N/A) was set, 160MHz in example above. So we will
> get:
>
>         (5170 - 5250 @ 160), (N/A, 20)
>         (5250 - 5330 @ 160), (N/A, 20), DFS
>
> In other case:
> country FR: DFS-ETSI
>         (2402 - 2482 @ 40), (N/A, 20)
>         (5170 - 5250 @ AUTO), (N/A, 20)
>         (5250 - 5330 @ 80), (N/A, 20), DFS
>         (5490 - 5710 @ 80), (N/A, 27), DFS
>
> We will get:
>         (5170 - 5250 @ 80), (N/A, 20)
>         (5250 - 5330 @ 80), (N/A, 20), DFS
>
> Base on this calculations we will set correct channel
> bandwidth flags.
> I decided to don't change freq_range->max_bandwidth_khz
> because they are const.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
> *V3 - don't introduce any new flag, base only on freq_range->max_bandwidth_khz
>       if == 0 handle as a AUTO calculation request.
>
>  net/wireless/reg.c |  120 +++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 104 insertions(+), 16 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index d58a09c..7fbaade 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -541,6 +541,61 @@ static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
>         return regd;
>  }
>
> +static unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
> +                                         const struct ieee80211_reg_rule *rule)
> +{
> +       const struct ieee80211_freq_range *freq_range = &rule->freq_range;
> +       const struct ieee80211_freq_range *freq_range_tmp;
> +       const struct ieee80211_reg_rule *tmp;
> +       u32 start_freq, end_freq, idx, no;
> +
> +       for (idx = 0; idx < rd->n_reg_rules; idx++)
> +               if (rule == &rd->reg_rules[idx])
> +                       break;
> +
> +       if (idx == rd->n_reg_rules)
> +               return 0;
> +
> +       /* get start_freq */
> +       no = idx;
> +
> +       while (no) {
> +               tmp = &rd->reg_rules[--no];
> +               freq_range_tmp = &tmp->freq_range;
> +
> +               if (freq_range_tmp->end_freq_khz < freq_range->start_freq_khz)
> +                       break;
> +
> +               if (freq_range_tmp->max_bandwidth_khz)
> +                       break;
> +
> +               freq_range = freq_range_tmp;
> +       };
> +
> +       start_freq = freq_range->start_freq_khz;
> +
> +       /* get end_freq */
> +       freq_range = &rule->freq_range;
> +       no = idx;
> +
> +       while (no < rd->n_reg_rules - 1) {
> +               tmp = &rd->reg_rules[++no];
> +               freq_range_tmp = &tmp->freq_range;
> +
> +               if (freq_range_tmp->start_freq_khz > freq_range->end_freq_khz)
> +                       break;
> +
> +               if (freq_range_tmp->max_bandwidth_khz)
> +                       break;
> +
> +               freq_range = freq_range_tmp;
> +       }
> +
> +       end_freq = freq_range->end_freq_khz;
> +
> +       return end_freq - start_freq;
> +}
> +
>  /* Sanity check on a regulatory rule */
>  static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
>  {
> @@ -649,7 +704,9 @@ reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
>   * Helper for regdom_intersect(), this does the real
>   * mathematical intersection fun
>   */
> -static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
> +static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
> +                              const struct ieee80211_regdomain *rd2,
> +                              const struct ieee80211_reg_rule *rule1,
>                                const struct ieee80211_reg_rule *rule2,
>                                struct ieee80211_reg_rule *intersected_rule)
>  {
> @@ -657,7 +714,7 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
>         struct ieee80211_freq_range *freq_range;
>         const struct ieee80211_power_rule *power_rule1, *power_rule2;
>         struct ieee80211_power_rule *power_rule;
> -       u32 freq_diff;
> +       u32 freq_diff, max_bandwidth1, max_bandwidth2;
>
>         freq_range1 = &rule1->freq_range;
>         freq_range2 = &rule2->freq_range;
> @@ -671,8 +728,16 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
>                                          freq_range2->start_freq_khz);
>         freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
>                                        freq_range2->end_freq_khz);
> -       freq_range->max_bandwidth_khz = min(freq_range1->max_bandwidth_khz,
> -                                           freq_range2->max_bandwidth_khz);
> +
> +       max_bandwidth1 = freq_range1->max_bandwidth_khz;
> +       if (!max_bandwidth1)
> +               max_bandwidth1 = reg_get_max_bandwidth(rd1, rule1);
> +
> +       max_bandwidth2 = freq_range1->max_bandwidth_khz;

I guess you want to use freq_range2 here ...

> +       if (!max_bandwidth1)

and check max_bandwidth2 here.

> +               max_bandwidth2 = reg_get_max_bandwidth(rd2, rule2);
> +
> +       freq_range->max_bandwidth_khz = min(max_bandwidth1, max_bandwidth2);
>
>         freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
>         if (freq_range->max_bandwidth_khz > freq_diff)

[snip rest which seemed fine on a first glance]


Regards
Jonas

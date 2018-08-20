Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbeHTNpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 09:45:19 -0400
Date: Mon, 20 Aug 2018 12:27:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Grzegorz Duszy??ski <gfduszynski@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] cfg80211: remove division by size of sizeof(struct
 ieee80211_wmm_rule)
Message-ID: <20180820102710.GA2760@redhat.com> (sfid-20180820_123018_771668_891B04D5)
References: <20180820073705.9683-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180820073705.9683-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 20, 2018 at 09:37:05AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Pointer arithmetic already adjusts by the size of the struct,
> so the sizeof() calculation is wrong. This is basically the
> same as Colin King's patch for similar code in the iwlwifi
> driver.
> 
> Fixes: 230ebaa189af ("cfg80211: read wmm rules from regulatory database")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/reg.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 4fc66a117b7d..283902974fbf 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -452,8 +452,7 @@ reg_copy_regd(const struct ieee80211_regdomain *src_regd)
>  			continue;
>  
>  		regd->reg_rules[i].wmm_rule = d_wmm +
> -			(src_regd->reg_rules[i].wmm_rule - s_wmm) /
> -			sizeof(struct ieee80211_wmm_rule);
> +			(src_regd->reg_rules[i].wmm_rule - s_wmm);
>  	}
>  	return regd;
>  }

As side note those pointer aritmetics related with rule->wmm_rule is
really involuted in various places in reg.c . Seems would be better to
just make wmm_rule part of iee80211_reg_rule structure like this:

struct ieee80211_reg_rule {
        struct ieee80211_freq_range freq_range;
        struct ieee80211_power_rule power_rule;
        struct ieee80211_wmm_rule wmm_rule;
        u32 flags;
        u32 dfs_cac_ms;
};

and use a flag to intdicate wmm_rule is valid. There should be no
big memory overhead sice there are only few reg_rules for the regdomain.
Or I'm wrong?

Regards
Stanislaw

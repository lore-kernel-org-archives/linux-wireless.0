Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f47.google.com ([209.85.167.47]:40312 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbeHUMQn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 08:16:43 -0400
Received: by mail-lf1-f47.google.com with SMTP id y200-v6so12996175lfd.7
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2018 01:57:24 -0700 (PDT)
Subject: Re: [RFC] cfg80211: let's wmm_rule be part of reg_rule structure
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20180821074020.GA28952@redhat.com>
From: =?UTF-8?Q?Grzegorz_Duszy=c5=84ski?= <gfduszynski@gmail.com>
Message-ID: <7580e821-bfa0-e4d4-435f-a042b0eba555@gmail.com> (sfid-20180821_105729_363447_0781BE0B)
Date: Tue, 21 Aug 2018 10:57:20 +0200
MIME-Version: 1.0
In-Reply-To: <20180821074020.GA28952@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've just briefly tested it, looks like it's working!
I have only remote access to my machine at the moment so it's difficult 
to say for sure if everything is in order.
However stalls do not occur, nor there are any error/warnings anywhere.


On 21.08.2018 09:40, Stanislaw Gruszka wrote:
> I'm not sure if it works, I only copiled it for now.
> Looking for review/comments at this point.
> --
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> index b4c3a957c102..73969dbeb5c5 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> @@ -985,15 +985,12 @@ struct ieee80211_regdomain *
>   	const u8 *nvm_chan = cfg->nvm_type == IWL_NVM_EXT ?
>   			     iwl_ext_nvm_channels : iwl_nvm_channels;
>   	struct ieee80211_regdomain *regd, *copy_rd;
> -	int size_of_regd, regd_to_copy, wmms_to_copy;
> -	int size_of_wmms = 0;
> +	int size_of_regd, regd_to_copy;
>   	struct ieee80211_reg_rule *rule;
> -	struct ieee80211_wmm_rule *wmm_rule, *d_wmm, *s_wmm;
>   	struct regdb_ptrs *regdb_ptrs;
>   	enum nl80211_band band;
>   	int center_freq, prev_center_freq = 0;
> -	int valid_rules = 0, n_wmms = 0;
> -	int i;
> +	int valid_rules = 0;
>   	bool new_rule;
>   	int max_num_ch = cfg->nvm_type == IWL_NVM_EXT ?
>   			 IWL_NVM_NUM_CHANNELS_EXT : IWL_NVM_NUM_CHANNELS;
> @@ -1012,11 +1009,7 @@ struct ieee80211_regdomain *
>   		sizeof(struct ieee80211_regdomain) +
>   		num_of_ch * sizeof(struct ieee80211_reg_rule);
>   
> -	if (geo_info & GEO_WMM_ETSI_5GHZ_INFO)
> -		size_of_wmms =
> -			num_of_ch * sizeof(struct ieee80211_wmm_rule);
> -
> -	regd = kzalloc(size_of_regd + size_of_wmms, GFP_KERNEL);
> +	regd = kzalloc(size_of_regd, GFP_KERNEL);
>   	if (!regd)
>   		return ERR_PTR(-ENOMEM);
>   
> @@ -1030,8 +1023,6 @@ struct ieee80211_regdomain *
>   	regd->alpha2[0] = fw_mcc >> 8;
>   	regd->alpha2[1] = fw_mcc & 0xff;
>   
> -	wmm_rule = (struct ieee80211_wmm_rule *)((u8 *)regd + size_of_regd);
> -
>   	for (ch_idx = 0; ch_idx < num_of_ch; ch_idx++) {
>   		ch_flags = (u16)__le32_to_cpup(channels + ch_idx);
>   		band = (ch_idx < NUM_2GHZ_CHANNELS) ?
> @@ -1085,26 +1076,10 @@ struct ieee80211_regdomain *
>   		    band == NL80211_BAND_2GHZ)
>   			continue;
>   
> -		if (!reg_query_regdb_wmm(regd->alpha2, center_freq,
> -					 &regdb_ptrs[n_wmms].token, wmm_rule)) {
> -			/* Add only new rules */
> -			for (i = 0; i < n_wmms; i++) {
> -				if (regdb_ptrs[i].token ==
> -				    regdb_ptrs[n_wmms].token) {
> -					rule->wmm_rule = regdb_ptrs[i].rule;
> -					break;
> -				}
> -			}
> -			if (i == n_wmms) {
> -				rule->wmm_rule = wmm_rule;
> -				regdb_ptrs[n_wmms++].rule = wmm_rule;
> -				wmm_rule++;
> -			}
> -		}
> +		reg_query_regdb_wmm(regd->alpha2, center_freq, rule);
>   	}
>   
>   	regd->n_reg_rules = valid_rules;
> -	regd->n_wmm_rules = n_wmms;
>   
>   	/*
>   	 * Narrow down regdom for unused regulatory rules to prevent hole
> @@ -1113,28 +1088,13 @@ struct ieee80211_regdomain *
>   	regd_to_copy = sizeof(struct ieee80211_regdomain) +
>   		valid_rules * sizeof(struct ieee80211_reg_rule);
>   
> -	wmms_to_copy = sizeof(struct ieee80211_wmm_rule) * n_wmms;
> -
> -	copy_rd = kzalloc(regd_to_copy + wmms_to_copy, GFP_KERNEL);
> +	copy_rd = kzalloc(regd_to_copy, GFP_KERNEL);
>   	if (!copy_rd) {
>   		copy_rd = ERR_PTR(-ENOMEM);
>   		goto out;
>   	}
>   
>   	memcpy(copy_rd, regd, regd_to_copy);
> -	memcpy((u8 *)copy_rd + regd_to_copy, (u8 *)regd + size_of_regd,
> -	       wmms_to_copy);
> -
> -	d_wmm = (struct ieee80211_wmm_rule *)((u8 *)copy_rd + regd_to_copy);
> -	s_wmm = (struct ieee80211_wmm_rule *)((u8 *)regd + size_of_regd);
> -
> -	for (i = 0; i < regd->n_reg_rules; i++) {
> -		if (!regd->reg_rules[i].wmm_rule)
> -			continue;
> -
> -		copy_rd->reg_rules[i].wmm_rule = d_wmm +
> -			(regd->reg_rules[i].wmm_rule - s_wmm);
> -	}
>   
>   out:
>   	kfree(regdb_ptrs);
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9a850973e09a..8ebabc9873d1 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -4865,8 +4865,8 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
>    *
>    * Return: 0 on success. -ENODATA.
>    */
> -int reg_query_regdb_wmm(char *alpha2, int freq, u32 *ptr,
> -			struct ieee80211_wmm_rule *rule);
> +int reg_query_regdb_wmm(char *alpha2, int freq,
> +			struct ieee80211_reg_rule *rule);
>   
>   /*
>    * callbacks for asynchronous cfg80211 methods, notification
> diff --git a/include/net/regulatory.h b/include/net/regulatory.h
> index 60f8cc86a447..4c4ec3951c48 100644
> --- a/include/net/regulatory.h
> +++ b/include/net/regulatory.h
> @@ -217,7 +217,7 @@ struct ieee80211_wmm_rule {
>   struct ieee80211_reg_rule {
>   	struct ieee80211_freq_range freq_range;
>   	struct ieee80211_power_rule power_rule;
> -	struct ieee80211_wmm_rule *wmm_rule;
> +	struct ieee80211_wmm_rule wmm_rule;
>   	u32 flags;
>   	u32 dfs_cac_ms;
>   };
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 7acc16f34942..ef1f00266566 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -3598,6 +3598,7 @@ enum nl80211_reg_rule_flags {
>   	NL80211_RRF_NO_HT40PLUS		= 1<<14,
>   	NL80211_RRF_NO_80MHZ		= 1<<15,
>   	NL80211_RRF_NO_160MHZ		= 1<<16,
> +	NL80211_RRF_HAS_WMM		= 1<<17,
>   };
>   
>   #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 88efda7c9f8a..fccc1af0d027 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1135,7 +1135,7 @@ void ieee80211_regulatory_limit_wmm_params(struct ieee80211_sub_if_data *sdata,
>   {
>   	struct ieee80211_chanctx_conf *chanctx_conf;
>   	const struct ieee80211_reg_rule *rrule;
> -	struct ieee80211_wmm_ac *wmm_ac;
> +	const struct ieee80211_wmm_ac *wmm_ac;
>   	u16 center_freq = 0;
>   
>   	if (sdata->vif.type != NL80211_IFTYPE_AP &&
> @@ -1154,15 +1154,15 @@ void ieee80211_regulatory_limit_wmm_params(struct ieee80211_sub_if_data *sdata,
>   
>   	rrule = freq_reg_info(sdata->wdev.wiphy, MHZ_TO_KHZ(center_freq));
>   
> -	if (IS_ERR_OR_NULL(rrule) || !rrule->wmm_rule) {
> +	if (IS_ERR_OR_NULL(rrule) || !(rrule->flags & NL80211_RRF_HAS_WMM)) {
>   		rcu_read_unlock();
>   		return;
>   	}
>   
>   	if (sdata->vif.type == NL80211_IFTYPE_AP)
> -		wmm_ac = &rrule->wmm_rule->ap[ac];
> +		wmm_ac = &rrule->wmm_rule.ap[ac];
>   	else
> -		wmm_ac = &rrule->wmm_rule->client[ac];
> +		wmm_ac = &rrule->wmm_rule.client[ac];
>   	qparam->cw_min = max_t(u16, qparam->cw_min, wmm_ac->cw_min);
>   	qparam->cw_max = max_t(u16, qparam->cw_max, wmm_ac->cw_max);
>   	qparam->aifs = max_t(u8, qparam->aifs, wmm_ac->aifsn);
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 5fb9b7dd9831..461621b02573 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -669,13 +669,13 @@ static int nl80211_msg_put_wmm_rules(struct sk_buff *msg,
>   			goto nla_put_failure;
>   
>   		if (nla_put_u16(msg, NL80211_WMMR_CW_MIN,
> -				rule->wmm_rule->client[j].cw_min) ||
> +				rule->wmm_rule.client[j].cw_min) ||
>   		    nla_put_u16(msg, NL80211_WMMR_CW_MAX,
> -				rule->wmm_rule->client[j].cw_max) ||
> +				rule->wmm_rule.client[j].cw_max) ||
>   		    nla_put_u8(msg, NL80211_WMMR_AIFSN,
> -			       rule->wmm_rule->client[j].aifsn) ||
> +			       rule->wmm_rule.client[j].aifsn) ||
>   		    nla_put_u8(msg, NL80211_WMMR_TXOP,
> -			       rule->wmm_rule->client[j].cot))
> +			       rule->wmm_rule.client[j].cot))
>   			goto nla_put_failure;
>   
>   		nla_nest_end(msg, nl_wmm_rule);
> @@ -768,7 +768,7 @@ static int nl80211_msg_put_channel(struct sk_buff *msg, struct wiphy *wiphy,
>   		const struct ieee80211_reg_rule *rule =
>   			freq_reg_info(wiphy, chan->center_freq);
>   
> -		if (!IS_ERR(rule) && rule->wmm_rule) {
> +		if (!IS_ERR(rule) && (rule->flags & NL80211_RRF_HAS_WMM)) {
>   			if (nl80211_msg_put_wmm_rules(msg, rule))
>   				goto nla_put_failure;
>   		}
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 4fc66a117b7d..eb78c34d2357 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -425,35 +425,22 @@ static bool is_user_regdom_saved(void)
>   reg_copy_regd(const struct ieee80211_regdomain *src_regd)
>   {
>   	struct ieee80211_regdomain *regd;
> -	int size_of_regd, size_of_wmms;
> +	int size_of_regd;
>   	unsigned int i;
> -	struct ieee80211_wmm_rule *d_wmm, *s_wmm;
>   
>   	size_of_regd =
>   		sizeof(struct ieee80211_regdomain) +
>   		src_regd->n_reg_rules * sizeof(struct ieee80211_reg_rule);
> -	size_of_wmms = src_regd->n_wmm_rules *
> -		sizeof(struct ieee80211_wmm_rule);
>   
> -	regd = kzalloc(size_of_regd + size_of_wmms, GFP_KERNEL);
> +	regd = kzalloc(size_of_regd, GFP_KERNEL);
>   	if (!regd)
>   		return ERR_PTR(-ENOMEM);
>   
>   	memcpy(regd, src_regd, sizeof(struct ieee80211_regdomain));
>   
> -	d_wmm = (struct ieee80211_wmm_rule *)((u8 *)regd + size_of_regd);
> -	s_wmm = (struct ieee80211_wmm_rule *)((u8 *)src_regd + size_of_regd);
> -	memcpy(d_wmm, s_wmm, size_of_wmms);
> -
>   	for (i = 0; i < src_regd->n_reg_rules; i++) {
>   		memcpy(&regd->reg_rules[i], &src_regd->reg_rules[i],
>   		       sizeof(struct ieee80211_reg_rule));
> -		if (!src_regd->reg_rules[i].wmm_rule)
> -			continue;
> -
> -		regd->reg_rules[i].wmm_rule = d_wmm +
> -			(src_regd->reg_rules[i].wmm_rule - s_wmm) /
> -			sizeof(struct ieee80211_wmm_rule);
>   	}
>   	return regd;
>   }
> @@ -860,9 +847,10 @@ static bool valid_regdb(const u8 *data, unsigned int size)
>   	return true;
>   }
>   
> -static void set_wmm_rule(struct ieee80211_wmm_rule *rule,
> +static void set_wmm_rule(struct ieee80211_reg_rule *rrule,
>   			 struct fwdb_wmm_rule *wmm)
>   {
> +	struct ieee80211_wmm_rule *rule = &rrule->wmm_rule;
>   	unsigned int i;
>   
>   	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
> @@ -876,11 +864,13 @@ static void set_wmm_rule(struct ieee80211_wmm_rule *rule,
>   		rule->ap[i].aifsn = wmm->ap[i].aifsn;
>   		rule->ap[i].cot = 1000 * be16_to_cpu(wmm->ap[i].cot);
>   	}
> +
> +	rrule->flags |= NL80211_RRF_HAS_WMM;
>   }
>   
>   static int __regdb_query_wmm(const struct fwdb_header *db,
>   			     const struct fwdb_country *country, int freq,
> -			     u32 *dbptr, struct ieee80211_wmm_rule *rule)
> +			     struct ieee80211_reg_rule *rule)
>   {
>   	unsigned int ptr = be16_to_cpu(country->coll_ptr) << 2;
>   	struct fwdb_collection *coll = (void *)((u8 *)db + ptr);
> @@ -901,8 +891,6 @@ static int __regdb_query_wmm(const struct fwdb_header *db,
>   			wmm_ptr = be16_to_cpu(rrule->wmm_ptr) << 2;
>   			wmm = (void *)((u8 *)db + wmm_ptr);
>   			set_wmm_rule(rule, wmm);
> -			if (dbptr)
> -				*dbptr = wmm_ptr;
>   			return 0;
>   		}
>   	}
> @@ -910,8 +898,7 @@ static int __regdb_query_wmm(const struct fwdb_header *db,
>   	return -ENODATA;
>   }
>   
> -int reg_query_regdb_wmm(char *alpha2, int freq, u32 *dbptr,
> -			struct ieee80211_wmm_rule *rule)
> +int reg_query_regdb_wmm(char *alpha2, int freq, struct ieee80211_reg_rule *rule)
>   {
>   	const struct fwdb_header *hdr = regdb;
>   	const struct fwdb_country *country;
> @@ -925,8 +912,7 @@ int reg_query_regdb_wmm(char *alpha2, int freq, u32 *dbptr,
>   	country = &hdr->country[0];
>   	while (country->coll_ptr) {
>   		if (alpha2_equal(alpha2, country->alpha2))
> -			return __regdb_query_wmm(regdb, country, freq, dbptr,
> -						 rule);
> +			return __regdb_query_wmm(regdb, country, freq, rule);
>   
>   		country++;
>   	}
> @@ -935,32 +921,13 @@ int reg_query_regdb_wmm(char *alpha2, int freq, u32 *dbptr,
>   }
>   EXPORT_SYMBOL(reg_query_regdb_wmm);
>   
> -struct wmm_ptrs {
> -	struct ieee80211_wmm_rule *rule;
> -	u32 ptr;
> -};
> -
> -static struct ieee80211_wmm_rule *find_wmm_ptr(struct wmm_ptrs *wmm_ptrs,
> -					       u32 wmm_ptr, int n_wmms)
> -{
> -	int i;
> -
> -	for (i = 0; i < n_wmms; i++) {
> -		if (wmm_ptrs[i].ptr == wmm_ptr)
> -			return wmm_ptrs[i].rule;
> -	}
> -	return NULL;
> -}
> -
>   static int regdb_query_country(const struct fwdb_header *db,
>   			       const struct fwdb_country *country)
>   {
>   	unsigned int ptr = be16_to_cpu(country->coll_ptr) << 2;
>   	struct fwdb_collection *coll = (void *)((u8 *)db + ptr);
>   	struct ieee80211_regdomain *regdom;
> -	struct ieee80211_regdomain *tmp_rd;
> -	unsigned int size_of_regd, i, n_wmms = 0;
> -	struct wmm_ptrs *wmm_ptrs;
> +	unsigned int size_of_regd, i;
>   
>   	size_of_regd = sizeof(struct ieee80211_regdomain) +
>   		coll->n_rules * sizeof(struct ieee80211_reg_rule);
> @@ -969,12 +936,6 @@ static int regdb_query_country(const struct fwdb_header *db,
>   	if (!regdom)
>   		return -ENOMEM;
>   
> -	wmm_ptrs = kcalloc(coll->n_rules, sizeof(*wmm_ptrs), GFP_KERNEL);
> -	if (!wmm_ptrs) {
> -		kfree(regdom);
> -		return -ENOMEM;
> -	}
> -
>   	regdom->n_reg_rules = coll->n_rules;
>   	regdom->alpha2[0] = country->alpha2[0];
>   	regdom->alpha2[1] = country->alpha2[1];
> @@ -1013,37 +974,11 @@ static int regdb_query_country(const struct fwdb_header *db,
>   				1000 * be16_to_cpu(rule->cac_timeout);
>   		if (rule->len >= offsetofend(struct fwdb_rule, wmm_ptr)) {
>   			u32 wmm_ptr = be16_to_cpu(rule->wmm_ptr) << 2;
> -			struct ieee80211_wmm_rule *wmm_pos =
> -				find_wmm_ptr(wmm_ptrs, wmm_ptr, n_wmms);
> -			struct fwdb_wmm_rule *wmm;
> -			struct ieee80211_wmm_rule *wmm_rule;
> -
> -			if (wmm_pos) {
> -				rrule->wmm_rule = wmm_pos;
> -				continue;
> -			}
> -			wmm = (void *)((u8 *)db + wmm_ptr);
> -			tmp_rd = krealloc(regdom, size_of_regd + (n_wmms + 1) *
> -					  sizeof(struct ieee80211_wmm_rule),
> -					  GFP_KERNEL);
> -
> -			if (!tmp_rd) {
> -				kfree(regdom);
> -				kfree(wmm_ptrs);
> -				return -ENOMEM;
> -			}
> -			regdom = tmp_rd;
> -
> -			wmm_rule = (struct ieee80211_wmm_rule *)
> -				((u8 *)regdom + size_of_regd + n_wmms *
> -				sizeof(struct ieee80211_wmm_rule));
> +			struct fwdb_wmm_rule *wmm = (void *)((u8 *)db + wmm_ptr);
>   
> -			set_wmm_rule(wmm_rule, wmm);
> -			wmm_ptrs[n_wmms].ptr = wmm_ptr;
> -			wmm_ptrs[n_wmms++].rule = wmm_rule;
> +			set_wmm_rule(rrule, wmm);
>   		}
>   	}
> -	kfree(wmm_ptrs);
>   
>   	return reg_schedule_apply(regdom);
>   }
> --
>

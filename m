Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33116 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbcIIPte (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 11:49:34 -0400
Received: by mail-qk0-f194.google.com with SMTP id n66so6052105qkf.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Sep 2016 08:49:33 -0700 (PDT)
Date: Fri, 9 Sep 2016 11:47:24 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 3/3] mwifiex: add custom regulatory domain support
Message-ID: <20160909154724.GA21325@localhost> (sfid-20160909_174939_849271_BF745C29)
References: <1470754246-635-1-git-send-email-akarwar@marvell.com>
 <1470754246-635-3-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470754246-635-3-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2016 at 08:20:46PM +0530, Amitkumar Karwar wrote:
> This patch creates custom regulatory rules based on the information
> received from firmware and enable them during wiphy registration.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Hi,

This patch recently landed in wireless-testing but I noticed (or well,
smatch noticed) some issues with the error paths:

> +	if (adapter->regd) {

does null-check here and elsewhere...

> +static struct ieee80211_regdomain *
> +mwifiex_create_custom_regdomain(struct mwifiex_private *priv,
> +				u8 *buf, u16 buf_len)
> +{
> +	u16 num_chan = buf_len / 2;
> +	struct ieee80211_regdomain *regd;
> +	struct ieee80211_reg_rule *rule;
> +	bool new_rule;
> +	int regd_size, idx, freq, prev_freq = 0;
> +	u32 bw, prev_bw = 0;
> +	u8 chflags, prev_chflags = 0, valid_rules = 0;
> +
> +	if (WARN_ON_ONCE(num_chan > NL80211_MAX_SUPP_REG_RULES))
> +		return ERR_PTR(-EINVAL);
> +

...returns ERR_PTR here

> +	regd_size = sizeof(struct ieee80211_regdomain) +
> +		    num_chan * sizeof(struct ieee80211_reg_rule);
> +
> +	regd = kzalloc(regd_size, GFP_KERNEL);
> +	if (!regd)
> +		return ERR_PTR(-ENOMEM);

and here.

> +
> +	for (idx = 0; idx < num_chan; idx++) {
> +		u8 chan;
> +		enum nl80211_band band;
> +
> +		chan = *buf++;
> +		if (!chan)
> +			return NULL;

^ here, returns null, leaking regd

> +		chflags = *buf++;
> +		band = (chan <= 14) ? NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
> +		freq = ieee80211_channel_to_frequency(chan, band);
> +		new_rule = false;
> +
> +		if (chflags & MWIFIEX_CHANNEL_DISABLED)
> +			continue;
> +
> +		if (band == NL80211_BAND_5GHZ) {
> +			if (!(chflags & MWIFIEX_CHANNEL_NOHT80))
> +				bw = MHZ_TO_KHZ(80);
> +			else if (!(chflags & MWIFIEX_CHANNEL_NOHT40))
> +				bw = MHZ_TO_KHZ(40);
> +			else
> +				bw = MHZ_TO_KHZ(20);
> +		} else {
> +			if (!(chflags & MWIFIEX_CHANNEL_NOHT40))
> +				bw = MHZ_TO_KHZ(40);
> +			else
> +				bw = MHZ_TO_KHZ(20);
> +		}
> +
> +		if (idx == 0 || prev_chflags != chflags || prev_bw != bw ||
> +		    freq - prev_freq > 20) {
> +			valid_rules++;
> +			new_rule = true;
> +		}
> +
> +		rule = &regd->reg_rules[valid_rules - 1];
> +
> +		rule->freq_range.end_freq_khz = MHZ_TO_KHZ(freq + 10);
> +
> +		prev_chflags = chflags;
> +		prev_freq = freq;
> +		prev_bw = bw;
> +
> +		if (!new_rule)
> +			continue;
> +
> +		rule->freq_range.start_freq_khz = MHZ_TO_KHZ(freq - 10);
> +		rule->power_rule.max_eirp = DBM_TO_MBM(19);
> +
> +		if (chflags & MWIFIEX_CHANNEL_PASSIVE)
> +			rule->flags = NL80211_RRF_NO_IR;
> +
> +		if (chflags & MWIFIEX_CHANNEL_DFS)
> +			rule->flags = NL80211_RRF_DFS;
> +
> +		rule->freq_range.max_bandwidth_khz = bw;
> +	}
> +
> +	regd->n_reg_rules = valid_rules;
> +	regd->alpha2[0] = '9';
> +	regd->alpha2[1] = '9';
> +
> +	return regd;
> +}

[...]

>  static int mwifiex_ret_chan_region_cfg(struct mwifiex_private *priv,
>  				       struct host_cmd_ds_command *resp)
>  {
> @@ -1050,6 +1137,10 @@ static int mwifiex_ret_chan_region_cfg(struct mwifiex_private *priv,
>  			mwifiex_dbg_dump(priv->adapter, CMD_D, "CHAN:",
>  					 (u8 *)head + sizeof(*head),
>  					 tlv_buf_len);
> +			priv->adapter->regd =
> +				mwifiex_create_custom_regdomain(priv,
> +								(u8 *)head +
> +						sizeof(*head), tlv_buf_len);

Here regd is assigned without checking IS_ERR.

-- 
Bob Copeland %% http://bobcopeland.com/

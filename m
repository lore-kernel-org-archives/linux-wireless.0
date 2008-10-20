Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYJTGmj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 02:42:39 -0400
Subject: Re: [PATCH v3] mac80211/drivers: rewrite the rate control API
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <1224052607.3027.20.camel@johannes.berg>
References: <1223996147.10113.33.camel@johannes.berg>
	 (sfid-20081014_165703_092655_BE6BA58D)  <1224052607.3027.20.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 14:42:20 +0800
Message-Id: <1224484940.24677.169.camel@debian.sh.intel.com> (sfid-20081020_084243_113222_8178060A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 23:36 -0700, Johannes Berg wrote:
> So after the previous changes we were still unhappy with how
> convoluted the API is and decided to make things simpler for
> everybody. This completely changes the rate control API, now
> taking into account 802.11n with MCS rates and more control,
> most drivers don't support that though.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

[...]

> @@ -318,9 +348,33 @@ static void iwl3945_rx_reply_tx(struct i
>         }
> 
>         info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
> -       memset(&info->status, 0, sizeof(info->status));
> +       ieee80211_tx_info_clear_status(info);
> +
> +       /* Fill the MRR chain with some info about on-chip retransmissions */
> +       rate_idx = iwl3945_hwrate_to_plcp_idx(tx_resp->rate);
> +       if (info->band == IEEE80211_BAND_5GHZ)
> +               rate_idx -= IWL_FIRST_OFDM_RATE;
> +
> +       info->status.rates[0].count = tx_resp->failure_frame + 1;

This is useless. And it is even confusable with the later count++.

> +       fail = tx_resp->failure_frame;
> +       for(i = 0; i < 4; i++) {

Where does the '4' come from? Why not IEEE80211_TX_MAX_RATES?

> +               int next = iwl3945_rs_next_rate(priv, rate_idx);
> +
> +               info->status.rates[i].idx = rate_idx;
> +
> +               if ((rate_idx == next) || (i == 3)) {

ditto

[...]

Other iwlwifi changes looks fine to me.

Thanks,
-yi


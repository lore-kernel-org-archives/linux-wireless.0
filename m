Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3AZXD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 18:03:59 -0500
Message-ID: <1359241463.9086.4.camel@jlt4.sipsolutions.net> (sfid-20130127_000405_983252_F2702587)
Subject: Re: [PATCH v2] mac80211: dynamic short slot time for MBSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Sun, 27 Jan 2013 00:04:23 +0100
In-Reply-To: <1359232645-10563-1-git-send-email-thomas@cozybit.com> (sfid-20130126_213837_005675_90531EEB)
References: <1359232645-10563-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130126_213837_005675_90531EEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	sband = local->hw.wiphy->bands[band];
> +	bitrates = sband->bitrates;

It might be interesting to loop once here and build a bitmap (in an
unsigned long) of rates marked ERP_G. Something like

erp_rates = 0;
for (i = 0; i < sband->n_bitrates; i++)
	if (bitrates[i].flags & ...)
		erp_rates |= BIT(i);


> +	rcu_read_lock();
> +	list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +		if (sdata != sta->sdata ||
> +		    sta->plink_state != NL80211_PLINK_ESTAB)
> +			continue;
> +
> +		short_slot = false;
> +		rates = sta->sta.supp_rates[band];
> +		for_each_set_bit(i, (unsigned long *)&rates,
> +				 sizeof(rates) * BITS_PER_BYTE) {
> +			if (bitrates[i].flags & IEEE80211_RATE_ERP_G) {
> +				short_slot = true;
> +				break;
> +			}
> +		}
> +
> +		if (!short_slot)
> +			break;

Then the inner bitrate loop here becomes just

		if (!(rates & erp_rates)) {
			short_slot = false;
			break;
		}

which assumes "short_slot = true" as a precondition to going into the
sta loop.

(although that does change the overall logic to enable short slot when
NO stations are present)

johannes


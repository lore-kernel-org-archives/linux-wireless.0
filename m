Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab2AINE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 08:04:56 -0500
Subject: Re: [PATCHv2 2/2] mac80211: add support for mcs masks
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1325793490-21501-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1325793490-21501-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 14:04:54 +0100
Message-ID: <1326114294.3451.25.camel@jlt3.sipsolutions.net> (sfid-20120109_140459_343615_F1603F3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-05 at 20:58 +0100, Simon Wunderlich wrote:

> +static bool rate_idx_match_mcs_mask(struct ieee80211_tx_rate *rate,
> +				    u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
> +{
> +	int i, j;
> +	int ridx, rbit;
> +
> +	ridx = rate->idx / 8;
> +	rbit = rate->idx % 8;
> +
> +	/* sanity check */
> +	if (ridx < 0 || ridx > IEEE80211_HT_MCS_MASK_LEN)
> +		return false;
> +
> +	/* See whether the selected rate or anything below it is allowed. */
> +	for (i = ridx; i >= 0; i--) {
> +		for (j = rbit; j >= 0; j--)
> +			if (mcs_mask[i] & BIT(j)) {
> +				rate->idx = i * 8 + j;
> +				return true;
> +			}
> +		rbit = 7;
> +	}
> +
> +	/* Try to find a higher rate that would be allowed */
> +	ridx = (rate->idx + 1) / 8;
> +	rbit = (rate->idx + 1) % 8;
> +
> +	for (i = ridx; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
> +		for (j = rbit; j < 8; j++)
> +			if (mcs_mask[i] & BIT(j)) {
> +				rate->idx = i * 8 + j;
> +				return true;
> +			}
> +		rbit = 0;
> +	}
> +	return false;

All this logic is pretty complex, maybe we could translate the bitmap to
an array of unsigned longs and use test_bit() instead of open-coding it
for 8-bit words?

johannes


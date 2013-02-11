Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46097 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab3BKN5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 08:57:31 -0500
Received: by mail-bk0-f46.google.com with SMTP id j5so2655357bkw.33
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 05:57:30 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v2 3/3] mac80211/minstrel_ht: add support for using CCK rates
Date: Mon, 11 Feb 2013 14:57:28 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1360589765-58642-1-git-send-email-nbd@openwrt.org> <1360589765-58642-2-git-send-email-nbd@openwrt.org> <1360589765-58642-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1360589765-58642-3-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201302111457.28452.chunkeey@googlemail.com> (sfid-20130211_145915_646613_D30A8B2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 11, 2013 02:36:05 PM Felix Fietkau wrote:
> When MCS rates start to get bad in 2.4 GHz because of long range or
> strong interference, CCK rates can be a lot more robust.
> 
> This patch adds a pseudo MCS group containing CCK rates (long preamble
> in the lower 4 slots, short preamble in the upper slots).
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  static void
> +minstrel_ht_update_cck(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
> +		       struct ieee80211_supported_band *sband,
> +		       struct ieee80211_sta *sta)
> +{
> +	int i;
> +
> +	if (sband->band != IEEE80211_BAND_2GHZ)
> +		return;
> +
> +	mi->cck_supported = 0;
> +	mi->cck_supported_short = 0;
> +	for (i = 0; i < 4; i++) {
> +		if (!rate_supported(sta, sband->band, mp->cck_rates[i]))
> +			continue;

Don't we need to check if the receiver (and the minstrel_ht sender)
supports IEEE80211_HT_CAP_DSSSCCK40 when the phy is in HT40+/- mode?

Regards,
	Christian

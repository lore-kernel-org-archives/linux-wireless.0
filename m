Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:43643 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030503Ab3DSOLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 10:11:05 -0400
Received: by mail-we0-f178.google.com with SMTP id z53so3779369wey.9
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 07:11:03 -0700 (PDT)
Date: Fri, 19 Apr 2013 16:06:53 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v3 1/3] mac80211: improve the rate control API
Message-ID: <20130419140653.GB8341@magnum.frso.rivierawaves.com> (sfid-20130419_161109_399635_CE27FA2E)
References: <1366376477-29376-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366376477-29376-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 19, 2013 at 03:01:15PM +0200, Felix Fietkau wrote:
> +	if (!(rates[0].flags & IEEE80211_TX_RC_MCS)) {
> +		s8 baserate = 0;
> +
> +		rate = &sband->bitrates[rates[0].idx];
> +
> +		for (i = 0; i < sband->n_bitrates; i++) {
> +			/* must be a basic rate */
> +			if (!(vif->bss_conf.basic_rates & BIT(i)))
> +				continue;
[...]
> -	if (!(info->control.rates[0].flags & IEEE80211_TX_RC_MCS)) {
> -		u32 basic_rates = tx->sdata->vif.bss_conf.basic_rates;
> -		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
> -
> -		rate = &sband->bitrates[info->control.rates[0].idx];
> -
> -		for (i = 0; i < sband->n_bitrates; i++) {
> -			/* must be a basic rate */
> -			if (!(basic_rates & BIT(i)))
> -				continue;

The moved code doesn't match, missing 5253ffb.
 
Karl

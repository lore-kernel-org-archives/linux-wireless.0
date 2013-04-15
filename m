Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3DONiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 09:38:50 -0400
Message-ID: <1366033124.8361.22.camel@jlt4.sipsolutions.net> (sfid-20130415_153854_122382_83E508EC)
Subject: Re: [PATCH 1/5] mac80211: fix and optimize MCS mask handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Apr 2013 15:38:44 +0200
In-Reply-To: <1365890626-86895-1-git-send-email-nbd@openwrt.org>
References: <1365890626-86895-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
> +		struct ieee80211_supported_band *sband = wiphy->bands[i];
> +		int j;
> +
>  		sdata->rc_rateidx_mask[i] = mask->control[i].legacy;
>  		memcpy(sdata->rc_rateidx_mcs_mask[i], mask->control[i].mcs,
>  		       sizeof(mask->control[i].mcs));
> +
> +		sdata->rc_has_mcs_mask[i] = false;
> +		if (!sband)
> +			continue;
> +
> +		for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++)

I think I'd kinda prefer extra braces, but hey, I'd change that myself,
but there's another question:

> +			if (~sdata->rc_rateidx_mcs_mask[i][j]) {

That ~ seems a bit odd to me, any reason you didn't just use ! ?

johannes


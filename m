Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60141 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbaFCTka (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 15:40:30 -0400
Message-ID: <1401824416.4157.32.camel@jlt4.sipsolutions.net> (sfid-20140603_214034_543097_142BADD1)
Subject: Re: [PATCH v2 1/2] mac80211: move csa counters from sdata to
 beacon/presp
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Jun 2014 21:40:16 +0200
In-Reply-To: <1401345535-22991-2-git-send-email-michal.kazior@tieto.com> (sfid-20140529_084616_544643_50FA8B92)
References: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
	 <1401345535-22991-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140529_084616_544643_50FA8B92)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-29 at 08:38 +0200, Michal Kazior wrote:


> +               memcpy(new->csa_counter_offsets,
> csa->counter_offsets_beacon,
> +                      csa->n_counter_offsets_beacon *
> +                      sizeof(*new->csa_counter_offsets));

Given that it's used like an array, maybe
sizeof(new->csa_counter_offsets[0]) would be more readable? (this is in
a few places)

> +++ b/net/mac80211/ibss.c
> @@ -143,7 +143,7 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
>  		*pos++ = csa_settings->block_tx ? 1 : 0;
>  		*pos++ = ieee80211_frequency_to_channel(
>  				csa_settings->chandef.chan->center_freq);
> -		sdata->csa_counter_offset_beacon[0] = (pos - presp->head);
> +		presp->csa_counter_offsets[0] = (pos - presp->head);

This seems slightly odd, but maybe it's a bugfix? Or are presp/beacon
actually identical?

johannes


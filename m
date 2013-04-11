Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3DKKCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 06:02:36 -0400
Message-ID: <1365674551.8272.39.camel@jlt4.sipsolutions.net> (sfid-20130411_120239_600910_7B62C701)
Subject: Re: [PATCH] mac80211: always pick a basic rate to tx RTS/CTS for
 pre-HT rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Thu, 11 Apr 2013 12:02:31 +0200
In-Reply-To: <1365156384-6699-1-git-send-email-karl.beldan@gmail.com> (sfid-20130405_121029_391208_2FD323E8)
References: <1365156384-6699-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130405_121029_391208_2FD323E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-05 at 12:06 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When the 1st rate control entry is a pre-HT rate we want to set
> rts_cts_rate_idx "as the fastest basic rate that is not faster than the
> data rate"(code comments).
> But in case some bss allowed rate indexes are lower than the lowest bss
> basic rate, if the rate control selects a rate among the formers for its
> 1st rate control entry, rts_cts_rate_idx remains 0 and is not a basic
> rate index.
> This commit sets rts_cts_rate_idx to the lowest bss basic rate index in
> this situation.

Ok after reviewing this again I applied it.


>  	if (!(info->control.rates[0].flags & IEEE80211_TX_RC_MCS)) {
> -		s8 baserate = 0;
> +		u32 basic_rates = tx->sdata->vif.bss_conf.basic_rates;
> +		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;

Note that this also assumes that rate 0 is a mandatory rate, which
presumably will always be true.

johannes


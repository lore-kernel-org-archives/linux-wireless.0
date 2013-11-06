Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3KFKPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:15:24 -0500
Message-ID: <1383732921.14307.20.camel@jlt4.sipsolutions.net> (sfid-20131106_111527_847231_C46792F1)
Subject: Re: [PATCH 01/19] cfg80211: enforce disabling channels by custom or
 strict settings
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 11:15:21 +0100
In-Reply-To: <1383671897-7746-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181714_779531_5FE770AA)
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
	 <1383671897-7746-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131105_181714_779531_5FE770AA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-05 at 09:17 -0800, Luis R. Rodriguez wrote:

> @@ -1251,7 +1261,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
>  	if (IS_ERR(reg_rule)) {
>  		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
>  			      chan->center_freq);
> -		chan->flags = IEEE80211_CHAN_DISABLED;
> +		chan->flags = chan->orig_flags |= IEEE80211_CHAN_DISABLED;

Are you sure the |= is right?

johannes


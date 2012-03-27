Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2C0PEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 11:04:35 -0400
Message-ID: <1332860673.3501.4.camel@jlt3.sipsolutions.net> (sfid-20120327_170438_742208_724DC73A)
Subject: Re: [PATCH 1/3] mac80211: prepare ieee80211_mandatory_rates to
 per-vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2012 17:04:33 +0200
In-Reply-To: <1332856558-5708-2-git-send-email-michal.kazior@tieto.com>
References: <1332856558-5708-1-git-send-email-michal.kazior@tieto.com>
	 <1332856558-5708-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now I'm confused, and I probably confused you as well ...

> -u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
> +u32 ieee80211_mandatory_rates(struct ieee80211_sub_if_data *sdata,
>  			      enum ieee80211_band band)
>  {
> +	struct ieee80211_local *local = sdata->local;
>  	struct ieee80211_supported_band *sband;
>  	struct ieee80211_rate *bitrates;
>  	u32 mandatory_rates;

Shouldn't we just remove the sdata/local argument? We don't need it
after all, except for the fallback case that never happens (so we can do
something like "return 1" after the warning)?

johannes


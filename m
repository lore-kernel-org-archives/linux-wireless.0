Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2C0PHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 11:07:03 -0400
Message-ID: <1332860821.3501.6.camel@jlt3.sipsolutions.net> (sfid-20120327_170708_823983_516A7C1E)
Subject: Re: [PATCH 2/3] mac80211: prepare ieee80211_sta_get_rates to per-vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2012 17:07:01 +0200
In-Reply-To: <1332856558-5708-3-git-send-email-michal.kazior@tieto.com>
References: <1332856558-5708-1-git-send-email-michal.kazior@tieto.com>
	 <1332856558-5708-3-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-27 at 15:55 +0200, Michal Kazior wrote:

> -u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
> +u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
>  			    struct ieee802_11_elems *elems,
>  			    enum ieee80211_band band)
>  {
> +	struct ieee80211_local *local = sdata->local;
>  	struct ieee80211_supported_band *sband;
>  	struct ieee80211_rate *bitrates;
>  	size_t num_rates;

Ditto here, though I actually got confused even further ... we shouldn't
remove the local/sdata arguments, we should only remove the use of
local->hw.conf.channel! IOW simply something like this:

-       if (!sband) {
-               WARN_ON(1);
-               sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-       }
+       if (WARN_ON(!sband))
+               return 1;

should be sufficient instead of doing all the prototype changes?

johannes


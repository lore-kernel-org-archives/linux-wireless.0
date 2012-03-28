Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab2C1LRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 07:17:55 -0400
Message-ID: <1332933473.3479.31.camel@jlt3.sipsolutions.net> (sfid-20120328_131801_909499_BB9BAE56)
Subject: Re: [PATCH] mac80211: remove hw.conf.channel usage where possible
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Mar 2012 13:17:53 +0200
In-Reply-To: <1332932064-13758-1-git-send-email-michal.kazior@tieto.com>
References: <1332932064-13758-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-28 at 12:54 +0200, Michal Kazior wrote:
> Removes hw.conf.channel usage from the following functions:
>  * ieee80211_mandatory_rates
>  * ieee80211_sta_get_rates
>  * ieee80211_frame_duration
> 
> This is in preparation for multi-channel operation.

Nice, thanks.

> @@ -120,7 +120,7 @@ int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
>  	 * DIV_ROUND_UP() operations.
>  	 */
>  
> -	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ || erp) {
> +	if (!WARN_ON(!sband) && sband->band == IEEE80211_BAND_5GHZ || erp) {

This seems a bit odd to me, maybe change to

if (WARN_ON(!sband))
	return 0;
if (sband->band == ... || erp)
	...

or something like that? Or is there any code that has to pass NULL for
some reason?

Also, now that I think about it, is there a reason to pass
	struct ieee80211_supported_band *sband
rather than
	enum ieee80211_band band?

That wouldn't allow invalid/NULL value of course.


>  __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
>  					struct ieee80211_vif *vif,
> +					struct ieee80211_supported_band *sband,

same here.

Other than that, which may be needed, this looks good to me.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab1D0Kpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 06:45:52 -0400
Subject: Re: [PATCH] mac80211: Add new API for rate selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <19895.62392.401485.495514@gargle.gargle.HOWL> (sfid-20110427_124302_999971_7FE5CCB6)
References: <19895.62392.401485.495514@gargle.gargle.HOWL>
	 (sfid-20110427_124302_999971_7FE5CCB6)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 12:45:49 +0200
Message-ID: <1303901149.3542.1.camel@jlt3.sipsolutions.net> (sfid-20110427_124611_735163_F2FEEA47)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-27 at 16:15 +0530, Sujith wrote:

> -	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
> -		return -EOPNOTSUPP;


> +static inline int drv_set_bitrate_mask(struct ieee80211_local *local,
> +				       struct ieee80211_sub_if_data *sdata,
> +				       const struct cfg80211_bitrate_mask *mask)
> +{
> +	int ret = -ENOTSUPP;

I didn't even know -ENOTSUPP existed, but shouldn't it stay -EOPNOTSUPP?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab0CQQRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 12:17:43 -0400
Subject: Re: [RFC PATCHv3 1/2] cfg80211: Add connection quality monitoring
 support to nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1268830877-5162-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830877-5162-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 09:17:43 -0700
Message-ID: <1268842663.5989.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 15:01 +0200, Juuso Oikarinen wrote:

> +/**
> + * enum nl80211_cqm_state - current state in relation to set threshold
> + * @NL80211_CQM_STATE_ABOVE: the level is above the configured threshold
> + * @NL80211_CQM_STATE_BELOW: the level is below the configured threshold
> + */
> +enum nl80211_cqm_state {
> +	NL80211_CQM_STATE_ABOVE,
> +	NL80211_CQM_STATE_BELOW,
> +};

Thoughts about removing this and just exporting the actual (smoothed?)
RSSI instead in the event? Or do you simply not get that from the hw?

johannes


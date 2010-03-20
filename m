Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab0CTQsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 12:48:30 -0400
Subject: Re: [RFC PATCHv5 1/2] cfg80211: Add connection quality monitoring
 support to nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@nokia.com
In-Reply-To: <1268985801-25225-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1268985801-25225-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268985801-25225-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 09:48:06 -0700
Message-ID: <1269103686.4652.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-19 at 10:03 +0200, Juuso Oikarinen wrote:

> + * @NL80211_CMD_SET_CQM: Connection quality monitor configuration and
> + *      notification. This command is used both as a command (to configure
> + *      a trigger level) and as an event (to indicate the configured level was
> + *      reached.) Setting zero threshold disables the feature.

I've been thinking about this for a while, and I think I finally decided
that I'd prefer another command number for the event. SET doesn't seem
to match the event very well at all.

> +/**
> + * enum nl80211_cqm_rssi_threshold_event - RSSI threshold event
> + * @NL80211_CQM_RSSI_THRESHOLD_EVENT_NONE - No RSSI threshold event occurred

What is none intended for? If it's for any of the other possible future
enhancements, I'd think in that case we just leave out the attribute?

> +static struct nla_policy
> +nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] __read_mostly = {
> +	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
> +	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U8 },

Now I'm confused. Not that I think we'll ever need a hysteresis value
larger than that, but isn't that a little inconsistent?

johannes


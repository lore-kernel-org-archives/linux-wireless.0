Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0C2G1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 02:27:31 -0400
Subject: Re: [PATCH 0/2] mac80211: cfg80211: Roam trigger support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	luciano.coelho@nokia.com
In-Reply-To: <20100328194332.GA384@jm.kir.nu>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1269499567.5041.0.camel@jlt3.sipsolutions.net>
	 <20100328194332.GA384@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 08:27:15 +0200
Message-ID: <1269844035.4131.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-03-28 at 12:43 -0700, Jouni Malinen wrote:

> +	/*
> +	 * Weighted average of the signal strength from Beacon frames in the
> +	 * current BSS. This is in units of 1/16 of the signal unit to maintain
> +	 * accuracy and to speed up calculations, i.e., the value need to be
> +	 * devided by 16 to get the actual value.
> +	 */

divided ;)
Ok I wouldn't have noticed if evolution didn't have spell checking...

> +		if (sig < thold &&
> +		    (last_event == 0 || sig < last_event - hyst)) {
> +			ifmgd->last_cqm_event_signal = sig;
> +			ieee80211_cqm_rssi_notify(
> +				&sdata->vif,
> +				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
> +				GFP_ATOMIC);
> +		} else if (sig > thold &&
> +			   (last_event == 0 || sig > last_event + hyst)) {
> +			ifmgd->last_cqm_event_signal = sig;
> +			ieee80211_cqm_rssi_notify(
> +				&sdata->vif,
> +				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
> +				GFP_ATOMIC);

No need for GFP_ATOMIC, GFP_KERNEL should be fine, I think.

johannes


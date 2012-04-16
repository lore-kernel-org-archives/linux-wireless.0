Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2DPRc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 13:32:58 -0400
Message-ID: <4F8C57CC.4090505@sipsolutions.net> (sfid-20120416_193307_368356_CB9C7997)
Date: Mon, 16 Apr 2012 10:33:00 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] mac80211: Support on-channel scan option.
References: <1334248689-23018-1-git-send-email-greearb@candelatech.com> (sfid-20120412_183929_638765_C70D881D)
In-Reply-To: <1334248689-23018-1-git-send-email-greearb@candelatech.com> (sfid-20120412_183929_638765_C70D881D)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Did you test it?

> +		/* If we are scanning only on the current channel, then
> +		 * we do not need to stop normal activities
> +		 */
> +		unsigned long next_delay;
> +
> +		__set_bit(SCAN_ONCHANNEL_SCANNING,&local->scanning);
> +		ieee80211_recalc_idle(local);
> +		/* Notify driver scan is starting, keep order of operations
> +		 * same as normal software scan, in case that matters. */
> +		drv_sw_scan_start(local);
> +		ieee80211_configure_filter(local); /* accept probe-responses */
> +		/* We need to ensure power level is at max for scanning. */
> +		ieee80211_hw_config(local, 0);

a few blank lines would be nice :)

> +		if ((req->channels[0]->flags&
> +		     IEEE80211_CHAN_PASSIVE_SCAN) ||
> +		    !local->scan_req->n_ssids) {

That formatting is a bit off it seems. Or is that just my mailer?

johannes

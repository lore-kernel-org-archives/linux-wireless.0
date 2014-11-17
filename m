Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:37351 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751899AbaKQL2w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 06:28:52 -0500
Message-ID: <1416223724.14067.3.camel@coelho.fi> (sfid-20141117_122855_271548_15F57E67)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Mon, 17 Nov 2014 13:28:44 +0200
In-Reply-To: <1416221286-23126-1-git-send-email-johannes@sipsolutions.net>
References: <1416221286-23126-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [RFC] mac80211: allow drivers to provide any statistics
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-17 at 11:48 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In many cases, drivers can filter things like beacons that will
> skew statistics reported by mac80211. To get correct statistics
> in these cases, call drivers to obtain statistics and let them
> override all values, filling values from mac80211 if the driver
> didn't provide them.
> 
> Note that this doesn't currently allow a driver to say "I know
> this value is wrong, don't report it at all", or to sum it up
> with a mac80211 value (as could be useful for "dropped misc"),
> that can be added if it turns out to be needed.
> 
> This also gets rid of the get_rssi() method as is can now be
> implemented using sta_statistics().
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c | 22 ++++----

The wlcore part of this looks fine to me.

Acked-by: Luciano Coelho <luca@coelho.fi>

--
Luca.


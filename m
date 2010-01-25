Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:33483 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0AYNZw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 08:25:52 -0500
Message-ID: <4B5D9BDC.8030307@openwrt.org>
Date: Mon, 25 Jan 2010 14:25:48 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: wait for beacon before associating
References: <1264423044.23766.39.camel@johannes.local>
In-Reply-To: <1264423044.23766.39.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-25 1:37 PM, Johannes Berg wrote:
> This patch makes mac80211 wait for a beacon
> before associating to have proper information
> from it, in particular the DTIM period. It
> also makes it not probe the AP if it already
> has a probe response, so that only one of
> probing and waiting for beacon can be done,
> one of them must have been received to know
> about the BSS.
> 
> Note that I don't think this helps the
> synchronisation issue Kalle pointed out since
> we do not tell the driver about the bssid, in
> fact in this patch I explicitly open up the
> filters to receive the beacon.
> 
> The default timeout is 112.5% of the beacon
> interval, so a single lost beacon could cause
> the association to fail, I'm not sure if that
> is desirable or if the default timeout should
> be longer.
I think if this is required only for powersave, it would be nice if it
would only wait for the beacon if either powersave is actually enabled,
or user space requests it.
I'd like to avoid making the assoc process more unreliable for noisy
environments in cases where it isn't necessary to do so.

- Felix

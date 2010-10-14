Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab0JNNuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 09:50:22 -0400
Subject: Re: [PATCH 3/6] Add a function for evaluating rate changes for
 possible notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20101013224851.B8E5D20465@glenhelen.mtv.corp.google.com>
References: <20101013224851.B8E5D20465@glenhelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 15:51:05 +0200
Message-ID: <1287064265.4641.435.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 15:13 -0700, Paul Stewart wrote:
> Called from a work proc, this examines the last transmit rate change
> to see if it warrants an event transmission.

> +        list_for_each_entry(sdata, &local->interfaces, list) {
> +                if (!netif_running(sdata->dev) ||

ieee80211_sdata_running

> +		if (!(ifmgd->flags & IEEE80211_STA_TX_RATE_CHANGED) ||
> +		    bss_conf->cqm_bitrate_thold == 0)
> +			continue;

why would this work item even be running with a threshold of zero?

Again, this won't compile without the next patch.

However, I think all of this is really expensive. For many devices,
you'll effectively be triggering an evaluation of the bitrate for every
packet. This will work well with minstrel, since it properly uses and
advertises the "best throughput" rate, but not necessarily with other
algorithms.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39636 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965919AbcAZNNk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 08:13:40 -0500
Message-ID: <1453814017.2759.44.camel@sipsolutions.net> (sfid-20160126_141352_277618_06C9995B)
Subject: Re: [PATCH] mac80211: fix unnecessary frame drops in mesh fwding
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 26 Jan 2016 14:13:37 +0100
In-Reply-To: <1453729404-26506-1-git-send-email-michal.kazior@tieto.com> (sfid-20160125_144242_994035_4B1110EE)
References: <1453729404-26506-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160125_144242_994035_4B1110EE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-01-25 at 14:43 +0100, Michal Kazior wrote:
> The ieee80211_queue_stopped() expects hw queue
> number but it was given raw WMM AC number instead.
> 
> This could cause frame drops and problems with
> traffic in some cases - most notably if driver
> doesn't map AC numbers to queue numbers 1:1 and
> uses ieee80211_stop_queues() and
> ieee80211_wake_queue() only without ever calling
> ieee80211_wake_queues().
> 
[...]

Yeah, this seems right - applied.

I put it into mac80211-next since you nobody complained before so it's
likely not relevant without your other ath10k patches.

johannes

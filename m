Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43020 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751500AbcLEOIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:08:14 -0500
Message-ID: <1480946891.31788.10.camel@sipsolutions.net> (sfid-20161205_150817_092629_1114780C)
Subject: Re: [PATCH] mac80211:  Return avg sig, rx, tx values in ethtool
 stats.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Mon, 05 Dec 2016 15:08:11 +0100
In-Reply-To: <1480442872-7358-1-git-send-email-greearb@candelatech.com> (sfid-20161129_190824_045626_457405E8)
References: <1480442872-7358-1-git-send-email-greearb@candelatech.com>
         (sfid-20161129_190824_045626_457405E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-11-29 at 10:07 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> For non-station devices.  This gives at least some useful
> summary in some cases (especially when we know AP has only one
> station attached, for instance).

I never saw the point in having ethtool statistics for something you
can get elsewhere, but I'm certainly not making it return a random
station's data disregarding everything else. At least the existing ones
are sums so that all stations are taken into account...

You really should just get per-station stuff through nl80211.

johannes

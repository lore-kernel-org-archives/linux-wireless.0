Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42870 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbcLEN5O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 08:57:14 -0500
Message-ID: <1480946188.31788.6.camel@sipsolutions.net> (sfid-20161205_145718_364291_A5E87328)
Subject: Re: [PATCH 2/2] mac80211:  put upper bound on txqi queue length.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Mon, 05 Dec 2016 14:56:28 +0100
In-Reply-To: <1480442753-6830-2-git-send-email-greearb@candelatech.com> (sfid-20161129_190601_774406_10D2EEDF)
References: <1480442753-6830-1-git-send-email-greearb@candelatech.com>
         <1480442753-6830-2-git-send-email-greearb@candelatech.com>
         (sfid-20161129_190601_774406_10D2EEDF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-11-29 at 10:05 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This fixes OOM when using pktgen to drive a wifi station at more than
> the station can transmit.  pktgen uses ndo_start_xmit instead of
> going
> through the queue layer, so it will not back off when the queues are
> stopped, and would thus cause packets to be added to the txqi->queue
> until the system goes OOM and crashes.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> This is against 4.7.10+, not sure if it is actually needed in latest
> kernel.

One would hope that fq_tin_enqueue() does something like that, but
anyway the patch doesn't apply so I'm dropping it.

johannes

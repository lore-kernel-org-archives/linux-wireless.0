Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57421 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757734AbcILJ6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:58:49 -0400
Message-ID: <1473674327.29016.3.camel@sipsolutions.net> (sfid-20160912_120042_939812_458CEE97)
Subject: Re: [PATCH] mac80211: fix sequence number assignment for PS
 response frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Mon, 12 Sep 2016 11:58:47 +0200
In-Reply-To: <20160904160059.66297-1-nbd@nbd.name> (sfid-20160904_180104_088886_B2893E34)
References: <20160904160059.66297-1-nbd@nbd.name>
         (sfid-20160904_180104_088886_B2893E34)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-09-04 at 18:00 +0200, Felix Fietkau wrote:
> When using intermediate queues, sequence number allocation is
> deferred
> until dequeue. This doesn't work for PS response frames, which bypass
> those queues.
> 
Applied.

This worries me a bit though - there's nothing, afaict, that guarantees
that dequeue and real TX are not concurrent, and that would corrupt a
number of things, no?

johannes

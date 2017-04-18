Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45870 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755550AbdDRIxM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 04:53:12 -0400
Message-ID: <1492505589.2472.2.camel@sipsolutions.net> (sfid-20170418_105344_247770_F670FA72)
Subject: Re: [PATCH V2 02/10] nl80211: allow multiple active scheduled scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 18 Apr 2017 10:53:09 +0200
In-Reply-To: <1492085196-4574-3-git-send-email-arend.vanspriel@broadcom.com>
References: <1492085196-4574-1-git-send-email-arend.vanspriel@broadcom.com>
         <1492085196-4574-3-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Overall this looks good, and I've almost applied it - but I have a
question on this patch.

You have this list:

> +	struct list_head sched_scan_req_list;

> 	struct cfg80211_sched_scan_request __rcu *sched_scan_req;

but you kept this. In fact, it's even still *used*. I don't understand
that part.

Also, you used RCU primitives for the new list, but you never actually
used them - except in one place (in nl80211_stop_sched_scan) where it's
actually not needed at all and the _rcu should be removed (since it
holds the lock)

What's up with that?

johannes

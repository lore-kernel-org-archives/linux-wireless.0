Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56162 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdBOHr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 02:47:27 -0500
Message-ID: <1487144841.4026.1.camel@sipsolutions.net> (sfid-20170215_084731_709278_5C4B0730)
Subject: Re: [PATCH] mac80211:  allow overriding station bandwidth.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2017 08:47:21 +0100
In-Reply-To: <1487106095-23287-1-git-send-email-greearb@candelatech.com> (sfid-20170214_220143_477541_65E9EEB9)
References: <1487106095-23287-1-git-send-email-greearb@candelatech.com>
         (sfid-20170214_220143_477541_65E9EEB9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-14 at 13:01 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This allows one to disable VHT160 (or 80+80) on hardware
> that might otherwise try to use it.  One potential reason
> to do this is that at least some 160Mhz/80+80 hardware can
> only do 2x2 at 160Mhz, but can do 4x4 at 80Mhz.  And, due to
> driver and firmware issues, it may effectively be limitted
> to 1x1 at 160Mhz for some NICs.

I think the feature is acceptable and don't mind adding that (though
perhaps we should start thinking about making some of these things
debug-only features), but I think the description of why you might want
to do this is misleading - those issues you're describing really should
be solved differently, and I posted the basis for that yesterday.

johannes

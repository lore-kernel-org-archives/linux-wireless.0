Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53522 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbeDSP1A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 11:27:00 -0400
Message-ID: <1524151617.3024.25.camel@sipsolutions.net> (sfid-20180419_172706_126804_DCB1BF85)
Subject: Re: [PATCH 1/3] ethtool: Support ETHTOOL_GSTATS2 command.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>, netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Thu, 19 Apr 2018 17:26:57 +0200
In-Reply-To: <173c5f98-36bc-2e52-1e64-3a5f89008d46@candelatech.com>
References: <1524016176-3881-1-git-send-email-greearb@candelatech.com>
         <1524086817.3024.9.camel@sipsolutions.net>
         <f43d7ee4-7f27-b145-125e-32dbc31a27f1@candelatech.com>
         <1524119910.3024.12.camel@sipsolutions.net>
         <173c5f98-36bc-2e52-1e64-3a5f89008d46@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-04-19 at 08:25 -0700, Ben Greear wrote:
> 
> In order to efficiently parse lots of stats over and over again, I probe
> the stat names once on startup, map them to the variable I am trying to use
> (since different drivers may have different names for the same basic stat),
> and then I store the stat index.
> 
> On subsequent stat reads, I just grab stats and go right to the index to
> store the stat.
> 
> If the stats indexes change, that will complicate my logic quite a bit.

That's a good point.

> Maybe the flag could be called:  ETHTOOL_GS2_NO_REFRESH_FW ?

Sounds more to the point to me, yeah.

> > 
> > Also, wrt. the rest of the patch, I'd argue that it'd be worthwhile to
> > write the spatch and just add the flags argument to "get_ethtool_stats"
> > instead of adding a separate method - internally to the kernel it's not
> > that hard to change.
> 
> Maybe this could be in followup patches?  It's going to touch a lot of files,
> and might be hell to get merged all at once, and I've never used spatch, so
> just maybe someone else will volunteer that part :)

I guess you'll have to ask davem. :)

johannes

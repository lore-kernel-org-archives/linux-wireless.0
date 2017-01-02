Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37118 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751208AbdABKsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 05:48:55 -0500
Message-ID: <1483354130.4596.5.camel@sipsolutions.net> (sfid-20170102_114858_400325_D219FCD7)
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY
 to support BTCOEX
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhchelvam@codeaurora.org>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Date: Mon, 02 Jan 2017 11:48:50 +0100
In-Reply-To: <ae82112880d55451342e7a6e5a47c33f@codeaurora.org>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
         <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
         <1480949353.31788.27.camel@sipsolutions.net>
         <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
         <1481645351.20412.34.camel@sipsolutions.net>
         <134cc8e58ecb804b6dda0137c4c37be8@codeaurora.org>
         <1481881024.27953.14.camel@sipsolutions.net>
         <ae82112880d55451342e7a6e5a47c33f@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > 1) does it even make sense to split it out per AC? wouldn't it be
> > weird
> > if you supported this only for VO and BK, and not the others, or
> > something like that?
> > 
> 
> It has support for BE, VI, management and beacon frames also.
> Or do you meant to say like support only for VO and BK?

I mean - does it make sense for a piece of hardware to support only
VO/BK, without the others? I don't really see how that would make
sense, but maybe I'm missing something?

IOW - why have all these bits rather than just one?

> > 2) Wouldn't it make more sense to define this in nl80211 and just
> > pass the bitmap through to userspace? That would save quite a bit
> > of netlink mangling complexity.
> > 
> 
> Please let me know if the below design/thought is fine to you.
> 
> iw phyX set btcoex_priority <[vi, vo, be, bk, mgmt, beacon]>

That seems fine, but I don't see how the iw command line is relevant to
the question of whether we pass flag attributes or a bitmap??

> By this command user should give one or more than one frame types
> for 
> this btcoex priority,
> we will parse that in "iw" and send as a single bitmap(less than
> 0x64)  to the driver?

Right, and also to nl80211. Why not?

johannes

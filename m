Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55330 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760122AbcLPJhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 04:37:09 -0500
Message-ID: <1481881024.27953.14.camel@sipsolutions.net> (sfid-20161216_103717_375905_C8CD7CFB)
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY
 to support BTCOEX
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhchelvam@codeaurora.org>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Date: Fri, 16 Dec 2016 10:37:04 +0100
In-Reply-To: <134cc8e58ecb804b6dda0137c4c37be8@codeaurora.org>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
         <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
         <1480949353.31788.27.camel@sipsolutions.net>
         <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
         <1481645351.20412.34.camel@sipsolutions.net>
         <134cc8e58ecb804b6dda0137c4c37be8@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > is it fine to have as WIPHY_BTCOEX_BE_PREFERRED ?
> > 
> > It's not really clear to me what you intend to do this - if it's
> > really support flags then you really should name those better.
> > 
> 
> This is support flags and it used by the driver to intimate driver 
> supported frame type for the BTCOEX to cfg like
> "wiphy_wowlan_support_flags" implementation. Please suggest if this
> is ok ? I will be thankful if you can suggest a  better one if this
> is not ok "WIPHY_BTCOEX_SUPPORTS_BE"

Well, I see a few things here:

1) does it even make sense to split it out per AC? wouldn't it be weird
if you supported this only for VO and BK, and not the others, or
something like that?

2) Wouldn't it make more sense to define this in nl80211 and just pass
the bitmap through to userspace? That would save quite a bit of netlink
mangling complexity.

3) I think the naming is confusing - "WIPHY_BTCOEX_SUPPORTS_BE_PREF" or
so might be more appropriate?

> Do you mean to say, sending a value from user space and parse that
> in  the driver?

I was more thinking of the capability advertisement, but yeah, both
ways seems reasonable.

johannes

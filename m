Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43668 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750951AbcLEPOu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 10:14:50 -0500
Message-ID: <1480950886.31788.44.camel@sipsolutions.net> (sfid-20161205_161453_573752_0F5A837B)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 05 Dec 2016 16:14:46 +0100
In-Reply-To: <5845824B.4090304@gmail.com> (sfid-20161205_160549_860372_16971AFA)
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
         <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
         <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
         (sfid-20161205_160549_860372_16971AFA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Well, no, that'd only work with an open connection :)

Actually, it also works fairly easily for when firmware has 4-way-
handshake offload, which will be coming to a kernel near you soon.

> And even that is questionable in my mind for some of the more
> advanced cases.

Well, at least in that case you can have things running (for a while)
if the manager crashes?

> But I'm not sure what your point is, do you still have objections to 
> this approach?

Well, first of all, you can keep things running, at least until you've
figured out how to restart wpa_supplicant/whatever.

There also aren't really any important resources to clear when
userspace dies, at least nothing that userspace can't trivially clear
later by disconnecting (even unconditionally and ignoring the
result)...

So basically I just don't see the advantage. It feels like trading a
single line of userspace code to disconnect with some (not super
complex, but still somewhat involved) kernel-side tracking. That
doesn't really seem like a worthwhile tradeoff to me.

johannes

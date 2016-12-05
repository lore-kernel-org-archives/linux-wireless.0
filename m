Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:43699 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbcLEPlB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 10:41:01 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1480950886.31788.44.camel@sipsolutions.net>
Date: Mon, 5 Dec 2016 16:40:59 +0100
Cc: Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Message-Id: <8D3A438A-E7E8-4DF8-BEE3-83DCF918BB71@holtmann.org> (sfid-20161205_164105_077433_561C1A84)
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
 <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
 <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
 <1480950886.31788.44.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>>> Well, no, that'd only work with an open connection :)
> 
> Actually, it also works fairly easily for when firmware has 4-way-
> handshake offload, which will be coming to a kernel near you soon.
> 
>> And even that is questionable in my mind for some of the more
>> advanced cases.
> 
> Well, at least in that case you can have things running (for a while)
> if the manager crashes?
> 
>> But I'm not sure what your point is, do you still have objections to 
>> this approach?
> 
> Well, first of all, you can keep things running, at least until you've
> figured out how to restart wpa_supplicant/whatever.
> 
> There also aren't really any important resources to clear when
> userspace dies, at least nothing that userspace can't trivially clear
> later by disconnecting (even unconditionally and ignoring the
> result)...
> 
> So basically I just don't see the advantage. It feels like trading a
> single line of userspace code to disconnect with some (not super
> complex, but still somewhat involved) kernel-side tracking. That
> doesn't really seem like a worthwhile tradeoff to me.

I do not get this argument. That is what WEXT forced you to do since the APIs were awful and clueless. I thought we have moved passed this messy userspace and racy guess work.

If I am a wireless management daemon, I want to decide what happens when I unexpectedly die or get killed for some reason where it is no longer in my control to do this. And there is no guarantee that the daemon even gets restarted. Now you leave dangling connections around. If userspace asks the kernel to clean up after it, then the kernel should be able to do so. That is the only sane option since everything else is racy. The daemon is not in control and has no idea how much time has passed or what happened while it was away. So the only clean thing to do, ask the kernel to disconnect in case something unexpected happens.

And frankly if the wireless daemon can not ask the kernel to clean up, how would a connection manager then even begin to handle this properly. It causes more races and more issues. It becomes a state tracking nightmare. And this is not some theoretical issue, we have seen all the issues with ConnMan. Remember that ConnMan runs in production consumer devices. So these things are real. These systems have to kill daemons for resource limits and other reasons that are out of the control of the daemon itself. And there is no recovery, and if there is, there is no knowing when that happens.

So userspace can clear later argument is not valid for me. If your userspace wants to do that, then fine. Our userspace does not want unsupervised or unmanaged connections. If it goes away, then it wants that these are cleared. And that option is clearly what this patch provides. I find this a clean and useful addition to nl80211. Why are you saying this is not worthwhile?

Regards

Marcel

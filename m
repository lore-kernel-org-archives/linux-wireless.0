Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34385 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbcLEPcw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 10:32:52 -0500
Received: by mail-oi0-f52.google.com with SMTP id y198so343540796oia.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 07:32:52 -0800 (PST)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
 <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
 <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
 <1480950886.31788.44.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <584588A2.9090006@gmail.com> (sfid-20161205_163256_333315_ACC2B3FF)
Date: Mon, 5 Dec 2016 09:32:50 -0600
MIME-Version: 1.0
In-Reply-To: <1480950886.31788.44.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 12/05/2016 09:14 AM, Johannes Berg wrote:
>>> Well, no, that'd only work with an open connection :)
>
> Actually, it also works fairly easily for when firmware has 4-way-
> handshake offload, which will be coming to a kernel near you soon.
>

Great, but still not applicable for all devices, and still questionable 
how useful an unmanaged connection actually is.  But okay.

>> And even that is questionable in my mind for some of the more
>> advanced cases.
>
> Well, at least in that case you can have things running (for a while)
> if the manager crashes?
>

To what purpose?  That's like saying that maybe a socket should be kept 
open in case an application crashes.

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

Sure, but in the meantime you have a completely unmanaged connection, 
with no connection manager to tell you what the state of it is.  Maybe 
okay for a command line system with a brain in front of it, but not much 
use anywhere else.

But for that use case the SOCKET_OWNER attribute can be omitted...

>
> So basically I just don't see the advantage. It feels like trading a
> single line of userspace code to disconnect with some (not super
> complex, but still somewhat involved) kernel-side tracking. That
> doesn't really seem like a worthwhile tradeoff to me.
>

Well, we'd be trading quite a bit of race-prone user space code that 
performs the clean up on start up for one line of attributes.  I call 
that a good trade.

Also, I thought it was good form / the UNIX way to clean up after 
processes exit ungracefully.  You seem to be arguing against that?  I 
would argue the kernel should be doing the opposite.  It should always 
clean up the connection unless user space has indicated it can be 'reused'.

Regards,
-Denis

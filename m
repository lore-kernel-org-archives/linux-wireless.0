Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44670 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753809AbdCFJbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 04:31:11 -0500
Message-ID: <1488787876.5761.1.camel@sipsolutions.net> (sfid-20170306_103535_865009_8D3CB01F)
Subject: Re: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to
 suspend async: error -16)
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 06 Mar 2017 09:11:16 +0100
In-Reply-To: <37f7bd69-9a0e-7e49-7035-9e6f2cfef260@googlemail.com> (sfid-20170305_161243_562385_03404077)
References: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com>
         <1487938277.2540.13.camel@sipsolutions.net>
         <5d69cf9b-1113-835a-8423-3796586eae20@googlemail.com>
         <1487965047.30601.2.camel@sipsolutions.net>
         <6337fa40-adcc-b889-1842-16e0f316ea3e@googlemail.com>
         <1488444909.8390.11.camel@sipsolutions.net>
         <0cd984fd-3d26-15b2-03ce-69cdb7c0e434@googlemail.com>
         <1488479939.23555.1.camel@sipsolutions.net>
         <37f7bd69-9a0e-7e49-7035-9e6f2cfef260@googlemail.com>
         (sfid-20170305_161243_562385_03404077)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-03-05 at 16:12 +0100, Oliver Freyermuth wrote:

[snip]

> With tcp-mode, and using the small testing code I found from you
> somewhere on the web:
> https://bugs.chromium.org/p/chromium/issues/detail?id=361435#c21
> indeed I get:
> "new client!"
> after the machine has suspended. 
> It even seems to receive the "WAKEUPNOW" when I close the server,
> since it does not make further reconnection attempts after. 

Heh. I think you're quite possibly the first person (other than me) to
ever use this :)

[snip]

> So nothing which looks bad as far as I can see. 

Agree, nothing looks bad. Try running "iw event" while you suspend - if
the NIC thought it woke up the system there will be an event indicating
so.

> Maybe this UEFI firmware is broken in a different, albeit "more
> stupid" way: 
> Discarding ACPI wakeup from PCI devices, even though it leaves them
> powered? 

I guess it's possible. I guess there's also a chance that we're missing
some setup in the driver though. I vaguely remember a patch in ChromeOS
that somehow we never merged ... ah yes, must've been this one:
https://chromium-review.googlesource.com/311101
though that means it's not relevant in your system.

So basically I don't really see anything missing in the driver, hmm.

johannes

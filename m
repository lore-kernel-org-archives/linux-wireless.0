Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37405 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753704AbdCFWSb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 17:18:31 -0500
Received: by mail-wm0-f49.google.com with SMTP id n11so76747161wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 14:17:42 -0800 (PST)
Subject: Re: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to
 suspend async: error -16)
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com>
 <1487938277.2540.13.camel@sipsolutions.net>
 <5d69cf9b-1113-835a-8423-3796586eae20@googlemail.com>
 <1487965047.30601.2.camel@sipsolutions.net>
 <6337fa40-adcc-b889-1842-16e0f316ea3e@googlemail.com>
 <1488444909.8390.11.camel@sipsolutions.net>
 <0cd984fd-3d26-15b2-03ce-69cdb7c0e434@googlemail.com>
 <1488479939.23555.1.camel@sipsolutions.net>
 <37f7bd69-9a0e-7e49-7035-9e6f2cfef260@googlemail.com>
 <1488787876.5761.1.camel@sipsolutions.net>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <a4d62049-b406-0321-11c1-109c61527df5@googlemail.com> (sfid-20170306_231843_529234_2099A019)
Date: Mon, 6 Mar 2017 22:47:41 +0100
MIME-Version: 1.0
In-Reply-To: <1488787876.5761.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.03.2017 um 09:11 schrieb Johannes Berg:
> On Sun, 2017-03-05 at 16:12 +0100, Oliver Freyermuth wrote:
> 
> [snip]
> 
>> With tcp-mode, and using the small testing code I found from you
>> somewhere on the web:
>> https://bugs.chromium.org/p/chromium/issues/detail?id=361435#c21
>> indeed I get:
>> "new client!"
>> after the machine has suspended. 
>> It even seems to receive the "WAKEUPNOW" when I close the server,
>> since it does not make further reconnection attempts after. 
> 
> Heh. I think you're quite possibly the first person (other than me) to
> ever use this :)
> 
It seems the script itself is really working as it should, see below ;-). 

> [snip]
> 
>> So nothing which looks bad as far as I can see. 
> 
> Agree, nothing looks bad. Try running "iw event" while you suspend - if
> the NIC thought it woke up the system there will be an event indicating
> so.
> 
Indeed, I get:
1488836432.153465: wlan0 (phy #0): WoWLAN wakeup
        * packet (might be truncated): ac:fd:ce:de:e1:58:b8:27:eb:f4:3b:4c:08:00:45:00:00:31:78:d1:40:00:3f:06:3d:55:c0:a8:02:23:c0:a8:02:2d:30:39:30:39:f2:04:6f:88:8b:74:4c:c2:50:18:72:10:00:00:00:00:57:41:4b:45:55:50:4e:4f:57
        * TCP connection wakeup received

Note the trailing "57:41:4b:45:55:50:4e:4f:57" which is your "WAKEUPNOW". 

Also magic packet "works" this way, i.e. shows up via "iw event". 

>> Maybe this UEFI firmware is broken in a different, albeit "more
>> stupid" way: 
>> Discarding ACPI wakeup from PCI devices, even though it leaves them
>> powered? 
> 
> I guess it's possible. I guess there's also a chance that we're missing
> some setup in the driver though. I vaguely remember a patch in ChromeOS
> that somehow we never merged ... ah yes, must've been this one:
> https://chromium-review.googlesource.com/311101
> though that means it's not relevant in your system.
> 
> So basically I don't really see anything missing in the driver, hmm.
I realized I also have a Win10 installation on that machine - and may as well try WoWLAN with it. 
Enabling (in the dreaded device manager) wake via the WiFi device, magic packet mode, I also cannot wake the machine. 
So if it was a driver bug, it would have to be present both in Windows and Linux drivers - but I guess it's just another case
of broken system firmware *sigh*. 

And that's even though it's a pretty recent Clevo W230SD-based machine (which I considered decently widespread)
with unlocked UEFI (so I see almost all options), but of course nothing related to ACPI wakeup. 
But I guess widespread alone does not help ;-). 

> 
> johannes
> 

Thanks for all!
Oliver

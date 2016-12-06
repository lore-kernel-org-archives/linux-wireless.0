Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35142 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbcLFWAy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Dec 2016 17:00:54 -0500
Received: by mail-oi0-f65.google.com with SMTP id v84so43004232oie.2
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2016 14:00:06 -0800 (PST)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
 <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
 <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
 <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
 <1481008560.6610.3.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <584730D7.2020708@gmail.com> (sfid-20161206_230114_406465_164B0092)
Date: Tue, 6 Dec 2016 15:42:47 -0600
MIME-Version: 1.0
In-Reply-To: <1481008560.6610.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 12/06/2016 01:16 AM, Johannes Berg wrote:
> On Mon, 2016-12-05 at 09:32 -0600, Denis Kenzior wrote:
>
>> To what purpose?  That's like saying that maybe a socket should be
>> kept open in case an application crashes.
>
> That socket would be useless, so no, that's not comparable at all. It's
> more like saying the disk should be unmounted once 'mount' exits ;-)
>

Except the kernel doesn't want to reconfigure mount parameters every 
15-30 minutes.  So no, its not like 'mount' at all ;)  But I digress, I 
can see that we won't agree here.  But we still would like the kernel to 
clean up nicely if stuff hits the fan.

> Anyway ... I'm not even super against this patch, but you need to fix

I'm afraid to consider what you're like when you _are_ 'super' against 
something :)

> things:
>   * this is actually wrong for authenticate - I'll let you figure out
>     why by yourself

So here's a quick test, with the client triggering authenticate, then 
crashing:

< Request: Authenticate (0x25) len 52 [ack]                  362.339712
     Interface Index: 3 (0x00000003)
     Wiphy Frequency: 2417 (0x00000971)
     MAC Address <snip>
     SSID: len 9
         <snip>
     Auth Type: 0 (0x00000000)
 > Event: New Station (0x13) len 32                           362.341337
     Interface Index: 3 (0x00000003)
 > Response: Authenticate (0x25) len 4                        362.341860
     Status: Success (0)
 > Event: Authenticate (0x25) len 64                          362.343640
     Wiphy: 0 (0x00000000)
     Interface Index: 3 (0x00000003)
 > Event: Del Station (0x14) len 1144                         367.442024
     Interface Index: 3 (0x00000003)
     MAC Address <snip>

Pay attention to the time stamps.  The del station event comes in 5 
seconds or so after our client has aborted.  So for 5 seconds we have an 
unmanaged link to some AP.  It would be nice if the authentication was 
aborted as soon as we crash.

So again, why do you say that SOCKET_OWNER is 'wrong' for authenticate? 
  Or do you mean something else?

>   * you need to teach people to write useful commit messages

The commit description in this patch was lacking.  We both agree here.

Regards,
-Denis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:32915 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbcLGGlD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 01:41:03 -0500
Received: by mail-oi0-f54.google.com with SMTP id w63so406522777oiw.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2016 22:40:58 -0800 (PST)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
 <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
 <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
 <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
 <1481008560.6610.3.camel@sipsolutions.net> <584730D7.2020708@gmail.com>
 <1481091301.4092.5.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <5847AEF9.90409@gmail.com> (sfid-20161207_074106_627610_394FFC52)
Date: Wed, 7 Dec 2016 00:40:57 -0600
MIME-Version: 1.0
In-Reply-To: <1481091301.4092.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 12/07/2016 12:15 AM, Johannes Berg wrote:
>
>> I'm afraid to consider what you're like when you _are_ 'super'
>> against something :)
>
> Why, that's easy, there wouldn't be a long discussion like that ;-)

lol

>
> No, this is the part you didn't understand. Simply authenticating
> doesn't actually create anything like a "link" to the AP. The only

Okay, but it is then a bit misleading that iw link reports us being 
'connected' during this time for example.

> reason we keep the station entry around for a few seconds is that it
> *probably* will be used next to associate. But if you don't do that, or
> authenticate to some other AP, or do whatever else - nothing stops you
> from doing that. There's no connection, nothing really stays active
> except for this 5 second grace period to associate.
>
> So even if you crash here like in the example, there's nothing to clean
> up, a subsequent authentication attempt to the same or another AP will
> go through anyway.
>
> Therefore, there's nothing to "own" with an authentication attempt,
> since it doesn't actually keep any (permanent) state in the kernel, and
> keeping the station entry around is just an optimisation.
>
> I don't think it's worth trying to clean that up.

Fair enough.  I think we can live with that since we're not using 
CMD_AUTHENTICATE unless we need to roam using FT.

Regards,
-Denis

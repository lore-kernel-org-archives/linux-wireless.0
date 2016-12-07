Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:32921 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbcLGBkf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Dec 2016 20:40:35 -0500
Received: by mail-io0-f195.google.com with SMTP id j92so10693637ioi.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2016 17:40:34 -0800 (PST)
Received: from mail-io0-f179.google.com (mail-io0-f179.google.com. [209.85.223.179])
        by smtp.gmail.com with ESMTPSA id e72sm10140429iof.26.2016.12.06.17.40.33
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2016 17:40:33 -0800 (PST)
Received: by mail-io0-f179.google.com with SMTP id c21so631517300ioj.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2016 17:40:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <584730D7.2020708@gmail.com>
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
 <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
 <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
 <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
 <1481008560.6610.3.camel@sipsolutions.net> <584730D7.2020708@gmail.com>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Wed, 7 Dec 2016 02:40:32 +0100
Message-ID: <CAOq732LOk-GQiSfs9Js-qEgvmbNMD_xf6j_1NR88Z1SDL=J8WA@mail.gmail.com> (sfid-20161207_024039_953803_7BFA5059)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT
To: Denis Kenzior <denkenz@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 6 December 2016 at 22:42, Denis Kenzior <denkenz@gmail.com> wrote:
> On 12/06/2016 01:16 AM, Johannes Berg wrote:
>> Anyway ... I'm not even super against this patch, but you need to fix
>> things:
>>   * this is actually wrong for authenticate - I'll let you figure out
>>     why by yourself
>
>
> So here's a quick test, with the client triggering authenticate, then
> crashing:
>
> < Request: Authenticate (0x25) len 52 [ack]                  362.339712
>     Interface Index: 3 (0x00000003)
>     Wiphy Frequency: 2417 (0x00000971)
>     MAC Address <snip>
>     SSID: len 9
>         <snip>
>     Auth Type: 0 (0x00000000)
>> Event: New Station (0x13) len 32                           362.341337
>     Interface Index: 3 (0x00000003)
>> Response: Authenticate (0x25) len 4                        362.341860
>     Status: Success (0)
>> Event: Authenticate (0x25) len 64                          362.343640
>     Wiphy: 0 (0x00000000)
>     Interface Index: 3 (0x00000003)
>> Event: Del Station (0x14) len 1144                         367.442024
>     Interface Index: 3 (0x00000003)
>     MAC Address <snip>
>
> Pay attention to the time stamps.  The del station event comes in 5 seconds
> or so after our client has aborted.  So for 5 seconds we have an unmanaged
> link to some AP.  It would be nice if the authentication was aborted as soon
> as we crash.
>
> So again, why do you say that SOCKET_OWNER is 'wrong' for authenticate?  Or
> do you mean something else?

Possibly Johanness refers to the fact that if you use
CMD_AUTHENTICATE, or if you use CMD_CONNECT but the driver implements
the SME -- doesn't use the cfg80211 software SME -- then
cfg80211_disconnect won't do anything if we're not associated, only
authenticated.  Currently cfg80211 doesn't have knowledge of whether
it is authenticated and where to.

With the software SME current_bss would be set from the moment the
authentication attempt starts, so there seems to be an inconsistency
which would affect for example the NL80211_BSS_STATUS_ASSOCIATED flags
in the result of CMD_GET_SCAN.  Perhaps this can be fixed by always
setting current_bss on auth attempt start, with flags to indicate
whether authentication has happened and whether association happened.

At the very least with this patch if you set the socket owner during
CMD_AUTHENTICATE and then separately associate, you'd get the expected
deauthentication.

Best regards

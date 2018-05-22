Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:36708 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbeEVOpz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 10:45:55 -0400
Received: by mail-ot0-f195.google.com with SMTP id m11-v6so21270033otf.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 07:45:55 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from
 conn_owner
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
References: <20180428014732.4018-1-andrew.zaborowski@intel.com>
 <87in8b8ooy.fsf@purkki.adurom.net>
 <CAOq732JPfbJWyR0RROY-t67p7dOuoHoHS6eaMrZ1j39F1Q0zmg@mail.gmail.com>
 <1525720752.22388.3.camel@sipsolutions.net> <5AF1959E.6020605@broadcom.com>
 <1525781970.14830.11.camel@sipsolutions.net> <5AF1995D.3040204@broadcom.com>
 <A996D5EE-1279-4DEC-832F-FC4D5FD7FC61@gmail.com>
 <5B03F345.70809@broadcom.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <ffdde7b5-2852-3bdc-cfa1-0d9e83e810b7@gmail.com> (sfid-20180522_164559_790864_2F8D07D2)
Date: Tue, 22 May 2018 09:45:53 -0500
MIME-Version: 1.0
In-Reply-To: <5B03F345.70809@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 05/22/2018 05:39 AM, Arend van Spriel wrote:
> On 5/8/2018 5:05 PM, Denis Kenzior wrote:
>> Hi Arend,
>>
>>>
>>> Sure. I guess we all have been there kicking of wpa_s and discovering
>>> there is already one running in the background. I am just a bit
>>> squeamish to change the behavior like this. Hmmmm. Is wpa_s already
>>> using SOCKET_OWNER. If so, I might create a patch to opt-out for that
>>> so people can knowingly choose chaos ;-)
>>>
>>
>> wpa_s is using SOCKET_OWNER these days.  However, with the introduction
>> of Control Port over NL80211, just getting rid of SOCKET_OWNER might not
>> be that easy.
> 
> I have a regression test script employing py80211 which listens for 
> connect event. Right now I am using an older wpa_s, but the above will 
> screw it up.

So it is still early in the morning for me and you might have to talk 
slower.  But let me take a stab anyway :)

What will screw up?  The connect event is always multicast, so you 
should still receive it regardless of SOCKET_OWNER / Control Port over 
NL80211.

> 
> If I recall correctly the mlme notification needed to be unicast, 
> because multicast was not 100% reliable, right? Would it be acceptable 
> to send unicast to the socket owner and still do the multicast or are we 
> already doing that? If not, that would fix my imminent issue.
> 

Control Port events are only unicast to the application that is the 
SOCKET_OWNER.  E.g. either wpa_s or iwd.  They are never multicast as 
nobody else could make sense of them anyway due to lack of passphrase / 
nonces.

The other 'regular' events like Disconnect, Connect, etc are still 
multicast.  What this patch does is prevents some app from rudely coming 
in and sending a Disconnect on an interface which is being managed by 
another process, e.g. iwd or wpa_s, that has set the SOCKET_OWNER flag.

Regards,
-Denis

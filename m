Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:42239 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbeEVKjE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 06:39:04 -0400
Received: by mail-qt0-f196.google.com with SMTP id c2-v6so22712059qtn.9
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 03:39:04 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from
 conn_owner
To: Denis Kenzior <denkenz@gmail.com>
References: <20180428014732.4018-1-andrew.zaborowski@intel.com>
 <87in8b8ooy.fsf@purkki.adurom.net>
 <CAOq732JPfbJWyR0RROY-t67p7dOuoHoHS6eaMrZ1j39F1Q0zmg@mail.gmail.com>
 <1525720752.22388.3.camel@sipsolutions.net> <5AF1959E.6020605@broadcom.com>
 <1525781970.14830.11.camel@sipsolutions.net> <5AF1995D.3040204@broadcom.com>
 <A996D5EE-1279-4DEC-832F-FC4D5FD7FC61@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B03F345.70809@broadcom.com> (sfid-20180522_123910_301916_2ACAF5E4)
Date: Tue, 22 May 2018 12:39:01 +0200
MIME-Version: 1.0
In-Reply-To: <A996D5EE-1279-4DEC-832F-FC4D5FD7FC61@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/8/2018 5:05 PM, Denis Kenzior wrote:
> Hi Arend,
>
>>
>> Sure. I guess we all have been there kicking of wpa_s and discovering
>> there is already one running in the background. I am just a bit
>> squeamish to change the behavior like this. Hmmmm. Is wpa_s already
>> using SOCKET_OWNER. If so, I might create a patch to opt-out for that
>> so people can knowingly choose chaos ;-)
>>
>
> wpa_s is using SOCKET_OWNER these days.  However, with the introduction
> of Control Port over NL80211, just getting rid of SOCKET_OWNER might not
> be that easy.

I have a regression test script employing py80211 which listens for 
connect event. Right now I am using an older wpa_s, but the above will 
screw it up.

If I recall correctly the mlme notification needed to be unicast, 
because multicast was not 100% reliable, right? Would it be acceptable 
to send unicast to the socket owner and still do the multicast or are we 
already doing that? If not, that would fix my imminent issue.

Regards,
Arend

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:39499 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbeEHMek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 08:34:40 -0400
Received: by mail-wm0-f49.google.com with SMTP id f8-v6so21262277wmc.4
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2018 05:34:39 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from
 conn_owner
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180428014732.4018-1-andrew.zaborowski@intel.com>
 <87in8b8ooy.fsf@purkki.adurom.net>
 <CAOq732JPfbJWyR0RROY-t67p7dOuoHoHS6eaMrZ1j39F1Q0zmg@mail.gmail.com>
 <1525720752.22388.3.camel@sipsolutions.net> <5AF1959E.6020605@broadcom.com>
 <1525781970.14830.11.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AF1995D.3040204@broadcom.com> (sfid-20180508_143452_529504_B7923B28)
Date: Tue, 8 May 2018 14:34:37 +0200
MIME-Version: 1.0
In-Reply-To: <1525781970.14830.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/8/2018 2:19 PM, Johannes Berg wrote:
> On Tue, 2018-05-08 at 14:18 +0200, Arend van Spriel wrote:
>> On 5/7/2018 9:19 PM, Johannes Berg wrote:
>>> On Sun, 2018-04-29 at 20:30 +0200, Andrew Zaborowski wrote:
>>>> On 28 April 2018 at 15:07, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>>> Andrew Zaborowski <andrew.zaborowski@intel.com> writes:
>>>>>> Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
>>>>>> NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
>>>>>> from clients other than the connection owner set in the connect,
>>>>>> authenticate or associate commands, if it was set.
>>>>>>
>>>>>> The main point of this check is to prevent chaos when two processes
>>>>>> try to use nl80211 at the same time, it's not a security measure.
>>>>>> The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
>>>>>> START_AP/STOP_AP.
>>>>>
>>>>> s-o-b missing.
>>>>
>>>> True, thanks.  Also I was going to send this as an RFC.
>>>>
>>>
>>> Looks fine to me, please resend if you want it in :)
>>
>> Do we really want this? Is the referred chaos hypothetical or an actual
>> issue. Nothing stops me from doing an 'ifconfig down' so why should 'iw
>> disconnect' be any different. As far I can tell it does not affect my
>> testing environment, but particularly in such use-cases I can expect
>> issues adopting this change, which is also hypothetical of course ;-)
>
> Yeah, it's a good question. But it might help with inadvertent issues,
> like starting wpa_s which immediately disconnects if it finds something
> connected. If that fails, perhaps you have a better chance of noticing
> the error?

Sure. I guess we all have been there kicking of wpa_s and discovering 
there is already one running in the background. I am just a bit 
squeamish to change the behavior like this. Hmmmm. Is wpa_s already 
using SOCKET_OWNER. If so, I might create a patch to opt-out for that so 
people can knowingly choose chaos ;-)

Regards,
Arend

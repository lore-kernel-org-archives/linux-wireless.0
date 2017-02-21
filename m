Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34312 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752230AbdBULpZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 06:45:25 -0500
Received: by mail-qk0-f176.google.com with SMTP id s186so119211270qkb.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 03:45:24 -0800 (PST)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170221100957.30965-1-johannes@sipsolutions.net>
 <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
 <1487673603.2215.3.camel@sipsolutions.net>
 <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
Cc: Eliad Peller <eliad@wizery.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a021dbf9-854d-0339-b87d-b27b746ccd1b@broadcom.com> (sfid-20170221_124553_318866_0155E0E0)
Date: Tue, 21 Feb 2017 12:45:22 +0100
MIME-Version: 1.0
In-Reply-To: <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 21-2-2017 12:34, Arend Van Spriel wrote:
> On 21-2-2017 11:40, Johannes Berg wrote:
>> On Tue, 2017-02-21 at 11:32 +0100, Arend Van Spriel wrote:
>>> On 21-2-2017 11:09, Johannes Berg wrote:
>>>> From: Eliad Peller <eliad@wizery.com>
>>>>
>>>> Let drivers advertise support for station-mode 4-way handshake
>>>> offloading with a new
>>>> NL80211_EXT_FEATURE_4WAY_HANDSHAKE_OFFLOAD_STA
>>>> flag.
>>>
>>> I find use of the term OFFLOAD a bit redundant as it is implied by
>>> its presence anyway.
>>
>> Fair enough, we can remove that.
>>
>>>> Add a new NL80211_ATTR_PMK attribute that might be passed as part
>>>> of NL80211_CMD_CONNECT command, and contain the PSK (which is the
>>>> PMK, hence the name.)
> 
> It is also added to NL80211_CMD_ASSOCIATE. Maybe worth mentioning.
> 
>>>> The driver/device is assumed to handle the 4-way handshake by
>>>> itself in this case (including key derivations, etc.), instead
>>>> of relying on the supplicant.
> 
> What I am also missing is how to deal with NL80211_CMD_CONNECTED event
> signalling. Should that be given after (un)successful completion of the
> 4-way handshake or should we have a separate event for that?
> 
> Regards,
> Arend
> 
>>>> This patch is somewhat based on this one (by Vladimir Kondratiev):
>>>> https://patchwork.kernel.org/patch/1309561/.
>>>
>>> It also looks quite like this one we posted a while ago [1]. Our bad
>>> that we did not follow-up :-p
>>
>> Indeed, I was looking for the better link (had gmane recorded in the
>> internal commit log) and found a few that all looked the same ... :)
>>
>> Would this work for you? We should have wpa_supplicant support too, but
>> need to ask Andrei to look at that.

Forgot to reply to this. Yes, this will work. Can come up with wpa_supp
changes.

Regards,
Arend

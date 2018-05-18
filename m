Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:42865 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbeERTAY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 15:00:24 -0400
Received: by mail-oi0-f67.google.com with SMTP id t27-v6so7995827oij.9
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 12:00:23 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
 <1526631206.3805.1.camel@sipsolutions.net>
 <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
 <5AFF2169.4010003@broadcom.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <51c56faf-267d-c204-243a-31fc91976c5e@gmail.com> (sfid-20180518_210027_857161_EE419AB0)
Date: Fri, 18 May 2018 14:00:20 -0500
MIME-Version: 1.0
In-Reply-To: <5AFF2169.4010003@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 05/18/2018 01:54 PM, Arend van Spriel wrote:
> On 5/18/2018 6:47 PM, Denis Kenzior wrote:
>> Hi Johannes,
>>
>> On 05/18/2018 03:13 AM, Johannes Berg wrote:
>>> On Fri, 2018-05-11 at 09:48 -0700, Tim Kourt wrote:
>>>> __cfg80211_bss_expire function was incorrectly used to flush the BSS
>>>> entries from the previous scan results, causing NL80211_SCAN_FLAG_FLUSH
>>>> flag to have no effect.
>>>
>>> Hmm. I guess I'm not convinced - what's the bug?
>>>
>>> We flush anything that's older than our start, so that should work just
>>> fine?
>>>
>>
>> Just FYI, there's definitely something funny with the scanning code:
>>
>> denkenz@iwd-test ~ $ sudo iw dev wlp2s0 scan flush
>> BSS 10:c3:7b:54:74:d4(on wlp2s0)
>>      last seen: 274.815s [boottime]
>>      freq: 5765
>>      beacon interval: 100 TUs
>>      signal: -35.00 dBm
>>      last seen: 349 ms ago
>>      Information elements from Probe Response frame:
>>      SSID: \x00\x00\x00\x00\x00\x00\x00\x00\x00
>>
>>
>> Then if I try:
>> denkenz@iwd-test ~ $ sudo iw dev wlp2s0 scan flush ssid myssid
>> BSS 10:c3:7b:54:74:d4(on wlp2s0)
>>      last seen: 319.667s [boottime]
>>      freq: 5765
>>      beacon interval: 100 TUs
>>      signal: -42.00 dBm
>>      last seen: 350 ms ago
>>      Information elements from Probe Response frame:
>>      SSID: \x00\x00\x00\x00\x00\x00\x00\x00\x00
>> ....
>> BSS 10:c3:7b:54:74:d4(on wlp2s0)
>>      last seen: 319.662s [boottime]
>>      freq: 5765
>>      beacon interval: 100 TUs
>>      signal: -37.00 dBm
>>      last seen: 355 ms ago
>>      Information elements from Probe Response frame:
>>      SSID: myssid
>>
>> Shouldn't the second scan give a single result from that one BSS?
> 
> Looking at the 'last seen' values it does look ok. Both results have the 
> same BSSID, but the first one shows the broadcast ssid (or so it seems). 

Are you saying the first result is from the Beacon and the other is from 
the Probe Response?  Then why are the 'Information elements from Probe 
Response frame' the way they are?

> Neither iw nor nl80211 on the kernel side add the broadcast ssid. So 
> question is what device are you using and does it use mac80211 software 

Intel 7260.  We're seeing the same results with hwsim as well though. 
This was just a quick test to illustrate.

> scanning or hardware scanning. I did not dive into mac80211 to see if 
> the broadcast ssid is added there.

By the way, if you're interested.  The same tests with a Broadcom based 
device wouldn't even find the hidden network.  It would always come back 
with a single 'x00' SSID regardless of whether I added 'ssid myssid' at 
the end.

Regards,
-Denis

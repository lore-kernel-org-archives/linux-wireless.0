Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:41635 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbeEVPDd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 11:03:33 -0400
Received: by mail-oi0-f65.google.com with SMTP id 11-v6so16492027ois.8
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 08:03:33 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
 <1526631206.3805.1.camel@sipsolutions.net>
 <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
 <5AFF2169.4010003@broadcom.com>
 <51c56faf-267d-c204-243a-31fc91976c5e@gmail.com>
 <5B03C5BA.50804@broadcom.com>
 <c8f3d9a7-b978-8af8-6594-d0ae66652956@gmail.com>
 <1527000610.6787.14.camel@sipsolutions.net>
 <1527000664.6787.15.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <d1b22fc7-805a-cb30-3dc5-0acf9236b672@gmail.com> (sfid-20180522_170337_219809_1C287B7A)
Date: Tue, 22 May 2018 10:03:30 -0500
MIME-Version: 1.0
In-Reply-To: <1527000664.6787.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 05/22/2018 09:51 AM, Johannes Berg wrote:
> On Tue, 2018-05-22 at 16:50 +0200, Johannes Berg wrote:
>> On Tue, 2018-05-22 at 09:48 -0500, Denis Kenzior wrote:
>>> Hi Arend,
>>>
>>>>> Are you saying the first result is from the Beacon and the other is from
>>>>> the Probe Response?  Then why are the 'Information elements from Probe
>>>>> Response frame' the way they are?
>>>>
>>>> Nope. I am not saying that. I am saying that there are two probe
>>>> requests being sent. One with broadcast ssid, ie. ssid_len == 0, and
>>>> with ssid 'myssid'. But it is speculation without a sniffer capture.
>>>
>>> Ah I see what you mean now.  No, we traced this down to hostapd itself
>>> and it was receiving a single Probe Request with the ssid set and
>>> replying to it per spec.  So I'm pretty confident this scenario isn't
>>> what is happening.  Let me try to get some actual packet captures...
>>
>> Was "myssid" the real SSID, or did you hide that from us and it was
>> really 9 characters long in the original?

See the other sub-thread.  It was 9 characters long, I hand-edited it to 
protect the innocent.

>>
>> If it was really 9 characters long I could imagine that there's a
>> different bug with a beacon with all-zero-bytes having been received
>> (and getting stuck into the probe response buffer for some reason), and
>> then you *should* see both entries.
> 
> Or perhaps there's a bug with how we link the results between
> hidden/non-hidden, but it seems to me that hostapd would never have
> responded with a probe response with zeroed bytes.
> 

We suspect it is likely a bug in cfg80211_bss_update logic somewhere.

Regards,
-Denis

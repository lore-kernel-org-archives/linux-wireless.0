Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:32809 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753087AbeDRI3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 04:29:40 -0400
Received: by mail-qk0-f193.google.com with SMTP id d206so920642qkb.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2018 01:29:39 -0700 (PDT)
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
To: Dan Williams <dcbw@redhat.com>,
        Brian Norris <briannorris@chromium.org>
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
 <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
 <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
 <e16557d0891352ae0b83902faee97023@codeaurora.org>
 <877epbs5v7.fsf@kamboji.qca.qualcomm.com> <5AD11D7C.1030603@broadcom.com>
 <242be71eb87140c9560163c4000255b2@codeaurora.org>
 <8736zvqtcw.fsf@kamboji.qca.qualcomm.com>
 <20180417002854.GA186697@rodete-desktop-imager.corp.google.com>
 <5AD5AEB5.1040808@broadcom.com>
 <20180417160715.GA255263@rodete-desktop-imager.corp.google.com>
 <5AD66BD9.4000706@broadcom.com>
 <CA+ASDXOoxMyTq2CVnUwvN1LBWj1Y9wpsRPKuM0tVzA80sDYG-w@mail.gmail.com>
 <c4f3d20e8c16c8bf8721f0a50fb809781b30b3f7.camel@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, cjhuang@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Johannes Berg <johannes@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AD701F0.20504@broadcom.com> (sfid-20180418_102944_424836_16ED61B1)
Date: Wed, 18 Apr 2018 10:29:36 +0200
MIME-Version: 1.0
In-Reply-To: <c4f3d20e8c16c8bf8721f0a50fb809781b30b3f7.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Johannes (to confirm/correct my understanding regarding "supported 
commands")

On 4/18/2018 4:35 AM, Dan Williams wrote:
> On Tue, 2018-04-17 at 15:26 -0700, Brian Norris wrote:
>> On Tue, Apr 17, 2018 at 2:49 PM, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> On 4/17/2018 6:07 PM, Brian Norris wrote:
>>>> On Tue, Apr 17, 2018 at 10:22:13AM +0200, Arend van Spriel wrote:
>>>>> I believe checking command support is not really recommended.
>>>>> Instead, you
>>>>> better check NL80211_ATTR_SCHED_SCAN_MAX_REQS being non-zero
>>>>> (since kernel
>>>>> 4.12 that is).
>>>>
>>>>
>>>> Why not? Command support checking is what wpa_supplicant is
>>>> doing.
>>>
>>>
>>> That's not really a good argument. A couple (or more) years ago
>>> wpa_supplicant was not doing nl80211 but wext and some other using
>>> driver private ioctls, but that did not make it the best approach.
>>
>> I see what you're saying (though your comparison doesn't seem that
>> fair either; private ioctls are nothing like a well-defined nl80211
>> support list), and I'm totally good on looking at the new flag
>> eventually. But you still haven't answered my question ("why not?").
>> Is there a problem with the "supported commands" list?

My understanding is that in general the "supported commands" list is not 
well-maintained. Not every nl80211 command is represented in the list so 
user-space can not know whether it is missing or not supported.
For this particular START_SCHED_SCAN command it can be used still and 
indeed probably for a long time. I just wanted to point out that it is 
not recommended for new user-space functionality.

>>> The START_SCHED_SCAN command is indeed still provided to user-
>>> space:
>>
>> And as I see it, it probably needs to be for essentially forever. Or
>> at least a significant amount of time after wpa_supplicant stops
>> relying on it. (Hint: it's still using it today, with no reference to
>> NL80211_ATTR_SCHED_SCAN_MAX_REQS.) There's a reason the kernel has
>> ABI
>> guarantees. I suspect you only get a chance to rewrite the world
>> (WEXT
>> -> nl80211) a few times in the life of kernel ABIs.
>
> It sometimes feels like wpa_supplicant gets treated as a static entity
> that can never be changed.  In fact, send a patch to Jouni implementing
> the best practice, with a fallback to preserve compat for old kernels,
> and I'm sure he'd entertain it.  Just because the supplicant does
> something a certain way, doesn't mean it's the *best* way, but it too
> evolves.

I was actually considering to do that. The netlink messages are easily 
checked for presence of an attribute so deciding on whether to use the 
fallback is trivial.

Regards,
Arend

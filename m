Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35078 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934275AbdA0L0D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 06:26:03 -0500
Received: by mail-pg0-f53.google.com with SMTP id 194so80735483pgd.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2017 03:25:23 -0800 (PST)
Subject: Re: [PATCH] nl80211: fix validation of scheduled scan info for wowlan
 netdetect
To: Johannes Berg <johannes@sipsolutions.net>,
        Luca Coelho <luca@coelho.fi>
References: <1484820088-24448-1-git-send-email-arend.vanspriel@broadcom.com>
 <1484827206.2774.12.camel@coelho.fi>
 <bde55d09-6f3e-1f90-4aef-0e1169c11cf6@broadcom.com>
 <1485248251.7244.3.camel@sipsolutions.net>
 <13d1e654-6928-39e7-4751-fb90d3da7a54@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a36abf1d-5d4b-4c37-e325-a69166663a04@broadcom.com> (sfid-20170127_122611_840865_CC39877A)
Date: Fri, 27 Jan 2017 12:25:18 +0100
MIME-Version: 1.0
In-Reply-To: <13d1e654-6928-39e7-4751-fb90d3da7a54@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24-1-2017 12:28, Arend Van Spriel wrote:
> On 24-1-2017 9:57, Johannes Berg wrote:
>> On Thu, 2017-01-19 at 14:08 +0100, Arend Van Spriel wrote:
>>>
>>> On 19-1-2017 13:00, Luca Coelho wrote:
>>>> On Thu, 2017-01-19 at 10:01 +0000, Arend van Spriel wrote:
>>>>> For wowlan netdetect a separate limit is defined for the number
>>>>> of
>>>>> matchsets. Currently, this limit is ignored and the regular limit
>>>>> for scheduled scan matchsets, ie. struct wiphy::max_match_sets,
>>>>> is
>>>>> used for the net-detect case as well.
>>>>>
>>>>> Cc: Luciano Coelho <luciano.coelho@intel.com>
>>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>>> ---
>>>>
>>>> What?! You don't have the same number of matchsets for both? :P
>>>
>>> Actually I have, but your comment mentioned they do not have to be
>>> the
>>> same. brcmfmac actually did not set max_nd_match_sets so I was
>>> surprised
>>> it worked. That said this patch will result in regression in brcmfmac
>>> :-p Not sure about other drivers supporting net-detect.
>>
>> So do you want to submit a patch to brcmfmac first, and then I'll apply
>> this later? I can apply it and break it, but now that we already know
>> ...?
> 
> I have a brcmfmac patch in the queue. I will look at the other scheduled
> scan supporting drivers.

Hi Johannes,

I actually have two dependent brcmfmac patches. Do you expect conflict
if Kalle takes all?

Regards,
Arend

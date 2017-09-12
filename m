Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:37414 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdILISF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 04:18:05 -0400
Received: by mail-qt0-f172.google.com with SMTP id b1so14303825qtc.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Sep 2017 01:18:05 -0700 (PDT)
Subject: Re: [PATCH V2 1/3] brcmfmac: Avoid possible out-of-bounds read
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170909193020.19061-1-cernekee@chromium.org>
 <deff51ff-40f0-ffa4-afd0-b95465c66a8e@broadcom.com>
 <87tw08mpq1.fsf@purkki.adurom.net> <59B78E94.5040909@broadcom.com>
 <87o9qgicju.fsf@kamboji.qca.qualcomm.com> <59B793C9.2030103@broadcom.com>
 <87k214ibps.fsf@kamboji.qca.qualcomm.com>
Cc: Kevin Cernekee <cernekee@chromium.org>, franky.lin@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org,
        Greg KH <greg@kroah.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59B79838.6090408@broadcom.com> (sfid-20170912_101839_240785_3911E9FB)
Date: Tue, 12 Sep 2017 10:18:00 +0200
MIME-Version: 1.0
In-Reply-To: <87k214ibps.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Greg KH

On 9/12/2017 10:05 AM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 9/12/2017 9:47 AM, Kalle Valo wrote:
>>> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>>>
>>>> On 9/12/2017 7:48 AM, Kalle Valo wrote:
>>>>> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>>>>>
>>>>>> On 09-09-17 21:30, Kevin Cernekee wrote:
>>>>>>> In brcmf_p2p_notify_rx_mgmt_p2p_probereq(), chanspec is assigned before
>>>>>>> the length of rxframe is validated.  This could lead to uninitialized
>>>>>>> data being accessed (but not printed).  Since we already have a
>>>>>>> perfectly good endian-swapped copy of rxframe->chanspec in ch.chspec,
>>>>>>> and ch.chspec is not modified by decchspec(), avoid the extra
>>>>>>> assignment and use ch.chspec in the debug print.
>>>>>>>
>>>>>>> Suggested-by: Mattias Nissler <mnissler@chromium.org>
>>>>>>> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
>>>>>>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>>>>> ---
>>>>>>>      drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 +--
>>>>>>>      1 file changed, 1 insertion(+), 2 deletions(-)
>>>>>>>
>>>>>>>
>>>>>>> V1->V2: Clarify changelog re: whether the uninitialized data is printed.
>>>>>>
>>>>>> This patch and the others in this series look fine to me.
>>>>>
>>>>> Should these go to v4.14?
>>>>
>>>> I have no strong opinion. These are certainly improvements, but it
>>>> does not seem an -rc fix to me. Within this series I would say patch
>>>> 3/3 adds an additional sanity check in the event processing against an
>>>> attack so you may consider adding just that one to v4.14
>>>
>>> Ok, I'll queue patch 3 to v4.14.
>>>
>>>> and tag it for stable, ie.:
>>>>
>>>> Cc: stable@vger.kernel.org # v3.8.x
>>>
>>> But why v3.8.x? I admit that I haven't fully figured out the stable tags
>>> yet, but doesn't that mean that it will be only applied to v3.8.x and
>>> nothing else? I was expecting it to be:
>>>
>>> Cc: stable@vger.kernel.org # v3.8+
>>>
>>
>> It is actually in the stable-kernel-rules documentation [1]:
>>
>> """
>> Also, some patches may have kernel version prerequisites.  This can be
>> specified in the following format in the sign-off area:
>>
>> .. code-block:: none
>>
>>       Cc: <stable@vger.kernel.org> # 3.3.x
>>
>> The tag has the meaning of:
>>
>> .. code-block:: none
>>
>>       git cherry-pick <this commit>
>>
>> For each "-stable" tree starting with the specified version.
>> """
>
> Yeah, but it says "starting with" which I interpret as "starting with
> string '3.3'". For example the commit here would be applied to 3.3.1,
> 3.3.2 and 3.3.3 etc but _not_ to 3.4, 3.4.1, 3.5 or any later release.
>
> Of course I can be way off here, wouldn't be the first :)

Dito. I interpret "each -stable tree" as each stable branch in the 
stable repository. Would Greg know?

Regards,
Arend

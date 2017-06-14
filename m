Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36342 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751868AbdFNJur (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 05:50:47 -0400
Received: by mail-wr0-f173.google.com with SMTP id 36so59511476wry.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2017 02:50:46 -0700 (PDT)
Subject: Re: [V3] brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, "Peter S. Housel" <housel@acm.org>
References: <1497264382-2290-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170613070028.5F9CB606DC@smtp.codeaurora.org>
 <6a8d5627-1d7c-a448-6657-0e1a2bb5ed9a@broadcom.com>
 <87vany3oxp.fsf@kamboji.qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dea76ed4-cd32-0cfa-a2b3-29ed96382cdb@broadcom.com> (sfid-20170614_115202_425605_D61E583C)
Date: Wed, 14 Jun 2017 11:50:43 +0200
MIME-Version: 1.0
In-Reply-To: <87vany3oxp.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/14/2017 11:21 AM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> On 13-06-17 09:00, Kalle Valo wrote:
>>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>>
>>>> From: "Peter S. Housel" <housel@acm.org>
>>>>
>>>> An earlier change to this function (3bdae810721b) fixed a leak in the
>>>> case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
>>>> glom_skb buffer, used for emulating a scattering read, is never used
>>>> or referenced after its contents are copied into the destination
>>>> buffers, and therefore always needs to be freed by the end of the
>>>> function.
>>>>
>>>> Fixes: 3bdae810721b ("brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain")
>>>> Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for
>>>> host without sg support")
>>>> Cc: stable@vger.kernel.org # 4.9.x-
>>>> Signed-off-by: Peter S. Housel <housel@acm.org>
>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>
>>> Patch applied to wireless-drivers-next.git, thanks.
>>
>> Yikes. You say wireless-drivers-next? I should have tagged it better,
>> but I would like to get this fix in 4.12 and stable.
> 
> Yes, always document clearly your intentions. I have so many patches
> (and emails) to go through that I do not have much time for each patch
> to figure out which tree it should go. And in this case the commit log
> didn't mention any major breakage so I assumed this is for -next.
> 
> In theory I could cherry-pick the commit to wireless-drivers, but as
> this doesn't look like a serious issue (no crashes or anything like
> that), is it enough that this goes to 4.12 via stable tree? Just takes a
> little longer, nothing else.

It is for you to decide. This is what Peter wrote:

"""
I’m fine with this, or indeed most of the other proposed solutions. The 
important thing is that the leak is fixed; in the driver's current state 
I was able to run our wearable device out of memory in just over 20 
seconds running iperf.
"""

Regards,
Arend

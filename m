Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:32860 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdGGTjH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 15:39:07 -0400
Received: by mail-wr0-f178.google.com with SMTP id r103so60330420wrb.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jul 2017 12:39:06 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: fix possible buffer overflow in
 brcmf_cfg80211_mgmt_tx()
To: sedat.dilek@gmail.com
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org
References: <1499428893-30750-1-git-send-email-arend.vanspriel@broadcom.com>
 <CA+icZUXVEBQzau4d36iO1vvhioX_WM8AH-iw=Tv+vUcVBtUeWw@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <069e03ba-9d83-cde9-5ff1-49f847ccb887@broadcom.com> (sfid-20170707_213910_688414_CCD0F1F2)
Date: Fri, 7 Jul 2017 21:39:03 +0200
MIME-Version: 1.0
In-Reply-To: <CA+icZUXVEBQzau4d36iO1vvhioX_WM8AH-iw=Tv+vUcVBtUeWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-07-17 14:47, Sedat Dilek wrote:
> On Fri, Jul 7, 2017 at 2:01 PM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> The lower level nl80211 code in cfg80211 ensures that "len" is between
>> 25 and NL80211_ATTR_FRAME (2304).  We subtract DOT11_MGMT_HDR_LEN (24) from
>> "len" so thats's max of 2280.  However, the action_frame->data[] buffer is
>> only BRCMF_FIL_ACTION_FRAME_SIZE (1800) bytes long so this memcpy() can
>> overflow.
>>
>>         memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
>>                le16_to_cpu(action_frame->len));
>>
>> Reported-by: "freenerguo(郭大兴)" <freenerguo@tencent.com>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>> Hi Kalle,
>>
>> Here is the patch as Linus send it to us and security@kernel.org. I
>> removed the lower bound check as that is already done in cfg80211.
>> Now I signed off on the patch although formally I suppose Linus should
>> sign it off. Putting it out there so people can respond as deemed
>> necessary.
>>
>> Now fingers crossed whether patchwork will properly deal with the UTF-8
>> characters :-p
>>
> 
> Somehow horrific to see - less in usage (no CC here).

Sorry, Sedat

What is horrific? It is a bit cryptic (for me) what you would like me to
do now if anything.

Regards,
Arend

> - Sedat -
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?qt=grep&q=security%40kernel.org
> 

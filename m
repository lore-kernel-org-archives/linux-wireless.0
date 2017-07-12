Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34273 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbdGLKAA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 06:00:00 -0400
Received: by mail-vk0-f66.google.com with SMTP id f68so785749vkg.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jul 2017 03:00:00 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <069e03ba-9d83-cde9-5ff1-49f847ccb887@broadcom.com>
References: <1499428893-30750-1-git-send-email-arend.vanspriel@broadcom.com>
 <CA+icZUXVEBQzau4d36iO1vvhioX_WM8AH-iw=Tv+vUcVBtUeWw@mail.gmail.com> <069e03ba-9d83-cde9-5ff1-49f847ccb887@broadcom.com>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Wed, 12 Jul 2017 11:59:59 +0200
Message-ID: <CA+icZUVcG7+fk-BK8o3UU87Y-rqT7_nC4TMdzAVwawHb84cv-g@mail.gmail.com> (sfid-20170712_120005_852547_DC17EA54)
Subject: Re: [PATCH] brcmfmac: fix possible buffer overflow in brcmf_cfg80211_mgmt_tx()
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 7, 2017 at 9:39 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 07-07-17 14:47, Sedat Dilek wrote:
>> On Fri, Jul 7, 2017 at 2:01 PM, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> The lower level nl80211 code in cfg80211 ensures that "len" is between
>>> 25 and NL80211_ATTR_FRAME (2304).  We subtract DOT11_MGMT_HDR_LEN (24) =
from
>>> "len" so thats's max of 2280.  However, the action_frame->data[] buffer=
 is
>>> only BRCMF_FIL_ACTION_FRAME_SIZE (1800) bytes long so this memcpy() can
>>> overflow.
>>>
>>>         memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
>>>                le16_to_cpu(action_frame->len));
>>>
>>> Reported-by: "freenerguo(=E9=83=AD=E5=A4=A7=E5=85=B4)" <freenerguo@tenc=
ent.com>
>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>> ---
>>> Hi Kalle,
>>>
>>> Here is the patch as Linus send it to us and security@kernel.org. I
>>> removed the lower bound check as that is already done in cfg80211.
>>> Now I signed off on the patch although formally I suppose Linus should
>>> sign it off. Putting it out there so people can respond as deemed
>>> necessary.
>>>
>>> Now fingers crossed whether patchwork will properly deal with the UTF-8
>>> characters :-p
>>>
>>
>> Somehow horrific to see - less in usage (no CC here).
>
> Sorry, Sedat
>
> What is horrific? It is a bit cryptic (for me) what you would like me to
> do now if anything.
>

You did a CC <security@kernel.org>, thanks.
Looking at the sources, docs and (commit) logs, this email-address
seems "unknown" and less in usage.

- Sedat -

> Regards,
> Arend
>
>> - Sedat -
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/l=
og/?qt=3Dgrep&q=3Dsecurity%40kernel.org
>>

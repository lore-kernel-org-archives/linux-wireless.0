Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38841 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943484AbdDTTNm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 15:13:42 -0400
Received: by mail-wm0-f52.google.com with SMTP id r190so645424wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 12:13:42 -0700 (PDT)
Subject: Re: [PATCH] brcm80211: brcmfmac: Ensure that incoming skb's are
 writable
To: James Hughes <james.hughes@raspberrypi.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: netdev@vger.kernel.org, Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org
References: <20170420111651.10213-1-james.hughes@raspberrypi.org>
 <87y3uv48nv.fsf@kamboji.qca.qualcomm.com>
 <CAE_XsMJGpKKdZ4E90tkzYwe+7KJ8JB5Rwrzga6aUi1LZG+wH4w@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <60f9d8a0-e8b5-ef05-ea78-caacfcf0ae67@broadcom.com> (sfid-20170420_211347_080375_42A9E629)
Date: Thu, 20 Apr 2017 21:13:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAE_XsMJGpKKdZ4E90tkzYwe+7KJ8JB5Rwrzga6aUi1LZG+wH4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/20/2017 2:09 PM, James Hughes wrote:
> On 20 April 2017 at 12:31, Kalle Valo <kvalo@codeaurora.org> wrote:
>> + linux-wireless
>>
>> James Hughes <james.hughes@raspberrypi.org> writes:
>>
>>> The driver was adding header information to incoming skb
>>> without ensuring the head was uncloned and hence writable.
>>>
>>> skb_cow_head has been used to ensure they are writable, however,
>>> this required some changes to error handling to ensure that
>>> if skb_cow_head failed it was not ignored.
>>>
>>> This really needs to be reviewed by someone who is more familiar
>>> with this code base to ensure any deallocation of skb's is
>>> still correct.
>>>
>>> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
>>
>> You should also CC linux-wireless, otherwise patchwork won't see it.
>>
>> --
>> Kalle Valo
> 
> Thanks Kalle, I wasn't subscribed to wireless, but have now done so. I
> also failed to read the MAINTAINERS list correctly..
> 
> With regard to this particular patch, this is related to the recent
> patches to use skb_cow_head in a number of USB net drivers to ensure
> they can write headers correctly, and I suspect the same fault is
> possible/likely in other drivers outside the USB net realm, as this
> patch shows.
> 
> I'm not overly happy with the error handling in this patch, but that
> said, the error handling over this entire driver does strike me as
> suspect. Quite a few places where return codes are ignored, just in my
> quick examination. So not really sure how to proceed past this patch,
> if at all.

I would appreciate it if you can provide details about the code you 
consider suspect. I will respond on the patches soon.

Regards,
Arend

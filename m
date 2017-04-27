Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:30411 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S968102AbdD0Iy2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 04:54:28 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3R8sRdL024457
        for <linux-wireless@vger.kernel.org>; Thu, 27 Apr 2017 09:54:27 +0100
Received: from mail-wr0-f198.google.com (mail-wr0-f198.google.com [209.85.128.198])
        by mx07-00252a01.pphosted.com with ESMTP id 2a2eberpst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Thu, 27 Apr 2017 09:54:26 +0100
Received: by mail-wr0-f198.google.com with SMTP id w50so2476238wrc.4
        for <linux-wireless@vger.kernel.org>; Thu, 27 Apr 2017 01:54:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALLGbRJ=xWGBvWzj=SjfeHPV_c43JEaDbUNmP7=0g2=py0U=vQ@mail.gmail.com>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170426085337.181AA61493@smtp.codeaurora.org> <CALLGbR+dhPUjUJACQohnHd2RbN8BxrDeSz1SsVo2WAKYo5Gsuw@mail.gmail.com>
 <4d7ced43-4a95-f626-b66e-285c133c48c1@broadcom.com> <CAE_XsM+XRcnO+tQEPnntNYVObnpJwimXP1_41aqJPwnxHWxonQ@mail.gmail.com>
 <CALLGbRJ=xWGBvWzj=SjfeHPV_c43JEaDbUNmP7=0g2=py0U=vQ@mail.gmail.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Thu, 27 Apr 2017 09:54:25 +0100
Message-ID: <CAE_XsMJRKTm8sQJPjZJgF-uEwNHeuVCMm7fmMOLi-z_iZ0sO+Q@mail.gmail.com> (sfid-20170427_105444_657930_82783355)
Subject: Re: ath6kl: assure headroom of skbuff is writable in .start_xmit()
To: Steve deRosier <derosier@gmail.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 April 2017 at 05:55, Steve deRosier <derosier@gmail.com> wrote:
> On Wed, Apr 26, 2017 at 12:54 PM, James Hughes
> <james.hughes@raspberrypi.org> wrote:
>> On 26 April 2017 at 19:03, Arend Van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>>
>>>
>>> On 26-4-2017 17:44, Steve deRosier wrote:
>>>> On Wed, Apr 26, 2017 at 1:53 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>>>>> An issue was found brcmfmac driver in which a skbuff in .start_xmit()
>>>>>> callback was actually cloned. So instead of checking for sufficient
>>>>>> headroom it should also be writable. Hence use skb_cow_head() to
>>>>>> check and expand the headroom appropriately.
>>>>>>
>>>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>>>
>>>>> Steve, would you have time to run a quick test with this?
>>>>>
>>>>> Patch set to Deferred.
>>>>>
>>>>
>>>> Happy to give it a quick spin on both of my platforms.
>>>>
>
> @ Arend and James, thanks for the info. I understand it, but
> unfortunately I can't seem to replicate the problems on my platforms
> with the limited time I have available to test it. It also may have to
> do with my platforms having special custom bridging related code, or
> just me having setup too simple of a test.
>
> That said...
>
> @Kalle: I have tested on both my 6004 and 6003 platforms. I didn't
> notice any incorrect behavior in my testing. But I don't have a test
> setup that would have shown the original problem as reported on the
> brcm driver so I can't say that the change actually _fixes_ anything.
> Only that in my testing it doesn't seem to break anything.
>
> Tested-by: Steve deRosier <derosier@gmail.com>
>
> - Steve

It was quite difficult to reproduce on the Pi - in general the system
seems to recover from corrupted headers, but on the Pi the Wifi driver
was writing in some information to the header, then checking it again
later (after I think some sort of loopback, but not sure) - it was
corrupted. It requires BOTH drivers to have to same fault, i.e. both
failed to unclone, and it also required both drivers to be writing
something to the header in a place that was subsequently checked by
one of the drivers somehow to see if the data was valid. Even then it
only appeared to happen on certain packet types, in my case DHCP
packets using IPv6 seemed to kick it off.

So quite unpredictable when an error may occur.

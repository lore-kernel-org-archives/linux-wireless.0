Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38325 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdD0Ezu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 00:55:50 -0400
Received: by mail-wm0-f45.google.com with SMTP id r190so7031837wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 21:55:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE_XsM+XRcnO+tQEPnntNYVObnpJwimXP1_41aqJPwnxHWxonQ@mail.gmail.com>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170426085337.181AA61493@smtp.codeaurora.org> <CALLGbR+dhPUjUJACQohnHd2RbN8BxrDeSz1SsVo2WAKYo5Gsuw@mail.gmail.com>
 <4d7ced43-4a95-f626-b66e-285c133c48c1@broadcom.com> <CAE_XsM+XRcnO+tQEPnntNYVObnpJwimXP1_41aqJPwnxHWxonQ@mail.gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 26 Apr 2017 21:55:48 -0700
Message-ID: <CALLGbRJ=xWGBvWzj=SjfeHPV_c43JEaDbUNmP7=0g2=py0U=vQ@mail.gmail.com> (sfid-20170427_065559_604687_5DB3DD9D)
Subject: Re: ath6kl: assure headroom of skbuff is writable in .start_xmit()
To: James Hughes <james.hughes@raspberrypi.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 26, 2017 at 12:54 PM, James Hughes
<james.hughes@raspberrypi.org> wrote:
> On 26 April 2017 at 19:03, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>>
>> On 26-4-2017 17:44, Steve deRosier wrote:
>>> On Wed, Apr 26, 2017 at 1:53 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>>>> An issue was found brcmfmac driver in which a skbuff in .start_xmit()
>>>>> callback was actually cloned. So instead of checking for sufficient
>>>>> headroom it should also be writable. Hence use skb_cow_head() to
>>>>> check and expand the headroom appropriately.
>>>>>
>>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>>
>>>> Steve, would you have time to run a quick test with this?
>>>>
>>>> Patch set to Deferred.
>>>>
>>>
>>> Happy to give it a quick spin on both of my platforms.
>>>

@ Arend and James, thanks for the info. I understand it, but
unfortunately I can't seem to replicate the problems on my platforms
with the limited time I have available to test it. It also may have to
do with my platforms having special custom bridging related code, or
just me having setup too simple of a test.

That said...

@Kalle: I have tested on both my 6004 and 6003 platforms. I didn't
notice any incorrect behavior in my testing. But I don't have a test
setup that would have shown the original problem as reported on the
brcm driver so I can't say that the change actually _fixes_ anything.
Only that in my testing it doesn't seem to break anything.

Tested-by: Steve deRosier <derosier@gmail.com>

- Steve

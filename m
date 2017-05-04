Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29369 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753180AbdEDNIV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 09:08:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Steve deRosier <derosier@gmail.com>
CC: James Hughes <james.hughes@raspberrypi.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath6kl: assure headroom of skbuff is writable in .start_xmit()
Date: Thu, 4 May 2017 13:08:17 +0000
Message-ID: <87o9v8rcqn.fsf@kamboji.qca.qualcomm.com> (sfid-20170504_150825_253969_82AB00B4)
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
        <20170426085337.181AA61493@smtp.codeaurora.org>
        <CALLGbR+dhPUjUJACQohnHd2RbN8BxrDeSz1SsVo2WAKYo5Gsuw@mail.gmail.com>
        <4d7ced43-4a95-f626-b66e-285c133c48c1@broadcom.com>
        <CAE_XsM+XRcnO+tQEPnntNYVObnpJwimXP1_41aqJPwnxHWxonQ@mail.gmail.com>
        <CALLGbRJ=xWGBvWzj=SjfeHPV_c43JEaDbUNmP7=0g2=py0U=vQ@mail.gmail.com>
In-Reply-To: <CALLGbRJ=xWGBvWzj=SjfeHPV_c43JEaDbUNmP7=0g2=py0U=vQ@mail.gmail.com>       (Steve
 deRosier's message of "Wed, 26 Apr 2017 21:55:48 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> On Wed, Apr 26, 2017 at 12:54 PM, James Hughes
> <james.hughes@raspberrypi.org> wrote:
>> On 26 April 2017 at 19:03, Arend Van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>>
>>>
>>> On 26-4-2017 17:44, Steve deRosier wrote:
>>>> On Wed, Apr 26, 2017 at 1:53 AM, Kalle Valo <kvalo@codeaurora.org> wro=
te:
>>>>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>>>>> An issue was found brcmfmac driver in which a skbuff in .start_xmit(=
)
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

Yeah, I was mostly worried about regression. I didn't expect you to
replicate the bug. Thanks for testing, I'll add this patch to my queue.

--=20
Kalle Valo=

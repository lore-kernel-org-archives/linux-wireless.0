Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34056 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdGGOOO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 10:14:14 -0400
MIME-Version: 1.0
In-Reply-To: <87bmowd0mh.fsf@kamboji.qca.qualcomm.com>
References: <CAMuHMdWVYA4TejcTjOQh7CBfFwJ=q59pzvuHrpH91Kx=-BK9fg@mail.gmail.com>
 <c72d2e7a-195d-bcac-4ce5-f3051531664c@gmail.com> <87bmowd0mh.fsf@kamboji.qca.qualcomm.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 7 Jul 2017 16:14:13 +0200
Message-ID: <CAK8P3a1CAmHcywnzngo1UOE69ZZZDVbocVEUFt6Uyy05fpaK5w@mail.gmail.com> (sfid-20170707_161444_453411_0CF101AB)
Subject: Re: ath10k: ret used but uninitialized
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 7, 2017 at 12:04 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>
>>> With gcc 4.1.2:
>>>
>>> drivers/net/wireless/ath/ath10k/sdio.c: In function
>>> =E2=80=98ath10k_sdio_mbox_rxmsg_pending_handler=E2=80=99:
>>> drivers/net/wireless/ath/ath10k/sdio.c:676: warning: =E2=80=98ret=E2=80=
=99 may be used
>>> uninitialized in this function
>>>
>>>> +
>>>> +       *done =3D true;
>>>> +
>>>> +       /* Copy the lookahead obtained from the HTC register table int=
o our
>>>> +        * temp array as a start value.
>>>> +        */
>>>> +       lookaheads[0] =3D msg_lookahead;
>>>> +
>>>> +       timeout =3D jiffies + SDIO_MBOX_PROCESSING_TIMEOUT_HZ;
>>>
>>> Although very unlikely due to the long timeout, if the code is preempte=
d here,
>>> and the loop below never entered, ret will indeed be uninitialized.
>>>
>>> It's unclear to me what the proper initialization would be, though, so
>>> that's why I didn't send a patch.
>>>
>> I think it would be best to use 0 as initial value of ret in this case.
>> This will make all other interrupts be processed in a normal way.
>>
>> Kalle: Should I create a new patch (initializing ret with zero)?
>
> Yes, please send a new patch fixing this.
>
> But I don't like that much with the style of initialising ret to zero,
> it tends to hide things. Instead my preference is something like below
> where the error handling is more explicit and easier to find where it's
> exactly failing. But that's just an example how I would try to solve it,
> it still lacks the handling of -ECANCEL etc.

I think I would simply replace the "while() {}" loop with "do{} while()",
as that would guarantee it to be run at least once in a way that the
compiler can see.

       Arnd

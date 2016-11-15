Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33547 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbcKOSeb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 13:34:31 -0500
Received: by mail-wm0-f65.google.com with SMTP id u144so2828486wmu.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 10:34:30 -0800 (PST)
Subject: Re: [RFC 10/12] ath10k: Added QCA65XX hw definition
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
 <1479141222-8493-11-git-send-email-erik.stromdahl@gmail.com>
 <CA+BoTQmcyVQDOd2o0YDvepuLbSz76p8hetrWA6mWJeGxvbM8iQ@mail.gmail.com>
 <87wpg5qai1.fsf@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <0c1172f0-2e3b-6147-646c-adb98b9ea3b7@gmail.com> (sfid-20161115_193434_902538_93494DC1)
Date: Tue, 15 Nov 2016 19:34:28 +0100
MIME-Version: 1.0
In-Reply-To: <87wpg5qai1.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/15/2016 11:54 AM, Valo, Kalle wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
> 
>> On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
>>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>>> ---
>>>  drivers/net/wireless/ath/ath10k/hw.h |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
>>> index 46142e9..ef45ecf 100644
>>> --- a/drivers/net/wireless/ath/ath10k/hw.h
>>> +++ b/drivers/net/wireless/ath/ath10k/hw.h
>>> @@ -224,6 +224,7 @@ enum ath10k_hw_rev {
>>>         ATH10K_HW_QCA9377,
>>>         ATH10K_HW_QCA4019,
>>>         ATH10K_HW_QCA9887,
>>> +       ATH10K_HW_QCA65XX,
>>
>> Are you 100% positive that you're supporting all QCA65XX chips? The
>> rule of thumb is to avoid Xs as much as possible unless totally
>> perfectly completely sure.
> 
I admit that I am definitely not totally perfectly completely sure about
this :)
In fact, I don't have a clue what does numbers really mean. All I know
is that the chipset I am using is called QCA6584 which I think is an
automotive version of another chipses called QCA6574. I have tried to
google these numbers up, but it is really hard to find anything useful.
So I thought, hey, why don't I just add a few X'es in there and I have
support for both!

> But the thing is that nobody can't be absolutely sure as we never know
> what marketing comes up within few years again. So I would say that XX
> in chip names should be completely avoided to avoid any confusion. We
> already suffer from this in ath10k with QCA988X and QCA9888 which are
> different designs but the names overlap.
> 
> I haven't reviewed Erik's patches yet but I'm surprised why even a new
> enum value is needed here. I was assuming we could use ATH10K_HW_QCA6174
> because AFAIK they share the same design. Any particular reason for
> this?
> 
The reason for this was that the switch(hw_rev)-statement in
ath10k_core_create assigns ar->regs and ar->hw_values to structures
containing values that are not applicable for SDIO. I though that I
would potentially need other structures, but after investigating the
qca6174_regs struct, it seems that the values that are applicable for
SDIO are the same.
I will remove this enum and use ATH10K_HW_QCA6174 instead as you
propose. If for some reason I would need other regs and hw_values
structs in the future, we can figure out appropriate names then.

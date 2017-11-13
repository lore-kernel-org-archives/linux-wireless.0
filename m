Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:46058 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdKMWgh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 17:36:37 -0500
Received: by mail-ot0-f175.google.com with SMTP id b17so2965646oth.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 14:36:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87y3na7eei.fsf@qca.qualcomm.com>
References: <20171110025415.7854-1-drake@endlessm.com> <87y3na7eei.fsf@qca.qualcomm.com>
From: Daniel Drake <drake@endlessm.com>
Date: Tue, 14 Nov 2017 06:36:36 +0800
Message-ID: <CAD8Lp47uJbB27xZPH3dDqNuJcaNCGEsbpdqfK-h4+nzVLGk1aw@mail.gmail.com> (sfid-20171113_233641_554933_EE7E5D82)
Subject: Re: [v2] ath9k: add MSI support
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Russell Hu <rhu@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Robert Chang <rwchang@qti.qualcomm.com>,
        Aeolus Yang <aeolus@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "andy@infradead.org" <andy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 13, 2017 at 4:48 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Enabling MSI by default is just too invasive, ath9k is used in so many
> different enviroments that risk of regressions is high. MSI needs a lot
> of testing before we can even consider enabling it by default.

And it seems like we already found a regression here - the MSI Message
Data is being corrupted as described in my last mail. Can't be fixed
in firmware, but it would be good to have confirmation of the hardware
behavivour, and maybe some other solution is possible? Are you
following this up within Qualcomm?

>> I have tested your patch on Acer Aspire ES1-432. It does not work -
>> I still can't connect to wifi.
>> /proc/interrupts shows that no MSI interrupts are delivered, the
>> counters are 0.
>>
>> lspci -vv shows:
>>         Capabilities: [50] MSI: Enable+ Count=1/4 Maskable+ 64bit+
>>                 Address: 00000000fee0f00c  Data: 4142
>>                 Masking: 0000000e  Pending: 00000000
>>
>> So MSI is enabled and the vector number is 0x42 (decimal 66).
>> However my kernel log is now totally spammed with:
>>   do_IRQ: 0.64 No irq handler for vector
>>
>> My assumption here is that the ath9k hardware implementation of
>> MSI is buggy, and it is therefore corrupting the MSI vector number
>> by zeroing out the lower 2 bits (e.g. 66 -> 64).

Thanks
Daniel

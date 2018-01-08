Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:46324 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757211AbeAHXHx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 18:07:53 -0500
Received: by mail-oi0-f52.google.com with SMTP id d124so4909789oib.13
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jan 2018 15:07:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87bmi45yim.fsf@kamboji.qca.qualcomm.com>
References: <20171110025415.7854-1-drake@endlessm.com> <87y3na7eei.fsf@qca.qualcomm.com>
 <CAD8Lp47uJbB27xZPH3dDqNuJcaNCGEsbpdqfK-h4+nzVLGk1aw@mail.gmail.com>
 <87bmk5hx9x.fsf@kamboji.qca.qualcomm.com> <CAD8Lp455GLxVHves8gNbfm9dMUmhj1DOMyeiOk5Td7m2rAxYFA@mail.gmail.com>
 <CAD8Lp44BWhK7j5dKzHqqXTaR4uG9=-6oJd2NEsdM8oQYw0D8Bw@mail.gmail.com> <87bmi45yim.fsf@kamboji.qca.qualcomm.com>
From: Daniel Drake <drake@endlessm.com>
Date: Mon, 8 Jan 2018 17:07:51 -0600
Message-ID: <CAD8Lp45_v4bzAceGxGo_-zOyyVkL29S24XRjte8Em-g8XoLqvw@mail.gmail.com> (sfid-20180109_000758_051392_C74EA032)
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
        "andy@infradead.org" <andy@infradead.org>,
        "acelan.kao@canonical.com" <acelan.kao@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 8, 2018 at 6:24 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> (Adding AceLan)
>
> Daniel Drake <drake@endlessm.com> writes:
>
>> On Wed, Nov 15, 2017 at 7:38 AM, Daniel Drake <drake@endlessm.com> wrote:
>>> On Tue, Nov 14, 2017 at 8:15 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>>>> Can't be fixed in firmware, but it would be good to have confirmation
>>>>> of the hardware behavivour, and maybe some other solution is possible?
>>>>> Are you following this up within Qualcomm?
>>>>
>>>> No time to do that right now, sorry.
>>>
>>> I got several autoresponders from people on this thread from Qualcomm
>>> Taiwan. Would it be useful for us to drop off a sample of the affected
>>> product at your Taipei or Hsinchu office so that you can investigate
>>> further?
>>
>> Ping - how can we collaborate on this?
>
> Are you asking me? While looking at my todo list for this year I doubt I
> can find time to help with the MSI implementation or bugfixing.

So far you are the only Qualcomm person to reply to the many mails I
have written on this topic, so I appreciate the response. I have sunk
many hours into this unfortunate situation so I'd really appreciate if
you could point me to someone at Qualcomm who can provide a response.
I am willing to continue doing the hard work, but I do need some
Qualcomm help in getting past brick walls.

> But my plan is that first I would apply Russel's patch which makes it
> possible to enable MSI with a module parameter:
>
> https://patchwork.kernel.org/patch/9999249/

This isn't enough to fix many of the systems that are affected by this
issue. You add the parameter, enable it, and MSI support totally fails
to deliver any interrupts. Pasting again from earlier:

I have tested your patch on Acer Aspire ES1-432. It does not work - I
still can't connect to wifi.
/proc/interrupts shows that no MSI interrupts are delivered, the counters are 0.

lspci -vv shows:
        Capabilities: [50] MSI: Enable+ Count=1/4 Maskable+ 64bit+
                Address: 00000000fee0f00c  Data: 4142
                Masking: 0000000e  Pending: 00000000

So MSI is enabled and the vector number is 0x42 (decimal 66).
However my kernel log is now totally spammed with:
  do_IRQ: 0.64 No irq handler for vector

My assumption here is that the ath9k hardware implementation of MSI is
buggy, and it is therefore corrupting the MSI vector number by zeroing
out the lower 2 bits (e.g. 66 -> 64).

It would be very useful if Qualcomm could confirm if this behaviour is
really true.

For more info please see:
   https://marc.info/?l=linux-pci&m=150238260826803&w=2
   https://marc.info/?t=150631283200001&r=1&w=2
   https://marc.info/?l=linux-pci&m=150831581725596&w=2

Thanks,
Daniel

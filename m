Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:40376 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757011AbeAHOQX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 09:16:23 -0500
Received: by mail-qt0-f195.google.com with SMTP id u42so13716274qte.7
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jan 2018 06:16:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87bmi45yim.fsf@kamboji.qca.qualcomm.com>
References: <20171110025415.7854-1-drake@endlessm.com> <87y3na7eei.fsf@qca.qualcomm.com>
 <CAD8Lp47uJbB27xZPH3dDqNuJcaNCGEsbpdqfK-h4+nzVLGk1aw@mail.gmail.com>
 <87bmk5hx9x.fsf@kamboji.qca.qualcomm.com> <CAD8Lp455GLxVHves8gNbfm9dMUmhj1DOMyeiOk5Td7m2rAxYFA@mail.gmail.com>
 <CAD8Lp44BWhK7j5dKzHqqXTaR4uG9=-6oJd2NEsdM8oQYw0D8Bw@mail.gmail.com> <87bmi45yim.fsf@kamboji.qca.qualcomm.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 8 Jan 2018 16:16:21 +0200
Message-ID: <CAHp75VchLbC5qYpxqh0qoxsS9X27Jyn8MA5aJZHw+wToqJJOAg@mail.gmail.com> (sfid-20180108_151629_113031_F9873AB1)
Subject: Re: [v2] ath9k: add MSI support
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Daniel Drake <drake@endlessm.com>,
        Russell Hu <rhu@qti.qualcomm.com>,
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

On Mon, Jan 8, 2018 at 2:24 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
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
>
> But my plan is that first I would apply Russel's patch which makes it
> possible to enable MSI with a module parameter:
>
> https://patchwork.kernel.org/patch/9999249/

Just in case it was missed during review:

The variables like

+ bool msi_enabled;

usually are redundant because PCI core keeps track of MSI/MSI-X status
(enabled/disabled)
So, if there is no MSI-X involved or MSI-X is handled in the same way
as MSI in the driver, one can use

pci_dev_msi_enabled() instead.

> Are everyone happy with this plan?

Sounds reasonable.

-- 
With Best Regards,
Andy Shevchenko

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52652 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753313AbdJMBMv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 21:12:51 -0400
Received: from mail-wm0-f72.google.com ([74.125.82.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <chia-lin.kao@canonical.com>)
        id 1e2oWw-0007cU-N6
        for linux-wireless@vger.kernel.org; Fri, 13 Oct 2017 01:12:50 +0000
Received: by mail-wm0-f72.google.com with SMTP id 136so7696672wmu.3
        for <linux-wireless@vger.kernel.org>; Thu, 12 Oct 2017 18:12:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFv23QkLJ0m112Y8iAGv+6DyFT52Hqnxq5Fy=ryWTWxu8oTXdw@mail.gmail.com>
References: <1506408099-18488-1-git-send-email-acelan.kao@canonical.com>
 <1506408099-18488-2-git-send-email-acelan.kao@canonical.com>
 <20170926064456.GA28611@infradead.org> <CAFv23Qm9kZLSqJ_BP1D7mWCxekq0nt3S8onT1ckH-AoHDBUDzw@mail.gmail.com>
 <20170926140413.GA19977@infradead.org> <878th14kde.fsf@kamboji.qca.qualcomm.com>
 <CAFv23Qn4OMuHaSA6UG+Q7L1sTt+ZO8T-JYVaBM1FxZtGNxOhdQ@mail.gmail.com>
 <CAD8Lp46mdgbfCGY_i=N7FB1rMfL0KA0VFQxJESxshe4Cn6k4+Q@mail.gmail.com> <CAFv23QkLJ0m112Y8iAGv+6DyFT52Hqnxq5Fy=ryWTWxu8oTXdw@mail.gmail.com>
From: AceLan Kao <acelan.kao@canonical.com>
Date: Fri, 13 Oct 2017 09:12:49 +0800
Message-ID: <CAFv23Q=dFRfxXQnY3pu_zV-yK9yaw-t3-Kn2q9YFFuyB9jJMog@mail.gmail.com> (sfid-20171013_031316_583811_A8704713)
Subject: Re: [PATCH 2/6] ath9k: add a quirk to set use_msi automatically
To: Daniel Drake <drake@endlessm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Christoph Hellwig <hch@infradead.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

After applied the 2 commits you mentioned in the email, ath9k works.

https://marc.info/?l=linux-wireless&m=150631274108016&w=2
https://github.com/endlessm/linux/commit/739c7a924db8f4434a9617657

Best regards,
AceLan Kao.

2017-10-05 14:39 GMT+08:00 AceLan Kao <acelan.kao@canonical.com>:
> Hi all,
>
> Please drop my patches, Qualcomm is working internally and will submit
> the MSI patch by themselves.
> Thanks.
>
> Hi Daniel,
>
> I'll try your patches tomorrow.
>
> Best regards,
> AceLan Kao.
>
> 2017-10-02 12:21 GMT+08:00 Daniel Drake <drake@endlessm.com>:
>> Hi AceLan,
>>
>> On Thu, Sep 28, 2017 at 4:28 PM, AceLan Kao <acelan.kao@canonical.com> wrote:
>>> Hi Daniel,
>>>
>>> I've tried your patch, but it doesn't work for me.
>>> Wifi can scan AP, but can't get connected.
>>
>> Can you please clarify which patch(es) you have tried?
>>
>> This is the base patch which adds the infrastructure to request
>> specific MSI IRQ vectors:
>> https://marc.info/?l=linux-wireless&m=150631274108016&w=2
>>
>> This is the ath9k MSI patch which makes use of that:
>> https://github.com/endlessm/linux/commit/739c7a924db8f4434a9617657
>>
>> If you were already able to use ath9k MSI interrupts without specific
>> consideration for which MSI vector numbers were used, these are the
>> possible explanations that spring to mind:
>>
>> 1. You got lucky and it picked a vector number that is 4-aligned. You
>> can check this in the "lspci -vvv" output. You'll see something like:
>> Capabilities: [50] MSI: Enable+ Count=1/4 Maskable+ 64bit+
>>         Address: 00000000fee0300c  Data: 4142
>> The lower number is the vector number. In my example here 0x42 (66) is
>> not 4-aligned so the failure condition will be hit.
>>
>> 2. You are using interrupt remapping, which I suspect may provide a
>> high likelihood of MSI interrupt vectors being 4-aligned. See if
>> /proc/interrupts shows the IRQ type as IR-PCI-MSI
>> Unfortunately interrupt remapping is not available here,
>> https://lists.linuxfoundation.org/pipermail/iommu/2017-August/023717.html
>>
>> 3. My assumption that all ath9k hardware corrupts the MSI vector
>> number could wrong. However we've seen this on different wifi modules
>> in laptops produced by different OEMs and ODMs, so it seems to be a
>> somewhat widespread problem at least.
>>
>> 4. My assumption that ath9k hardware is corrupting the MSI vector
>> number could be wrong; maybe another component is to blame, could it
>> be a BIOS issue? Admittedly I don't really know how I can debug the
>> layers inbetween seeing the MSI Message Data value disagree with the
>> vector number being handled inside do_IRQ().
>>
>> Daniel

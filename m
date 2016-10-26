Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35490 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932320AbcJZUZ0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 16:25:26 -0400
Received: by mail-wm0-f52.google.com with SMTP id e69so56282232wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2016 13:25:26 -0700 (PDT)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Matthias Klein <matthias.klein@optimeas.de>,
        Michal Kazior <michal.kazior@tieto.com>,
        Jonas Gorski <jonas.gorski@gmail.com>
References: <em1c0906d6-d30a-4f2c-bafb-bfec0d18a58d@nb-mak>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Oliver Zemann <oliver.zemann@gmail.com>
Message-ID: <7991f55c-ce11-9261-5c8f-3ff8c051b6d1@gmail.com> (sfid-20161026_222531_345639_6CB7E82C)
Date: Wed, 26 Oct 2016 22:25:24 +0200
MIME-Version: 1.0
In-Reply-To: <em1c0906d6-d30a-4f2c-bafb-bfec0d18a58d@nb-mak>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>
>> I (naively) went through pci/pm git log and found the following was
>> applied on 4.7-rc2 (i.e. prior to 4.7 release):
>>
>>  commit 006d44e49a259b39947366728d65a873a19aadc0
>>  Author: Mika Westerberg <mika.westerberg@linux.intel.com>
>>  Date:   Thu Jun 2 11:17:15 2016 +0300
>>
>>      PCI: Add runtime PM support for PCIe ports
>>
>> From reading the commit log it seems to me like it could be it.
>>
>> ath10k tries to wake up the device during probing before it starts
>> talking to it and it does so through MMIO/PCI config space. If it's
>> not mapped properly then driver will not be able to wake it up and
>> will timeout waiting for it.
>>
>> Can you try cherry-picking it into your 4.4.24 and see if it helps?
>>
>>
> Thanks for the help!
>
> Until now I did not compile a kernel for the board.
> I will give it a try and come back with the results ...
>
>
> Best regards,
> Matthias
>
Any news on that? I am in contact with the support of SolidRun 
(clearfog). Unfortunately they will stay at 4.4.x - no upgrade to 4.8 
nor 4.9 planned. Unfortunately the commit (006d44e) is incompatible to 
4.4. because pci_dev does not know bridge_d3

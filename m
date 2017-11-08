Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:43881 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdKHKiO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 05:38:14 -0500
Received: by mail-wr0-f196.google.com with SMTP id 4so1983662wrt.0
        for <linux-wireless@vger.kernel.org>; Wed, 08 Nov 2017 02:38:13 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
To: Simon Shields <simon@lineageos.org>
References: <20171104132421.GA1541@archbox.home> <5A004099.90200@broadcom.com>
 <20171106112726.GA25134@lineageos.org> <5A019463.9060701@broadcom.com>
 <20171107133112.GA1323@lineageos.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, devicetree@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A02DE93.8030502@broadcom.com> (sfid-20171108_113820_355986_6A1ED2DA)
Date: Wed, 8 Nov 2017 11:38:11 +0100
MIME-Version: 1.0
In-Reply-To: <20171107133112.GA1323@lineageos.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Stefan

On 11/7/2017 2:31 PM, Simon Shields wrote:
> Hi Arend,
>
> On Tue, Nov 07, 2017 at 12:09:23PM +0100, Arend van Spriel wrote:
>> On 11/6/2017 12:27 PM, Simon Shields wrote:
>>> On Mon, Nov 06, 2017 at 11:59:37AM +0100, Arend van Spriel wrote:
>>>> On 11/4/2017 2:24 PM, Simon Shields wrote:
>>>>> Some boards use an external 32khz clock for low-power
>>>>> mode timing. Make sure the clock is powered on while the chipset
>>>>> is active.
>>>>
>>>> Do you have such a board? With the little documentation I can get my hands
>>>> on here I wonder whether the clock needs to be enabled before the device is
>>>> powered. If you have the hardware I would like to check some registers in
>>>> the device.
>>>>
>>>
>>> Yes. Trats2 (exynos4412-based) has such a setup. The BCM4334 works fine
>>> with this patch and one more that enables the WL_REG_EN pin when
>>> brcmfmac is probed.
>>
>> Ok. So this is exactly the thing I was wondering about. So it makes me
>> curious how the WL_REG_EN patch looks like. Can you provide that?
>>
>
> Here[0] is a link to the patch in its current state. Obviously, it's not
> ready at all for mainlining :-)
>
> [0]: https://github.com/fourkbomb/linux/commit/436e59e58b44d856c186fc4767560cecbcbc0c59.patch

Thanks. Indeed doing it in module_init of brcmfmac is not going to fly. 
Actually the MMC stack has a mechanism to power the SDIO device. This 
can be configured through the device tree [1]. I just checked and it 
actually includes specifying the external clock as well.

Regards,
Arend

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:54134 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752424AbdKGLJ0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 06:09:26 -0500
Received: by mail-qt0-f193.google.com with SMTP id n61so14644035qte.10
        for <linux-wireless@vger.kernel.org>; Tue, 07 Nov 2017 03:09:26 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
To: Simon Shields <simon@lineageos.org>
References: <20171104132421.GA1541@archbox.home> <5A004099.90200@broadcom.com>
 <20171106112726.GA25134@lineageos.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, devicetree@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A019463.9060701@broadcom.com> (sfid-20171107_120940_088546_137CF0F3)
Date: Tue, 7 Nov 2017 12:09:23 +0100
MIME-Version: 1.0
In-Reply-To: <20171106112726.GA25134@lineageos.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/6/2017 12:27 PM, Simon Shields wrote:
> On Mon, Nov 06, 2017 at 11:59:37AM +0100, Arend van Spriel wrote:
>> On 11/4/2017 2:24 PM, Simon Shields wrote:
>>> Some boards use an external 32khz clock for low-power
>>> mode timing. Make sure the clock is powered on while the chipset
>>> is active.
>>
>> Do you have such a board? With the little documentation I can get my hands
>> on here I wonder whether the clock needs to be enabled before the device is
>> powered. If you have the hardware I would like to check some registers in
>> the device.
>>
>
> Yes. Trats2 (exynos4412-based) has such a setup. The BCM4334 works fine
> with this patch and one more that enables the WL_REG_EN pin when
> brcmfmac is probed.

Ok. So this is exactly the thing I was wondering about. So it makes me 
curious how the WL_REG_EN patch looks like. Can you provide that?

> Without this patch (and only enabling WL_REG_EN), the chip is detected but
> attempting to initialise it fails with a bunch of timeouts.

I would be interested in seeing a detailed log of that. Could you 
provide that? You need to build the driver with CONFIG_BRCMDBG and pass 
module parameter 'debug=0x1416' upon insmod/modprobe.

Regards,
Arend

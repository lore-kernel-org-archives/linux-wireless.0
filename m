Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788B6C677FF
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 16:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB7A20659
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 16:04:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CB7A20659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=theobroma-systems.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbeJKXch convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 19:32:37 -0400
Received: from vegas.theobroma-systems.com ([144.76.126.164]:59973 "EHLO
        mail.theobroma-systems.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729014AbeJKXch (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 19:32:37 -0400
Received: from [86.59.122.178] (port=60496 helo=[10.2.146.249])
        by mail.theobroma-systems.com with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <christoph.muellner@theobroma-systems.com>)
        id 1gAdS6-0007KO-9B; Thu, 11 Oct 2018 18:04:42 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: brcmfmac with BCM4359 on arm64 (RK3399) and SDIO
From:   =?utf-8?Q?Christoph_M=C3=BCllner?= 
        <christoph.muellner@theobroma-systems.com>
In-Reply-To: <fabdecc1-f032-789e-058f-2c62442b12c0@theobroma-systems.com>
Date:   Thu, 11 Oct 2018 18:04:41 +0200
Cc:     "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C9DFBEBB-4481-4CBA-AE10-92A20C815D4F@theobroma-systems.com>
References: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
 <CA+8PC_dkJAPR2C0DsOWRb__RrijbZZ43MM1gtKGjsMxdTGwsZQ@mail.gmail.com>
 <fabdecc1-f032-789e-058f-2c62442b12c0@theobroma-systems.com>
To:     Franky Lin <franky.lin@broadcom.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
X-Mailer: Apple Mail (2.3445.6.18)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Franky and Arend,

today I could get a SDIO Wifi module, which includes a BCM43455.
I was able to get this up and running without any issues with the brcmfmac
driver and a 4.19 kernel. For me that's enough evidence to say that the SDIO
driver works.

However, the BCM4359 still does not work.
It times out in brcmf_sdio_firmware_callback(), while enabling func2.

I've inserted tons of debug log outputs in both, the DHD driver and the
brcmfmac driver, and compared them. Differences which I've found so far
are: a) brcmfmac strips out whitespaces from nvram contents and
b) DHD downloads firmware first and brcmfmac downloads nvram first.
I've adapted the DHD driver to behave like brcmfmac in both cases
and it still works.

I've increased the timeout for enabling func2 from 3 seconds to 10 seconds,
but that did not help.

Any ideas left?

Thanks,
Christoph


> On 09.10.2018, at 22:55, Christoph Müllner <christoph.muellner@theobroma-systems.com> wrote:
> 
> Hi Franky,
> 
> thank's for your help.
> 
> As the BCM4359 is already supported (as PCIe device) in the brcmfmac
> driver, I assumed that base addresses will be correct.
> But having a closer look it is indeed the problematic part.
> I've temporary fixed the return value in brcmf_chip_tcm_rambase
> to the one matching the DHD's output and the SDIO errors are gone:
> 
> bcmdhd (4.4):
> [   15.701860] dhdsdio_write_vars: varaddr=0x23f1e8
> [   15.707024] dhdsdio_write_vars: varsize=3604
> [   15.711830] dhdsdio_write_vars: bus->dongle_ram_base=0x160000
> [   15.718221] dhdsdio_write_vars: bus->ramsize=917504
> [   15.723649] dhdsdio_write_vars: bus->varsz=3601
> [   15.752063] dhdsdio_write_vars: Download, Upload and compare of NVRAM
> succeeded.
> 
> brcmfmac (4.19):
> [    7.773752] brcmf_sdio_download_nvram: address=0x25f1f0
> [    7.782824] brcmf_sdio_download_nvram: bus->ci->ramsize=917504
> [    7.792544] brcmf_sdio_download_nvram: varsz=3600
> [    7.800926] brcmf_sdio_download_nvram: bus->ci->rambase=0x180000
> [    7.816106] brcmfmac: brcmf_sdiod_ramrw: membytes transfer failed
> [    7.835253] brcmfmac: brcmf_sdio_verifymemory: error -84 on reading
> 2048 membytes at 0x0025f1f0
> 
> brcmfmac (4.19-fixedoffset):
> [    7.625436] brcmf_sdio_download_nvram: address=0x23f1f0
> [    7.634582] brcmf_sdio_download_nvram: bus->ci->ramsize=917504
> [    7.644284] brcmf_sdio_download_nvram: varsz=3600
> [    7.652641] brcmf_sdio_download_nvram: bus->ci->rambase=0x160000
> 
> Unfortunately I still don't get a wlan0 interface (and more important:
> no error message from the brcmfmac driver).
> I'm now trying to get brcmfmac's tracing features up and running
> to see where the driver got stuck.
> 
> Anyways, thank you very much so far.
> 
> BR
> Christoph
> 
> 
> On 10/9/18 8:59 PM, Franky Lin wrote:
>> Hi Christoph,
>> 
>> On Tue, Oct 9, 2018 at 11:10 AM Christoph Müllner
>> <christoph.muellner@theobroma-systems.com> wrote:
>>> 
>>> Hi Arend,
>>> 
>>> recently I got an SDIO module, which includes a BCM4359.
>>> I tried to get it up and running via the SD card interface
>>> on a RK3399 SoC and succeeded in doing so with
>>> bcmdhd.1.579.77.41.x and a vendor kernel (based on Linux 4.4).
>>> All that was necessary was configure BCMDHD to run with
>>> in-band IRQs and use a GPIO as gpio_wl_reg_on.
>>> 
>>> Since I can run a mainline kernel as well, I gave it a try and
>>> tried brcmfmac on Linux 4.19-rc7. As the BCM4359 is not in
>>> the list of supported SDIO devices, but is supported USB device,
>>> I've created a patch (attached), which adds the support for that device.
>>> Additionally I've patched my DTS to include the WL_REG_ON
>>> pin as part of mmc-pwrseq-simple's reset-gpios and added
>>> a bcm4329-fmac node in the mmc node.
>>> 
>>> During bootup I see messages from brcmfmac, which indicate
>>> that the BCM4359 has been found, but loading the nvram file
>>> continuously fails:
>>> 
>>>> [    5.993741] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4359-sdio for chip BCM4359/9
>>>> [...]
>>>> [    7.987167] brcmfmac: brcmf_sdiod_ramrw: membytes transfer failed
>>>> [    8.008715] brcmfmac: brcmf_sdio_verifymemory: error -84 on reading 2048 membytes at 0x0025f1f0
>>>> [    8.021182] brcmfmac: brcmf_sdio_download_firmware: dongle nvram file download failed
>> 
>> Does it always fail at nvram verification? If so please help to get
>> the address and varsz in brcmf_sdio_download_nvram. Also their
>> equivalent in bcmdhd which should be varaddr and varsize in
>> dhdsdio_write_vars.
>> 
>> Thanks,
>> --Franky
>> 
>>> That -84 means EILSEQ, which is the error value, which represents
>>> a CRC error during SDIO data exchange (returned by the function dw_mci_data_complete()
>>> in the MMC driver).
>>> 
>>> To address this, I've reduced the clock speed (in several steps) to 400 kHz
>>> (and verified the clock signal on an oscilloscope), but the issue persists.
>>> I've also tried to use Linux 4.14.74, where I see the same issue.
>>> 
>>> I can confirm that the MMC interface works in general (I can use an SD card
>>> to host my rootfs).
>>> 
>>> FWIW I'm using the same exact same firmware and nvram file for the DHD driver
>>> and the brcmfmac.
>>> 
>>> Do you have any ideas how to debug this issue?
>>> 
>>> Thanks,
>>> Christoph
>>> 
>>> 
>>> 
>>> --
>>> Christoph Müllner
>>> Theobroma Systems Design und Consulting GmbH
>>> Seestadtstraße 27 (Aspern IQ), 1220 Wien, Austria
>>> Phone: +43 1 236 98 93-409, Fax: +43 1 236 98 93-9
>>> http://www.theobroma-systems.com
>>> 
>>> 
>>> 
>>> 


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34943 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752155AbdGYOuB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 10:50:01 -0400
Received: by mail-wm0-f66.google.com with SMTP id r77so3427995wmd.2
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2017 07:50:01 -0700 (PDT)
From: Rafal <fatwildcat@gmail.com>
Date: Tue, 25 Jul 2017 16:49:53 +0200 (CEST)
To: Arend van Spriel <arend.vanspriel@broadcom.com>
cc: Rafal <fatwildcat@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: brcmfmac: 43430, additional delay after core out of reset
In-Reply-To: <59773630.5020407@broadcom.com>
Message-ID: <alpine.DEB.2.20.1707251614560.4934@wilk> (sfid-20170725_165006_606006_17CC1FC6)
References: <alpine.DEB.2.20.1707211817260.11359@wilk> <59773630.5020407@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 25 Jul 2017, Arend van Spriel wrote:

> On 7/21/2017 6:20 PM, Rafal wrote:
>> Again, ap6212 device on board. When the module gets unloaded and then
>> loaded again, sometimes the driver fails to bring up the device - it
>> stops with the following errors:
>> 
>> [  125.668000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command
>> and terminate frame
>> [  125.676000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command
>> and terminate frame
>> [  125.680000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command
>> and terminate frame
>> [  125.684000] brcmfmac: brcmf_sdio_dpc: failed backplane access over
>> SDIO, halting operation
>> [  125.684000] brcmfmac: brcmf_proto_bcdc_query_dcmd:
>> brcmf_proto_bcdc_msg failed w/status -84
>> [  125.684000] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr
>> failed, -84
>> [  125.684000] brcmfmac: brcmf_bus_started: failed: -84
>> 
>> I have made some investigations and it looks the problem is caused by
>> too short time between getting CM3 core out of reset and first
>> communication attempt with the device. It looks the device needs about
>> 50ms to boot up. Usually the appropriate delay is introduced by function
>> sdio_enable_func which is called just after activation of the core to
>> enable F2 function on device. Usually the sdio function introduces the
>> needed 50ms delay and everything is OK. But sometimes the function
>> returns immediately. In this case the driver breaks down with the above
>> error. But if the additional delay is added in place of
>> sdio_enable_func, everything is okay.
>
> Hi Rafal,
>
> That is an interesting find. I took a dive into the SDIO code. After enabling 
> F2 there are actually three signals from the device that indicate its 
> readiness to handle communication with the host. However, none of them are 
> waited for before activating higher layer operations in the driver. So 
> instead of the delay it may be better to wait for the device to come up 
> properly and indicate its readiness. If we do need this delay I would rather 
> put it in sdio.c. Anyway, if I come up with a patch for testing would you be 
> willing to give it a spin. Thanks for digging deeper.
>
> Regards,
> Arend

I don't insist to add the fix. After sending this email I have started
to think about many things. But, at first, the facts. Below is the
output from two runs of the driver without the additional delay. I have
added some traces in the driver, namely, four pr_info calls: one call in
brcmf_chip_cm3_set_active, just before brcmf_chip_resetcore. Two calls
surrounding sdio_enable_func call to turn on the F2 and one call at
brcmf_c_preinit_dcmds begin, just before attempt to obtain
cur_etheraddr. Below are two outputs: one successful, one with failure:


[13065.924000] brcmfmac: >> brcmf_chip_cm3_set_active: before brcmf_chip_resetcore
[13065.928000] brcmfmac: >> brcmf_sdio_firmware_callback: before sdio_enable_func
[13065.928000] brcmfmac: >> brcmf_sdio_firmware_callback: after sdio_enable_func
[13065.928000] brcmfmac: >> brcmf_c_preinit_dcmds: begin
[13065.928000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command and terminate frame


[13211.944000] brcmfmac: >> brcmf_chip_cm3_set_active: before brcmf_chip_resetcore
[13211.948000] brcmfmac: >> brcmf_sdio_firmware_callback: before sdio_enable_func
[13211.984000] brcmfmac: >> brcmf_sdio_firmware_callback: after sdio_enable_func
[13211.984000] brcmfmac: >> brcmf_c_preinit_dcmds: begin
[13211.984000] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jun  6 2014 14:50:39 version 7.10.226.49 (r) FWID 01-8962686a


As you can see in the first output, it was only one tick between core
reset and getting cur_etheraddr iovar (device has 250Hz timer). In
second output it was some delay in sdio_enable_func, about 40ms. It is
not an accident - always when sdio_enable_func returns immediately,
gettting iovar fails and always when sdio_enable_func waits, getting
iovar finishes successfully.

You can believe me that F2 function is disabled before the enable call in
both cases, i.e. SDIO_CCCR_IOEx register is set to 2. You can believe me
also that sleep added before brcmf_chip_resetcore does not help, but
sleep added just after brcmf_chip_resetcore - helps.

Now, what are my doubts. I'm wondering why enable_timeout for F1 is set
to 0 but for F2 is set to 3000 (3 seconds)? Does it mean that
SDIO_CCCR_IORx register value should be changed by device (firmware?)
when it is ready to operate, but from some reason it responds sometimes
when is not ready? I'm not familiar with the ideas, how it should
work. Is it a bug in the ap6212 device firmware? If so, the problem
occurrence may depend not only on the chip version, but also on firmware
version?

Rafal

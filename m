Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:33219 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbdGYMOn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 08:14:43 -0400
Received: by mail-wr0-f171.google.com with SMTP id v105so87942914wrb.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2017 05:14:43 -0700 (PDT)
Message-ID: <59773630.5020407@broadcom.com> (sfid-20170725_141448_182425_8CD2F7AA)
Date: Tue, 25 Jul 2017 14:14:40 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Rafal <fatwildcat@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: brcmfmac: 43430, additional delay after core out of reset
References: <alpine.DEB.2.20.1707211817260.11359@wilk>
In-Reply-To: <alpine.DEB.2.20.1707211817260.11359@wilk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/21/2017 6:20 PM, Rafal wrote:
> Again, ap6212 device on board. When the module gets unloaded and then
> loaded again, sometimes the driver fails to bring up the device - it
> stops with the following errors:
>
> [  125.668000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command
> and terminate frame
> [  125.676000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command
> and terminate frame
> [  125.680000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command
> and terminate frame
> [  125.684000] brcmfmac: brcmf_sdio_dpc: failed backplane access over
> SDIO, halting operation
> [  125.684000] brcmfmac: brcmf_proto_bcdc_query_dcmd:
> brcmf_proto_bcdc_msg failed w/status -84
> [  125.684000] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr
> failed, -84
> [  125.684000] brcmfmac: brcmf_bus_started: failed: -84
>
> I have made some investigations and it looks the problem is caused by
> too short time between getting CM3 core out of reset and first
> communication attempt with the device. It looks the device needs about
> 50ms to boot up. Usually the appropriate delay is introduced by function
> sdio_enable_func which is called just after activation of the core to
> enable F2 function on device. Usually the sdio function introduces the
> needed 50ms delay and everything is OK. But sometimes the function
> returns immediately. In this case the driver breaks down with the above
> error. But if the additional delay is added in place of
> sdio_enable_func, everything is okay.

Hi Rafal,

That is an interesting find. I took a dive into the SDIO code. After 
enabling F2 there are actually three signals from the device that 
indicate its readiness to handle communication with the host. However, 
none of them are waited for before activating higher layer operations in 
the driver. So instead of the delay it may be better to wait for the 
device to come up properly and indicate its readiness. If we do need 
this delay I would rather put it in sdio.c. Anyway, if I come up with a 
patch for testing would you be willing to give it a spin. Thanks for 
digging deeper.

Regards,
Arend

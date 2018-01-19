Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:45474 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbeASIVw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 03:21:52 -0500
Received: by mail-wm0-f46.google.com with SMTP id i186so1685256wmi.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jan 2018 00:21:52 -0800 (PST)
Subject: Re: sdio failure to initialize on warm boot.
To: Kyle Evans <kvans32@gmail.com>
References: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com>
 <5A55D325.60805@broadcom.com>
 <3842a299-cd14-65db-1222-6849bc95ef74@gmail.com>
 <5A59CF17.6040706@broadcom.com> <20180118172804.GA1170@localhost.localdomain>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A61AA9E.6000505@broadcom.com> (sfid-20180119_092156_783621_BD685E1B)
Date: Fri, 19 Jan 2018 09:21:50 +0100
MIME-Version: 1.0
In-Reply-To: <20180118172804.GA1170@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/18/2018 6:50 PM, Kyle Evans wrote:
> * Arend van Spriel <arend.vanspriel@broadcom.com>:
>> On 1/12/2018 9:18 PM, Kyle Evans wrote:
>>> 2) After reboot I get this nasty error...
>>> [    0.000000] Kernel command line: console=tty0 selinux=0
>>> video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
>>> [    2.269750] mmc0: Invalid maximum block size, assuming 512 bytes
>>> [    2.330010] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci]
>>> using ADMA
>>> [    2.645242] mmc0: error -110 whilst initialising SDIO card
>>
>> Ok. I suppose you mean a warm reboot. So I suppose the card is not
>> properly power cycled. If your SDHCI controller driver (is it
>> sdhci-acpi?) is loaded as a module, you could try to unload it and load
>> it again. Let me know if that works for you to confirm my guess.
>
> Your guess is correct. The following brings up wifi after failure to do
> so during warm boot.
>
> modprobe -r sdhci-tegra; modprobe sdhci-tegra;

Do you know if your uses a device tree and where I can find it? 
Typically, there is a GPIO to the wifi device that needs to be toggled 
using mmc powerseq.

Regards,
Arend

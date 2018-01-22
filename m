Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:36898 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbeAVJWP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 04:22:15 -0500
Received: by mail-qt0-f171.google.com with SMTP id d54so19065838qtd.4
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jan 2018 01:22:15 -0800 (PST)
Subject: Re: sdio failure to initialize on warm boot.
To: Kyle Evans <kvans32@gmail.com>
References: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com>
 <5A55D325.60805@broadcom.com>
 <3842a299-cd14-65db-1222-6849bc95ef74@gmail.com>
 <5A59CF17.6040706@broadcom.com> <20180118172804.GA1170@localhost.localdomain>
 <5A61AA9E.6000505@broadcom.com> <20180119160554.GA4162@localhost.localdomain>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A65AD44.6020506@broadcom.com> (sfid-20180122_102332_753492_A9DC13ED)
Date: Mon, 22 Jan 2018 10:22:12 +0100
MIME-Version: 1.0
In-Reply-To: <20180119160554.GA4162@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/19/2018 5:05 PM, Kyle Evans wrote:
> * Arend van Spriel <arend.vanspriel@broadcom.com>:
>> On 1/18/2018 6:50 PM, Kyle Evans wrote:
>>> * Arend van Spriel <arend.vanspriel@broadcom.com>:
>>>> On 1/12/2018 9:18 PM, Kyle Evans wrote:
>>>>> 2) After reboot I get this nasty error...
>>>>> [    0.000000] Kernel command line: console=tty0 selinux=0
>>>>> video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
>>>>> [    2.269750] mmc0: Invalid maximum block size, assuming 512 bytes
>>>>> [    2.330010] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci]
>>>>> using ADMA
>>>>> [    2.645242] mmc0: error -110 whilst initialising SDIO card
>>>>
>>>> Ok. I suppose you mean a warm reboot. So I suppose the card is not
>>>> properly power cycled. If your SDHCI controller driver (is it
>>>> sdhci-acpi?) is loaded as a module, you could try to unload it and load
>>>> it again. Let me know if that works for you to confirm my guess.
>>>
>>> Your guess is correct. The following brings up wifi after failure to do
>>> so during warm boot.
>>>
>>> modprobe -r sdhci-tegra; modprobe sdhci-tegra;
>>
>> Do you know if your uses a device tree and where I can find it?
>> Typically, there is a GPIO to the wifi device that needs to be toggled
>> using mmc powerseq.
>
> I had a hunch this is was the next step. This device did not ship with a
> DT, but I have one in the works. My initial trial & error has been met
> with error.

So I am getting predictable huh?

> This is what I have so far, which is wrong since adding pwrseq (boot panic):
> 	sdhci@c8000000 {
>                  compatible = "nvidia,tegra20-sdhci";
>                  reg = <0xc8000000 0x200>;
>                  interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
>                  clocks = <&tegra_car TEGRA20_CLK_SDMMC1>;
>                  resets = <&tegra_car 14>;
>                  reset-names = "sdhci";
>
>                  status = "okay";
>                  //power-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
>                  bus-width = <4>;
>                  keep-power-in-suspend;
>                  non-removable;
>                  mmc-pwrseq = <&wlan_rst>;
>
>                  brcmf: wifi@1 {
>                          compatible = "brcm,bcm4329-fmac";
>                          interrupt-parent = <&gpio>;
>                          interrupts = <TEGRA_GPIO(Y, 6) GPIO_ACTIVE_HIGH>,
>                                       <TEGRA_GPIO(S, 0) GPIO_ACTIVE_HIGH>;
>                          interrupt-names = "host-wake";

Always having a hard time reading this stuff. So does interrupts 
property state 2 interrupts here? If so, than interrupt-names should 
also have two names. Actually, according to the binding only a single 
interrupt should be given (only (S, 0) I think). Furthermore, you are 
missing the 'reg' property to specify the SDIO function, ie. "reg = <1>;".

>                  };
>          };
>
>          wlan_rst: sdhci0_pwrseq {
>                  compatible = "mmc-pwrseq-simple";
>                  reset-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_LOW>;
>          };

Ignoring the ext_clk stuff, the pwrseq-simple does following: upon power 
on, set reset-gpios to 1, power on bus, set reset-gpios back to 0, 
optionally wait for post_power_on_delay_ms. The pre-DT kernel stuff is 
different. It simply sets the reset gpio to 1 upon power on, and wait 
for 200ms leaving the gpio as is and does the same for power off.

TF101_SDIO_WOW seems for enabling host wakeup by the host-controller 
device for which I would expect the driver to call device_init_wakeup(). 
However, this functionality does not seem present in the sdhci-tegra driver.

Regards,
Arend

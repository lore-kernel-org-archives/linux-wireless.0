Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:37716 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbeAZIM6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 03:12:58 -0500
Received: by mail-it0-f47.google.com with SMTP id q8so914234itb.2
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jan 2018 00:12:58 -0800 (PST)
From: Kyle Evans <kvans32@gmail.com>
Date: Fri, 26 Jan 2018 05:45:16 -0500
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kyle Evans <kvans32@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: sdio failure to initialize on warm boot.
Message-ID: <20180126104516.GA1167@localhost.localdomain> (sfid-20180126_091303_217810_D91B6F00)
References: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com>
 <5A55D325.60805@broadcom.com>
 <3842a299-cd14-65db-1222-6849bc95ef74@gmail.com>
 <5A59CF17.6040706@broadcom.com>
 <20180118172804.GA1170@localhost.localdomain>
 <5A61AA9E.6000505@broadcom.com>
 <20180119160554.GA4162@localhost.localdomain>
 <5A65AD44.6020506@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A65AD44.6020506@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Arend van Spriel <arend.vanspriel@broadcom.com>:
> On 1/19/2018 5:05 PM, Kyle Evans wrote:
> > * Arend van Spriel <arend.vanspriel@broadcom.com>:
> >> On 1/18/2018 6:50 PM, Kyle Evans wrote:
> >>> * Arend van Spriel <arend.vanspriel@broadcom.com>:
> >>>> On 1/12/2018 9:18 PM, Kyle Evans wrote:
> >>>>> 2) After reboot I get this nasty error...
> >>>>> [    0.000000] Kernel command line: console=tty0 selinux=0
> >>>>> video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
> >>>>> [    2.269750] mmc0: Invalid maximum block size, assuming 512 bytes
> >>>>> [    2.330010] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci]
> >>>>> using ADMA
> >>>>> [    2.645242] mmc0: error -110 whilst initialising SDIO card
> >>>>
> >>>> Ok. I suppose you mean a warm reboot. So I suppose the card is not
> >>>> properly power cycled. If your SDHCI controller driver (is it
> >>>> sdhci-acpi?) is loaded as a module, you could try to unload it and load
> >>>> it again. Let me know if that works for you to confirm my guess.
> >>>
> >>> Your guess is correct. The following brings up wifi after failure to do
> >>> so during warm boot.
> >>>
> >>> modprobe -r sdhci-tegra; modprobe sdhci-tegra;
> >>
> >> Do you know if your uses a device tree and where I can find it?
> >> Typically, there is a GPIO to the wifi device that needs to be toggled
> >> using mmc powerseq.
> >
> > I had a hunch this is was the next step. This device did not ship with a
> > DT, but I have one in the works. My initial trial & error has been met
> > with error.
> 
> So I am getting predictable huh?

> 
> > This is what I have so far, which is wrong since adding pwrseq (boot panic):
> > 	sdhci@c8000000 {
> >                  compatible = "nvidia,tegra20-sdhci";
> >                  reg = <0xc8000000 0x200>;
> >                  interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
> >                  clocks = <&tegra_car TEGRA20_CLK_SDMMC1>;
> >                  resets = <&tegra_car 14>;
> >                  reset-names = "sdhci";
> >
> >                  status = "okay";
> >                  //power-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
> >                  bus-width = <4>;
> >                  keep-power-in-suspend;
> >                  non-removable;
> >                  mmc-pwrseq = <&wlan_rst>;
> >
> >                  brcmf: wifi@1 {
> >                          compatible = "brcm,bcm4329-fmac";
> >                          interrupt-parent = <&gpio>;
> >                          interrupts = <TEGRA_GPIO(Y, 6) GPIO_ACTIVE_HIGH>,
> >                                       <TEGRA_GPIO(S, 0) GPIO_ACTIVE_HIGH>;
> >                          interrupt-names = "host-wake";
> 
> Always having a hard time reading this stuff. So does interrupts 
> property state 2 interrupts here?

Ok, I've slimmed it down to only S,0-"host-wake".

> If so, than interrupt-names should 
> also have two names. Actually, according to the binding only a single 
> interrupt should be given (only (S, 0) I think). Furthermore, you are 
> missing the 'reg' property to specify the SDIO function, ie. "reg = <1>;".

I took the reg property out becuase it causes the below compiler
warnings. Putting it back in causes a black screen with no console
output. Any clues?

arch/arm/boot/dts/tegra20-tf101.dtb: Warning (reg_format): "reg"
property in /sdhci@c8000000/wifi@1 has invalid length (4 bytes)
(#address-cells == 2, #size-cells == 1)
arch/arm/boot/dts/tegra20-tf101.dtb: Warning (avoid_default_addr_size):
Relying on default #address-cells value for /sdhci@c8000000/wifi@1
arch/arm/boot/dts/tegra20-tf101.dtb: Warning (avoid_default_addr_size):
Relying on default #size-cells value for /sdhci@c8000000/wifi@1

> 
> >                  };
> >          };
> >
> >          wlan_rst: sdhci0_pwrseq {
> >                  compatible = "mmc-pwrseq-simple";
> >                  reset-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_LOW>;
> >          };
> 
> Ignoring the ext_clk stuff, the pwrseq-simple does following: upon power 
> on, set reset-gpios to 1, power on bus, set reset-gpios back to 0, 
> optionally wait for post_power_on_delay_ms. The pre-DT kernel stuff is 
> different. It simply sets the reset gpio to 1 upon power on, and wait 
> for 200ms leaving the gpio as is and does the same for power off.

So,,,, pwrseq is the wrong approach here?

	wlan_rst: sdhci0_pwrseq {
                compatible = "mmc-pwrseq-simple";
                reset-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
                //post-power-on-delay-ms = <200>;
                post-power-off-delay-us = <200>;
        };

I have tested with/without ACTIVE_LOW/HIGH, on/off-delay, all combinations. 
Using ACTIVE_HIGH, which is contrary to binding documentation, allows the sdhci
controller to enumerate. It does not enumerate with ACTIVE_LOW. no
combination loads brcmfmac.

I did the same with U,0, which is the rfkill resource, moving K,6 back to
power-gpios. This got me back to square one, works on cold boot only,
with any combination.

It is indicated that power off is were the problem is. On the other 
hand, it would seem that there should be a reset mechanism and we 
either have the wrong pin, or it is not being triggered properly.

> 
> TF101_SDIO_WOW seems for enabling host wakeup by the host-controller 
> device for which I would expect the driver to call device_init_wakeup(). 
> However, this functionality does not seem present in the sdhci-tegra driver.

I think I follow, is this in-band IRQ related?
I just don't understand what the host controller has to do with wireless wakeup,
since the wireless is part of a doughter card. Unless they both need to be
enabled for WOW to work. At any rate, WOW is of little importance at this time.
I was just curious where to put all of the pieces and it looks like
there is no room for all of the pieces.

-Kyle

> 
> Regards,
> Arend

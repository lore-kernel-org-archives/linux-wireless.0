Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32977 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab2AMQcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 11:32:18 -0500
Received: by bkuw12 with SMTP id w12so86893bku.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2012 08:32:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE7DoPZvEud7_uN_JEiJ0CzZ2BGfDdzNn_EdOnGThLSshFsoSw@mail.gmail.com>
References: <CAE7DoPZvEud7_uN_JEiJ0CzZ2BGfDdzNn_EdOnGThLSshFsoSw@mail.gmail.com>
Date: Fri, 13 Jan 2012 10:32:16 -0600
Message-ID: <CAE7DoPYGN1q2Ecv=j3fH0J9gr_+1Kot=tp_VkS9O=F3vA1CqwA@mail.gmail.com> (sfid-20120113_173222_297095_CB730AAA)
Subject: Re: ath5k: no interrupts
From: Ben Gardner <gardner.ben@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My issue had to do with broken ACPI on the LX board.
After disabling ACPI, the driver works perfectly.

Ben

On Thu, Jan 12, 2012 at 10:38 AM, Ben Gardner <gardner.ben@gmail.com> wrote:
> I am using Atheros AR5414 card in a custom Geode LX-based board.
> It is a mini-PCI card with PCI ID 168c:001b.
>
> Under the 2.6.25 kernel, the ath5k driver works.
> Under the 3.0.9 and 3.2.0 kernels, the card does not work.
> By 'does not work' I mean that it can't find any access points.  After digging
> a bit, it looks like interrupts are not occurring.
>
> Here is a snippet of the kernel log (Geode LX/3.0.9):
> [    1.712119] cfg80211: Calling CRDA to update world regulatory domain
> [    1.801089] ath5k 0000:00:0c.0: PCI INT A -> Link[LNKA] -> GSI 10
> (level, low) -> IRQ 10
> [    1.801270] ath5k 0000:00:0c.0: registered as 'phy0'
> [    2.468139] ath: EEPROM regdomain: 0x0
> [    2.468158] ath: EEPROM indicates default country code should be used
> [    2.468176] ath: doing EEPROM country->regdmn map search
> [    2.468200] ath: country maps to regdmn code: 0x3a
> [    2.468217] ath: Country alpha2 being used: US
> [    2.468233] ath: Regpair used: 0x3a
> [    2.468862] ieee80211 phy0: Selected rate control algorithm 'pid'
> [    2.471545] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
>
> ~ # cat /proc/interrupts
>           CPU0
>  0:      43630    XT-PIC-XT-PIC    timer
>  2:          0    XT-PIC-XT-PIC    cascade
>  3:          1    XT-PIC-XT-PIC
>  4:          1    XT-PIC-XT-PIC
>  8:          0    XT-PIC-XT-PIC    rtc0
>  9:          0    XT-PIC-XT-PIC    acpi
> 10:          0    XT-PIC-XT-PIC    ath
> 11:       2373    XT-PIC-XT-PIC    ehci_hcd:usb1, ohci_hcd:usb2, eth0
> 14:        418    XT-PIC-XT-PIC    pata_cs5536
> NMI:          0   Non-maskable interrupts
> LOC:          0   Local timer interrupts
> SPU:          0   Spurious interrupts
> PMI:          0   Performance monitoring interrupts
> IWI:          0   IRQ work interrupts
> ERR:          0
> MIS:          0
>
> The 'registers' from debugfs show that an interrupt is pending.
> ~ # cat /debug/ieee80211/phy1/ath5k/registers
> AR5K_CR                  0x00000004
> AR5K_RXDP                0x1f3524e0
> AR5K_CFG                 0x00000100
> AR5K_IER                 0x00000001
> AR5K_BCR                 0x00000000
> AR5K_RTSD0               0x00000000
> AR5K_RTSD1               0x00000000
> AR5K_TXCFG               0x00000015
> AR5K_RXCFG               0x00000005
> AR5K_RXJLA               0x1f3524f0
> AR5K_MIBC                0x00000001
> AR5K_TOPS                0x00000008
> AR5K_RXNOFRM             0x00000000
> AR5K_TXNOFRM             0x00000000
> AR5K_RPGTO               0x00000000
> AR5K_RFCNT               0x0000001f
> AR5K_MISC                0x00000000
> AR5K_QCUDCU_CLKGT        0x00de96a1
> AR5K_ISR                 0x00000000
> AR5K_PISR                0x00045005
> AR5K_SISR0               0x00000000
> AR5K_SISR1               0x00000000
> AR5K_SISR2               0x88800000
> AR5K_SISR3               0x00000000
> AR5K_SISR4               0x00000000
> AR5K_IMR                 0x00000000
> AR5K_PIMR                0x800814b5
> AR5K_SIMR0               0x00cf0000
> AR5K_SIMR1               0x004f0000
> AR5K_SIMR2               0x00070000
> AR5K_SIMR3               0x00000000
> AR5K_SIMR4               0x00000000
> AR5K_DCM_ADDR            0x00000012
> AR5K_DCCFG               0x00000000
> AR5K_CCFG                0x00000000
> AR5K_CPC0                0x00000000
> AR5K_CPC1                0x00000000
> AR5K_CPC2                0x00000000
> AR5K_CPC3                0x00000000
> AR5K_CPCOVF              0x00000000
> AR5K_RESET_CTL           0x00000000
> AR5K_SLEEP_CTL           0x00000000
> AR5K_INTPEND             0x00000001
> AR5K_SFR                 0x00000000
> AR5K_PCICFG              0x00000014
> AR5K_GPIOCR              0x00008000
> AR5K_GPIODO              0x00000001
> AR5K_SREV                0x000000a5
>
>
> For comparison, I also have an older Geode GX-based board with the same Atheros
> card.  The exact same 3.0.9 image works just fine on that board.
> Here is the same group of kernel logs:
> [    6.033111] cfg80211: Calling CRDA to update world regulatory domain
> [    6.455114] ath5k 0000:00:0d.0: guessed PCI INT A -> IRQ 11
> [    6.455965] ath5k 0000:00:0d.0: registered as 'phy0'
> [    7.228768] ath: EEPROM regdomain: 0x0
> [    7.228800] ath: EEPROM indicates default country code should be used
> [    7.228828] ath: doing EEPROM country->regdmn map search
> [    7.228865] ath: country maps to regdmn code: 0x3a
> [    7.228893] ath: Country alpha2 being used: US
> [    7.228918] ath: Regpair used: 0x3a
> [    7.230164] ieee80211 phy0: Selected rate control algorithm 'pid'
> [    7.234204] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
>
> The only significant difference is the line that shows the IRQ.
>
>
> At this point, I'm not sure if this is a problem with the ath5k driver or with
> the something else that changed in the kernel between the two versions, or with
> the CPU board itself.
>
> I have not yet done a bisect to see when the driver stopped working on the LX.
> I plan to do that next.
>
> Any suggestions as to what to look for would be helpful.
>
> Thanks,
> Ben

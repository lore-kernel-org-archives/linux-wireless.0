Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:42253 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYEOTpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 15:45:01 -0400
Received: by an-out-0708.google.com with SMTP id d40so128735and.103
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2008 12:44:59 -0700 (PDT)
Message-ID: <40f31dec0805151244o2438c3bfrbbe065ab58a7198@mail.gmail.com> (sfid-20080515_214521_760404_886935F7)
Date: Thu, 15 May 2008 22:44:59 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Zack Weinberg" <zackw@panix.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/5/14 Zack Weinberg <zackw@panix.com>:
> I have a shiny new Thinkpad T61 and I'd like to get its wireless
> chipset working with the ath5k driver.  I have tried
> compat-wireless-2008-05-07 on top of kernel 2.6.25.1 -- I get this in
> dmesg:
>
> # modprobe ath5k
> [15497.699573] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
> low) -> IRQ 17
> [15497.699607] PCI: Setting latency timer of device 0000:03:00.0 to 64
> [15497.699665] ath5k_pci 0000:03:00.0: registered as 'phy0'
> [15498.709122] ath5k phy0: failed to wakeup the MAC Chip
> [15498.709195] ACPI: PCI interrupt for device 0000:03:00.0 disabled
> [15498.709205] ath5k_pci: probe of 0000:03:00.0 failed with error -5
>
> # lspci -vnn -s 0000:03:00.0
> 03:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
> 802.11abg NIC [168c:1014] (rev 01)
>        Subsystem: IBM Device [1014:058a]
>        Flags: fast devsel, IRQ 17
>        Memory at df3f0000 (64-bit, non-prefetchable) [size=64K]
>        Capabilities: [40] Power Management version 2
>        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
>        Capabilities: [60] Express Legacy Endpoint, MSI 00
>        Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
>        Capabilities: [100] Advanced Error Reporting <?>
>        Capabilities: [140] Virtual Channel <?>
>        Kernel modules: ath5k
>
> ath_info does not work:
> # ath_info df3f0000
> Unable to read EEPROM Magic value!
>
> The old madwifi drivers don't work with this chip either:
> # modprobe ath_pci
> [  392.367300] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111,
> RF5112, RF2413, RF5413)
> [  392.379623] wlan: 0.9.4
> [  392.381431] ath_pci: 0.9.4
> [  392.381466] PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
> [  392.381472] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
> low) -> IRQ 17
> [  392.381488] PCI: Setting latency timer of device 0000:03:00.0 to 64
> [  392.385856] wifi%d: unable to attach hardware: 'Hardware didn't
> respond as expected' (HAL status 3)
> [  392.385870] ACPI: PCI interrupt for device 0000:03:00.0 disabled
>
> What can I do to help make this chip work in the near future?
>
> zw

Are you sure that ath5k from compat-wireless is being used and not the
one that comes with 2.6.25 ?
In ath5k that comes with 2.6.25 the fix Bob mentioned is not included
and PCI-E cards hang.
Have you tried blacklisting ath5k, power-cycle and only use
madwifi/ndiswrapper ?

If your card doesn't work even after disabling ath5k and power-cycle
(reboot won't work, you'll have to actually turn your system off and
on) then you might have some hw problem.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:25915 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919AbYENRYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 13:24:10 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2842632fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 10:24:08 -0700 (PDT)
Message-ID: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com> (sfid-20080514_192448_331054_2B8CA2FD)
Date: Wed, 14 May 2008 13:24:07 -0400
From: "Zack Weinberg" <zackw@panix.com>
To: linux-wireless@vger.kernel.org
Subject: Getting ath5k driver working with Thinkpad T61 [168c:1014]
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a shiny new Thinkpad T61 and I'd like to get its wireless
chipset working with the ath5k driver.  I have tried
compat-wireless-2008-05-07 on top of kernel 2.6.25.1 -- I get this in
dmesg:

# modprobe ath5k
[15497.699573] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[15497.699607] PCI: Setting latency timer of device 0000:03:00.0 to 64
[15497.699665] ath5k_pci 0000:03:00.0: registered as 'phy0'
[15498.709122] ath5k phy0: failed to wakeup the MAC Chip
[15498.709195] ACPI: PCI interrupt for device 0000:03:00.0 disabled
[15498.709205] ath5k_pci: probe of 0000:03:00.0 failed with error -5

# lspci -vnn -s 0000:03:00.0
03:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
802.11abg NIC [168c:1014] (rev 01)
	Subsystem: IBM Device [1014:058a]
	Flags: fast devsel, IRQ 17
	Memory at df3f0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
	Capabilities: [60] Express Legacy Endpoint, MSI 00
	Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Kernel modules: ath5k

ath_info does not work:
# ath_info df3f0000
Unable to read EEPROM Magic value!

The old madwifi drivers don't work with this chip either:
# modprobe ath_pci
[  392.367300] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111,
RF5112, RF2413, RF5413)
[  392.379623] wlan: 0.9.4
[  392.381431] ath_pci: 0.9.4
[  392.381466] PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
[  392.381472] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[  392.381488] PCI: Setting latency timer of device 0000:03:00.0 to 64
[  392.385856] wifi%d: unable to attach hardware: 'Hardware didn't
respond as expected' (HAL status 3)
[  392.385870] ACPI: PCI interrupt for device 0000:03:00.0 disabled

What can I do to help make this chip work in the near future?

zw

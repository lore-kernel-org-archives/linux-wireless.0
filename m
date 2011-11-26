Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esme.agmk.net ([217.73.31.59]:48178 "EHLO esme.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab1KZTBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Nov 2011 14:01:15 -0500
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pawel.sikora@agmk.net>
To: mcgrof@qca.qualcomm.com
Subject: ath9k module not fully operating.
Date: Sat, 26 Nov 2011 19:39:10 +0100
Cc: jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201111261939.10769.pawel.sikora@agmk.net> (sfid-20111126_200128_769115_0E326078)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

i have an asus laptop with following atheros wireless adapter:

03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
        Subsystem: AzureWave AW-NB037H 802.11bgn Wireless Half-size Mini PCIe Card [AR9002WB-1NGCD]
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at ddc00000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [60] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 00-15-17-ff-ff-24-14-12
        Capabilities: [170] Power Budgeting <?>
        Kernel driver in use: ath9k
        Kernel modules: ath9k

during latop startup the "wireless" led is turned off, kernel with udev load ath9k module

[    9.070238] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.070257] ath9k 0000:03:00.0: setting latency timer to 64
[    9.081908] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    9.082056] snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[    9.082241] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    9.083643] input: Asus WMI hotkeys as /devices/platform/asus-nb-wmi/input/input6
[    9.119760] ath: EEPROM regdomain: 0x60
[    9.119764] ath: EEPROM indicates we should expect a direct regpair map
[    9.119768] ath: Country alpha2 being used: 00
[    9.119771] ath: Regpair used: 0x60
[    9.131566] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    9.238212] asus_wmi: Backlight controlled by ACPI video driver
[    9.239078] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[    9.241745] Registered led device: ath9k-phy0
[    9.241756] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xffffc90001860000, irq=17

but the wpa_supplicant daemon finally can't establish link with accesspoint (reports rf-kill? error).
manual wireless enabling (Fn key + F2 key) fixes wpa_supplicant problems.
it looks like the ath9k module doesn't enable some hardware parts on system startup / laptop resume.
i've tested this issue with 3.1.2 and 3.2.0-rc3 git kernel sources.

BR,
Paweł.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40996 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3BYQeq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 11:34:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UA115-0005kj-8Q
	for linux-wireless@vger.kernel.org; Mon, 25 Feb 2013 17:35:03 +0100
Received: from c-68-53-95-0.hsd1.tn.comcast.net ([68.53.95.0])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 17:35:03 +0100
Received: from aaraines by c-68-53-95-0.hsd1.tn.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 17:35:03 +0100
To: linux-wireless@vger.kernel.org
From: Drew Raines <aaraines@gmail.com>
Subject: Re: drivers/net/wireless/iwlwifi/dvm/tx.c and arch/x86/kernel/apic/ipi.c: Kernel trace when roaming between different Access Points with the same ESSID
Date: Mon, 25 Feb 2013 10:01:54 -0600
Message-ID: <87d2vowff1.fsf@mid.raines.me> (sfid-20130225_173450_669857_0C9D90B8)
References: <CAD77+gQFfNvz02=0FWDq+KUGk5QO_MywWw=NBMk6YaFGNQ4+kA@mail.gmail.com>
	<CAD77+gTFDbNopgJjMv+BGJCbueR-k8Uiyq41DfOeF_t1oJm7EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Richard Hartmann wrote:

> Yet another one, this time during high USB i/o load.

I've been suffering this issue as well since some version of the
experimental Wheezy packages of 3.7.x, but it's also happening with a
make-kpkg build of 3.8.

If I switch APs in my house, my connection immediately fails and it
won't work until I power the radio off and back on with the hardware
switch on the side of the laptop.  I can't even `modprobe -r iwlwifi'
the driver ("FATAL: Module iwlwifi is in use.").

I do not have this problem when waking from sleep.

Thanks for any help!

-Drew

Details:

Debian Wheezy
Linux beta 3.8.0 #1 SMP Thu Feb 21 12:30:32 CST 2013 x86_64 GNU/Linux
Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
Thinkpad X230

lspci and kernel logs attached.


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=lspci.txt
Content-Description: lspci output

% lspci -nnv
00:00.0 Host bridge [0600]: Intel Corporation 3rd Gen Core processor DRAM Controller [8086:0154] (rev 09)
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>

00:02.0 VGA compatible controller [0300]: Intel Corporation 3rd Gen Core processor Graphics Controller [8086:0166] (rev 09) (prog-if 00 [VGA controller])
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, fast devsel, latency 0, IRQ 46
	Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
	Memory at e0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 5000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915

00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04) (prog-if 30 [XHCI])
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, medium devsel, latency 0, IRQ 42
	Memory at f2520000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: xhci_hcd

00:16.0 Communication controller [0780]: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at f2535000 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>
	Kernel driver in use: mei

00:16.3 Serial controller [0700]: Intel Corporation 7 Series/C210 Series Chipset Family KT Controller [8086:1e3d] (rev 04) (prog-if 02 [16550])
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 19
	I/O ports at 50b0 [size=8]
	Memory at f253c000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: serial

00:19.0 Ethernet controller [0200]: Intel Corporation 82579LM Gigabit Network Connection [8086:1502] (rev 04)
	Subsystem: Lenovo Device [17aa:21f3]
	Flags: bus master, fast devsel, latency 0, IRQ 20
	Memory at f2500000 (32-bit, non-prefetchable) [size=128K]
	Memory at f253b000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at 5080 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e

00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, medium devsel, latency 0, IRQ 16
	Memory at f253a000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci-pci

00:1b.0 Audio device [0403]: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller [8086:1e20] (rev 04)
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, fast devsel, latency 0, IRQ 48
	Memory at f2530000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 [8086:1e10] (rev c4) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: f1d00000-f24fffff
	Prefetchable memory behind bridge: 00000000f0400000-00000000f0bfffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 [8086:1e12] (rev c4) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: f1c00000-f1cfffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.2 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 [8086:1e14] (rev c4) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=0b, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f1400000-f1bfffff
	Prefetchable memory behind bridge: 00000000f0c00000-00000000f13fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at f2539000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci-pci

00:1f.0 ISA bridge [0601]: Intel Corporation QM77 Express Chipset LPC Controller [8086:1e55] (rev 04)
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: lpc_ich

00:1f.2 SATA controller [0106]: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] [8086:1e03] (rev 04) (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 44
	I/O ports at 50a8 [size=8]
	I/O ports at 50bc [size=4]
	I/O ports at 50a0 [size=8]
	I/O ports at 50b8 [size=4]
	I/O ports at 5060 [size=32]
	Memory at f2538000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller [8086:1e22] (rev 04)
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: medium devsel, IRQ 18
	Memory at f2534000 (64-bit, non-prefetchable) [size=256]
	I/O ports at efa0 [size=32]
	Kernel driver in use: i801_smbus

02:00.0 System peripheral [0880]: Ricoh Co Ltd MMC/SD Host Controller [1180:e822] (rev 07) (prog-if 01)
	Subsystem: Lenovo Device [17aa:21fa]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f1d00000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: sdhci-pci

03:00.0 Network controller [0280]: Intel Corporation Centrino Ultimate-N 6300 [8086:4238] (rev 3e)
	Subsystem: Intel Corporation Centrino Ultimate-N 6300 3x3 AGN [8086:1111]
	Flags: bus master, fast devsel, latency 0, IRQ 47
	Memory at f1c00000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlwifi

% 

--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=kern.log.txt
Content-Description: Debian kern.log since waking from sleep and changing
 access points

Feb 25 08:10:18 beta kernel: [33640.020257] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
Feb 25 08:10:18 beta kernel: [33640.021017] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
Feb 25 08:10:18 beta kernel: [33640.027725] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
Feb 25 08:10:18 beta kernel: [33640.318556] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Feb 25 08:10:24 beta kernel: [33646.685427] wlan0: authenticate with 7c:d1:c3:d2:03:e8
Feb 25 08:10:24 beta kernel: [33646.719611] wlan0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
Feb 25 08:10:24 beta kernel: [33646.720539] wlan0: send auth to 7c:d1:c3:d2:03:e8 (try 1/3)
Feb 25 08:10:24 beta kernel: [33646.723084] wlan0: authenticated
Feb 25 08:10:24 beta kernel: [33646.726020] wlan0: associate with 7c:d1:c3:d2:03:e8 (try 1/3)
Feb 25 08:10:24 beta kernel: [33646.729484] wlan0: RX AssocResp from 7c:d1:c3:d2:03:e8 (capab=0x1431 status=0 aid=4)
Feb 25 08:10:24 beta kernel: [33646.736607] wlan0: associated
Feb 25 08:10:24 beta kernel: [33646.736668] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Feb 25 08:10:24 beta kernel: [33646.736856] cfg80211: Calling CRDA for country: US
Feb 25 08:10:24 beta kernel: [33646.744868] cfg80211: Regulatory domain changed to country: US
Feb 25 08:10:24 beta kernel: [33646.744875] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb 25 08:10:24 beta kernel: [33646.744881] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Feb 25 08:10:24 beta kernel: [33646.744886] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Feb 25 08:10:24 beta kernel: [33646.744890] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 25 08:10:24 beta kernel: [33646.744895] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 25 08:10:24 beta kernel: [33646.744899] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 25 08:10:24 beta kernel: [33646.744903] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Feb 25 08:10:42 beta kernel: [33664.400652] wlan0: authenticate with 60:33:4b:e4:cf:33
Feb 25 08:10:42 beta kernel: [33664.400660] wlan0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
Feb 25 08:10:42 beta kernel: [33664.402397] wlan0: send auth to 60:33:4b:e4:cf:33 (try 1/3)
Feb 25 08:10:42 beta kernel: [33664.404960] wlan0: authenticated
Feb 25 08:10:42 beta kernel: [33664.407618] wlan0: associate with 60:33:4b:e4:cf:33 (try 1/3)
Feb 25 08:10:42 beta kernel: [33664.416954] wlan0: RX AssocResp from 60:33:4b:e4:cf:33 (capab=0x1431 status=0 aid=2)
Feb 25 08:10:42 beta kernel: [33664.430459] wlan0: associated
Feb 25 08:12:14 beta kernel: [33756.515953] iptables denied: IN=wlan0 OUT= MAC=ff:ff:ff:ff:ff:ff:f8:1e:df:ed:57:0e:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=0x00 PREC=0x00 TTL=255 ID=28624 PROTO=UDP SPT=68 DPT=67 LEN=308 
Feb 25 08:24:30 beta kernel: [34491.039003] iptables denied: IN=wlan0 OUT= MAC=ff:ff:ff:ff:ff:ff:94:94:26:02:f1:0c:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=0x00 PREC=0x00 TTL=255 ID=57103 PROTO=UDP SPT=68 DPT=67 LEN=308 
Feb 25 08:55:19 beta kernel: [36337.206835] iptables denied: IN=wlan0 OUT= MAC=ff:ff:ff:ff:ff:ff:f8:1e:df:ed:57:0e:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=0x00 PREC=0x00 TTL=255 ID=28626 PROTO=UDP SPT=68 DPT=67 LEN=308 
Feb 25 09:00:26 beta kernel: [36644.079340] iptables denied: IN=wlan0 OUT= MAC=ff:ff:ff:ff:ff:ff:94:94:26:02:f1:0c:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=328 TOS=0x00 PREC=0x00 TTL=255 ID=57105 PROTO=UDP SPT=68 DPT=67 LEN=308 
Feb 25 09:05:25 beta kernel: [36942.801585] thinkpad_acpi: unknown possible thermal alarm or keyboard event received
Feb 25 09:05:25 beta kernel: [36942.801591] thinkpad_acpi: unhandled HKEY event 0x6040
Feb 25 09:05:25 beta kernel: [36942.801595] thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net
Feb 25 09:05:25 beta kernel: [36942.802107] thinkpad_acpi: EC reports that Thermal Table has changed
Feb 25 09:06:15 beta kernel: [36992.759187] iwlwifi 0000:03:00.0: RF_KILL bit toggled to disable radio.
Feb 25 09:06:15 beta kernel: [36992.759389] wlan0: deauthenticating from 60:33:4b:e4:cf:33 by local choice (reason=3)
Feb 25 09:06:15 beta kernel: [36992.759442] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.759648] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.759652] wlan0: failed to remove key (0, 60:33:4b:e4:cf:33) from hardware (-5)
Feb 25 09:06:15 beta kernel: [36992.760589] iwlwifi 0000:03:00.0: Tx flush command to flush out all frames
Feb 25 09:06:15 beta kernel: [36992.760599] iwlwifi 0000:03:00.0: Tx flush command to flush out all frames
Feb 25 09:06:15 beta kernel: [36992.761961] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.761998] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.762009] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.762015] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.762021] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.762154] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.762156] wlan0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-5)
Feb 25 09:06:15 beta kernel: [36992.762180] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.762182] wlan0: failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware (-5)
Feb 25 09:06:15 beta kernel: [36992.762279] cfg80211: Calling CRDA to update world regulatory domain
Feb 25 09:06:15 beta kernel: [36992.770797] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.770841] iwlwifi 0000:03:00.0: Not sending command - RF KILL
Feb 25 09:06:15 beta kernel: [36992.772432] cfg80211: World regulatory domain updated:
Feb 25 09:06:15 beta kernel: [36992.772438] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb 25 09:06:15 beta kernel: [36992.772444] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 25 09:06:15 beta kernel: [36992.772449] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 25 09:06:15 beta kernel: [36992.772454] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 25 09:06:15 beta kernel: [36992.772458] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 25 09:06:15 beta kernel: [36992.772463] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 25 09:06:18 beta kernel: [36995.170679] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
Feb 25 09:06:18 beta kernel: [36995.176049] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
Feb 25 09:06:18 beta kernel: [36995.177242] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
Feb 25 09:06:18 beta kernel: [36995.468144] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Feb 25 09:06:18 beta kernel: [36995.498943] usb 3-1.4: new full-speed USB device number 4 using ehci-pci
Feb 25 09:06:18 beta kernel: [36995.594696] usb 3-1.4: New USB device found, idVendor=0a5c, idProduct=21e6
Feb 25 09:06:18 beta kernel: [36995.594699] usb 3-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb 25 09:06:18 beta kernel: [36995.594701] usb 3-1.4: Product: BCM20702A0
Feb 25 09:06:18 beta kernel: [36995.594702] usb 3-1.4: Manufacturer: Broadcom Corp
Feb 25 09:06:18 beta kernel: [36995.594704] usb 3-1.4: SerialNumber: E006E6B8A6A1
Feb 25 09:06:24 beta kernel: [37001.841631] wlan0: authenticate with 7c:d1:c3:d2:03:e8
Feb 25 09:06:24 beta kernel: [37001.875570] wlan0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
Feb 25 09:06:24 beta kernel: [37001.876212] wlan0: send auth to 7c:d1:c3:d2:03:e8 (try 1/3)
Feb 25 09:06:24 beta kernel: [37001.878686] wlan0: authenticated
Feb 25 09:06:24 beta kernel: [37001.881142] wlan0: associate with 7c:d1:c3:d2:03:e8 (try 1/3)
Feb 25 09:06:24 beta kernel: [37001.884534] wlan0: RX AssocResp from 7c:d1:c3:d2:03:e8 (capab=0x1431 status=0 aid=5)
Feb 25 09:06:24 beta kernel: [37001.892273] wlan0: associated
Feb 25 09:06:24 beta kernel: [37001.892333] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Feb 25 09:06:24 beta kernel: [37001.892459] cfg80211: Calling CRDA for country: US
Feb 25 09:06:24 beta kernel: [37001.901495] cfg80211: Regulatory domain changed to country: US
Feb 25 09:06:24 beta kernel: [37001.901503] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb 25 09:06:24 beta kernel: [37001.901509] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Feb 25 09:06:24 beta kernel: [37001.901514] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Feb 25 09:06:24 beta kernel: [37001.901519] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 25 09:06:24 beta kernel: [37001.901524] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 25 09:06:24 beta kernel: [37001.901528] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 25 09:06:24 beta kernel: [37001.901533] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Feb 25 09:06:34 beta kernel: [37011.517893] usb 3-1.4: USB disconnect, device number 4
Feb 25 09:12:15 beta kernel: [37351.996099] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 250 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.996110] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 251 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.996116] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 252 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.996121] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 253 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.996126] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 253 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.996888] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 253 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.999932] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 254 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.999941] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 255 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.999947] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 0 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.999953] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 1 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.999958] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 2 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.999962] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 3 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.999968] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 4 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37351.999972] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 5 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.002682] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 6 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.002693] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 7 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.005084] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 8 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.005093] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 9 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.005099] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 10 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.005106] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 11 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.005111] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 12 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.005116] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 13 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.005121] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 14 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.008036] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 15 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.008045] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 16 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.008051] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 17 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.009990] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 18 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.009999] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 19 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.010005] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 20 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.010011] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 21 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.013002] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 22 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.013012] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 23 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.013018] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 24 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.013023] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 25 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.013029] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 26 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.013033] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 27 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.015832] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 28 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.015839] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 29 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.019435] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 29 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.022993] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 30 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.023005] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 31 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.023011] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 32 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.026235] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 33 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.026246] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 34 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.026252] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 35 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.026257] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 36 is out of range [0-256] 250 250.
Feb 25 09:12:15 beta kernel: [37352.029866] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 37 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.029878] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 38 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.029886] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 39 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.029892] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 40 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.048753] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 41 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.048766] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 42 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.051659] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 43 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.056210] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 44 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.056224] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 45 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.059092] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 46 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.059105] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 47 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.062469] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 48 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.062482] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 49 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.065794] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 50 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.065811] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 51 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.088082] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 52 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.090753] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 53 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.090764] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 54 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.090771] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 55 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.090776] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 56 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.090781] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 57 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.090787] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 58 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.090791] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 59 is out of range [0-256] 251 250.
Feb 25 09:12:15 beta kernel: [37352.091263] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 60 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.091276] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 60 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.092156] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 60 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.095331] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 61 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.095350] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 62 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.095363] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 63 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.095370] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 64 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.095377] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 65 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.095386] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 66 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.095393] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 67 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.097903] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 68 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.097915] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 69 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.101496] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 70 is out of range [0-256] 0 250.
Feb 25 09:12:15 beta kernel: [37352.108418] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 71 is out of range [0-256] 7 250.
Feb 25 09:12:15 beta kernel: [37352.113597] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 72 is out of range [0-256] 9 250.
Feb 25 09:12:15 beta kernel: [37352.113667] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 73 is out of range [0-256] 10 250.
Feb 25 09:12:15 beta kernel: [37352.113675] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 74 is out of range [0-256] 10 250.
Feb 25 09:12:15 beta kernel: [37352.113680] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 75 is out of range [0-256] 10 250.
Feb 25 09:12:15 beta kernel: [37352.114024] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 76 is out of range [0-256] 15 250.
Feb 25 09:12:15 beta kernel: [37352.114031] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 77 is out of range [0-256] 15 250.
Feb 25 09:12:15 beta kernel: [37352.114036] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 78 is out of range [0-256] 15 250.
Feb 25 09:12:15 beta kernel: [37352.114099] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 79 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.120338] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 80 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.120352] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 81 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.120361] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 82 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.120370] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 83 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.120378] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 84 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.120386] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 85 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.120393] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 86 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.121948] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 87 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.121959] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 88 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.121969] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 89 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.121975] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 90 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.121983] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 91 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.121991] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 92 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.122000] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 92 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.122812] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 92 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.126182] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 93 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.126196] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 94 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.126205] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 95 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.126213] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 96 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.126222] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 97 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.128566] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 98 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.128579] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 99 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.128587] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 100 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.132941] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 101 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.132948] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 102 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.132951] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 103 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.132955] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 104 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.132958] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 105 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.132961] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 106 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.132964] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 107 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.132967] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 108 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.132971] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 109 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.135416] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 110 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.135420] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 111 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.135423] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 112 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.135425] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 113 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.135428] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 114 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.135430] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 115 is out of range [0-256] 16 250.
Feb 25 09:12:15 beta kernel: [37352.280654] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 139 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.280658] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 140 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.280772] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 140 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.281565] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 140 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.284608] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 141 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.284612] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 142 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.284614] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 143 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.284616] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 144 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.284618] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 145 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.284620] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 146 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.284622] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 147 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.284623] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 148 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.284625] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 149 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.286562] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 150 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.286565] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 151 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.286567] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 152 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.286569] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 153 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.286571] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 154 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.286573] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 155 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.286575] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 155 is out of range [0-256] 139 139.
Feb 25 09:12:15 beta kernel: [37352.287418] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 155 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.290461] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 156 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.290463] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 157 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.290465] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 158 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.290467] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 159 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.290469] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 160 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.290471] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 161 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.290473] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 162 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.290475] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 163 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.290476] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 164 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.293180] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 165 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.293184] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 166 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.295652] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 167 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.295656] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 168 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.295658] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 169 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.295660] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 170 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.295662] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 171 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.295664] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 172 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.295666] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 173 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.295668] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 174 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.295669] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 175 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.298370] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 176 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.298374] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 177 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.298376] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 178 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.298378] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 179 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.298380] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 180 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.298382] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 181 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.298384] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 182 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.298386] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 183 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300956] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 184 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300959] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 185 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300961] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 186 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300964] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 187 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300966] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 188 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300968] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 189 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300969] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 190 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300971] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 191 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300973] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 192 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.300975] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 193 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303653] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 194 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303657] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 195 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303658] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 196 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303661] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 197 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303662] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 198 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303664] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 199 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303666] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 200 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303668] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 201 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303670] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 202 is out of range [0-256] 141 139.
Feb 25 09:12:15 beta kernel: [37352.303672] iwlwifi 0000:03:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (15), last_to_free 203 is out of range [0-256] 141 139.
Feb 25 09:12:16 beta kernel: [37352.503157] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
Feb 25 09:12:16 beta kernel: [37352.503166] iwlwifi 0000:03:00.0: CSR values:
Feb 25 09:12:16 beta kernel: [37352.503170] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Feb 25 09:12:16 beta kernel: [37352.503177] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d304
Feb 25 09:12:16 beta kernel: [37352.503185] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
Feb 25 09:12:16 beta kernel: [37352.503193] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503200] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503207] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503214] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X0000000f
Feb 25 09:12:16 beta kernel: [37352.503221] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503229] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
Feb 25 09:12:16 beta kernel: [37352.503236] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X00000074
Feb 25 09:12:16 beta kernel: [37352.503243] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X41210ffd
Feb 25 09:12:16 beta kernel: [37352.503251] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
Feb 25 09:12:16 beta kernel: [37352.503258] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00030001
Feb 25 09:12:16 beta kernel: [37352.503265] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
Feb 25 09:12:16 beta kernel: [37352.503272] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X000032a1
Feb 25 09:12:16 beta kernel: [37352.503279] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503286] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503293] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503300] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000078
Feb 25 09:12:16 beta kernel: [37352.503308] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88407673
Feb 25 09:12:16 beta kernel: [37352.503314] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
Feb 25 09:12:16 beta kernel: [37352.503321] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503329] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Feb 25 09:12:16 beta kernel: [37352.503336] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
Feb 25 09:12:16 beta kernel: [37352.503339] iwlwifi 0000:03:00.0: FH register values:
Feb 25 09:12:16 beta kernel: [37352.503358] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X40816f00
Feb 25 09:12:16 beta kernel: [37352.503376] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X040816e0
Feb 25 09:12:16 beta kernel: [37352.503394] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000090
Feb 25 09:12:16 beta kernel: [37352.503413] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00811114
Feb 25 09:12:16 beta kernel: [37352.503431] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Feb 25 09:12:16 beta kernel: [37352.503450] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Feb 25 09:12:16 beta kernel: [37352.503468] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503487] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07fd0001
Feb 25 09:12:16 beta kernel: [37352.503505] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
Feb 25 09:12:16 beta kernel: [37352.503510] iwlwifi 0000:03:00.0: Loaded firmware version: 9.221.4.1 build 25532
Feb 25 09:12:16 beta kernel: [37352.503659] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
Feb 25 09:12:16 beta kernel: [37352.503663] iwlwifi 0000:03:00.0: Status: 0x0000204C, count: 5
Feb 25 09:12:16 beta kernel: [37352.503667] iwlwifi 0000:03:00.0: 0x00000004 | NMI_INTERRUPT_WDG           
Feb 25 09:12:16 beta kernel: [37352.503671] iwlwifi 0000:03:00.0: 0x000006B4 | uPc
Feb 25 09:12:16 beta kernel: [37352.503674] iwlwifi 0000:03:00.0: 0x0000067A | branchlink1
Feb 25 09:12:16 beta kernel: [37352.503677] iwlwifi 0000:03:00.0: 0x0000071A | branchlink2
Feb 25 09:12:16 beta kernel: [37352.503681] iwlwifi 0000:03:00.0: 0x00001532 | interruptlink1
Feb 25 09:12:16 beta kernel: [37352.503684] iwlwifi 0000:03:00.0: 0x0000EB8C | interruptlink2
Feb 25 09:12:16 beta kernel: [37352.503687] iwlwifi 0000:03:00.0: 0x00000002 | data1
Feb 25 09:12:16 beta kernel: [37352.503690] iwlwifi 0000:03:00.0: 0x07030000 | data2
Feb 25 09:12:16 beta kernel: [37352.503693] iwlwifi 0000:03:00.0: 0x00000FDC | line
Feb 25 09:12:16 beta kernel: [37352.503697] iwlwifi 0000:03:00.0: 0x594035EB | beacon time
Feb 25 09:12:16 beta kernel: [37352.503700] iwlwifi 0000:03:00.0: 0x95DB9A15 | tsf low
Feb 25 09:12:16 beta kernel: [37352.503703] iwlwifi 0000:03:00.0: 0x0000004F | tsf hi
Feb 25 09:12:16 beta kernel: [37352.503706] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
Feb 25 09:12:16 beta kernel: [37352.503709] iwlwifi 0000:03:00.0: 0x1550B33E | time gp2
Feb 25 09:12:16 beta kernel: [37352.503712] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
Feb 25 09:12:16 beta kernel: [37352.503716] iwlwifi 0000:03:00.0: 0x000109DD | uCode version
Feb 25 09:12:16 beta kernel: [37352.503719] iwlwifi 0000:03:00.0: 0x00000074 | hw version
Feb 25 09:12:16 beta kernel: [37352.503722] iwlwifi 0000:03:00.0: 0x0048D304 | board version
Feb 25 09:12:16 beta kernel: [37352.503725] iwlwifi 0000:03:00.0: 0x0F05001C | hcmd
Feb 25 09:12:16 beta kernel: [37352.503729] iwlwifi 0000:03:00.0: 0x2FF63802 | isr0
Feb 25 09:12:16 beta kernel: [37352.503732] iwlwifi 0000:03:00.0: 0x1141E000 | isr1
Feb 25 09:12:16 beta kernel: [37352.503735] iwlwifi 0000:03:00.0: 0x0000011A | isr2
Feb 25 09:12:16 beta kernel: [37352.503738] iwlwifi 0000:03:00.0: 0x1543FCC3 | isr3
Feb 25 09:12:16 beta kernel: [37352.503741] iwlwifi 0000:03:00.0: 0x00000000 | isr4
Feb 25 09:12:16 beta kernel: [37352.503744] iwlwifi 0000:03:00.0: 0x10800112 | isr_pref
Feb 25 09:12:16 beta kernel: [37352.503748] iwlwifi 0000:03:00.0: 0x00000FDC | wait_event
Feb 25 09:12:16 beta kernel: [37352.503751] iwlwifi 0000:03:00.0: 0x000000C4 | l2p_control
Feb 25 09:12:16 beta kernel: [37352.503754] iwlwifi 0000:03:00.0: 0x00000FDA | l2p_duration
Feb 25 09:12:16 beta kernel: [37352.503757] iwlwifi 0000:03:00.0: 0x00000007 | l2p_mhvalid
Feb 25 09:12:16 beta kernel: [37352.503761] iwlwifi 0000:03:00.0: 0x00103042 | l2p_addr_match
Feb 25 09:12:16 beta kernel: [37352.503764] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
Feb 25 09:12:16 beta kernel: [37352.503767] iwlwifi 0000:03:00.0: 0x02061043 | timestamp
Feb 25 09:12:16 beta kernel: [37352.503770] iwlwifi 0000:03:00.0: 0x00009098 | flow_handler
Feb 25 09:12:16 beta kernel: [37352.503839] iwlwifi 0000:03:00.0: Log capacity 1024 is bogus, limit to 512 entries
Feb 25 09:12:16 beta kernel: [37352.503843] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
Feb 25 09:12:16 beta kernel: [37352.503867] iwlwifi 0000:03:00.0: EVT_LOGT:0357410157:0x00000000:0212
Feb 25 09:12:16 beta kernel: [37352.503882] iwlwifi 0000:03:00.0: EVT_LOGT:0357410196:0x00000000:0215
Feb 25 09:12:16 beta kernel: [37352.503897] iwlwifi 0000:03:00.0: EVT_LOGT:0357410199:0x00000008:0220
Feb 25 09:12:16 beta kernel: [37352.503912] iwlwifi 0000:03:00.0: EVT_LOGT:0357410216:0x00000000:0302
Feb 25 09:12:16 beta kernel: [37352.503927] iwlwifi 0000:03:00.0: EVT_LOGT:0357410245:0x000000d4:0303
Feb 25 09:12:16 beta kernel: [37352.503942] iwlwifi 0000:03:00.0: EVT_LOGT:0357410250:0x000016cc:0217
Feb 25 09:12:16 beta kernel: [37352.503957] iwlwifi 0000:03:00.0: EVT_LOGT:0357410251:0x0fcb001c:0217
Feb 25 09:12:16 beta kernel: [37352.503972] iwlwifi 0000:03:00.0: EVT_LOGT:0357410324:0x0fcc001c:0206
Feb 25 09:12:16 beta kernel: [37352.503987] iwlwifi 0000:03:00.0: EVT_LOGT:0357410325:0x00000001:0204
Feb 25 09:12:16 beta kernel: [37352.504001] iwlwifi 0000:03:00.0: EVT_LOGT:0357410328:0x01101100:0205
Feb 25 09:12:16 beta kernel: [37352.504016] iwlwifi 0000:03:00.0: EVT_LOGT:0357410352:0x00000020:0208
Feb 25 09:12:16 beta kernel: [37352.504031] iwlwifi 0000:03:00.0: EVT_LOGT:0357410372:0x00000000:0302
Feb 25 09:12:16 beta kernel: [37352.504046] iwlwifi 0000:03:00.0: EVT_LOGT:0357410401:0x000000c4:0303
Feb 25 09:12:16 beta kernel: [37352.504061] iwlwifi 0000:03:00.0: EVT_LOGT:0357410409:0x00000001:0203
Feb 25 09:12:16 beta kernel: [37352.504075] iwlwifi 0000:03:00.0: EVT_LOGT:0357410412:0x0fcc001c:0206
Feb 25 09:12:16 beta kernel: [37352.504090] iwlwifi 0000:03:00.0: EVT_LOGT:0357410413:0x00000040:0204
Feb 25 09:12:16 beta kernel: [37352.504105] iwlwifi 0000:03:00.0: EVT_LOGT:0357410417:0x2f110000:0227
Feb 25 09:12:16 beta kernel: [37352.504120] iwlwifi 0000:03:00.0: EVT_LOGT:0357410417:0xc3f0207c:0228
Feb 25 09:12:16 beta kernel: [37352.504135] iwlwifi 0000:03:00.0: EVT_LOGT:0357610298:0x000000f0:0123
Feb 25 09:12:16 beta kernel: [37352.504150] iwlwifi 0000:03:00.0: EVT_LOGT:0357610308:0x00000000:0125
Feb 25 09:12:16 beta kernel: [37352.506731] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 1 [0x07fd0001]
Feb 25 09:12:16 beta kernel: [37352.507034] ieee80211 phy0: Hardware restart was requested
Feb 25 09:12:16 beta kernel: [37352.507229] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
Feb 25 09:12:16 beta kernel: [37352.513934] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1

--=-=-=--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54597 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0GJFqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jul 2010 01:46:52 -0400
Received: by wwb24 with SMTP id 24so5591570wwb.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jul 2010 22:46:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilE2uM6UoHe0UZo20CYfc8DCxpHLlSdQyzyJw2J@mail.gmail.com>
References: <AANLkTim3gow5YFI1L-AwUMwGVb-MHkfZTXIIg3mitWne@mail.gmail.com>
	<AANLkTilE2uM6UoHe0UZo20CYfc8DCxpHLlSdQyzyJw2J@mail.gmail.com>
Date: Sat, 10 Jul 2010 00:46:49 -0500
Message-ID: <AANLkTilWbGRye3yddyZ8mG4ZWz-fu5wKrTDaVLOCKKpY@mail.gmail.com>
Subject: Re: BCM4311 in Ad-hoc Mode - Connection Unsuccessful
From: Nicholas Betcher <nbetcher@gmail.com>
To: Linux-Wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some updates:

- I am using kernel version 2.6.34 from openSUSE 11.3 RC2.
- Per the advice of a user on IRC I tried compat-wireless (from
07/08/2010) and the problem still persists.
- My firmware is 478.104 (as recommended on the Wiki)
- This problem persists with or without WEP enabled on the phone.
- Scanning networks before connecting DOES reveal other networks.
- iw event -t shows:
1278739983.002762: wlan0 (phy #0): scan started
1278739984.284008: wlan0 (phy #0): scan finished: 2412 2417 2422 2427
2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
- I have no access to another Ad-hoc device/software.

Any help on this is greatly appreciated!
Thanks.



On Sun, Jul 4, 2010 at 5:37 AM, Nicholas Betcher <nbetcher@gmail.com> wrote:
> Hello,
> I have recently been using (lightly) tethering on my Android phone and
> it uses Ad-hoc to provide wireless tethering. Unfortunately openSUSE
> 11.3 RC1 seems to be unable to connect to it. I haven't quite pinned
> down at what point it is failing, but it isn't failing at obtaining a
> DHCP lease, it's something more problematic. I have verified my
> settings are all correct on both sides (computer and phone). Also - to
> rule out hardware issues - I have used Windows 7 on the same system to
> successfully connect to the phone.
> Here are various logs/etc:
>
> lspci -v -nn:
> 03:00.0 Network controller [0280]: Broadcom Corporation BCM4311
> 802.11b/g WLAN [14e4:4311] (rev 02)
>         Subsystem: Hewlett-Packard Company BCM4311 802.11b/g Wireless
> LAN Controller [103c:1374]
>         Flags: bus master, fast devsel, latency 0, IRQ 18
>         Memory at b8000000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [58] Vendor Specific Information: Len=78 <?>
>         Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [d0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [13c] Virtual Channel
>         Capabilities: [160] Device Serial Number [REMOVED INTENTIONALLY]
>         Capabilities: [16c] Power Budgeting <?>
>         Kernel driver in use: b43-pci-bridge
>
> dmesg:
> [  328.352293] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
> [  328.384141] b43-pci-bridge 0000:03:00.0: PCI: Disallowing DAC for device
> [  328.384147] b43-phy0: DMA mask fallback from 64-bit to 32-bit
> [  328.398967] wlan0: Trigger new scan to find an IBSS to join
> [  331.704086] wlan0: Trigger new scan to find an IBSS to join
> [  335.704063] wlan0: Trigger new scan to find an IBSS to join
> [  336.996057] wlan0: Creating new IBSS network, BSSID [REMOVED INTENTIONALLY]
> [  367.704079] wlan0: No active IBSS STAs - trying to scan for other
> IBSS networks with same SSID (merge)
> [  399.704089] wlan0: No active IBSS STAs - trying to scan for other
> IBSS networks with same SSID (merge)
>
>
> /var/log/messages:
> Jul  3 01:57:53 NickB-Laptop ifup:     wlan0     name: BCM4311 802.11b/g WLAN
> Jul  3 01:57:53 NickB-Laptop ifup-wireless:     wlan0     warning:
> using NO encryption
> Jul  3 01:57:53 NickB-Laptop kernel: [  684.963046] b43-phy0: Loading
> firmware version 478.104 (2008-07-01 00:50:23)
> Jul  3 01:57:53 NickB-Laptop kernel: [  684.995149] b43-pci-bridge
> 0000:03:00.0: PCI: Disallowing DAC for device
> Jul  3 01:57:53 NickB-Laptop kernel: [  684.995153] b43-phy0: DMA mask
> fallback from 64-bit to 32-bit
> Jul  3 01:57:53 NickB-Laptop kernel: [  685.008172] wlan0: Selected
> IBSS BSSID [REMOVED INTENTIONALLY] based on configured SSID
> Jul  3 01:57:54 NickB-Laptop ifup-dhcp:     wlan0     Starting DHCP4 client
> Jul  3 01:57:54 NickB-Laptop dhcpcd[5932]: wlan0: dhcpcd 3.2.3 starting
> Jul  3 01:57:54 NickB-Laptop dhcpcd[5932]: wlan0: hardware address =
> [REMOVED INTENTIONALLY]
> Jul  3 01:57:54 NickB-Laptop dhcpcd[5932]: wlan0: broadcasting for a lease
> Jul  3 01:58:14 NickB-Laptop dhcpcd[5932]: wlan0: timed out
> Jul  3 01:58:15 NickB-Laptop ifup-dhcp:     wlan0     DHCP4 continues
> in background
> Jul  3 01:58:24 NickB-Laptop kernel: [  715.701300] wlan0: No active
> IBSS STAs - trying to scan for other IBSS networks with same SSID
> (merge)
> Jul  3 01:58:31 NickB-Laptop dhcpcd[4983]: eth0: timed out
> Jul  3 01:58:31 NickB-Laptop dhcpcd[4983]: eth0: lease expired 1799145
> seconds ago
> Jul  3 01:58:31 NickB-Laptop dhcpcd[4983]: eth0: broadcasting for a lease
> Jul  3 01:58:34 NickB-Laptop dhcpcd[5932]: wlan0: timed out
> Jul  3 01:58:34 NickB-Laptop dhcpcd[5932]: wlan0: broadcasting for a lease
> Jul  3 01:58:54 NickB-Laptop dhcpcd[5932]: wlan0: timed out
> Jul  3 01:58:54 NickB-Laptop dhcpcd[5932]: wlan0: broadcasting for a lease
> Jul  3 01:58:56 NickB-Laptop kernel: [  747.704067] wlan0: No active
> IBSS STAs - trying to scan for other IBSS networks with same SSID
> (merge)
>
> More is probably needed to truly debug this problem, so please CC me
> and let me know what more is needed.
> Thanks a million for the great driver, (seriously) :)
> Nick Betcher, CPhT
> Certified Pharmacy Technician
>

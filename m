Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:59634 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965323AbXBQQoi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 11:44:38 -0500
Message-ID: <20070217114436.jhcgs4soo4sgo8sk@webmail.spamcop.net>
Date: Sat, 17 Feb 2007 11:44:36 -0500
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: More breakage in wireless-dev.git
References: <1171690868.31103.17.camel@dv> <1171699574.32411.6.camel@dv>
	<200702171402.24593.mb@bu3sch.de>
In-Reply-To: <200702171402.24593.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Michael Buesch <mb@bu3sch.de>:

> On Saturday 17 February 2007 09:06, Pavel Roskin wrote:
> > I'm still getting "bcm43xx_d80211: FOUND UNSUPPORTED PHY (Analog 4, Type
> > 0, Revision 7)" from bcm43xx_d80211 for a card that used to work.  That
> > must be a separate problem.
>
> More info about your device, please.

It's the same PCIe module with PCI ID 14e4:4312.

# lspci -v -s 0c:00.0
0c:00.0 Network controller: Broadcom Corporation BCM4310 UART (rev 01)
        Subsystem: Dell Unknown device 0007
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at efdfc000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 2
        Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/0
Enable-
        Capabilities: [d0] Express Legacy Endpoint IRQ 0
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel

As it turns out, I'm getting the same problems with your (mb) branch, which
doesn't have the latest wireless-dev.git changes yet.

That's loading the device and bringing it up:

ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:0c:00.0 to 64
ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x11, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0A, vendor 0x4243)
ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x03, vendor 0x4243)
ssb: Core 3 found: PCI-E (cc 0x820, rev 0x01, vendor 0x4243)
ssb: Switching to ChipCommon core, index 0
ssb: Switching to PCI-E core, index 3
bcm43xx_d80211: Broadcom 4311 WLAN found
ssb: Switching to IEEE 802.11 core, index 1
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_d80211: Adding Interface type 2
bcm43xx_d80211: Found PHY: Analog 4, Type 2, Revision 8
bcm43xx_d80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
ssb: Switching to PCI-E core, index 3
ssb: Switching to IEEE 802.11 core, index 1
bcm43xx_d80211: Loading firmware version 371.1122 (2006-11-08 22:02:13)
ssb: Switching to ChipCommon core, index 0
ssb: Switching to IEEE 802.11 core, index 1
bcm43xx_d80211: Radio turned on
bcm43xx_d80211: Radio enabled by hardware
bcm43xx_d80211: Chip initialized
bcm43xx_d80211: 32-bit DMA initialized
bcm43xx_d80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
bcm43xx_d80211: Using hardware based encryption for keyidx: 0, mac:
ff:ff:ff:ff:ff:ff

Then I do scanning.  I didn't need to bring the interface down, but it's
possible that some userspace utility tried to do it:

wlan0: starting scan
bcm43xx_d80211: Reconfiguring PHYmode to A-PHY
bcm43xx_d80211: Wireless interface stopped
bcm43xx_d80211: DMA-32 0x0200 (RX) max used slots: 2/64
bcm43xx_d80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_d80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_d80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_d80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_d80211: DMA-32 0x0220 (TX) max used slots: 0/128
bcm43xx_d80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_d80211: Radio turned off
ssb: Switching to ChipCommon core, index 0
ssb: Switching to IEEE 802.11 core, index 1
bcm43xx_d80211: FOUND UNSUPPORTED PHY (Analog 4, Type 0, Revision 7)
bcm43xx_d80211: Fatal: Could not initialize device for new selected A-PHY mode
wlan0: failed to set channel 36 (5180 MHz) for scan
bcm43xx_d80211: Reconfiguring PHYmode to G-PHY
bcm43xx_d80211: Reconfiguring PHYmode to A-PHY
wlan0: scan completed
bcm43xx_d80211: Removing Interface type 2
bcm43xx_d80211: Radio turned off
ssb: Switching to ChipCommon core, index 0
slab error in verify_redzone_free(): cache `size-64': double free detected

Call Trace:
 [<ffffffff8027c761>] __slab_error+0x21/0x30
 [<ffffffff8027cfc8>] cache_free_debugcheck+0xf8/0x220
 [<ffffffff8802f1cd>] :bcm43xx_d80211:bcm43xx_wireless_core_exit+0x3d/0x90
 [<ffffffff8027d2d0>] kfree+0xb0/0x120
 [<ffffffff8802f1cd>] :bcm43xx_d80211:bcm43xx_wireless_core_exit+0x3d/0x90
 [<ffffffff8802f89b>] :bcm43xx_d80211:bcm43xx_remove_interface+0xfb/0x140
 [<ffffffff880057fa>] :80211:ieee80211_stop+0xfa/0x120
 [<ffffffff80463032>] dev_close+0x62/0x90
 [<ffffffff8046246d>] dev_change_flags+0x6d/0x150
 [<ffffffff8049f022>] devinet_ioctl+0x2f2/0x710
 [<ffffffff80464276>] dev_ioctl+0x3f6/0x440
 [<ffffffff80248cd5>] __lock_acquire+0xd35/0xdd0
 [<ffffffff8049f71c>] inet_ioctl+0x4c/0x80
 [<ffffffff804573a0>] sock_ioctl+0x210/0x240
 [<ffffffff804bb9db>] _spin_unlock_irq+0x2b/0x40
 [<ffffffff8028e68b>] do_ioctl+0x1b/0x60
 [<ffffffff8028e931>] vfs_ioctl+0x261/0x280
 [<ffffffff8028e99a>] sys_ioctl+0x4a/0x80
 [<ffffffff80209b6e>] system_call+0x7e/0x83

ffff81000763e240: redzone 1:0x5a2cf071, redzone 2:0x5a2cf071.
ssb: Switching to IEEE 802.11 core, index 1
bcm43xx_d80211: Adding Interface type 2
bcm43xx_d80211: FOUND UNSUPPORTED PHY (Analog 4, Type 0, Revision 7)

--
Regards,
Pavel Roskin

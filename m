Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out108.alice.it ([85.37.17.108]:3451 "EHLO
	smtp-out108.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab0BGToy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 14:44:54 -0500
Message-ID: <4B6F15D1.3050307@iperbole.bo.it>
Date: Sun, 07 Feb 2010 20:34:41 +0100
From: Lorenzo Raschi <ded1549@iperbole.bo.it>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: p54pci: "device does not respond!"
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've been using prism54 with fullmac firmware on my gentoo router since 
one year.
In AP mode prism54 works fine, although the fact that it works in open 
mode only (no key support).
Because I saw prism54 is deprecated now, I'm trying to switch to p54pci 
+ softmac driver. Unfortunately it doesn't work.

With kernel 2.6.31.6 dmesg tells me 9 times out of 10:

p54pci 0000:07:0e.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
p54pci 0000:07:0e.0: firmware: requesting isl3886pci
phy22: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy22: FW rev 2.13.12.0 - Softmac protocol 5.9
phy22: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy22: device does not respond!
p54pci 0000:07:0e.0: PCI INT A disabled
p54pci: probe of 0000:07:0e.0 failed with error -16

One time out of 10 it seems to works:

p54pci 0000:07:0e.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
p54pci 0000:07:0e.0: firmware: requesting isl3886pci
phy24: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy24: FW rev 2.13.12.0 - Softmac protocol 5.9
phy24: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy24: hwaddr 00:60:b3:52:fb:66, MAC:isl3890 RF:Frisbee
phy24: Selected rate control algorithm 'minstrel'
Registered led device: p54-phy24::assoc
Registered led device: p54-phy24::tx
Registered led device: p54-phy24::rx
Registered led device: p54-phy24::radio
p54pci 0000:07:0e.0: is registered as 'phy24'
ADDRCONF(NETDEV_UP): wlan0: link is not ready

I tried different firmwares without increasing the success ratio.
When it seemed to work I tried using the wifi card with hostapd. My 
laptop sees my wireless network, but as soon it try to register in, my 
router hangs.

I tried with kernel 2.6.33-rc6 also. With it the driver's module success 
ratio seems decreased. Anyway, when it works, I tried hostapd. My router 
hangs the same but, before it, dmesg tells me that:

------------[ cut here ]------------
WARNING: at net/mac80211/rx.c:2513 ieee80211_rx+0xa1/0x840()
Hardware name: OEM
Modules linked in: p54pci p54common ipt_ipp2p [last unloaded: p54common]
Pid: 0, comm: swapper Not tainted 2.6.33-rc6 #1
Call Trace:
  <IRQ>  [<ffffffff815b8191>] ? ieee80211_rx+0xa1/0x840
  [<ffffffff8103e188>] warn_slowpath_common+0x78/0xd0
  [<ffffffff8103e1ef>] warn_slowpath_null+0xf/0x20
  [<ffffffff815b8191>] ieee80211_rx+0xa1/0x840
  [<ffffffffa001fdbf>] ? p54p_check_rx_ring+0x15f/0x1d0 [p54pci]
  [<ffffffff815a6161>] ieee80211_tasklet_handler+0xf1/0x120
  [<ffffffff810433a9>] tasklet_action+0x69/0xf0
  [<ffffffffa001fbc2>] ? p54p_interrupt+0x112/0x130 [p54pci]
  [<ffffffff81043f06>] __do_softirq+0xa6/0x130
  [<ffffffff8101dba5>] ? ack_apic_level+0x95/0x240
  [<ffffffff810032cc>] call_softirq+0x1c/0x30
  [<ffffffff81005435>] do_softirq+0x55/0x90
  [<ffffffff81043be5>] irq_exit+0x75/0x90
  [<ffffffff810049b3>] do_IRQ+0x73/0xf0
  [<ffffffff815d8053>] ret_from_intr+0x0/0xa
  <EOI>  [<ffffffff8100ad36>] ? mwait_idle+0x66/0x80
  [<ffffffff81001640>] ? enter_idle+0x20/0x30
  [<ffffffff810016fb>] cpu_idle+0xab/0x100
  [<ffffffff815d1d1e>] start_secondary+0x174/0x1c6
---[ end trace ec372cd178aae683 ]---

please, don't hesitate to contact me (via email, I'm not registered into 
this ml) to have more details.

Best regards,

Lorenzo Raschi

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm15.bullet.mail.ird.yahoo.com ([77.238.189.68]:27712 "EHLO
	nm15.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357Ab3FPRSC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jun 2013 13:18:02 -0400
Message-ID: <1371403080.55562.YahooMailNeo@web133204.mail.ir2.yahoo.com> (sfid-20130616_191807_933662_4A17C049)
Date: Sun, 16 Jun 2013 18:18:00 +0100 (BST)
From: Jorge Bueno Moreno <jorge_bueno_moreno@yahoo.es>
Reply-To: Jorge Bueno Moreno <jorge_bueno_moreno@yahoo.es>
Subject: ath9k problems in AP mode for 3.2 kernels / 3.10-rc1-2 compat-drivers
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

My card is: TP-LINK Model No. TL-WN951N Ver 1.0 that shows as:

phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81: mem=0xf8ee0000, irq=20

and lspci:

05:05.0 Network controller: Atheros Communications Inc. AR5416 Wireless Network Adapter [AR5008 802.11(a)bgn] (rev 01)
    Subsystem: Atheros Communications Inc. Device 3071
    Flags: bus master, 66MHz, medium devsel, latency 168, IRQ 20
    Memory at febc0000 (32-bit, non-prefetchable) [size=64K]
    Capabilities: [40] #80 [0000]
    Kernel driver in use: ath9k

It works in STA mode in my debian squeeze with kernel 2.6.32-48 but not very well in AP mode given that,
as soon as hostapd is run to go AP mode I get:

Jun 16 12:33:33 hostname kernel: [   88.176476] irq 16: nobody cared (try booting with the "irqpoll" option)
Jun 16 12:33:33 hostname kernel: [   88.176560] Pid: 0, comm: swapper Not tainted 2.6.32-5-686 #1
Jun 16 12:33:33 hostname kernel: [   88.176565] Call Trace:
Jun 16 12:33:33 hostname kernel: [   88.176578]  [<c106db4d>] ? __report_bad_irq+0x24/0x69
Jun 16 12:33:33 hostname kernel: [   88.176587]  [<c106db54>] ? __report_bad_irq+0x2b/0x69
Jun 16 12:33:33 hostname kernel: [   88.176595]  [<c106dc79>] ? note_interrupt+0xe7/0x13e
Jun 16 12:33:33 hostname kernel: [   88.176603]  [<c106e1a7>] ? handle_fasteoi_irq+0x7a/0x97
Jun 16 12:33:33 hostname kernel: [   88.176612]  [<c1004dd7>] ? handle_irq+0x17/0x1b
Jun 16 12:33:33 hostname kernel: [   88.176620]  [<c1004659>] ? do_IRQ+0x38/0x89
Jun 16 12:33:33 hostname kernel: [   88.176628]  [<c10037f0>] ? common_interrupt+0x30/0x38
Jun 16 12:33:33 hostname kernel: [   88.176637]  [<c10088d3>] ? mwait_idle+0x62/0x6c
Jun 16 12:33:33 hostname kernel: [   88.176645]  [<c1002377>] ? cpu_idle+0x89/0xa2
Jun 16 12:33:33 hostname kernel: [   88.176649] handlers:
Jun 16 12:33:33 hostname kernel: [   88.176704] [<f7ec4277>] (ata_sff_interrupt+0x0/0xa2 [libata])
Jun 16 12:33:33 hostname kernel: [   88.176844] [<f7f169ad>] (usb_hcd_irq+0x0/0x71 [usbcore])
Jun 16 12:33:33 hostname kernel: [   88.176970] [<f7c676bc>] (rtl8169_interrupt+0x0/0x342 [r8169])
Jun 16 12:33:33 hostname kernel: [   88.177092] Disabling IRQ #16

and the wireless card stops working.

As a workaround, I've been running the kernel with "irqpoll/irqfixup" option but now I needed to migrate to debian wheezy
with kernel 3.2.46-1. With this version, kernel shows a similar error:


Jun 16 17:37:27 hostname kernel: [16005.334858] irq 16: nobody cared (try booting with the "irqpoll" option)
Jun 16 17:37:27 hostname kernel: [16005.335085] Pid: 0, comm: swapper/1 Not tainted 3.2.0-4-686-pae #1 Debian 3.2.46-1
Jun 16 17:37:27 hostname kernel: [16005.335094] Call Trace:
Jun 16 17:37:27 hostname kernel: [16005.335117]  [<c1078f57>] ? __report_bad_irq+0x1c/0x8d
Jun 16 17:37:27 hostname kernel: [16005.335132]  [<c107925a>] ? note_interrupt+0x11a/0x188
Jun 16 17:37:27 hostname kernel: [16005.335146]  [<c1077be0>] ? handle_irq_event_percpu+0x13f/0x155
Jun 16 17:37:27 hostname kernel: [16005.335160]  [<c107980a>] ? handle_level_irq+0x56/0x56
Jun 16 17:37:27 hostname kernel: [16005.335173]  [<c1077c17>] ? handle_irq_event+0x21/0x3a
Jun 16 17:37:27 hostname kernel: [16005.335186]  [<c107980a>] ? handle_level_irq+0x56/0x56
Jun 16 17:37:27 hostname kernel: [16005.335199]  [<c107986a>] ? handle_fasteoi_irq+0x60/0x85
Jun 16 17:37:27 hostname kernel: [16005.335207]  <IRQ>  [<c100c886>] ? do_IRQ+0x2e/0x76
Jun 16 17:37:27 hostname kernel: [16005.335231]  [<c12c84f0>] ? common_interrupt+0x30/0x38
Jun 16 17:37:27 hostname kernel: [16005.335245]  [<c103007b>] ? update_group_power+0x67/0xbf
Jun 16 17:37:27 hostname kernel: [16005.335260]  [<c1199de9>] ? intel_idle+0xcc/0xfb
Jun 16 17:37:27 hostname kernel: [16005.335274]  [<c120cc62>] ? cpuidle_idle_call+0xcc/0x142
Jun 16 17:37:27 hostname kernel: [16005.335287]  [<c100ace9>] ? cpu_idle+0x8b/0xaf
Jun 16 17:37:27 hostname kernel: [16005.335302]  [<c12ba6e6>] ? start_secondary+0x1be/0x1c3
Jun 16 17:37:27 hostname kernel: [16005.335311] handlers:
Jun 16 17:37:27 hostname kernel: [16005.335435] [<f84d1eca>] ata_bmdma_interrupt
Jun 16 17:37:27 hostname kernel: [16005.335599] [<f846b4d5>] usb_hcd_irq
Jun 16 17:37:27 hostname kernel: [16005.335734] [<f827321f>] rtl8169_interrupt
Jun 16 17:37:27 hostname kernel: [16005.335869] Disabling IRQ #16

but hangs completely showing traces in console and needing a hard reboot.

If I apply same workaround booting the kernel with "irqpoll/irqfixup" I can go AP mode, but as soon as a station tries to connect,
I get these messages flooding logs and AP doesn't work at all (I have to ifdown the interface to stop log flooding):

Jun 16 18:09:50 hostname kernel: [  170.379181] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x000264c0
Jun 16 18:09:50 hostname kernel: [  170.388883] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
Jun 16 18:09:50 hostname kernel: [  170.744131] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
Jun 16 18:09:50 hostname kernel: [  170.753829] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
Jun 16 18:09:50 hostname kernel: [  171.109084] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
Jun 16 18:09:50 hostname kernel: [  171.118791] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
Jun 16 18:09:51 hostname kernel: [  171.474058] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
Jun 16 18:09:51 hostname kernel: [  171.483760] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
Jun 16 18:09:51 hostname kernel: [  171.838977] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
Jun 16 18:09:51 hostname kernel: [  171.848685] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
Jun 16 18:09:52 hostname kernel: [  172.203898] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
Jun 16 18:09:52 hostname kernel: [  172.213600] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
Jun 16 18:09:52 hostname kernel: [  172.568817] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
Jun 16 18:09:52 hostname kernel: [  172.578515] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
Jun 16 18:09:52 hostname kernel: [  172.933750] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
Jun 16 18:09:52 hostname kernel: [  172.943450] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
...
...
Jun 16 18:10:12 hostname kernel: [  192.683280] ath: Failed to stop TX DMA, queues=0x001!
Jun 16 18:10:12 hostname kernel: [  192.707757] ath: Failed to stop TX DMA, queues=0x001!
Jun 16 18:10:12 hostname kernel: [  192.736734] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00004040
Jun 16 18:10:12 hostname kernel: [  192.756744] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
Jun 16 18:10:12 hostname kernel: [  192.791133] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
Jun 16 18:10:12 hostname kernel: [  192.807675] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up

I have compiled and tried latest stable driver version:

backports-3.10-rc1-2.tar.bz2

and snapshot:

backports-20130607.tar.bz2

with same results.



Final details on kernel driver versions used:

VERSION 2.6.32-48

2.6.32-5-686 #1 SMP Fri May 10 08:33:48 UTC 2013 i686

ath9k                 238533  0 
ath                     6026  1 ath9k
led_class               1757  1 ath9k
mac80211              123754  1 ath9k
cfg80211               87809  3 mac80211,ath,ath9k

modinfo ath9k
filename:       /lib/modules/2.6.32-5-686/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
license:        Dual BSD/GPL
description:    Support for Atheros 802.11n wireless LAN cards.
author:         Atheros Communications
alias:          pci:v0000168Cd0000002Esv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Dsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Csv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000029sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000027sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000024sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000023sv*sd*bc*sc*i*
depends:        mac80211,led-class,ath,cfg80211
vermagic:       2.6.32-5-686 SMP mod_unload modversions 686 
parm:           nohwcrypt:Disable hardware encryption (int)


VERSION 3.2.46-1

3.2.0-4-686-pae #1 SMP Debian 3.2.46-1 i686

ath9k                  67806  0 
ath9k_common           12648  1 ath9k
ath9k_hw              311433  2 ath9k_common,ath9k
ath                    17114  3 ath9k_hw,ath9k_common,ath9k
mac80211              171389  1 ath9k
cfg80211              113445  3 mac80211,ath,ath9k

modinfo ath9k
filename:       /lib/modules/3.2.0-4-686-pae/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
license:        Dual BSD/GPL
description:    Support for Atheros 802.11n wireless LAN cards.
author:         Atheros Communications
alias:          pci:v0000168Cd00000037sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000034sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000033sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000032sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000030sv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Esv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Dsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Csv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000029sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000027sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000024sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000023sv*sd*bc*sc*i*
depends:        ath9k_hw,ath9k_common,mac80211,ath,cfg80211
intree:         Y
vermagic:       3.2.0-4-686-pae SMP mod_unload modversions 686 
parm:           debug:Debugging mask (uint)
parm:           nohwcrypt:Disable hardware encryption (int)
parm:           blink:Enable LED blink on activity (int)
parm:           btcoex_enable:Enable wifi-BT coexistence (int)



Support/help to get this issue fixed will be much appreciated.

Thank you.

Regards,
Jorge.

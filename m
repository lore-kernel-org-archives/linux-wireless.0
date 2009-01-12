Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:49657 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZALRJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 12:09:52 -0500
Received: by rn-out-0910.google.com with SMTP id k40so7296243rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 09:09:49 -0800 (PST)
Message-ID: <496B795B.8090700@gmail.com> (sfid-20090112_180956_061814_EAC3795E)
Date: Mon, 12 Jan 2009 18:09:47 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200812161415.09365.chunkeey@web.de> <4947B1E3.4080008@gmail.com> <200812161510.09499.chunkeey@web.de>
In-Reply-To: <200812161510.09499.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Tuesday 16 December 2008 14:49:23 Artur Skawina wrote:
>>> Dec 16 14:32:44 kernel: usb 1-7: new high speed USB device using ehci_hcd and address 14
>>> Dec 16 14:32:44 kernel: usb 1-7: configuration #1 chosen from 1 choice
>>> Dec 16 14:32:44 kernel: usb 1-7: firmware: requesting isl3886usb
>>> Dec 16 14:32:44 kernel: usb 1-7: New USB device found, idVendor=0846, idProduct=4200
>>> Dec 16 14:32:44 kernel: usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> Dec 16 14:32:44 kernel: phy1: p54 detected a LM86 firmware
>>> Dec 16 14:32:44 kernel: phy1: FW rev 2.5.6.0 - Softmac protocol 3.0
>>> Dec 16 14:32:44 kernel: phy1: you are using an obsolete firmware. visit http://wireless.kernel.org/en/users/Drivers/p54 and grab one for "kernel >= 2.6.28"!
>>> Dec 16 14:32:44 kernel: phy1: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:no
>>> Dec 16 14:32:47 kernel: phy1: hwaddr 00:30:f1:12:34:56, MAC:isl3886 RF:Frisbee
>>> Dec 16 14:32:47 kernel: phy1: Selected rate control algorithm 'minstrel'
>>> Dec 16 14:32:47 kernel: usbcore: registered new interface driver p54usb
>>> Dec 16 14:32:47 kernel: udev: renamed network interface wlan0 to wlan1
>> Did not do any further testing yet.
> 
> Do the new firmwares work as well?
> Because I'll dropping support for the old firmwares in the future.
> The reason are bugs which can be triggered remotely...
> (e.g.: frames with a "special" length etc...)

I have not been using the old ones, so can't really compare them, but
the newer one seems to work, at least a bit:

kernel: usb 1-1.1: new full speed USB device using uhci_hcd and address 5
kernel: usb 1-1.1: configuration #1 chosen from 1 choice
kernel: usb 1-1.1: firmware: requesting isl3886usb
kernel: phy0: p54 detected a LM86 firmware
kernel: p54: rx_mtu reduced from 3240 to 2392
kernel: phy0: FW rev 2.13.1.0 - Softmac protocol 5.5
kernel: phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
kernel: phy0: hwaddr 00:30:f1:12:34:56, MAC:isl3886 RF:Frisbee
kernel: phy0: Selected rate control algorithm 'minstrel'
kernel: usb 1-1.1: New USB device found, idVendor=0846, idProduct=4200
kernel: usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0

so to test the device further i set up hostapd, which mostly worked; after 
a few tweaks (eg patching out country code setting in hostapd) i got an
almost working AP. "Almost" because connecting a client works sometimes,
but not always, and there seems to be way too much packet loss going on.
"dtim_period=1" seemed to improve things enough to achieve basic ipv4
connectivity (w/o it dhcp seemed to work, but arp usually did not).

But then i ran into a more serious issue -- the machine locks up completely
when trying to use the device (just connecting and disconnecting a client is
often enough). Happens after ~ a minute, the computer freezes, isn't
responsible over network, nothing in logs. It's a headless box, tried
hooking up a kbd and monitor, but that didn't help - console was dead too.
After setting up netconsole i first got two skb truesize warnings [1], then
after a short while again a complete lock up, nothing on the console.
Then tried plugging in a keyboard and that provoked a stream of order 0 page
allocation failures, but the machine remained dead.

artur

[1]:
------------[ cut here ]------------
WARNING: at net/core/skbuff.c:154 skb_truesize_bug+0x4c/0x50()
SKB BUG: Invalid truesize (288) len=111, sizeof(sk_buff)=180
Modules linked in: netconsole saa7134_empress saa6752hs lnbp21 s5h1420 saa7134 budget videobuf_dma_sg budget_ci budget_core serio_raw videobuf_core tveeprom saa7146 ttpci_eeprom ir_common [last unloaded: microcode]
Pid: 3797, comm: hostapd Not tainted 2.6.28-rc8-00519-g90435df #41
Call Trace:
 [<c0122f3f>] warn_slowpath+0x6f/0x90
 [<c03b7efb>] __qdisc_run+0x1ab/0x200
 [<c03a7f34>] dev_queue_xmit+0xd4/0x4e0
 [<c04acb7a>] ieee80211_monitor_start_xmit+0x6a/0xa0
 [<c03a7cda>] dev_hard_start_xmit+0x1aa/0x210
 [<c03b7efb>] __qdisc_run+0x1ab/0x200
 [<c03a7f34>] dev_queue_xmit+0xd4/0x4e0
 [<c0241b38>] copy_to_user+0x38/0x130
 [<c03a2bbc>] skb_truesize_bug+0x4c/0x50
 [<c039df97>] sock_rfree+0x57/0x60
 [<c03a1e76>] skb_release_head_state+0x36/0xb0
 [<c03a12f8>] __kfree_skb+0x8/0x90
 [<c03a39ea>] skb_free_datagram+0xa/0x30
 [<c0452c25>] packet_recvmsg+0x1a5/0x200
 [<c011cff3>] __wake_up_common+0x43/0x70
 [<c039b2b7>] sock_recvmsg+0xd7/0x120
 [<c0134d20>] autoremove_wake_function+0x0/0x50
 [<c0241a02>] copy_from_user+0x32/0x130
 [<c039c35e>] sys_recvfrom+0xce/0x160
 [<c0107c26>] read_tsc+0x6/0x40
 [<c029b85c>] pty_write+0x3c/0x60
 [<c0293e5b>] tty_put_char+0x2b/0x40
 [<c02972e4>] opost+0xd4/0x250
 [<c0139eb1>] getnstimeofday+0x41/0xf0
 [<c039c423>] sys_recv+0x33/0x40
 [<c039c996>] sys_socketcall+0x196/0x290
 [<c0103221>] sysenter_do_call+0x12/0x25
 [<c04c0000>] cond_resched_softirq+0x50/0x60
---[ end trace 9562176113d148b9 ]---
------------[ cut here ]------------
WARNING: at net/core/skbuff.c:154 skb_truesize_bug+0x4c/0x50()
SKB BUG: Invalid truesize (280) len=105, sizeof(sk_buff)=180
Modules linked in: netconsole saa7134_empress saa6752hs lnbp21 s5h1420 saa7134 budget videobuf_dma_sg budget_ci budget_core serio_raw videobuf_core tveeprom saa7146 ttpci_eeprom ir_common [last unloaded: microcode]
Pid: 3797, comm: hostapd Tainted: G        W  2.6.28-rc8-00519-g90435df #41
Call Trace:
 [<c0122f3f>] warn_slowpath+0x6f/0x90
 [<c03b7efb>] __qdisc_run+0x1ab/0x200
 [<c03a7f34>] dev_queue_xmit+0xd4/0x4e0
 [<c04acb7a>] ieee80211_monitor_start_xmit+0x6a/0xa0
 [<c03a7cda>] dev_hard_start_xmit+0x1aa/0x210
 [<c03b7efb>] __qdisc_run+0x1ab/0x200
 [<c03a7f34>] dev_queue_xmit+0xd4/0x4e0
 [<c0241b38>] copy_to_user+0x38/0x130
 [<c03a2bbc>] skb_truesize_bug+0x4c/0x50
 [<c039df97>] sock_rfree+0x57/0x60
 [<c03a1e76>] skb_release_head_state+0x36/0xb0
 [<c03a12f8>] __kfree_skb+0x8/0x90
 [<c03a39ea>] skb_free_datagram+0xa/0x30
 [<c0452c25>] packet_recvmsg+0x1a5/0x200
 [<c011cff3>] __wake_up_common+0x43/0x70
 [<c039b2b7>] sock_recvmsg+0xd7/0x120
 [<c0134d20>] autoremove_wake_function+0x0/0x50
 [<c0241a02>] copy_from_user+0x32/0x130
 [<c039c35e>] sys_recvfrom+0xce/0x160
 [<c0107c26>] read_tsc+0x6/0x40
 [<c029b85c>] pty_write+0x3c/0x60
 [<c0293e5b>] tty_put_char+0x2b/0x40
 [<c02972e4>] opost+0xd4/0x250
 [<c0139eb1>] getnstimeofday+0x41/0xf0
 [<c039c423>] sys_recv+0x33/0x40
 [<c039c996>] sys_socketcall+0x196/0x290
 [<c0103221>] sysenter_do_call+0x12/0x25
 [<c04c0000>] cond_resched_softirq+0x50/0x60
---[ end trace 9562176113d148b9 ]---

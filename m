Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:48551 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbZBJNpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 08:45:30 -0500
Received: by bwz5 with SMTP id 5so2684009bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2009 05:45:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234262188.4302.0.camel@johannes.local>
References: <1234262188.4302.0.camel@johannes.local>
Date: Tue, 10 Feb 2009 15:45:27 +0200
Message-ID: <dac45060902100545j3d9caf8er2183416f5b5669cc@mail.gmail.com> (sfid-20090210_144535_514365_34E35FDE)
Subject: Re: zd1211rw keeps failing
From: Mark Ryden <markryde@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
  - Can you please elaborate on under which sequence of operations
does this occur ? is it the wireless-testing tree? the reason is:
 I am using the latest git wireless-testing (from today; -rc4 based tre=
e).
I can associate to an Access Point without errors; and I tried more tha=
n once.

I had tried both when encryption is off in the Access Point and when
encryption is on in the Access Point.

What I tried first is:
modprobe zd1211rw
ifconfig wlan2 up
iwconfig wlan2 essid homeNet ap 00:1F:1F:25:C6:CA
and I could connect:
  In the log, I see:
=46eb 10 15:24:52 localhost kernel: zd1211rw 2-8.2:1.0: firmware versio=
n 4605
=46eb 10 15:24:52 localhost kernel: zd1211rw 2-8.2:1.0: zd1211 chip
0ace:1211 v4810 full 00-0e-2e AL2230_RF pa0 -----
=46eb 10 15:24:52 localhost kernel: cfg80211: Calling CRDA for country:=
 DE
=46eb 10 15:25:11 localhost kernel: wlan2: authenticate with AP 00:1f:1=
f:25:c6:ca
=46eb 10 15:25:11 localhost kernel: wlan2: authenticated
=46eb 10 15:25:11 localhost kernel: wlan2: associate with AP 00:1f:1f:2=
5:c6:ca
=46eb 10 15:25:11 localhost kernel: wlan2: RX AssocResp from
00:1f:1f:25:c6:ca (capab=3D0x401 status=3D0 aid=3D1)
=46eb 10 15:25:11 localhost kernel: wlan2: associated


---

When I tried with encryption on in the Access Point I did it with
NetworkManager, and it was OK. Here is what I saw in the kernel log:

=46eb 10 15:39:43 localhost NetworkManager: <info>  (wlan2) Supplicant
interface state change: 3 -> 4
=46eb 10 15:39:44 localhost NetworkManager: <info>  (wlan2) Supplicant
interface state change: 4 -> 5
=46eb 10 15:39:44 localhost NetworkManager: <info>  (wlan2) Supplicant
interface state change: 5 -> 6
=46eb 10 15:39:44 localhost NetworkManager: <info>  (wlan2) Supplicant
interface state change: 6 -> 7
=46eb 10 15:39:44 localhost NetworkManager: <info>  Activation
(wlan2/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'shapira'.
=46eb 10 15:39:44 localhost NetworkManager: <info>  Activation (wlan2)
Stage 3 of 5 (IP Configure Start) scheduled.
=46eb 10 15:39:44 localhost NetworkManager: <info>  Activation (wlan2)
Stage 3 of 5 (IP Configure Start) started...
=46eb 10 15:39:44 localhost NetworkManager: <info>  Activation (wlan2)
Beginning DHCP transaction.
=46eb 10 15:39:44 localhost dhclient: Internet Systems Consortium DHCP
Client V3.0.6-Fedora
=46eb 10 15:39:44 localhost dhclient: Copyright 2004-2007 Internet
Systems Consortium.
=46eb 10 15:39:44 localhost dhclient: All rights reserved.
=46eb 10 15:39:44 localhost dhclient: For info, please visit
http://www.isc.org/sw/dhcp/
=46eb 10 15:39:44 localhost dhclient:
=46eb 10 15:39:44 localhost NetworkManager: <info>  dhclient started wi=
th pid 3522
=46eb 10 15:39:44 localhost NetworkManager: <info>  Activation (wlan2)
Stage 3 of 5 (IP Configure Start) complete.
=46eb 10 15:39:44 localhost NetworkManager: <info>  DHCP: device wlan2
state changed (null) -> preinit
=46eb 10 15:39:44 localhost dhclient: Listening on LPF/wlan2/00:0e:2e:8=
4:99:4a
=46eb 10 15:39:44 localhost dhclient: Sending on   LPF/wlan2/00:0e:2e:8=
4:99:4a
=46eb 10 15:39:44 localhost dhclient: Sending on   Socket/fallback
=46eb 10 15:39:44 localhost dhclient: DHCPDISCOVER on wlan2 to
255.255.255.255 port 67 interval 8
=46eb 10 15:39:46 localhost dhclient: DHCPOFFER from 192.168.2.1
=46eb 10 15:39:46 localhost dhclient: DHCPREQUEST on wlan2 to
255.255.255.255 port 67
=46eb 10 15:39:54 localhost dhclient: DHCPREQUEST on wlan2 to
255.255.255.255 port 67
=46eb 10 15:39:54 localhost dhclient: DHCPACK from 192.168.2.1
=46eb 10 15:39:54 localhost NetworkManager: <info>  DHCP: device wlan2
state changed preinit -> bound
=46eb 10 15:39:54 localhost NetworkManager: <info>  Activation (wlan2)
Stage 4 of 5 (IP Configure Get) scheduled...
=46eb 10 15:39:54 localhost NetworkManager: <info>  Activation (wlan2)
Stage 4 of 5 (IP Configure Get) started...
=46eb 10 15:39:54 localhost NetworkManager: <info>    address 192.168.2=
=2E101
=46eb 10 15:39:54 localhost NetworkManager: <info>    netmask 255.255.2=
55.0
=46eb 10 15:39:54 localhost NetworkManager: <info>    broadcast 192.168=
=2E2.255
=46eb 10 15:39:54 localhost NetworkManager: <info>    gateway 192.168.2=
=2E1
=46eb 10 15:39:54 localhost NetworkManager: <info>    nameserver '192.1=
68.2.1'
=46eb 10 15:39:54 localhost NetworkManager: <info>  Activation (wlan2)
Stage 5 of 5 (IP Configure Commit) scheduled...
=46eb 10 15:39:54 localhost NetworkManager: <info>  Activation (wlan2)
Stage 4 of 5 (IP Configure Get) complete.
=46eb 10 15:39:54 localhost NetworkManager: <info>  Activation (wlan2)
Stage 5 of 5 (IP Configure Commit) started...
=46eb 10 15:39:54 localhost dhclient: bound to 192.168.2.101 -- renewal
in 387238970 seconds.
=46eb 10 15:39:55 localhost NetworkManager: <info>  Activation (wlan2)
successful, device activated.
=46eb 10 15:39:55 localhost NetworkManager: <info>  Activation (wlan2)
Stage 5 of 5 (IP Configure Commit) complete.


Note 1: my zd1211rw is build when CONFIG_ZD1211RW_DEBUG is not set.

Note2 (chipset): lsusb gives:
Bus 002 Device 073: ID 0ace:1211 ZyDAS 802.11b/g USB2 WiFi


Regards,
MarkR







On Tue, Feb 10, 2009 at 12:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> With the -rc4 based wireless tree:
>
> [ 1810.855457] usb 1-1: firmware: requesting zd1211/zd1211b_ub
> [ 1810.868857] usb 1-1: firmware: requesting zd1211/zd1211b_uphr
> [ 1810.926526] zd1211rw 1-1:1.0: firmware version 4725
> [ 1810.966529] zd1211rw 1-1:1.0: zd1211b chip 1582:6003 v4810 high 00=
-11-f6 AL2230_RF pa0 -----
> [ 1810.969518] cfg80211: Calling CRDA for country: DE
> [ 1811.970118] zd1211rw 1-1:1.0: error ioread32(CR_REG1): -110
> [ 1812.030460] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 1812.030467] BUG kmalloc-64: Poison overwritten
> [ 1812.030470] ------------------------------------------------------=
-----------------------
> [ 1812.030471]
> [ 1812.030474] INFO: 0xffff880055000550-0xffff88005500057f. First byt=
e 0x1 instead of 0x6b
> [ 1812.030487] INFO: Allocated in zd_usb_enable_int+0xa5/0x180 [zd121=
1rw] age=3D114 cpu=3D0 pid=3D4209
> [ 1812.030496] INFO: Freed in int_urb_complete+0x92/0x1bc [zd1211rw] =
age=3D107 cpu=3D0 pid=3D4209
> [ 1812.030499] INFO: Slab 0xffffe20002288000 objects=3D30 used=3D28 f=
p=3D0xffff880055000550 flags=3D0x40000000000000c3
> [ 1812.030503] INFO: Object 0xffff880055000550 @offset=3D1360 fp=3D0x=
ffff8800550003b8
> [ 1812.030504]
> [ 1812.030507] Bytes b4 0xffff880055000540:  42 c8 01 00 01 00 00 00 =
5a 5a 5a 5a 5a 5a 5a 5a B=EF=BF=BD......ZZZZZZZZ
> [ 1812.030529]   Object 0xffff880055000550:  01 90 82 96 00 00 80 96 =
a0 00 00 00 00 00 6b a5 ..............k=EF=BF=BD
> [ 1812.030551]   Object 0xffff880055000560:  00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 ................
> [ 1812.030573]   Object 0xffff880055000570:  00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 ................
> [ 1812.030594]   Object 0xffff880055000580:  6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk=EF=BF=BD
> [ 1812.030616]  Redzone 0xffff880055000590:  bb bb bb bb bb bb bb bb =
                        =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD
> [ 1812.030638]  Padding 0xffff8800550005d0:  5a 5a 5a 5a 5a 5a 5a 5a =
                        ZZZZZZZZ
> [ 1812.030662] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.29-rc4-wl-13=
559-g0416c58-dirty #40
> [ 1812.030666] Call Trace:
> [ 1812.030669]  <IRQ>  [<ffffffff802d3116>] print_trailer+0x106/0x160
> [ 1812.030681]  [<ffffffff802d3875>] check_bytes_and_report+0x125/0x1=
80
> [ 1812.030685]  [<ffffffff802d397c>] check_object+0xac/0x270
> [ 1812.030704]  [<ffffffffa005d7ae>] ? ohci_urb_enqueue+0xae/0x360 [o=
hci_hcd]
> [ 1812.030709]  [<ffffffff802d4595>] alloc_debug_processing+0x105/0x1=
a0
> [ 1812.030714]  [<ffffffff802d59d6>] __slab_alloc+0x96/0x2f0
> [ 1812.030721]  [<ffffffffa005d7ae>] ? ohci_urb_enqueue+0xae/0x360 [o=
hci_hcd]
> [ 1812.030728]  [<ffffffffa005d7ae>] ? ohci_urb_enqueue+0xae/0x360 [o=
hci_hcd]
> [ 1812.030732]  [<ffffffff802d6a06>] __kmalloc+0x106/0x140
> [ 1812.030739]  [<ffffffffa005d7ae>] ohci_urb_enqueue+0xae/0x360 [ohc=
i_hcd]
> [ 1812.030762]  [<ffffffffa0017838>] usb_hcd_submit_urb+0x88/0x1c0 [u=
sbcore]
> [ 1812.030779]  [<ffffffffa0017dfd>] usb_submit_urb+0x10d/0x340 [usbc=
ore]
> [ 1812.030789]  [<ffffffffa00934ce>] hid_irq_in+0x9e/0x210 [usbhid]
> [ 1812.030806]  [<ffffffffa0016050>] usb_hcd_giveback_urb+0x60/0xe0 [=
usbcore]
> [ 1812.030813]  [<ffffffffa005ab11>] finish_urb+0xa1/0x110 [ohci_hcd]
> [ 1812.030820]  [<ffffffffa005ac3b>] takeback_td+0xbb/0x160 [ohci_hcd=
]
> [ 1812.030826]  [<ffffffffa005ad93>] dl_done_list+0xb3/0x110 [ohci_hc=
d]
> [ 1812.030833]  [<ffffffffa005f470>] ohci_irq+0x2f0/0x3cc [ohci_hcd]
> [ 1812.030850]  [<ffffffffa0015930>] ? usb_hcd_irq+0x20/0xb0 [usbcore=
]
> [ 1812.030867]  [<ffffffffa0015950>] usb_hcd_irq+0x40/0xb0 [usbcore]
> [ 1812.030873]  [<ffffffff8029166b>] handle_IRQ_event+0x3b/0x80
> [ 1812.030877]  [<ffffffff802931f1>] handle_fasteoi_irq+0x91/0x110
> [ 1812.030883]  [<ffffffff8020e43c>] do_IRQ+0x9c/0x150
> [ 1812.030887]  [<ffffffff8020c6d3>] ret_from_intr+0x0/0xf
> [ 1812.030893]  [<ffffffff8024ccb0>] ? tasklet_action+0x140/0x160
> [ 1812.030898]  [<ffffffff8024ccac>] ? tasklet_action+0x13c/0x160
> [ 1812.030902]  [<ffffffff8024d71d>] ? __do_softirq+0x9d/0x190
> [ 1812.030907]  [<ffffffff8020cebc>] ? call_softirq+0x1c/0x40
> [ 1812.030909]  <EOI>  [<ffffffff8020e1a5>] ? do_softirq+0x75/0xc0
> [ 1812.030916]  [<ffffffff8024cd54>] ? ksoftirqd+0x84/0x1b0
> [ 1812.030920]  [<ffffffff8024ccd0>] ? ksoftirqd+0x0/0x1b0
> [ 1812.030924]  [<ffffffff8024ccd0>] ? ksoftirqd+0x0/0x1b0
> [ 1812.030929]  [<ffffffff8025f2e9>] ? kthread+0x49/0x90
> [ 1812.030934]  [<ffffffff8020cdba>] ? child_rip+0xa/0x20
> [ 1812.030938]  [<ffffffff8020c780>] ? restore_args+0x0/0x30
> [ 1812.030942]  [<ffffffff8025f2a0>] ? kthread+0x0/0x90
> [ 1812.030946]  [<ffffffff8020cdb0>] ? child_rip+0x0/0x20
> [ 1812.030949] FIX kmalloc-64: Restoring 0xffff880055000550-0xffff880=
05500057f=3D0x6b
> [ 1812.030950]
> [ 1812.030953] FIX kmalloc-64: Marking all objects used
> [ 1812.057052] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [ 1819.141519] wlan1: authenticate with AP 8e:b5:9c:32:62:6e
> [ 1819.340080] wlan1: authenticate with AP 8e:b5:9c:32:62:6e
> [ 1819.550073] wlan1: authenticate with AP 8e:b5:9c:32:62:6e
> [ 1819.750061] wlan1: authentication with AP 8e:b5:9c:32:62:6e timed =
out
>
> johannes
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

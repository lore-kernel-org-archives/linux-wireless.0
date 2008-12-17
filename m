Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:27274 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYLQE3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 23:29:19 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3581005wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 20:29:18 -0800 (PST)
Message-ID: <919fe2b30812162029w62a550dcs90ad1ed68eb9e1a7@mail.gmail.com> (sfid-20081217_052926_214060_9F077B8E)
Date: Tue, 16 Dec 2008 23:29:18 -0500
From: "Mark Asselstine" <asselsm@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] rt2860/wpa dev status
Cc: rt2400-devel@lists.sourceforge.net,
	"Mattias Nissler" <mattias.nissler@gmx.de>,
	"Felix Fietkau" <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200812101448.08990.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <919fe2b30810020637n2c9e857ak4ce55bcbf8a50ccb@mail.gmail.com>
	 <200812101448.08990.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2008 at 8:48 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
> Ralink has provided a new driver for the rt2860 hardware,
> I haven't tested it yet but it deserves the attention for one simple reason:
> it hooks into mac80211.
> It doesn't hook into rt2x00lib yet, and neither does it support everything
> mac80211 could do, but it can be used as base for further developing
> the rt2800pci drivers by filling the last remaining gaps.
>
> The driver can be found here:
> http://kernel.org/pub/linux/kernel/people/ivd/RT28xx_Linux_mac80211_20081203_V2.0-GPL.tgz
>
> Mark, Matthias and Felix you offered/provided help with the rt2800 developers
> before. I would really appreciate if you could help me with merging this drivers
> into the rt2800pci/rt2800usb drivers. :)
> (Other developers are off course welcome as well!)
>

Thanks for doing some of the initial legwork. I have finally managed
to get workflow in place and attempt to do some useful work. I can get
a reproducible kernel oops by simply doing a 'ifconfig wlan0 up'
followed by a 'iwlist wlan0 scanning'. I do plan on digging into this
but here is the oops:

BUG: unable to handle kernel NULL pointer dereference at 0000001c
IP: [<f80e9720>] rt2x00ht_create_tx_descriptor+0x20/0xc0 [rt2x00lib]
Oops: 0000 [#1]
last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.3/0000:01:00.0/firmware/0000:01:00.0/loading
Modules linked in: rt2800pci rt2x00pci rt2x00lib crc_ccitt
eeprom_93cx6 netconsole ipv6 [last unloaded: eeprom_93cx6]

Pid: 1803, comm: phy2 Not tainted (2.6.28-rc7-wl #12) 1000H
EIP: 0060:[<f80e9720>] EFLAGS: 00010286 CPU: 0
EIP is at rt2x00ht_create_tx_descriptor+0x20/0xc0 [rt2x00lib]
EAX: 00000000 EBX: f69e9e00 ECX: f7307b40 EDX: 00000000
ESI: f7307260 EDI: f7307240 EBP: f7307260 ESP: f69e9da0
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process phy2 (pid: 1803, ti=f69e8000 task=f71267c0 task.ti=f69e8000)
Stack:
 f69e9e00 f6959c00 f80e9800 f80e84ed f7307240 f6964c60 f6a06420 f7307b40
 0000002e f690b42c f7307240 f69641a0 f6959c00 f80e885a f69e9f40 c17ecac0
 00000000 f69eb100 f7307260 3f656025 00000000 f7307240 00000000 f6a26b00
Call Trace:
 [<f80e84ed>] rt2x00queue_create_tx_descriptor+0x23d/0x360 [rt2x00lib]
 [<f80e885a>] rt2x00queue_write_tx_frame+0x4a/0x190 [rt2x00lib]
 [<f80e762f>] rt2x00mac_tx+0x7f/0x300 [rt2x00lib]
 [<c036c831>] __ieee80211_tx+0x41/0xf0
 [<c036e85f>] ieee80211_master_start_xmit+0x1df/0x400
 [<c0378cd4>] schedule_timeout+0x54/0xb0
 [<c02e4a02>] dev_hard_start_xmit+0x232/0x2c0
 [<c02f2f3b>] __qdisc_run+0x19b/0x1f0
 [<c02e4e87>] dev_queue_xmit+0x2e7/0x500
 [<c035f3b8>] ieee80211_scan_work+0xe8/0x1a0
 [<c035f2d0>] ieee80211_scan_work+0x0/0x1a0
 [<c012b2da>] run_workqueue+0x4a/0xf0
 [<c037887c>] schedule+0x18c/0x2f0
 [<c012b70f>] worker_thread+0x7f/0xe0
 [<c012e920>] autoremove_wake_function+0x0/0x50
 [<c012b690>] worker_thread+0x0/0xe0
 [<c012e547>] kthread+0x37/0x70
 [<c012e510>] kthread+0x0/0x70
 [<c0103eab>] kernel_thread_helper+0x7/0x1c
Code: ff ff 90 90 90 90 90 90 90 90 90 83 ec 0c 89 1c 24 89 d3 0f b6
51 06 89 74 24 04 89 7c 24 08 8b 78 08 8d 14 92 8d 77 20 8b 46 20 <0f>
b6 40 1c 66 c7 43 14 00 00 66 c7 43 12 00 00 66 89 43 18 0f
EIP: [<f80e9720>] rt2x00ht_create_tx_descriptor+0x20/0xc0 [rt2x00lib]
SS:ESP 0068:f69e9da0
Kernel panic - not syncing: Fatal exception in interrupt


Dump of assembler code for function rt2x00ht_create_tx_descriptor:
0x00003730 <rt2x00ht_create_tx_descriptor+0>:   sub    $0xc,%esp
0x00003733 <rt2x00ht_create_tx_descriptor+3>:   mov    %ebx,(%esp)
0x00003736 <rt2x00ht_create_tx_descriptor+6>:   mov    %edx,%ebx
0x00003738 <rt2x00ht_create_tx_descriptor+8>:   movzbl 0x6(%ecx),%edx
0x0000373c <rt2x00ht_create_tx_descriptor+12>:  mov    %esi,0x4(%esp)
0x00003740 <rt2x00ht_create_tx_descriptor+16>:  mov    %edi,0x8(%esp)
0x00003744 <rt2x00ht_create_tx_descriptor+20>:  mov    0x8(%eax),%edi
0x00003747 <rt2x00ht_create_tx_descriptor+23>:  lea
(%edx,%edx,4),%edx
0x0000374a <rt2x00ht_create_tx_descriptor+26>:  lea    0x20(%edi),%esi
0x0000374d <rt2x00ht_create_tx_descriptor+29>:  mov    0x20(%esi),%eax
0x00003750 <rt2x00ht_create_tx_descriptor+32>:  movzbl 0x1c(%eax),%eax
0x00003754 <rt2x00ht_create_tx_descriptor+36>:  movw   $0x0,0x14(%ebx)
0x0000375a <rt2x00ht_create_tx_descriptor+42>:  movw   $0x0,0x12(%ebx)
0x00003760 <rt2x00ht_create_tx_descriptor+48>:  mov    %ax,0x18(%ebx)
0x00003764 <rt2x00ht_create_tx_descriptor+52>:  movzbl 0x8(%edx,%edx,1),%eax
0x0000376c <rt2x00ht_create_tx_descriptor+60>:  mov    %ax,0x10(%ebx)
0x00003770 <rt2x00ht_create_tx_descriptor+64>:  mov    %eax,%edx
0x00003772 <rt2x00ht_create_tx_descriptor+66>:  testw  $0xff00,0x6(%ecx)
0x00003778 <rt2x00ht_create_tx_descriptor+72>:  je     0x3781
<rt2x00ht_create_tx_descriptor+81>
0x0000377a <rt2x00ht_create_tx_descriptor+74>:  or     $0x8,%edx
0x0000377d <rt2x00ht_create_tx_descriptor+77>:  mov    %dx,0x10(%ebx)
0x00003781 <rt2x00ht_create_tx_descriptor+81>:  testb  $0x40,0x20(%edi)
0x00003785 <rt2x00ht_create_tx_descriptor+85>:  je     0x378b
<rt2x00ht_create_tx_descriptor+91>
0x00003787 <rt2x00ht_create_tx_descriptor+87>:  btsl   $0xe,(%ebx)
0x0000378b <rt2x00ht_create_tx_descriptor+91>:  movzbl 0xa(%esi),%edx
0x0000378f <rt2x00ht_create_tx_descriptor+95>:  movzbl %dl,%eax
0x00003792 <rt2x00ht_create_tx_descriptor+98>:  test   $0x8,%al
0x00003794 <rt2x00ht_create_tx_descriptor+100>: je     0x37a3
<rt2x00ht_create_tx_descriptor+115>
0x00003796 <rt2x00ht_create_tx_descriptor+102>: movw   $0x2,0x16(%ebx)
0x0000379c <rt2x00ht_create_tx_descriptor+108>: movzbl 0xa(%esi),%edx
0x000037a0 <rt2x00ht_create_tx_descriptor+112>: movzbl %dl,%eax
0x000037a3 <rt2x00ht_create_tx_descriptor+115>: test   $0x10,%al
0x000037a5 <rt2x00ht_create_tx_descriptor+117>: je     0x37b4
0x000037a7 <rt2x00ht_create_tx_descriptor+119>: movw   $0x3,0x16(%ebx)
0x000037ad:     movzbl 0xa(%esi),%edx
0x000037b1:     movzbl %dl,%eax
0x000037b4:     test   $0x20,%al
0x000037b6:     je     0x37c0
0x000037b8:     btsl   $0xf,(%ebx)
---Type <return> to continue, or q <return> to quit---
0x000037bc:     movzbl 0xa(%esi),%edx
0x000037c0:     test   %dl,%dl
0x000037c2:     jns    0x37c8
0x000037c4:     btsl   $0x10,(%ebx)
0x000037c8:     mov    (%esp),%ebx
0x000037cb:     mov    0x4(%esp),%esi
0x000037cf:     mov    0x8(%esp),%edi
0x000037d3:     add    $0xc,%esp
0x000037d6:     ret
End of assembler dump.

This could easily be my setup but I thought I would send it out to let
you know your email did not go unnoticed and secondly in case you had
some hints as to what I might be doing incorrectly.

Mark

> Ivo
>
> On Thursday 02 October 2008, Mark Asselstine wrote:
>> Hello,
>>
>> I have some free cycles and would love to help out in getting support
>> for rt2860 and wpa support into this project. I can see that such
>> support was discussed some at the last development meeting as well as
>> in Bug 10754. I have cloned the tree and am ready to go, anyone have
>> any pointers to areas I can help out with?
>>
>> Regards,
>> Mark
>>
>> -------------------------------------------------------------------------
>> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
>> Build the coolest Linux based applications with Moblin SDK & win great prizes
>> Grand prize is a trip for two to an Open Source event anywhere in the world
>> http://moblin-contest.org/redirect.php?banner_id=100&url=/
>> _______________________________________________
>> Rt2400-devel mailing list
>> Rt2400-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/rt2400-devel
>>
>
>
>

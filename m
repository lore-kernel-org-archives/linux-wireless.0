Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:31028 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbYKNFqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 00:46:08 -0500
Received: by yx-out-2324.google.com with SMTP id 8so570955yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 21:46:07 -0800 (PST)
Message-ID: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com> (sfid-20081114_064624_181159_88900B00)
Date: Thu, 13 Nov 2008 23:46:06 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Kernel oops when loading ath5k from compat-wireless in 2.6.27
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also reported here a few times, I've been seeing this bug every time I
try to load up the ath5k module in my kernel:
http://www.kerneloops.org/search.php?search=ieee80211_register_hw&btnG=Function+Search

If you guys have any suggestions, I'd love to hear them. I
disassembled the code in question but am not very good with these
things. It looks to be somewhere between lines 804-825 in
net/mac80211/main.c.

-Dan

ath5k_pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ath5k_pci 0000:01:00.0: setting latency timer to 64
ath5k_pci 0000:01:00.0: registered as ''
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<b80c1252>] :mac80211:ieee80211_register_hw+0x10f/0x2d6
*pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: ath5k(+) mac80211

Pid: 818, comm: modprobe Not tainted (2.6.27.6eee #3)
EIP: 0060:[<b80c1252>] EFLAGS: 00010286 CPU: 0
EIP is at ieee80211_register_hw+0x10f/0x2d6 [mac80211]
EAX: 00000000 EBX: b7345000 ECX: 00000001 EDX: 00000001
ESI: b681c180 EDI: 00000000 EBP: b7183000 ESP: b7365e00
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 818, ti=b7364000 task=b71f7130 task.ti=b7364000)
Stack: 00000000 00000000 b681cd00 b681cd00 b681fe06 b80ea639 b7365e70 b681cd00
       00000005 b7064458 b7365e70 b7064400 781689c9 b7007000 b8060000 b681cd00
       b681c180 00000000 b681fde4 b7183000 0c0c45e9 0000001a b681cde8 b7183000
Call Trace:
 [<b80ea639>] ath5k_pci_probe+0xc27/0x1150 [ath5k]
 [<781689c9>] find_inode+0x1b/0x56
 [<781e0b0e>] pci_device_probe+0x36/0x55
 [<78252342>] driver_probe_device+0xa1/0x132
 [<7825240a>] __driver_attach+0x37/0x55
 [<78251d86>] bus_for_each_dev+0x35/0x5c
 [<782521f1>] driver_attach+0x11/0x13
 [<782523d3>] __driver_attach+0x0/0x55
 [<7825184b>] bus_add_driver+0x91/0x1a7
 [<b802d000>] init_ath5k_pci+0x0/0x2f [ath5k]
 [<78252571>] driver_register+0x7d/0xd6
 [<b802d000>] init_ath5k_pci+0x0/0x2f [ath5k]
 [<781e0d11>] __pci_register_driver+0x35/0x60
 [<b802d01a>] init_ath5k_pci+0x1a/0x2f [ath5k]
 [<7810111f>] _stext+0x37/0xfb
 [<78137d76>] sys_init_module+0x87/0x175
 [<78102de9>] sysenter_do_call+0x12/0x25
 =======================
Code: 83 c8 00 00 00 21 03 c7 83 b4 00 00 00 1c 49 0d b8 c7 83 0c 02
00 00 ee 17 0c b8 8b 46 1c 8b 40 7c 8b 80 bc 00 00 00 6a 00 6a 00 <8b>
00 e8 75 64 06 c0 5f bf f4 ff ff ff 85 c0 89 46 20 5a 0f 84
EIP: [<b80c1252>] ieee80211_register_hw+0x10f/0x2d6 [mac80211] SS:ESP
0068:b7365e00
---[ end trace 0b0fad82f83782b1 ]---


GDB disassembly:

0x0000028f <ieee80211_register_hw+296>: cmpl   $0xd,0x30(%esi)
0x00000293 <ieee80211_register_hw+300>: mov    $0xd,%eax
0x00000298 <ieee80211_register_hw+305>: cmovae 0x30(%esi),%eax
0x0000029c <ieee80211_register_hw+309>: cmpl   $0x9,(%esi)
0x0000029f <ieee80211_register_hw+312>: mov    %eax,0x9c(%esi)
0x000002a5 <ieee80211_register_hw+318>: jg     0x2ad <ieee80211_register_hw+326>
0x000002a7 <ieee80211_register_hw+320>: movl   $0x64,(%esi)
0x000002ad <ieee80211_register_hw+326>: cmpw   $0x0,0x44(%esi)
0x000002b2 <ieee80211_register_hw+331>: jne    0x2ba <ieee80211_register_hw+339>
0x000002b4 <ieee80211_register_hw+333>: movw   $0x1,0x44(%esi)
0x000002ba <ieee80211_register_hw+339>: mov    0x2c(%esi),%ecx
0x000002bd <ieee80211_register_hw+342>: mov    0x44(%esi),%eax
0x000002c0 <ieee80211_register_hw+345>: mov    %ecx,%edx
0x000002c2 <ieee80211_register_hw+347>: mov    %ax,0xc(%esi)
---Type <return> to continue, or q <return> to quit---
0x000002c6 <ieee80211_register_hw+351>: mov    %cl,%al
0x000002c8 <ieee80211_register_hw+353>: and    $0xe0,%al
0x000002ca <ieee80211_register_hw+355>: cmp    $0x1,%al
0x000002cc <ieee80211_register_hw+357>: sbb    %eax,%eax
0x000002ce <ieee80211_register_hw+359>: and    $0x100,%edx
0x000002d4 <ieee80211_register_hw+365>: and    $0xf,%al
0x000002d6 <ieee80211_register_hw+367>: inc    %al
^^^ HERE ^^^
0x000002d8 <ieee80211_register_hw+369>: or     0x98(%esi),%al
0x000002de <ieee80211_register_hw+375>: cmp    $0x1,%edx
0x000002e1 <ieee80211_register_hw+378>: sbb    %edx,%edx
0x000002e3 <ieee80211_register_hw+380>: and    $0x3c,%dl
0x000002e6 <ieee80211_register_hw+383>: add    $0x4,%dl
0x000002e9 <ieee80211_register_hw+386>: or     %al,%dl
0x000002eb <ieee80211_register_hw+388>: test   %cl,%cl
0x000002ed <ieee80211_register_hw+390>: mov    %dl,0x98(%esi)
0x000002f3 <ieee80211_register_hw+396>: jns    0x2fe <ieee80211_register_hw+407>
0x000002f5 <ieee80211_register_hw+398>: or     $0x8,%dl
0x000002f8 <ieee80211_register_hw+401>: mov    %dl,0x98(%esi)
0x000002fe <ieee80211_register_hw+407>: mov    %esi,%eax
0x00000300 <ieee80211_register_hw+409>: call   0x301 <ieee80211_register_hw+410>
0x00000305 <ieee80211_register_hw+414>: test   %eax,%eax
0x00000307 <ieee80211_register_hw+416>: mov    %eax,%edi
0x00000309 <ieee80211_register_hw+418>: js     0x41b <ieee80211_register_hw+692>
0x0000030f <ieee80211_register_hw+424>: call   0x310 <ieee80211_register_hw+425>
0x00000314 <ieee80211_register_hw+429>: mov    0x54(%esi),%eax
0x00000317 <ieee80211_register_hw+432>: mov    %eax,%edx

GCC assembly compile:

	call	ieee80211_rx_bss_list_init
	movl	$1, %edx
	movl	$1, %ecx
	movl	$ieee80211_master_start_xmit, 412(%ebx)
	movl	$ieee80211_master_open, 508(%ebx)
	movl	$ieee80211_master_stop, 512(%ebx)
	movw	$801, 200(%ebx)
	movl	$ieee80211_header_ops, 180(%ebx)
	movl	$ieee80211_master_set_multicast_list, 524(%ebx)
	movl	28(%esi), %eax
	movl	124(%eax), %eax
	movl	188(%eax), %eax
	pushl	$0
	pushl	$0
	movl	(%eax), %eax
	call	__create_workqueue_key
	popl	%edi
	movl	$-12, %edi
	testl	%eax, %eax
	movl	%eax, 32(%esi)
	popl	%edx
	je	.L34
	cmpl	$13, 48(%esi)
	movl	$13, %eax
	cmovae	48(%esi), %eax
	cmpl	$9, (%esi)
	movl	%eax, 156(%esi)
	jg	.L35
	movl	$100, (%esi)
.L35:
	cmpw	$0, 68(%esi)
	jne	.L36
	movw	$1, 68(%esi)
.L36:
	movl	44(%esi), %ecx
	movl	68(%esi), %eax
	movl	%ecx, %edx
	movw	%ax, 12(%esi)
	movb	%cl, %al
	andb	$-32, %al
	cmpb	$1, %al
	sbbl	%eax, %eax
	andl	$256, %edx
	andb	$15, %al
	incb	%al
^^^ HERE ^^^
	orb	152(%esi), %al
	cmpl	$1, %edx
	sbbl	%edx, %edx
	andb	$60, %dl
	addb	$4, %dl
	orb	%al, %dl
	testb	%cl, %cl
	movb	%dl, 152(%esi)
	jns	.L41
	orb	$8, %dl
	movb	%dl, 152(%esi)
.L41:
	movl	%esi, %eax
	call	sta_info_start
	testl	%eax, %eax
	movl	%eax, %edi
	js	.L42
	call	rtnl_lock
	movl	84(%esi), %eax
	movl	%eax, %edx
	call	dev_alloc_name
	testl	%eax, %eax
	movl	%eax, %edi
	js	.L43
	movl	28(%esi), %edx
	movl	84(%esi), %ecx
	movl	(%edx), %eax
	movl	%eax, 308(%ecx)
	movw	4(%edx), %ax
	movw	%ax, 312(%ecx)
	movl	28(%esi), %eax
	movl	84(%esi), %edx
	movl	124(%eax), %eax
	movl	%eax, 688(%edx)
	movl	84(%esi), %eax
	call	register_netdevice
	testl	%eax, %eax
	movl	%eax, %edi
	js	.L43
	movl	36(%esi), %edx
	movl	%esi, %eax
	call	ieee80211_init_rate_ctrl_alg

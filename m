Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay.db.kumina.nl ([213.207.83.10]:36308 "EHLO
	mx1.kumina.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYKEPtZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 10:49:25 -0500
Received: from localhost (localhost [127.0.0.1])
	by mx1.kumina.nl (Postfix) with ESMTP id 45CC8CC069
	for <linux-wireless@vger.kernel.org>; Wed,  5 Nov 2008 16:28:35 +0100 (CET)
Received: from mx1.kumina.nl ([127.0.0.1])
	by localhost (mailrelay.db.kumina.nl [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ZtMOb+aGSXeO for <linux-wireless@vger.kernel.org>;
	Wed,  5 Nov 2008 16:28:31 +0100 (CET)
Received: from mx1.upexia.nl (colo2.db.upexia.nl [213.207.83.52])
	by mx1.kumina.nl (Postfix) with ESMTP id B2512CC06C
	for <linux-wireless@vger.kernel.org>; Wed,  5 Nov 2008 16:28:31 +0100 (CET)
Received: from [192.168.0.5] (tolva.upexia.nl [145.99.241.243])
	by mx1.upexia.nl (Postfix) with ESMTP id 53F0658167
	for <linux-wireless@vger.kernel.org>; Wed,  5 Nov 2008 16:28:31 +0100 (CET)
Message-ID: <4911BC1A.5030306@upexia.nl> (sfid-20081105_164930_146084_80F3F484)
Date: Wed, 05 Nov 2008 16:30:34 +0100
From: "Dirk Teurlings [Upexia]" <dirk@upexia.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k driver kernel panic while in AP mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

I'm working on getting OpenWrt support for the Linksys wrt350nv2, it's a 
marvell orion based arm9 platform with an atheros wireless n card.

The target is running a 2.6.27 kernel with compat-wireless-2008-11-03 
drivers with ath9k enabled. Hostapd 0.6.5 is used for AP mode setup
lspci shows: 01:07.0 Network controller: Atheros Communications, Inc. 
AR5416 802.11a/b/g/n Wireless PCI Adapter (rev 01)

The router runs fine for about a minute or five, but then it fails; here 
are two of the panics I got.
I've already asked the one responsible for wifi @ openwrt but he 
suggested to post my results here

-------------------------------------------------------

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1]
Modules linked in: ehci_hcd nf_nat_tftp nf_conntrack_tftp nf_nat_irc 
nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat 
nf_nat xt_state nf_conntrack_ipv4 nf_conntrack ipt_REJECT xt_TCPMSS 
ipt_LOG xt_multiport xt_mac xt_limit iptable_mangle iptable_filter 
ip_tables xt_tcpudp x_tables ath9k usbcore mac80211 cfg80211 arc4 
aes_generic deflate ecb cbc crypto_blkcipher crypto_hash cryptomgr 
crypto_algapi
CPU: 0    Not tainted  (2.6.27 #16)
PC is at skb_gso_segment+0x24/0x1c4
LR is at dev_hard_start_xmit+0x18c/0x274
pc : [<c0139128>]    lr : [<c0139454>]    psr: a0000013
sp : c0215cb4  ip : c0215cd4  fp : c0215cd0
r10: c02332e4  r9 : 00000000  r8 : c1d84620
r7 : 00000803  r6 : 00000008  r5 : c04e5840  r4 : 00000000
r3 : 00000000  r2 : c1890000  r1 : 00000803  r0 : c04e5840
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: a005317f  Table: 00cfc000  DAC: 00000017
Process swapper (pid: 0, stack limit = 0xc0214260)
Stack: (0xc0215cb4 to 0xc0216000)
5ca0:                                              00000000 c04e5840 
c023334c
5cc0: c1d50400 c0215cfc c0215cd4 c0139454 c0139114 c015ca00 c04e5840 
c0220380
5ce0: c04e5840 c1d84620 c1d50400 c0cac0f0 c0215d1c c0215d00 c013c200 
c01392d8
5d00: c04e5840 c0cac0e0 0000000e 00000000 c0215d40 c0215d20 c015cc08 
c013be78
5d20: c04e5840 c0233794 c0f530c0 c04e5860 c04e5840 c0215d64 c0215d44 
c015cf98
5d40: c015ca10 c1d50400 c015ca00 80000000 c04e5840 c1896048 c0215d78 
c0215d68
5d60: c0159d28 c015cf00 c04e5840 c0215da4 c0215d7c c0159fa0 c0159cf4 
c1d50400
5d80: c0159ce4 80000000 c1896048 c04e5840 c0233020 c1d19000 c0215de0 
c0215da8
5da0: c0158910 c0159d40 c1d19000 c01585bc 80000000 c0233774 c02332cc 
c04e5840
5dc0: c02332cc c04e5840 c0233020 c1d19000 00000008 c0215e0c c0215de4 
c0158de8
5de0: c01585cc 00000000 c01585bc 80000000 c02332cc c04e5840 c0221cf4 
c1d19000
5e00: c0215e40 c0215e10 c0139044 c0158b98 c0215ea0 c1c88d60 c04e5840 
00000000
5e20: c1ddb4e0 00000000 c1d19380 00000000 000018eb c0215e70 c0215e44 
c0193f08
5e40: c0138c08 c13e97c0 00000000 00000000 00000000 c04e5840 c189603a 
c1eb7c20
5e60: 00000001 c0215e9c c0215e74 c0194158 c0193dd4 c0215e80 c0052574 
c002744c
5e80: c1eb7c20 c04e5840 00000000 c1edc000 c0215ed0 c0215ea0 c0138f70 
c0193f64
5ea0: c0215f64 c0217b58 c02332b0 00000001 000018eb 00000040 0001aabc 
41069260
5ec0: 000018eb c0215ef0 c0215ed4 c013b5a4 c0138c08 c02332b0 00000040 
00000009
5ee0: 0000012c c0215f18 c0215ef4 c013afb4 c013b528 00000001 c0229520 
00000009
5f00: c0217b58 0001aabc 0001a9ec c0215f34 c0215f1c c0031abc c013af50 
00000006
5f20: c021b460 00000000 c0215f44 c0215f38 c0031dec c0031a70 c0215f60 
c0215f48
5f40: c001e048 c0031db8 ffffffff fdd20200 00000040 c0215fc0 c0215f64 
c001e7e8
5f60: c001e010 00000000 c1ee2be0 c0214000 00000000 c001fc44 c0214000 
c001cee0
5f80: c0217b58 0001aabc 41069260 0001a9ec c0215fc0 c0215fac c0215fac 
c001fb1c
5fa0: c001fc48 60000013 ffffffff c022bf14 c0223f30 c0215fd0 c0215fc4 
c019ddac
5fc0: c001faf4 c0215ff4 c0215fd4 c0008a34 c019dd68 c0008398 c001cee0 
a0053175
5fe0: c02243ec c001d2e4 00000000 c0215ff8 00008034 c00087b8 00000000 
00000000
Backtrace:
[<c0139104>] (skb_gso_segment+0x0/0x1c4) from [<c0139454>] 
(dev_hard_start_xmit+0x18c/0x274)
 r7:c1d50400 r6:c023334c r5:c04e5840 r4:00000000
[<c01392c8>] (dev_hard_start_xmit+0x0/0x274) from [<c013c200>] 
(dev_queue_xmit+0x398/0x470)
 r8:c0cac0f0 r7:c1d50400 r6:c1d84620 r5:c04e5840 r4:c0220380
[<c013be68>] (dev_queue_xmit+0x0/0x470) from [<c015cc08>] 
(ip_finish_output+0x208/0x25c)
 r7:00000000 r6:0000000e r5:c0cac0e0 r4:c04e5840
[<c015ca00>] (ip_finish_output+0x0/0x25c) from [<c015cf98>] 
(ip_output+0xa8/0xbc)
 r8:c04e5840 r7:c04e5860 r6:c0f530c0 r5:c0233794 r4:c04e5840
[<c015cef0>] (ip_output+0x0/0xbc) from [<c0159d28>] 
(ip_forward_finish+0x44/0x4c)
 r5:c1896048 r4:c04e5840
[<c0159ce4>] (ip_forward_finish+0x0/0x4c) from [<c0159fa0>] 
(ip_forward+0x270/0x2f0)
 r4:c04e5840
[<c0159d30>] (ip_forward+0x0/0x2f0) from [<c0158910>] 
(ip_rcv_finish+0x354/0x378)
 r7:c1d19000 r6:c0233020 r5:c04e5840 r4:c1896048
[<c01585bc>] (ip_rcv_finish+0x0/0x378) from [<c0158de8>] 
(ip_rcv+0x260/0x298)
 r8:00000008 r7:c1d19000 r6:c0233020 r5:c04e5840 r4:c02332cc
[<c0158b88>] (ip_rcv+0x0/0x298) from [<c0139044>] 
(netif_receive_skb+0x44c/0x498)
 r7:c1d19000 r6:c0221cf4 r5:c04e5840 r4:c02332cc
[<c0138bf8>] (netif_receive_skb+0x0/0x498) from [<c0193f08>] 
(br_handle_frame_finish+0x144/0x190)
[<c0193dc4>] (br_handle_frame_finish+0x0/0x190) from [<c0194158>] 
(br_handle_frame+0x204/0x23c)
 r8:00000001 r7:c1eb7c20 r6:c189603a r5:c04e5840 r4:00000000
[<c0193f54>] (br_handle_frame+0x0/0x23c) from [<c0138f70>] 
(netif_receive_skb+0x378/0x498)
 r7:c1edc000 r6:00000000 r5:c04e5840 r4:c1eb7c20
[<c0138bf8>] (netif_receive_skb+0x0/0x498) from [<c013b5a4>] 
(process_backlog+0x8c/0x120)
[<c013b518>] (process_backlog+0x0/0x120) from [<c013afb4>] 
(net_rx_action+0x74/0x1ac)
 r7:0000012c r6:00000009 r5:00000040 r4:c02332b0
[<c013af40>] (net_rx_action+0x0/0x1ac) from [<c0031abc>] 
(__do_softirq+0x5c/0xd0)
[<c0031a60>] (__do_softirq+0x0/0xd0) from [<c0031dec>] (irq_exit+0x44/0x4c)
 r6:00000000 r5:c021b460 r4:00000006
[<c0031da8>] (irq_exit+0x0/0x4c) from [<c001e048>] 
(__exception_text_start+0x48/0x60)
[<c001e000>] (__exception_text_start+0x0/0x60) from [<c001e7e8>] 
(__irq_svc+0x28/0x60)
Exception stack(0xc0215f64 to 0xc0215fac)
5f60:          00000000 c1ee2be0 c0214000 00000000 c001fc44 c0214000 
c001cee0
5f80: c0217b58 0001aabc 41069260 0001a9ec c0215fc0 c0215fac c0215fac 
c001fb1c
5fa0: c001fc48 60000013 ffffffff
 r6:00000040 r5:fdd20200 r4:ffffffff
[<c001fae4>] (cpu_idle+0x0/0x54) from [<c019ddac>] (rest_init+0x54/0x68)
 r5:c0223f30 r4:c022bf14
[<c019dd58>] (rest_init+0x0/0x68) from [<c0008a34>] 
(start_kernel+0x28c/0x2fc)
[<c00087a8>] (start_kernel+0x0/0x2fc) from [<00008034>] (0x8034)
 r6:c001d2e4 r5:c02243ec r4:a0053175
Code: e5933010 e1a07001 e3530000 13a03000 (15833000)
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 3 seconds..

-----------------------------------------------------
and another one:

Unable to handle kernel paging request at virtual address 00120122
pgd = c1f20000
[00120122] *pgd=00ca8031, *pte=00000000, *ppte=00000000
Internal error: Oops: 1 [#1]
Modules linked in: ehci_hcd nf_nat_tftp nf_conntrack_tftp nf_nat_irc 
nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat 
nf_nat xt_state nf_conntrack_ipv4 nf_conntrack ipt_REJECT xt_TCPMSS 
ipt_LOG xt_multiport xt_mac xt_limit iptable_mangle iptable_filter 
ip_tables xt_tcpudp x_tables ath9k usbcore mac80211 cfg80211 arc4 
aes_generic deflate ecb cbc crypto_blkcipher crypto_hash cryptomgr 
crypto_algapi
CPU: 0    Not tainted  (2.6.27 #16)
PC is at skb_copy_bits+0x184/0x214
LR is at __pskb_pull_tail+0x8c/0x2ac
pc : [<c01324bc>]    lr : [<c0133444>]    psr: 60000013
sp : c0215ca0  ip : 00000036  fp : c0215cd0
r10: c18aa070  r9 : c13693c0  r8 : 00000036
r7 : 001200d2  r6 : 00000036  r5 : 00000000  r4 : 00000000
r3 : 00000036  r2 : c18aaf60  r1 : 000004f8  r0 : c01fe7ac
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: a005317f  Table: 01f20000  DAC: 00000017
Process swapper (pid: 0, stack limit = 0xc0214260)
Stack: (0xc0215ca0 to 0xc0216000)
5ca0: 00000000 c13693c0 c13693c0 c13693c0 c13693c0 c1d22400 c0c69670 
00000000
5cc0: c02332e4 c0215cfc c0215cd4 c0133444 c0132348 c13693c0 c13693c0 
0000000e
5ce0: c1d22400 c0c69670 00000000 c02332e4 c0215d1c c0215d00 c013bed0 
c01333c8
5d00: c13693c0 c0c69660 0000000e 00000000 c0215d40 c0215d20 c015cc08 
c013be78
5d20: c13693c0 c0233794 c1e30960 c13693e0 c13693c0 c0215d64 c0215d44 
c015cf98
5d40: c015ca10 c1d22400 c015ca00 80000000 c13693c0 c18aa048 c0215d78 
c0215d68
5d60: c0159d28 c015cf00 c13693c0 c0215da4 c0215d7c c0159fa0 c0159cf4 
c1d22400
5d80: c0159ce4 80000000 c18aa048 c13693c0 c0233020 c1d19000 c0215de0 
c0215da8
5da0: c0158910 c0159d40 c1d19000 c01585bc 80000000 c0233774 c02332cc 
c13693c0
5dc0: c02332cc c13693c0 c0233020 c1d19000 00000008 c0215e0c c0215de4 
c0158de8
5de0: c01585cc 00000000 c01585bc 80000000 c02332cc c13693c0 c0221cf4 
c1d19000
5e00: c0215e40 c0215e10 c0139044 c0158b98 c0215ea0 c1c88d60 c13693c0 
00000000
5e20: c1ef44e0 00000000 c1d19380 00000000 ffffce20 c0215e70 c0215e44 
c0193f08
5e40: c0138c08 00000f20 00000000 ffc24270 00000000 c13693c0 c18aa03a 
c0c2e1a0
5e60: 00000001 c0215e9c c0215e74 c0194158 c0193dd4 c1ff1860 c1c88eb4 
c1ff17e8
5e80: c0c2e1a0 c13693c0 00000000 c1f42800 c0215ed0 c0215ea0 c0138f70 
c0193f64
5ea0: 0000000a c1fa0000 c02332b0 00000001 ffffce20 00000040 0001aabc 
41069260
5ec0: ffffce20 c0215ef0 c0215ed4 c013b5a4 c0138c08 c02332b0 00000040 
00000009
5ee0: 0000012c c0215f18 c0215ef4 c013afb4 c013b528 00000001 c0229520 
00000009
5f00: c0217b58 0001aabc 0001a9ec c0215f34 c0215f1c c0031abc c013af50 
00000006
5f20: c021b460 00000000 c0215f44 c0215f38 c0031dec c0031a70 c0215f60 
c0215f48
5f40: c001e048 c0031db8 ffffffff fdd20200 00000040 c0215fc0 c0215f64 
c001e7e8
5f60: c001e010 00000000 c1d4ec00 c0214000 60000013 c001fc44 c0214000 
c001cee0
5f80: c0217b58 0001aabc 41069260 0001a9ec c0215fc0 c0215fac c0215fac 
c001fc88
5fa0: c001fb1c 60000013 ffffffff c022bf14 c0223f30 c0215fd0 c0215fc4 
c019ddac
5fc0: c001faf4 c0215ff4 c0215fd4 c0008a34 c019dd68 c0008398 c001cee0 
a0053175
5fe0: c02243ec c001d2e4 00000000 c0215ff8 00008034 c00087b8 00000000 
00000000
Backtrace:
[<c0132338>] (skb_copy_bits+0x0/0x214) from [<c0133444>] 
(__pskb_pull_tail+0x8c/0x2ac)
[<c01333b8>] (__pskb_pull_tail+0x0/0x2ac) from [<c013bed0>] 
(dev_queue_xmit+0x68/0x470)
[<c013be68>] (dev_queue_xmit+0x0/0x470) from [<c015cc08>] 
(ip_finish_output+0x208/0x25c)
 r7:00000000 r6:0000000e r5:c0c69660 r4:c13693c0
[<c015ca00>] (ip_finish_output+0x0/0x25c) from [<c015cf98>] 
(ip_output+0xa8/0xbc)
 r8:c13693c0 r7:c13693e0 r6:c1e30960 r5:c0233794 r4:c13693c0
[<c015cef0>] (ip_output+0x0/0xbc) from [<c0159d28>] 
(ip_forward_finish+0x44/0x4c)
 r5:c18aa048 r4:c13693c0
[<c0159ce4>] (ip_forward_finish+0x0/0x4c) from [<c0159fa0>] 
(ip_forward+0x270/0x2f0)
 r4:c13693c0
[<c0159d30>] (ip_forward+0x0/0x2f0) from [<c0158910>] 
(ip_rcv_finish+0x354/0x378)
 r7:c1d19000 r6:c0233020 r5:c13693c0 r4:c18aa048
[<c01585bc>] (ip_rcv_finish+0x0/0x378) from [<c0158de8>] 
(ip_rcv+0x260/0x298)
 r8:00000008 r7:c1d19000 r6:c0233020 r5:c13693c0 r4:c02332cc
[<c0158b88>] (ip_rcv+0x0/0x298) from [<c0139044>] 
(netif_receive_skb+0x44c/0x498)
 r7:c1d19000 r6:c0221cf4 r5:c13693c0 r4:c02332cc
[<c0138bf8>] (netif_receive_skb+0x0/0x498) from [<c0193f08>] 
(br_handle_frame_finish+0x144/0x190)
[<c0193dc4>] (br_handle_frame_finish+0x0/0x190) from [<c0194158>] 
(br_handle_frame+0x204/0x23c)
 r8:00000001 r7:c0c2e1a0 r6:c18aa03a r5:c13693c0 r4:00000000
[<c0193f54>] (br_handle_frame+0x0/0x23c) from [<c0138f70>] 
(netif_receive_skb+0x378/0x498)
 r7:c1f42800 r6:00000000 r5:c13693c0 r4:c0c2e1a0
[<c0138bf8>] (netif_receive_skb+0x0/0x498) from [<c013b5a4>] 
(process_backlog+0x8c/0x120)
[<c013b518>] (process_backlog+0x0/0x120) from [<c013afb4>] 
(net_rx_action+0x74/0x1ac)
 r7:0000012c r6:00000009 r5:00000040 r4:c02332b0
[<c013af40>] (net_rx_action+0x0/0x1ac) from [<c0031abc>] 
(__do_softirq+0x5c/0xd0)
[<c0031a60>] (__do_softirq+0x0/0xd0) from [<c0031dec>] (irq_exit+0x44/0x4c)
 r6:00000000 r5:c021b460 r4:00000006
[<c0031da8>] (irq_exit+0x0/0x4c) from [<c001e048>] 
(__exception_text_start+0x48/0x60)
[<c001e000>] (__exception_text_start+0x0/0x60) from [<c001e7e8>] 
(__irq_svc+0x28/0x60)
Exception stack(0xc0215f64 to 0xc0215fac)
5f60:          00000000 c1d4ec00 c0214000 60000013 c001fc44 c0214000 
c001cee0
5f80: c0217b58 0001aabc 41069260 0001a9ec c0215fc0 c0215fac c0215fac 
c001fc88
5fa0: c001fb1c 60000013 ffffffff
 r6:00000040 r5:fdd20200 r4:ffffffff
[<c001fae4>] (cpu_idle+0x0/0x54) from [<c019ddac>] (rest_init+0x54/0x68)
 r5:c0223f30 r4:c022bf14
[<c019dd58>] (rest_init+0x0/0x68) from [<c0008a34>] 
(start_kernel+0x28c/0x2fc)
[<c00087a8>] (start_kernel+0x0/0x2fc) from [<00008034>] (0x8034)
 r6:c001d2e4 r5:c02243ec r4:a0053175
Code: e59f008c e59f1090 da000000 ebfbeaa1 (e5973050)
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 3 seconds..


-- 
Dirk Teurlings BICT

 Upexia

w: http://www.upexia.nl
e: info@upexia.nl
t: +31 (0) 85 210 2015
a: De Stoutheuvel 109
p: 5632 MX  Eindhoven


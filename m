Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.111.66.105] ([78.111.66.105]:51449 "EHLO mx03.syneticon.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZJXMAU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 08:00:20 -0400
Message-ID: <4AE2EC3E.3000503@wpkg.org>
Date: Sat, 24 Oct 2009 13:59:58 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-net@vger.kernel.org,
	linux-mips@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k AP kernel panic when client uses SCP
References: <4AD21AB4.6010208@wpkg.org> <4AE1AC69.7010904@wpkg.org> <69e28c910910230621j2176813dpe7f77b7dff5b1b44@mail.gmail.com> <4AE1AE74.4020600@wpkg.org>
In-Reply-To: <4AE1AE74.4020600@wpkg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomasz Chmielewski wrote:
> Gábor Stefanik wrote:
>> On Fri, Oct 23, 2009 at 3:15 PM, Tomasz Chmielewski <mangoo@wpkg.org> 
>> wrote:
>>> Bob Copeland wrote:
>>>> CONFIG_DEBUG_INFO is the basic switch.  I don't know if MIPS needs
>>>> CONFIG_FRAME_POINTER but that could help too.
>>> I don't see CONFIG_FRAME_POINTER available.
>>> I compiled with CONFIG_DEBUG_INFO; let me know if I should enable 
>>> some other
>>> DEBUG options as well (see below what's enabled and available).
>>>
>>> Before it oopses, I see lots of order 0 page allocation failures 
>>> (there are
>>> some extra spaces at the end of each line due to the broken konsole in
>>> KDE4):
>>>
>>> http://www1.wpkg.org/oops2.txt
> 
>> Is CONFIG_KALLSYMS set?
> 
> Good clue:
> 
> # zgrep KALL /proc/config.gz
> # CONFIG_KALLSYMS is not set
> 
> I'll recompile...

Is this one more useful?

[  516.430000] ------------[ cut here ]------------
[  516.430000] WARNING: at net/core/dev.c:1566 skb_gso_segment+0x110/0x298()
[  516.440000] b44: caps=(0x0, 0x0) len=52 data_len=0 ip_summed=1
[  516.450000] Modules linked in: configs aes_generic tun sch_sfq cls_fw sch_htb ipt_MASQUERADE iptable_nat nf_nat xt_MARK iptable_mangle ipt_ULOG xt_recent nf_conn1
[  516.480000] Call Trace:
[  516.480000] [<80013ac4>] dump_stack+0x8/0x34
[  516.480000] [<8002f2a0>] warn_slowpath_common+0x70/0x98
[  516.490000] [<8002f308>] warn_slowpath_fmt+0x24/0x30
[  516.490000] [<801f0398>] skb_gso_segment+0x110/0x298
[  516.500000] [<801f0728>] dev_hard_start_xmit+0x208/0x364
[  516.500000] [<80207c5c>] __qdisc_run+0x108/0x2f0
[  516.510000] [<801f4ad8>] dev_queue_xmit+0x25c/0x3a8
[  516.510000] [<802785c8>] br_dev_queue_push_xmit+0x98/0xac
[  516.520000] [<8027e66c>] br_nf_post_routing+0x23c/0x25c
[  516.520000] [<80214e78>] nf_iterate+0x70/0xf8
[  516.530000] [<80214fc8>] nf_hook_slow+0x88/0x12c
[  516.530000] [<80278630>] br_forward_finish+0x54/0x80
[  516.540000] [<8027dac0>] br_nf_forward_finish+0x114/0x130
[  516.540000] [<8027eba0>] br_nf_forward_ip+0x300/0x33c
[  516.550000] [<80214e78>] nf_iterate+0x70/0xf8
[  516.550000] [<80214fc8>] nf_hook_slow+0x88/0x12c
[  516.560000] [<802786e8>] __br_forward+0x8c/0xe0
[  516.560000] [<802796d4>] br_handle_frame_finish+0x168/0x1ac
[  516.570000] [<8027e260>] br_nf_pre_routing_finish+0x40c/0x450
[  516.580000] [<8027f564>] br_nf_pre_routing+0x824/0x86c
[  516.580000] [<80214e78>] nf_iterate+0x70/0xf8
[  516.580000] [<80214fc8>] nf_hook_slow+0x88/0x12c
[  516.590000] [<80279938>] br_handle_frame+0x220/0x26c
[  516.590000] [<801ef944>] netif_receive_skb+0x604/0x7b8
[  516.600000] [<801f23f0>] process_backlog+0xc8/0x138
[  516.600000] [<801f365c>] net_rx_action+0xe8/0x26c
[  516.610000] [<80035a84>] __do_softirq+0xac/0x160
[  516.610000] [<80035b94>] do_softirq+0x5c/0x94
[  516.620000] [<80036094>] irq_exit+0x40/0x8c
[  516.620000] [<80001844>] ret_from_irq+0x0/0x4
[  516.630000] [<800ab12c>] core_sys_select+0x1d0/0x2d0
[  516.630000] [<800ab870>] sys_select+0xe4/0x12c
[  516.640000] [<800035f0>] stack_done+0x20/0x3c
[  516.640000] 
[  516.640000] ---[ end trace b84c10674d0cf224 ]---
[  516.650000] Unhandled kernel unaligned access[#1]:
[  516.650000] Cpu 0
[  516.650000] $ 0   : 00000000 1000dc00 00000001 81f97a40
[  516.650000] $ 4   : e0f2fdea 00000000 00000001 00000083
[  516.650000] $ 8   : 00000000 00000083 80380000 ffffffea
[  516.650000] $12   : 80380000 00000030 00000020 00000000
[  516.650000] $16   : 0000000c 00000001 80dfa8e0 81c67000
[  516.650000] $20   : 81ccda00 8029ac50 80278530 81c67000
[  516.650000] $24   : 00000204 8023e8ec                  
[  516.650000] $28   : 81c14000 81c15750 00000005 801e6398
[  516.650000] Hi    : 00000000
[  516.650000] Lo    : 00000000
[  516.650000] epc   : 80073710 put_page+0x0/0x314
[  516.650000]     Tainted: G        W 
[  516.650000] ra    : 801e6398 skb_release_data+0xf4/0x160
[  516.650000] Status: 1000dc03    KERNEL EXL IE 
[  516.650000] Cause : 00800010
[  516.650000] BadVA : e0f2fdea
[  516.650000] PrId  : 00029006 (Broadcom BCM3302)
[  516.650000] Modules linked in: configs aes_generic tun sch_sfq cls_fw sch_htb ipt_MASQUERADE iptable_nat nf_nat xt_MARK iptable_mangle ipt_ULOG xt_recent nf_conn1
[  516.650000] Process init (pid: 1, threadinfo=81c14000, task=81c13938, tls=2aada4c0)
[  516.650000] Stack : 80dfa8e0 801e5c98 00000000 00000000 80dfa8e0 8038b698 80dfa8e0 801e5cf8
[  516.650000]         81ccda00 8038b698 80dfa8e0 81c67000 81ccda00 801f0858 80dfa8e0 81a40680
[  516.650000]         81c157d0 81dc6800 81dc6800 81ccda00 81ccda00 00000001 81dc6800 80dfa8e0
[  516.650000]         81c67000 0000548b 80207c5c 80207bf4 81dc6800 00000002 00000000 8027d934
[  516.650000]         81dc6800 81ccda00 80dfa8e0 00000000 8038bcd0 80000000 801f4ad8 801f4a34
[  516.650000]         ...
[  516.650000] Call Trace:
[  516.650000] [<80073710>] put_page+0x0/0x314
[  516.650000] [<801e6398>] skb_release_data+0xf4/0x160
[  516.650000] [<801e5cf8>] __kfree_skb+0x14/0x1c0
[  516.650000] [<801f0858>] dev_hard_start_xmit+0x338/0x364
[  516.650000] [<80207c5c>] __qdisc_run+0x108/0x2f0
[  516.650000] [<801f4ad8>] dev_queue_xmit+0x25c/0x3a8
[  516.650000] [<802785c8>] br_dev_queue_push_xmit+0x98/0xac
[  516.650000] [<8027e66c>] br_nf_post_routing+0x23c/0x25c
[  516.650000] [<80214e78>] nf_iterate+0x70/0xf8
[  516.650000] [<80214fc8>] nf_hook_slow+0x88/0x12c
[  516.650000] [<80278630>] br_forward_finish+0x54/0x80
[  516.650000] [<8027dac0>] br_nf_forward_finish+0x114/0x130
[  516.650000] [<8027eba0>] br_nf_forward_ip+0x300/0x33c
[  516.650000] [<80214e78>] nf_iterate+0x70/0xf8
[  516.650000] [<80214fc8>] nf_hook_slow+0x88/0x12c
[  516.650000] [<802786e8>] __br_forward+0x8c/0xe0
[  516.650000] [<802796d4>] br_handle_frame_finish+0x168/0x1ac
[  516.650000] [<8027e260>] br_nf_pre_routing_finish+0x40c/0x450
[  516.650000] [<8027f564>] br_nf_pre_routing+0x824/0x86c
[  516.650000] [<80214e78>] nf_iterate+0x70/0xf8
[  516.650000] [<80214fc8>] nf_hook_slow+0x88/0x12c
[  516.650000] [<80279938>] br_handle_frame+0x220/0x26c
[  516.650000] [<801ef944>] netif_receive_skb+0x604/0x7b8
[  516.650000] [<801f23f0>] process_backlog+0xc8/0x138
[  516.650000] [<801f365c>] net_rx_action+0xe8/0x26c
[  516.650000] [<80035a84>] __do_softirq+0xac/0x160
[  516.650000] [<80035b94>] do_softirq+0x5c/0x94
[  516.650000] [<80036094>] irq_exit+0x40/0x8c
[  516.650000] [<80001844>] ret_from_irq+0x0/0x4
[  516.650000] [<800ab12c>] core_sys_select+0x1d0/0x2d0
[  516.650000] [<800ab870>] sys_select+0xe4/0x12c
[  516.650000] [<800035f0>] stack_done+0x20/0x3c
[  516.650000] 
[  516.650000] 
[  516.650000] Code: 3c048007  08010d50  248436fc <8c820000> 3042c000  10400003  00803821  0801ca7f  00000000 
[  516.650000] Disabling lock debugging due to kernel taint
[  516.990000] Kernel panic - not syncing: Fatal exception in interrupt



As this line didn't fit:

Modules linked in: tun sch_sfq cls_fw sch_htb ipt_MASQUERADE iptable_nat nf_nat xt_MARK iptable_mangle ipt_ULOG xt_recent nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables ath5k mac80211 ath ohci_hcd cfg80211 uhci_hcd

-- 
Tomasz Chmielewski
http://wpkg.org

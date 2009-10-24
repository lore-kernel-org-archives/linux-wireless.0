Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:35497 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZJXTu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 15:50:56 -0400
Received: from localhost (filter1.syneticon.net [192.168.113.83])
	by mx03.syneticon.net (Postfix) with ESMTP id 5E3343601A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2009 21:51:00 +0200 (CEST)
Received: from mx03.syneticon.net ([192.168.113.84])
	by localhost (mx03.syneticon.net [192.168.113.83]) (amavisd-new, port 10025)
	with ESMTP id RP03FjRGzdOw for <linux-wireless@vger.kernel.org>;
	Sat, 24 Oct 2009 21:50:55 +0200 (CEST)
Received: from [192.168.10.145] (koln-4db4f0c2.pool.mediaWays.net [77.180.240.194])
	by mx03.syneticon.net (Postfix) with ESMTPSA
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2009 21:50:55 +0200 (CEST)
Message-ID: <4AE35A9E.8000507@wpkg.org>
Date: Sat, 24 Oct 2009 21:50:54 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: "Reserved instruction in kernel code" on ath9k insertion
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I do "modprobe ath9k" on ASUS-WL-500gP (MIPS) with _ath5k_ card (so, no ath9k hardware), it says "Reserved instruction in kernel code" - is it expected?

The kernel is 2.6.31.1.


# modprobe ath9k
[  165.440000] Reserved instruction in kernel code[#1]:
[  165.440000] Cpu 0
[  165.440000] $ 0   : 00000000 1000dc00 00000000 00000000
[  165.440000] $ 4   : c1135b20 00000001 c044e69c ffffffff
[  165.440000] $ 8   : 0000000a 8101f6d8 ffffffe0 0000002b
[  165.440000] $12   : 00000e44 00000006 80333ae8 5f657361
[  165.440000] $16   : 00000001 c1135ca4 80370000 81418000
[  165.440000] $20   : 00000000 00000000 00000000 004fe008
[  165.440000] $24   : 00000010 c1115118
[  165.440000] $28   : 81da6000 81da7ea8 7febead8 81418014
[  165.440000] Hi    : 00000000
[  165.440000] Lo    : 00000000
[  165.440000] epc   : c044e694 0xc044e694
[  165.440000]     Not tainted
[  165.440000] ra    : 81418014 ath9k_init+0x14/0xa4 [ath9k]
[  165.440000] Status: 1000dc03    KERNEL EXL IE
[  165.440000] Cause : 80800028
[  165.440000] PrId  : 00029006 (Broadcom BCM3302)
[  165.440000] Modules linked in: ath9k(+) aes_generic tun sch_sfq cls_fw sch_htb ipt_MASQUERADE iptable_nat nf_nat xt_MARK iptable_mangle ipt_ULOG xt_recent nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables arc4 ecb ath5k mac80211 ath ohci_hcd cfg80211 uhci_hcd
[  165.440000] Process modprobe (pid: 1285, threadinfo=81da6000, task=81dc0048, tls=2aad96f0)
[  165.440000] Stack : 00000000 00000000 c1049988 000002a0 00000001 8000cda4 80330000 c1135ca4
[  165.440000]         0041ee08 2ac50000 005021a8 00000000 8004d59c 0029e597 0041ee08 2ac50000
[  165.440000]         00000001 c1135ca4 0041ee08 2ac50000 005021a8 8005fc84 0029f000 00000002
[  165.440000]         00408228 00400de0 004f1400 2aad8f08 00408228 00400de0 004f1400 2aad8f08
[  165.440000]         800035f0 800035f0 005021a8 004ff648 004fe008 00000000 00401090 00000000
[  165.440000]         ...
[  165.440000] Call Trace:
[  165.440000] [<8000cda4>] do_one_initcall+0x6c/0x204
[  165.440000] [<8004d59c>] blocking_notifier_call_chain+0x14/0x20
[  165.440000] [<8005fc84>] sys_init_module+0xe8/0x214
[  165.440000] [<800035f0>] stack_done+0x20/0x3c
[  165.440000] [<800035f0>] stack_done+0x20/0x3c
[  165.440000]
[  165.440000]
[  165.440000] Code: 00000000  00000000  00000000 <00003009> 005196a8  005196a8  00000002  00000000  005166b0
[  165.440000] Disabling lock debugging due to kernel taint
Segmentation fault
#


-- 
Tomasz Chmielewski
http://wpkg.org

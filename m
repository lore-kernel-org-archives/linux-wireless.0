Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fallback7.mail.ru ([94.100.181.128]:40556 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815AbcFIHq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 03:46:57 -0400
Received: from smtp12.mail.ru (smtp12.mail.ru [94.100.181.93])
	by fallback7.mail.ru (mPOP.Fallback_MX) with ESMTP id 5094A16130944
	for <linux-wireless@vger.kernel.org>; Thu,  9 Jun 2016 10:45:48 +0300 (MSK)
Received: from 83.194.48.60.klj02-home.tm.net.my ([60.48.194.83]:57718 helo=[10.0.0.80])
	by smtp12.mail.ru with esmtpa (envelope-from <ash.benz@bk.ru>)
	id 1bAuev-0007dS-NU
	for linux-wireless@vger.kernel.org; Thu, 09 Jun 2016 10:45:46 +0300
To: linux-wireless@vger.kernel.org
From: "A. Benz" <ash.benz@bk.ru>
Subject: ath10k/QCA9980 - Issues introduced in wireless testing 2016-05
Message-ID: <ff65514a-47a3-2f32-658c-a2177401aa9a@bk.ru> (sfid-20160609_094716_951186_3140E6AF)
Date: Thu, 9 Jun 2016 15:46:30 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,

I am using LEDE on my IPQ806x (QCA9980) system (Archer C2600).
With compat-wireless-2016-05-12, I observed traces attached below.
The router is unstable and eventually reboots by itself (randomly).

Upon reverting to compat-wireless-2016-01, the issue disappears. Nothing 
else is changed (software-wise or hardware).
This was confirmed with other users.

A new compile with the fixes below:
https://git.lede-project.org/?p=lede/nbd/staging.git;a=commit;h=858e26f3c0fc11231f25497cbb2ddca1e5f101e0

Did not solve the problem.

Please let me know if I need to provide any further information.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 558 at 
compat-wireless-2016-05-12/net/mac80211/rx.c:4068 
ieee80211_rx_napi+0x8c/0x8a4 [mac80211]()
Modules linked in: pppoe ppp_async iptable_nat pppox ppp_generic 
nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT 
ipt_MASQUERADE xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark 
xt_mac xt_limit xt_id xt_conntrack xt_comment xt_TCPMSS xt_REDIRECT 
xt_LOG xt_CT slhc nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4 
nf_nat nf_log_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache 
nf_conntrack iptable_raw iptable_mangle iptable_fWed May 25 21:21:57 
2016 kern.warn kernel: [24187.498347] CPU: 0 PID: 558 Comm: hostapd 
Tainted: G        W       4.4.11 #2
Hardware name: Qualcomm (Flattened Device Tree)
[<c021ff34>] (unwind_backtrace) from [<c021cb9c>] (show_stack+0x10/0x14)
[<c021cb9c>] (show_stack) from [<c03a2218>] (dump_stack+0x88/0x9c)
[<c03a2218>] (dump_stack) from [<c0227adc>] (warn_slowpath_common+0x94/0xb0)
[<c0227adc>] (warn_slowpath_common) from [<c0227b94>] 
(warn_slowpath_null+0x1c/0x24)
[<c0227b94>] (warn_slowpath_null) from [<bf19fa44>] 
(ieee80211_rx_napi+0x8c/0x8a4 [mac80211])
[<bf19fa44>] (ieee80211_rx_napi [mac80211]) from [<bf20e9d0>] 
(ath10k_htt_t2h_msg_handler+0x92c/0x988 [ath10k_core])
[<bf20e9d0>] (ath10k_htt_t2h_msg_handler [ath10k_core]) from 
[<bf20f3e8>] (ath10k_htt_txrx_compl_task+0x9bc/0x117c [ath10k_core])
[<bf20f3e8>] (ath10k_htt_txrx_compl_task [ath10k_core]) from 
[<c022b158>] (tasklet_action+0xb8/0x144)
[<c022b158>] (tasklet_action) from [<c022b32c>] (__do_softirq+0xe0/0x21c)
[<c022b32c>] (__do_softirq) from [<c022b4d4>] (do_softirq.part.2+0x28/0x30)
[<c022b4d4>] (do_softirq.part.2) from [<c022b590>] 
(__local_bh_enable_ip+0xb4/0x104)
[<c022b590>] (__local_bh_enable_ip) from [<c0596684>] 
(packet_poll+0xc0/0x100)
[<c0596684>] (packet_poll) from [<c04b1368>] (sock_poll+0xec/0xf8)
[<c04b1368>] (sock_poll) from [<c02e7fc4>] (do_select+0x2f8/0x62c)
[<c02e7fc4>] (do_select) from [<c02e858c>] (core_sys_select+0x294/0x424)
[<c02e858c>] (core_sys_select) from [<c02e8820>] (SyS_select+0x104/0x130)
[<c02e8820>] (SyS_select) from [<c0209c00>] (ret_fast_syscall+0x0/0x3c)
---[ end trace e55b94e0d302fcd8 ]---

Regards,
A. Benz

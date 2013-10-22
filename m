Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38195 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3JVAGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 20:06:08 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r9M067pB004682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 17:06:07 -0700
Message-ID: <5265C16F.1080508@candelatech.com> (sfid-20131022_020612_862533_E248CCF5)
Date: Mon, 21 Oct 2013 17:06:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Splat in 3.12.0-rc5 (ath tree)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure how important this is...but here it be.


------------[ cut here ]------------
WARNING: CPU: 2 PID: 1523 at /mnt/sda/home/greearb/git/ath/net/wireless/util.c:1066 cfg80211_calculate_bitr)
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan pktgen lockd f71882fg coretemp hw]
CPU: 0 PID: 1523 Comm: btserver Tainted: G         C   3.12.0-rc5-wl+ #1
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
 0000000000000009 ffff8800d9ea1b48 ffffffff81566b46 ffff88021fa0ec78
 0000000000000000 ffff8800d9ea1b88 ffffffff8109e0a2 ffff8802156367c0
 ffffffffa0213471 ffff8800cf479e40 ffff880215636000 ffff8802155785c0
Call Trace:
 [<ffffffff81566b46>] dump_stack+0x55/0x86
 [<ffffffff8109e0a2>] warn_slowpath_common+0x77/0x91
 [<ffffffffa0213471>] ? cfg80211_calculate_bitrate+0xfa/0x18e [cfg80211]
 [<ffffffff8109e0d1>] warn_slowpath_null+0x15/0x17
 [<ffffffffa0213471>] cfg80211_calculate_bitrate+0xfa/0x18e [cfg80211]
 [<ffffffffa03a8e87>] ieee80211_get_et_stats+0xa7/0x44e [mac80211]
 [<ffffffff812170d3>] ? find_revoke_record+0x82/0x8e
 [<ffffffff812175e8>] ? jbd2_journal_cancel_revoke+0x118/0x160
 [<ffffffffa022bb14>] cfg80211_get_stats+0x44/0x4c [cfg80211]
 [<ffffffff814c3382>] dev_ethtool+0xbb1/0x1463
 [<ffffffff814bb91c>] ? dev_name_hash.isra.66+0x24/0x3a
 [<ffffffff814bba30>] ? dev_get_by_name_rcu+0x34/0x56
 [<ffffffff814cef6c>] dev_ioctl+0x487/0x5a3
 [<ffffffff814aa442>] sock_do_ioctl+0x36/0x41
 [<ffffffff814aa859>] sock_ioctl+0x1fe/0x20b
 [<ffffffff8117481d>] vfs_ioctl+0x21/0x34
 [<ffffffff81175076>] do_vfs_ioctl+0x3b8/0x3fb
 [<ffffffff810bee73>] ? should_resched+0x9/0x28
 [<ffffffff8156b960>] ? _cond_resched+0x9/0x1d
 [<ffffffff8117cb0b>] ? fget_light+0x39/0x99
 [<ffffffff8117510b>] SyS_ioctl+0x52/0x7f
 [<ffffffff810e070e>] ? current_kernel_time+0xd/0x31
 [<ffffffff815716bd>] system_call_fastpath+0x1a/0x1f
---[ end trace b61c38f55596de59 ]---

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


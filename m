Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44636 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab2CGTc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:32:57 -0500
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q27JWslr017521
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 7 Mar 2012 11:32:55 -0800
Message-ID: <4F57B7E6.1050103@candelatech.com> (sfid-20120307_203301_816701_DF7D4715)
Date: Wed, 07 Mar 2012 11:32:54 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: bss_info_change_notify warning (hacked 3.3.0-rc5+)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is with a somewhat hacked 3.3.0-rc5+.  Just
curious if this is a known problem.


Seems very reproducible on my system.


WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:10 ieee80211_bss_info_change_noti)
Hardware name: To be filled by O.E.M.
Modules linked in: 8021q garp stp llc macvlan wanlink(PO) pktgen lockd arc4 joydev ppdev microcode serio_]
Pid: 1855, comm: hostapd Tainted: P         C O 3.3.0-rc5+ #7
Call Trace:
  [<ffffffff81036eda>] warn_slowpath_common+0x80/0x98
  [<ffffffff81036f07>] warn_slowpath_null+0x15/0x17
  [<ffffffffa02c0010>] ieee80211_bss_info_change_notify+0x15f/0x18c [mac80211]
  [<ffffffffa02d472d>] ieee80211_config_beacon+0x58/0x208 [mac80211]
  [<ffffffff8144773b>] ? __mutex_unlock_slowpath+0x10d/0x11f
  [<ffffffffa02d4936>] ieee80211_add_beacon+0x35/0xa4 [mac80211]
  [<ffffffffa01fd715>] nl80211_addset_beacon+0x317/0x34a [cfg80211]
  [<ffffffff813b5a08>] genl_rcv_msg+0x1f4/0x239
  [<ffffffff813b5814>] ? genl_rcv+0x28/0x28
  [<ffffffff813b4836>] netlink_rcv_skb+0x3e/0x8f
  [<ffffffff813b580d>] genl_rcv+0x21/0x28
  [<ffffffff813b4611>] netlink_unicast+0xe9/0x152
  [<ffffffff813b4d6a>] netlink_sendmsg+0x1f8/0x216
  [<ffffffff81384122>] __sock_sendmsg_nosec+0x5f/0x6a
  [<ffffffff8138416a>] __sock_sendmsg+0x3d/0x48
  [<ffffffff81384a0a>] sock_sendmsg+0xa3/0xbc
  [<ffffffff811d12c2>] ? blk_finish_plug+0x13/0x34
  [<ffffffff810a8b87>] ? generic_file_aio_write+0xa6/0xb6
  [<ffffffff81383b68>] ? copy_from_user+0x9/0xb
  [<ffffffff813846b2>] ? move_addr_to_kernel+0x2b/0x65
  [<ffffffff8138e909>] ? copy_from_user+0x9/0xb
  [<ffffffff8138ec56>] ? verify_iovec+0x4f/0xa3
  [<ffffffff8138516c>] __sys_sendmsg+0x20f/0x29c
  [<ffffffff8144c242>] ? sub_preempt_count+0x92/0xa6
  [<ffffffff81052ecf>] ? __srcu_read_unlock+0x3b/0x59
  [<ffffffff8111d9c0>] ? fsnotify+0x255/0x285
  [<ffffffff81385356>] sys_sendmsg+0x3d/0x5b
  [<ffffffff8144dfb9>] system_call_fastpath+0x16/0x1b
---[ end trace 7abcbdd8b95b5194 ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38067 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1LESz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 13:55:59 -0500
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id pB5Itw0j001907
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 5 Dec 2011 10:55:58 -0800
Message-ID: <4EDD13BE.9040000@candelatech.com> (sfid-20111205_195609_269970_17114FA8)
Date: Mon, 05 Dec 2011 10:55:58 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Warnings in today's wireless-testing.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This machine is using ath9k NIC, with a wlan0 and vap0.
This was after module reload (and restart of user-space apps).

WARNING: at /home/greearb/git/linux.wireless-testing/net/mac80211/driver-ops.h:10 ieee80211_bss_info_change_notify+0x143/0x16b [mac80211]()
Hardware name: To Be Filled By O.E.M.
Modules linked in: ath5k arc4 ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 xt_CT iptable_raw 8021q garp stp llc fuse macvlan pktgen w83627ehf hwmon_vid 
coretemp hwmon nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec microcode snd_hwdep snd_seq i2c_i801 
snd_seq_device iTCO_wdt snd_pcm pcspkr serio_raw iTCO_vendor_support snd_timer snd r8169 soundcore snd_page_alloc mii i915 drm_kms_helper drm i2c_algo_bit video 
[last unloaded: arc4]
Pid: 3989, comm: hostapd Tainted: G        W    3.2.0-rc4-wl+ #30
Call Trace:
  [<c043603f>] warn_slowpath_common+0x65/0x7a
  [<f9405e78>] ? ieee80211_bss_info_change_notify+0x143/0x16b [mac80211]
  [<c0436063>] warn_slowpath_null+0xf/0x13
  [<f9405e78>] ieee80211_bss_info_change_notify+0x143/0x16b [mac80211]
  [<f9415f53>] ieee80211_change_bss+0x12a/0x134 [mac80211]
  [<f9415e29>] ? ieee80211_set_cqm_rssi_config+0x76/0x76 [mac80211]
  [<f92b8afa>] nl80211_set_bss+0xf4/0x103 [cfg80211]
  [<c071eeb1>] genl_rcv_msg+0x1d1/0x203
  [<c071ece0>] ? genl_rcv+0x22/0x22
  [<c071df5c>] netlink_rcv_skb+0x30/0x76
  [<c071ecd9>] genl_rcv+0x1b/0x22
  [<c071dd98>] netlink_unicast+0xc1/0x11c
  [<c071e3f2>] netlink_sendmsg+0x1d1/0x1e9
  [<c06f725d>] __sock_sendmsg_nosec+0x3e/0x46
  [<c06f75fd>] __sock_sendmsg+0x2a/0x33
  [<c06f7b0b>] sock_sendmsg+0x93/0xa7
  [<c0489677>] ? __generic_file_aio_write+0x24c/0x27d
  [<c0592f6d>] ? _copy_from_user+0x31/0x118
  [<c06ff8d0>] ? copy_from_user+0x8/0xa
  [<c06ffbca>] ? verify_iovec+0x3e/0x78
  [<c06f8509>] __sys_sendmsg+0x18d/0x20b
  [<c070438f>] ? dev_name_hash+0x16/0x48
  [<c070438f>] ? dev_name_hash+0x16/0x48
  [<c0592e66>] ? copy_to_user+0x2f/0x105
  [<c07083d2>] ? dev_ioctl+0x40e/0x561
  [<c04b1eaf>] ? kmem_cache_alloc+0x24/0x9d
  [<c06fbdbd>] ? sk_prot_alloc+0x23/0xd1
  [<c07a294c>] ? _raw_spin_unlock+0x8/0xa
  [<c06f713f>] ? sock_destroy_inode+0x23/0x26
  [<c06f713f>] ? sock_destroy_inode+0x23/0x26
  [<c04cd216>] ? __d_free+0x3c/0x3f
  [<c04cd216>] ? __d_free+0x3c/0x3f
  [<c06f8686>] sys_sendmsg+0x2b/0x43
  [<c06f9554>] sys_socketcall+0x161/0x1b6
  [<c0472e50>] ? audit_syscall_exit+0xfa/0x10f
  [<c07a7258>] sysenter_do_call+0x12/0x28
---[ end trace bf306c81490c62aa ]---


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


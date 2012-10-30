Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46846 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2J3DjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 23:39:07 -0400
Received: from [50.54.136.152] (50-54-136-152.evrt.wa.frontiernet.net [50.54.136.152])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q9U3d5Dh007465
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 20:39:05 -0700
Message-ID: <508F4BD9.3080206@candelatech.com> (sfid-20121030_043912_658376_38056A98)
Date: Mon, 29 Oct 2012 20:39:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wireless splat in 3.5.7+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We saw this (and many similar) when trying to bring up ~200 stations on a radio.

Shortly after, the machine locked hard.

Tainting comes from a network emulation module that was not in use (but was loaded).


WARNING: at /home/greearb/git/linux-3.5.dev.y/net/mac80211/driver-ops.h:12 ieee80211_bss_info_change_notify+0x167/0x192 [mac80211]()
Hardware name: To be filled by O.E.M.
sta39:  Failed check-sdata-in-driver check, flags: 0x0
Modules linked in: fuse 8021q garp stp llc lockd macvlan sunrpc wanlink(PO) pktgen f71882fg ath9k ath9k_common snd_hda_codec_realtek ath9k_hw snd_hda_intel 
coretemp ath hwmon snd_hda_codec mac80211 snd_hwdep snd_seq snd_seq_device kvm snd_pcm cfg80211 ppdev snd_page_alloc gpio_ich microcode e1000e snd_timer 
parport_pc serio_raw snd i2c_i801 lpc_ich pcspkr parport mfd_core uinput soundcore ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: nf_nat]
Pid: 29641, comm: iw Tainted: P           O 3.5.7+ #26
Call Trace:
  [<ffffffff8105c5cc>] warn_slowpath_common+0x80/0x98
  [<ffffffff8105c678>] warn_slowpath_fmt+0x41/0x43
  [<ffffffffa03b4a89>] ieee80211_bss_info_change_notify+0x167/0x192 [mac80211]
  [<ffffffffa03b4b83>] ieee80211_ifa_changed+0xcf/0xe1 [mac80211]
  [<ffffffff814e635c>] notifier_call_chain+0x32/0x5e
  [<ffffffff8107a38b>] __blocking_notifier_call_chain+0x4b/0x62
  [<ffffffff8107a3b1>] blocking_notifier_call_chain+0xf/0x11
  [<ffffffff8148670f>] __inet_del_ifa+0x190/0x22a
  [<ffffffff81487d9b>] inetdev_event+0x28f/0x403
  [<ffffffff8143fc4b>] ? fib_rules_event+0x23/0x13d
  [<ffffffff814e635c>] notifier_call_chain+0x32/0x5e
  [<ffffffff8107a158>] raw_notifier_call_chain+0xf/0x11
  [<ffffffff8142d4ef>] call_netdevice_notifiers+0x45/0x4a
  [<ffffffff8142d8a1>] rollback_registered_many+0x167/0x23c
  [<ffffffff8142da6d>] unregister_netdevice_queue+0x94/0xd6
  [<ffffffffa03bf63e>] ieee80211_if_remove+0x98/0x9c [mac80211]
  [<ffffffffa03c5f03>] ieee80211_del_iface+0x10/0x14 [mac80211]
  [<ffffffffa02093cf>] nl80211_del_interface+0x26/0x28 [cfg80211]
  [<ffffffff8144cecb>] genl_rcv_msg+0x22b/0x273
  [<ffffffff8144cca0>] ? genl_rcv+0x28/0x28
  [<ffffffff8144b798>] netlink_rcv_skb+0x3e/0x8f
  [<ffffffff8144cc99>] genl_rcv+0x21/0x28
  [<ffffffff8144b556>] netlink_unicast+0xe4/0x16a
  [<ffffffff8144bd11>] netlink_sendmsg+0x23d/0x25b
  [<ffffffff8141995c>] __sock_sendmsg_nosec+0x5f/0x6a
  [<ffffffff814199a4>] __sock_sendmsg+0x3d/0x48
  [<ffffffff81419f86>] sock_sendmsg+0xa3/0xbc
  [<ffffffff810faaa0>] ? mem_cgroup_end_update_page_stat+0x1c/0x27
  [<ffffffff810d7354>] ? unlock_page+0x22/0x27
  [<ffffffff810f36e7>] ? __do_fault+0x364/0x3a7
  [<ffffffff814193a2>] ? copy_from_user+0x9/0xb
  [<ffffffff81419c2e>] ? move_addr_to_kernel+0x2b/0x65
  [<ffffffff81424add>] ? copy_from_user+0x9/0xb
  [<ffffffff81424e2a>] ? verify_iovec+0x4f/0xa3
  [<ffffffff8141b1a8>] __sys_sendmsg+0x1fe/0x280
  [<ffffffff810f4b0d>] ? handle_mm_fault+0x1c7/0x1e1
  [<ffffffff814e62b8>] ? do_page_fault+0x2de/0x350
  [<ffffffff8107bcd2>] ? lg_local_unlock+0x28/0x45
  [<ffffffff81138836>] ? mntput_no_expire+0x3f/0x138
  [<ffffffff81138954>] ? mntput+0x25/0x27
  [<ffffffff8141b387>] sys_sendmsg+0x3d/0x5b
  [<ffffffff814e8179>] system_call_fastpath+0x16/0x1b
---[ end trace cf48c0a49a51fabd ]---
IPv6: ADDRCONF(NETDEV_CHANGE): sta155: link becomes ready

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


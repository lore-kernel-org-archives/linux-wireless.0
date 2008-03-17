Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:15183 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbYCQPDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 11:03:01 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: BUG: scheduling while atomic
Date: Mon, 17 Mar 2008 16:00:04 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803171600.04805.hs4233@mail.mn-solutions.de> (sfid-20080317_150307_177238_56CC604F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a bug that I don't have enought knowledge to debug it myself.
It happens with wireless-testing, v2.6.25-rc5-2623-g7556b76. I've no
additional patch from me on top of this.


$ pccardctl insert
...
kernel: pcmcia: registering new device pcmcia0.0
kernel: libertas: 00:16:41:72:f6:a8, fw 5.0.16p0, cap 0x00000303
kernel: libertas: eth1: Marvell WLAN 802.11 adapter


$ ifup eth1
kernel: BUG: scheduling while atomic: wpa_supplicant/1508/0x00000102
kernel: Pid: 1508, comm: wpa_supplicant Not tainted 2.6.25-rc5-wl #11
kernel:  [<c0114ea7>] __schedule_bug+0x42/0x47
kernel:  [<c031fba5>] schedule+0x4f/0x38b
kernel:  [<f8ab70b5>] ? __lbs_cmd_async+0x1d3/0x226 [libertas]
kernel:  [<c01279c3>] ? prepare_to_wait+0x55/0x5a
kernel:  [<f8ab71dd>] __lbs_cmd+0xd5/0x175 [libertas]
kernel:  [<c012784b>] ? autoremove_wake_function+0x0/0x33
kernel:  [<f8ab9da8>] lbs_set_mac_control+0x7a/0xcb [libertas]
kernel:  [<f8ab6aa3>] ? lbs_cmd_copyback+0x0/0x37 [libertas]
kernel:  [<f8aafdfc>] lbs_set_multicast_list+0x263/0x2ab [libertas]
kernel:  [<c02c8bd5>] ? __dev_addr_add+0x5e/0xb2
kernel:  [<c02c83d6>] __dev_set_rx_mode+0x72/0x75
kernel:  [<c02cc984>] dev_mc_add+0x4b/0x6e
kernel:  [<c02fd8c3>] igmp_group_added+0x40/0xeb
kernel:  [<c0151822>] ? kmem_cache_alloc+0x5a/0x92
kernel:  [<c02fd9d1>] ? ip_mc_inc_group+0x63/0x1b1
kernel:  [<c02fd9d1>] ? ip_mc_inc_group+0x63/0x1b1
kernel:  [<c02fdb07>] ip_mc_inc_group+0x199/0x1b1
kernel:  [<c02fdb5b>] ip_mc_up+0x3c/0x54
kernel:  [<c02fa1b2>] inetdev_event+0x20b/0x397
kernel:  [<c012acc6>] notifier_call_chain+0x2b/0x4a
kernel:  [<c012ad07>] __raw_notifier_call_chain+0xe/0x10
kernel:  [<c012ad15>] raw_notifier_call_chain+0xc/0xe
kernel:  [<c02c9581>] call_netdevice_notifiers+0x11/0x13
kernel:  [<c02ca440>] dev_open+0x6d/0x72
kernel:  [<c02c96c1>] dev_change_flags+0x9f/0x14d
kernel:  [<c02fa69a>] devinet_ioctl+0x213/0x513
kernel:  [<c02fad60>] inet_ioctl+0x8c/0xa8
kernel:  [<c02bfc5a>] sock_ioctl+0x1bb/0x1dc
kernel:  [<c0114956>] ? hrtick_start_fair+0xc1/0xfd
kernel:  [<c02bfa9f>] ? sock_ioctl+0x0/0x1dc
kernel:  [<c015dcbe>] vfs_ioctl+0x22/0x67
kernel:  [<c015df48>] do_vfs_ioctl+0x245/0x25c
kernel:  [<c015df8b>] sys_ioctl+0x2c/0x45
kernel:  [<c01037da>] sysenter_past_esp+0x5f/0x85
kernel:  =======================

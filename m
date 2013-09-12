Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60370 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3ILXID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 19:08:03 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r8CN81Mx001245
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Sep 2013 16:08:01 -0700
Message-ID: <52324951.6060200@candelatech.com> (sfid-20130913_010816_374186_AC13B8CD)
Date: Thu, 12 Sep 2013 16:08:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: start_next_roc splat in 3.11.0+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Was bringing up 128 stations configured for HotSpot 2.0 (wpa2, 802.1x, etc)
on a relatively slow machine.

I doubt it has much to do with how they are configured however.


The warning that hit is here:

	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
			       list);

	if (WARN_ON_ONCE(roc->started))
		return;


This is running my normal set of patches.


[  133.530413] ------------[ cut here ]------------
[  133.541409] WARNING: CPU: 1 PID: 7246 at /home/greearb/git/linux-3.11.dev.y/net/mac80211/offchannel.c:269 ieee80211_start_next_roc+0x1f1/0x210 [mac80211]()
[  133.565902] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 8021q garp stp mrp llc fuse macvlan wanlink(O) pktgen 
iTCO_wdt gpio_ich iTCO_vendor_support arc4 pcspkr serio_raw i2c_i801 snd_hda_codec_realtek lpc_ich joydev ath9k_htc ath9k snd_hda_intel ath9k_common 
snd_hda_codec snd_hwdep ath9k_hw ath mac80211 snd_seq snd_seq_device cfg80211 snd_pcm rfkill r8169 mii snd_page_alloc snd_timer snd soundcore uinput i915 video 
i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_nat]
[  133.643933] CPU: 1 PID: 7246 Comm: ip Tainted: G         C O 3.11.0+ #21
[  133.659832] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080015  05/31/2010
[  133.679989]  0000010d efa6b964 c09c877c f849d0e4 efa6b994 c0459804 c0b65c08 00000001
[  133.694895]  00001c4e f849d0e4 0000010d f844a711 f844a711 f7774360 f7774360 00000001
[  133.708929]  efa6b9a4 c0459842 00000009 00000000 efa6b9dc f844a711 efd14c30 f7774e78
[  133.723050] Call Trace:
[  133.731352]  [<c09c877c>] dump_stack+0x4c/0x78
[  133.741687]  [<c0459804>] warn_slowpath_common+0x84/0xa0
[  133.752888]  [<f844a711>] ? ieee80211_start_next_roc+0x1f1/0x210 [mac80211]
[  133.765706]  [<f844a711>] ? ieee80211_start_next_roc+0x1f1/0x210 [mac80211]
[  133.778334]  [<c0459842>] warn_slowpath_null+0x22/0x30
[  133.789153]  [<f844a711>] ieee80211_start_next_roc+0x1f1/0x210 [mac80211]
[  133.801612]  [<f846879e>] ? ieee80211_queue_work+0x2e/0x40 [mac80211]
[  133.813715]  [<f848759d>] ? ieee80211_mesh_notify_scan_completed+0x7d/0x90 [mac80211]
[  133.827250]  [<f844983a>] __ieee80211_scan_completed+0xca/0x1f0 [mac80211]
[  133.839946]  [<f8449a49>] ieee80211_scan_cancel+0xe9/0x190 [mac80211]
[  133.852084]  [<c0459fa8>] ? put_online_cpus+0x48/0x70
[  133.862866]  [<f8453547>] ieee80211_do_stop+0x647/0x700 [mac80211]
[  133.874749]  [<c09009d6>] ? dev_deactivate_many+0x1e6/0x210
[  133.885858]  [<f8453667>] ieee80211_stop+0x17/0x20 [mac80211]
[  133.897063]  [<c08e3049>] __dev_close_many+0x69/0xb0
[  133.907875]  [<c08fbe5e>] ? netpoll_rx_disable+0x3e/0x50
[  133.918588]  [<c08e30c6>] __dev_close+0x36/0x70
[  133.928541]  [<c08e2302>] __dev_change_flags+0x82/0x150
[  133.939080]  [<c0916554>] ? ip_local_deliver+0x44/0x90
[  133.949514]  [<c08e4033>] dev_change_flags+0x23/0x60
[  133.959742]  [<c08f17a4>] do_setlink+0x224/0x7a0
[  133.969666]  [<c06be142>] ? nla_parse+0x22/0xd0
[  133.979333]  [<c08f4b72>] rtnl_newlink+0x532/0x5b0
[  133.989164]  [<c06444fc>] ? security_capable+0x1c/0x30
[  133.999259]  [<c0461e4a>] ? ns_capable+0x2a/0x60
[  134.008797]  [<c08f2129>] rtnetlink_rcv_msg+0x179/0x1f0
[  134.019120]  [<c05596bd>] ? __kmalloc_track_caller+0x2d/0x170
[  134.029897]  [<c0515e66>] ? find_get_page+0x66/0xb0
[  134.040175]  [<c08d877b>] ? __alloc_skb+0x6b/0x180
[  134.050340]  [<c08f1fb0>] ? rtnetlink_rcv+0x30/0x30
[  134.060039]  [<c090b016>] netlink_rcv_skb+0x86/0xb0
[  134.069626]  [<c08f1f9c>] rtnetlink_rcv+0x1c/0x30
[  134.078854]  [<c090ad86>] netlink_unicast+0xe6/0x140
[  134.088397]  [<c090ba72>] netlink_sendmsg+0x242/0x620
[  134.097907]  [<c0452203>] ? __kunmap_atomic+0x83/0xa0
[  134.107349]  [<c051c780>] ? get_page_from_freelist+0x250/0x500
[  134.117435]  [<c08d147a>] sock_sendmsg+0xaa/0xe0
[  134.126226]  [<c08cf608>] ? copy_from_user+0x8/0x10
[  134.135068]  [<c08dba2b>] ? verify_iovec+0x5b/0xb0
[  134.143761]  [<c08d2285>] ___sys_sendmsg+0x2c5/0x2e0
[  134.152498]  [<c052244d>] ? lru_cache_add+0xd/0x10
[  134.160935]  [<c053adc3>] ? handle_pte_fault+0x493/0xae0
[  134.169849]  [<c08d7e30>] ? skb_dequeue+0x50/0x70
[  134.178135]  [<c053b601>] ? handle_mm_fault+0x1f1/0x300
[  134.186733]  [<c08d241e>] __sys_sendmsg+0x3e/0x70
[  134.194841]  [<c08d2466>] SyS_sendmsg+0x16/0x20
[  134.202652]  [<c08d27af>] SyS_socketcall+0x11f/0x2e0
[  134.210877]  [<c0566f7d>] ? ____fput+0xd/0x10
[  134.218528]  [<c09d364d>] sysenter_do_call+0x12/0x28
[  134.226767] ---[ end trace 2b5f2f9c64702e82 ]---
[  134.251401] ath: wiphy0: Failed to stop TX DMA, queues=0x005!
[  134.280969] ath: wiphy0: Failed to stop TX DMA, queues=0x004!


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55939 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2DQR0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 13:26:11 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q3HHQA3O006633
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 10:26:11 -0700
Message-ID: <4F8DA7B2.1060303@candelatech.com> (sfid-20120417_192614_210569_3F44B95A)
Date: Tue, 17 Apr 2012 10:26:10 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Kernel splat related to bad rate in latest wireless-testing (3.4.0-rc3-wl+)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has my ethtool & scan-on-channel patches and Felix's patch to make virtual stations
work on ath9k again.

I had 'reset' a virtual station interface, which basically bounces it and
tells supplication to re-associate.

Apr 17 10:20:37 localhost kernel: ADDRCONF(NETDEV_UP): sta2: link is not ready
Apr 17 10:20:39 localhost ntpd[1260]: Deleting interface #23 sta2, fe80::211:22ff:fe99:8802#123, interface stats: received=0, sent=0, dropped=0, active_time=231 
secs
Apr 17 10:20:48 localhost kernel: ------------[ cut here ]------------
Apr 17 10:20:48 localhost kernel: WARNING: at /home/greearb/git/linux.wireless-testing/include/net/mac80211.h:3737 rate_control_send_low+0xc1/0x1a1 [mac80211]()
Apr 17 10:20:48 localhost kernel: Hardware name: To Be Filled By O.E.M.
Apr 17 10:20:48 localhost kernel: Modules linked in: xt_CT iptable_raw 8021q garp stp llc fuse macvlan pktgen w83627ehf hwmon_vid nfs lockd fscache auth_rpcgss 
nfs_acl sunrpc ipv6 uinput snd_hda_codec_realtek arc4 joydev snd_hda_intel snd_hda_codec snd_hwdep snd_seq ath9k coretemp hwmon snd_seq_device mac80211 
microcode snd_pcm ath9k_common serio_raw i2c_i801 pcspkr iTCO_wdt ath9k_hw iTCO_vendor_support ath snd_timer snd r8169 cfg80211 soundcore snd_page_alloc mii 
i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: nf_nat]
Apr 17 10:20:48 localhost kernel: Pid: 36, comm: kworker/u:1 Not tainted 3.4.0-rc3-wl+ #22
Apr 17 10:20:48 localhost kernel: Call Trace:
Apr 17 10:20:48 localhost kernel: [<c04273e4>] warn_slowpath_common+0x65/0x7a
Apr 17 10:20:48 localhost kernel: [<f8c6db23>] ? rate_control_send_low+0xc1/0x1a1 [mac80211]
Apr 17 10:20:48 localhost kernel: [<c0427408>] warn_slowpath_null+0xf/0x13
Apr 17 10:20:48 localhost kernel: [<f8c6db23>] rate_control_send_low+0xc1/0x1a1 [mac80211]
Apr 17 10:20:48 localhost kernel: [<f8d03a91>] ath_get_rate+0x3c/0x2fb [ath9k]
Apr 17 10:20:48 localhost kernel: [<c0406dc0>] ? sched_clock+0x9/0xd
Apr 17 10:20:48 localhost kernel: [<c0446287>] ? sched_clock_local+0x17/0x13d
Apr 17 10:20:48 localhost kernel: [<f8c6e000>] rate_control_get_rate+0x87/0x24b [mac80211]
Apr 17 10:20:48 localhost kernel: [<f8c762ab>] invoke_tx_handlers+0x750/0xf3d [mac80211]
Apr 17 10:20:48 localhost kernel: [<c0448c1f>] ? enqueue_task_fair+0x326/0x441
Apr 17 10:20:48 localhost kernel: [<f8c7749e>] ieee80211_tx+0x73/0x9a [mac80211]
Apr 17 10:20:48 localhost kernel: [<f8c777af>] ieee80211_xmit+0xae/0xb6 [mac80211]
Apr 17 10:20:48 localhost kernel: [<f8c777fe>] ieee80211_tx_skb_tid+0x47/0x52 [mac80211]
Apr 17 10:20:48 localhost kernel: [<f8c7c77b>] ieee80211_send_nullfunc+0x55/0x59 [mac80211]
Apr 17 10:20:48 localhost kernel: [<f8c7dd33>] ieee80211_mgd_probe_ap_send+0x4d/0xe6 [mac80211]
Apr 17 10:20:48 localhost kernel: [<f8c7decd>] ieee80211_mgd_probe_ap+0x101/0x110 [mac80211]
Apr 17 10:20:48 localhost kernel: [<f8c7deeb>] ieee80211_sta_monitor_work+0xf/0x11 [mac80211]
Apr 17 10:20:48 localhost kernel: [<c0436b66>] process_one_work+0x155/0x204
Apr 17 10:20:48 localhost kernel: [<f8c7dedc>] ? ieee80211_mgd_probe_ap+0x110/0x110 [mac80211]
Apr 17 10:20:48 localhost kernel: [<c0438596>] worker_thread+0xf7/0x1fe
Apr 17 10:20:48 localhost kernel: [<c044193a>] ? complete+0x34/0x3e
Apr 17 10:20:48 localhost kernel: [<c043849f>] ? manage_workers+0x164/0x164
Apr 17 10:20:48 localhost kernel: [<c043b101>] kthread+0x67/0x6c
Apr 17 10:20:48 localhost kernel: [<c0430000>] ? run_timer_softirq+0xd2/0x192
Apr 17 10:20:48 localhost kernel: [<c043b09a>] ? __init_kthread_worker+0x28/0x28
Apr 17 10:20:48 localhost kernel: [<c07bdf76>] kernel_thread_helper+0x6/0xd
Apr 17 10:20:48 localhost kernel: ---[ end trace 6c78af2ddefabddd ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


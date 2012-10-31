Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56581 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab2JaSyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 14:54:09 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q9VIs8Ux006739
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 11:54:08 -0700
Message-ID: <509173D0.9010701@candelatech.com> (sfid-20121031_195414_905498_198D44C4)
Date: Wed, 31 Oct 2012 11:54:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WARNING in agg-tx.c (3.5.7+, not tainted)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While trying to debug another kernel splat, I saw this one.  System was
in process of creating and getting DHCP for 400 virtual stations.

Code in question:



	mutex_lock(&sta->ampdu_mlme.mtx);
	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);

	if (WARN_ON(!tid_tx)) {
#ifdef CONFIG_MAC80211_HT_DEBUG
		printk(KERN_DEBUG "addBA was not requested!\n");
#endif
		goto unlock;
	}


------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.5.dev.y/net/mac80211/agg-tx.c:650 ieee80211_start_tx_ba_cb+0x9d/0xd4 [mac80211]()
wiphy0: start_sw_scan: running-other-vifs: 0  running-station-vifs: 201, associated-stations: 42 scanning current channel: 2412 MHz
Hardware name: To be filled by O.E.M.
Modules linked in: ath5k ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfs nfs_acl auth_rpcgss fscache 8021q garp stp llc macvlan pktgen lockd sunrpc 
gpio_ich joydev coretemp hwmon ppdev kvm snd_hda_codec_realtek microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device serio_raw pcspkr snd_pcm 
snd_page_alloc snd_timer snd i2c_i801 lpc_ich mfd_core soundcore e1000e mei parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core 
[last unloaded: nf_nat]
Pid: 146, comm: kworker/u:2 Tainted: G           O 3.5.7+ #1
Call Trace:
  [<ffffffff8105d94c>] warn_slowpath_common+0x80/0x98
  [<ffffffff8105d979>] warn_slowpath_null+0x15/0x17
  [<ffffffffa04bab87>] ieee80211_start_tx_ba_cb+0x9d/0xd4 [mac80211]
  [<ffffffffa04c09c6>] ieee80211_iface_work+0xaa/0x2c7 [mac80211]
  [<ffffffff81072a84>] process_one_work+0x20e/0x345
  [<ffffffff81072a23>] ? process_one_work+0x1ad/0x345
  [<ffffffffa04c091c>] ? ieee80211_teardown_sdata+0xd9/0xd9 [mac80211]
  [<ffffffff81074d44>] worker_thread+0x136/0x255
  [<ffffffff81074c0e>] ? manage_workers+0x191/0x191
  [<ffffffff81078aeb>] kthread+0x84/0x8c
  [<ffffffff815185b4>] kernel_thread_helper+0x4/0x10
  [<ffffffff815121f4>] ? retint_restore_args+0x13/0x13
  [<ffffffff81078a67>] ? __init_kthread_worker+0x56/0x56
  [<ffffffff815185b0>] ? gs_change+0x13/0x13
---[ end trace 03bb877f0a1bdfc6 ]---

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


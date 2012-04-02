Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45354 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2DBTic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 15:38:32 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q32JcVxC012057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 2 Apr 2012 12:38:31 -0700
Message-ID: <4F7A0037.6090900@candelatech.com> (sfid-20120402_213835_863140_C1A892B9)
Date: Mon, 02 Apr 2012 12:38:31 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: warning from wireless/mlme.c in 3.3.0+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I saw this once on a system trying to associate 402 stations to two
different APs on two different radios.  Didn't appear to cause any
real trouble...


------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.3.dev.y/net/wireless/mlme.c:367 cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]()
Hardware name: To be filled by O.E.M.
Modules linked in: 8021q garp stp llc macvlan wanlink(PO) pktgen lockd arc4 joydev ppdev snd_hda_codec_realtek microcode snd_hda_intel snd_hda_codec snd_hwdep 
snd_seq serio_raw snd_seq_device pcspkr
ADDRCONF(NETDEV_UP): sta94: link is not ready
  ath9k snd_pcm i2c_i801 mac80211 ath9k_common ath9k_hw ath iTCO_wdt iTCO_vendor_support e1000e snd_timer snd cfg80211 soundcore snd_page_alloc mei(C) 
parport_pc parport uinput sunrpc ipv6 autofs4 i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: nf_nat]
Pid: 58, comm: kworker/u:3 Tainted: P         C O 3.3.0+ #16
Call Trace:
  [<ffffffff81036f45>] warn_slowpath_common+0x80/0x98
  [<ffffffff81036f72>] warn_slowpath_null+0x15/0x17
  [<ffffffffa01a416a>] cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]
  [<ffffffff814480f6>] ? mutex_unlock+0x9/0xb
  [<ffffffffa0285878>] ieee80211_assoc_done+0x4b/0x1c4 [mac80211]
  [<ffffffff8105d12b>] ? enqueue_task_fair+0x136/0x294
  [<ffffffff81055ba1>] ? resched_task+0x47/0x67
  [<ffffffff810e01d6>] ? __slab_free+0x118/0x22d
  [<ffffffff81449b18>] ? _raw_spin_unlock_irqrestore+0x3a/0x47
  [<ffffffffa0288414>] ieee80211_work_work+0xf6f/0xfd9 [mac80211]
  [<ffffffff81448e93>] ? __schedule+0x499/0x4c8
  [<ffffffff81057a50>] ? get_parent_ip+0x11/0x41
  [<ffffffffa02874a5>] ? free_work+0x14/0x14 [mac80211]
  [<ffffffff81049595>] process_one_work+0x1a6/0x278
  [<ffffffff8104b5e8>] worker_thread+0x136/0x255
  [<ffffffff8104b4b2>] ? manage_workers+0x190/0x190
  [<ffffffff8104ebe9>] kthread+0x84/0x8c
  [<ffffffff8144fd24>] kernel_thread_helper+0x4/0x10
  [<ffffffff8104eb65>] ? __init_kthread_worker+0x37/0x37
  [<ffffffff8144fd20>] ? gs_change+0x13/0x13
---[ end trace b1372724f0162d31 ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54412 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab2EWQ21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 12:28:27 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q4NGSQAP015224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 09:28:26 -0700
Message-ID: <4FBD102A.3060906@candelatech.com> (sfid-20120523_182831_867959_52B63B9C)
Date: Wed, 23 May 2012 09:28:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Kernel splats in 3.3.6+, drv_finish_tx_sync
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NOTE:  These are against 3.3.6+, not 3.3.7+ as I posted earlier.

We ran a torture test where we try to associate 130 stations against an AP
that can only do 128.  The end result is constant resetting of many of the
virtual station interfaces.

It ran overnight w/out crashing, but spewed quite a few warnings.

I will be happy to test patches or attempt fixes if anyone has suggestions
for what the cause might be....

------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:12 drv_finish_tx_sync+0x45/0x6e [mac80211]()
Hardware name: To be filled by O.E.M.
sta20:  Failed check-sdata-in-driver check, flags: 0x4
Modules linked in: aesni_intel cryptd aes_x86_64 aes_generic 8021q garp stp llc fuse macvlan wanlink(PO) pktgen coretemp hwmon sunrpc ipv6 uinput arc4 ath9k 
snd_hda_codec_realtek mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_seq ath9k_common ath9k_hw snd_seq_device snd_pcm ath snd_timer e1000e cfg80211 snd 
microcode ppdev iTCO_wdt soundcore pcspkr mei(C) serio_raw i2c_i801 snd_page_alloc iTCO_vendor_support parport_pc parport i915 drm_kms_helper drm i2c_algo_bit 
i2c_core video [last unloaded: nf_nat]
Pid: 31420, comm: kworker/u:0 Tainted: P        WC O 3.3.6+ #43
Call Trace:
  [<ffffffff81036ef9>] warn_slowpath_common+0x80/0x98
  [<ffffffff81036fa5>] warn_slowpath_fmt+0x41/0x43
  [<ffffffffa023d8ad>] drv_finish_tx_sync+0x45/0x6e [mac80211]
  [<ffffffffa023f9d9>] ieee80211_assoc_done+0x1b0/0x1c4 [mac80211]
  [<ffffffff8105d28f>] ? enqueue_task_fair+0x136/0x294
  [<ffffffff81055cd8>] ? resched_task+0x47/0x67
  [<ffffffff810e03e3>] ? __slab_free+0xe1/0x22d
  [<ffffffff8144a718>] ? _raw_spin_unlock_irqrestore+0x3a/0x47
  [<ffffffffa0242410>] ieee80211_work_work+0xf6f/0xfd9 [mac80211]
  [<ffffffff81449a93>] ? __schedule+0x499/0x4c8
  [<ffffffff81057b87>] ? get_parent_ip+0x11/0x41
  [<ffffffffa02414a1>] ? free_work+0x14/0x14 [mac80211]
  [<ffffffff810496b5>] process_one_work+0x1a6/0x278
  [<ffffffff8104b708>] worker_thread+0x136/0x255
  [<ffffffff8104b5d2>] ? manage_workers+0x190/0x190
  [<ffffffff8104ed09>] kthread+0x84/0x8c
  [<ffffffff81450924>] kernel_thread_helper+0x4/0x10
  [<ffffffff8104ec85>] ? __init_kthread_worker+0x37/0x37
  [<ffffffff81450920>] ? gs_change+0x13/0x13
---[ end trace d1b4803845952d45 ]---



static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
{
	WARN(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER),
	     "%s:  Failed check-sdata-in-driver check, flags: 0x%x\n",
	     sdata->dev->name, sdata->flags);
}


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43993 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2EBR3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 13:29:14 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q42HTD38027513
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 2 May 2012 10:29:14 -0700
Message-ID: <4FA16EE9.7090907@candelatech.com> (sfid-20120502_192918_383278_60354655)
Date: Wed, 02 May 2012 10:29:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rate-control related splat in 3.3.4+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This kernel has my patches and my proprietary module (which is not in use, but
still taints the kernel).  I doubt my patches would influence this splat,
but it's always possible.

The warning is the one below:

static inline s8
rate_lowest_index(struct ieee80211_supported_band *sband,
		  struct ieee80211_sta *sta)
{
	int i;

	for (i = 0; i < sband->n_bitrates; i++)
		if (rate_supported(sta, sband->band, i))
			return i;

	/* warn when we cannot find a rate. */
	WARN_ON_ONCE(1);

	/* and return 0 (the lowest index) */
	return 0;
}


Not sure how easy it is to reproduce..this was during boot up of a system
with 400 virtual stations....


May  2 10:22:51 localhost kernel: ------------[ cut here ]------------
May  2 10:22:51 localhost kernel: WARNING: at /home/greearb/git/linux-3.3.dev.y/include/net/mac80211.h:3634 rate_control_send_low+0xb9/0x18c [mac80211]()
May  2 10:22:51 localhost kernel: Hardware name: To be filled by O.E.M.
May  2 10:22:51 localhost kernel: Modules linked in: aesni_intel cryptd aes_x86_64 aes_generic 8021q garp stp llc fuse macvlan wanlink(PO) pktgen coretemp hwmon 
sunrpc ipv6 uinput arc4 snd_hda_codec_realtek snd_hda_intel snd_hda_codec ath9k mac80211 snd_hwdep snd_seq snd_seq_device ath9k_common snd_pcm ath9k_hw ppdev 
snd_timer ath snd microcode e1000e soundcore pcspkr serio_raw i2c_i801 cfg80211 iTCO_wdt mei(C) snd_page_alloc iTCO_vendor_support parport_pc parport i915 
drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
May  2 10:22:51 localhost kernel: Pid: 53, comm: kworker/u:2 Tainted: P         C O 3.3.4+ #40
May  2 10:22:51 localhost kernel: Call Trace:
May  2 10:22:51 localhost kernel: [<ffffffff81036ef9>] warn_slowpath_common+0x80/0x98
May  2 10:22:51 localhost kernel: [<ffffffff81036f26>] warn_slowpath_null+0x15/0x17
May  2 10:22:51 localhost kernel: [<ffffffffa0266798>] rate_control_send_low+0xb9/0x18c [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffffa01be6da>] ath_get_rate+0x4f/0x374 [ath9k]
May  2 10:22:51 localhost kernel: [<ffffffff81055d3f>] ? check_preempt_curr+0x3e/0x6d
May  2 10:22:51 localhost kernel: [<ffffffffa0266615>] rate_control_get_rate+0x89/0x124 [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffffa026fa7a>] invoke_tx_handlers+0x763/0x1032 [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffff8144a2a8>] ? _raw_spin_unlock_irqrestore+0x3a/0x47
May  2 10:22:51 localhost kernel: [<ffffffffa0257676>] ? sta_info_get+0x4e/0x67 [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffffa0270dfa>] ieee80211_tx+0x89/0xcb [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffff810ded2f>] ? virt_to_head_page+0x9/0x2c
May  2 10:22:51 localhost kernel: [<ffffffffa027133b>] ieee80211_xmit+0xbb/0xc9 [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffffa027139e>] ieee80211_tx_skb_tid+0x55/0x5c [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffffa025cfc8>] ieee80211_tx_ba_session_handle_start+0x290/0x29f [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffffa025c0c6>] ieee80211_ba_session_work+0xf7/0x14f [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffffa025bfcf>] ? ieee80211_ht_cap_ie_to_sta_ht_cap+0x123/0x123 [mac80211]
May  2 10:22:51 localhost kernel: [<ffffffff810496c9>] process_one_work+0x1a6/0x278
May  2 10:22:51 localhost kernel: [<ffffffff8104b71c>] worker_thread+0x136/0x255
May  2 10:22:51 localhost kernel: [<ffffffff8104b5e6>] ? manage_workers+0x190/0x190
May  2 10:22:51 localhost kernel: [<ffffffff8104ed1d>] kthread+0x84/0x8c
May  2 10:22:51 localhost kernel: [<ffffffff814504a4>] kernel_thread_helper+0x4/0x10
May  2 10:22:51 localhost kernel: [<ffffffff8104ec99>] ? __init_kthread_worker+0x37/0x37
May  2 10:22:51 localhost kernel: [<ffffffff814504a0>] ? gs_change+0x13/0x13
May  2 10:22:51 localhost kernel: ---[ end trace 3442b469f5a5b18e ]---


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


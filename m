Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54421 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab2EWQb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 12:31:26 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q4NGVQDw015489
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 09:31:26 -0700
Message-ID: <4FBD10DE.2030705@candelatech.com> (sfid-20120523_183133_378672_3A0BA3EB)
Date: Wed, 23 May 2012 09:31:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Kernel splats in 3.3.7+, rate_control_send_low
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We ran a torture test where we try to associate 130 stations against an AP
that can only do 128.  The end result is constant resetting of many of the
virtual station interfaces.

It ran overnight w/out crashing, but spewed quite a few warnings.

I will be happy to test patches or attempt fixes if anyone has suggestions
for what the cause might be....

------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.3.dev.y/include/net/mac80211.h:3634 rate_control_send_low+0xb9/0x18c [mac80211]()
Hardware name: To be filled by O.E.M.
Modules linked in: aesni_intel cryptd aes_x86_64 aes_generic 8021q garp stp llc fuse macvlan wanlink(PO) pktgen coretemp hwmon sunrpc ipv6 uinput arc4 ath9k 
snd_hda_codec_realtek mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_seq ath9k_common snd_seq_device ath9k_hw snd_pcm ath snd_timer e1000e cfg80211 snd 
iTCO_wdt mei(C) ppdev i2c_i801 soundcore microcode iTCO_vendor_support snd_page_alloc parport_pc serio_raw pcspkr parport i915 drm_kms_helper drm i2c_algo_bit 
i2c_core video [last unloaded: scsi_wait_scan]
Pid: 57, comm: kworker/u:3 Tainted: P         C O 3.3.7+ #44
Call Trace:
  [<ffffffff81036f19>] warn_slowpath_common+0x80/0x98
  [<ffffffff81036f46>] warn_slowpath_null+0x15/0x17
  [<ffffffffa0249798>] rate_control_send_low+0xb9/0x18c [mac80211]
  [<ffffffffa03196da>] ath_get_rate+0x4f/0x374 [ath9k]
  [<ffffffff81055d45>] ? check_preempt_curr+0x2d/0x6d
  [<ffffffffa0249615>] rate_control_get_rate+0x89/0x124 [mac80211]
  [<ffffffffa0252bb2>] invoke_tx_handlers+0x763/0x1032 [mac80211]
  [<ffffffffa023a676>] ? sta_info_get+0x4e/0x67 [mac80211]
  [<ffffffffa0253f32>] ieee80211_tx+0x89/0xcb [mac80211]
  [<ffffffff810deeb7>] ? virt_to_head_page+0x9/0x2c
  [<ffffffffa0254473>] ieee80211_xmit+0xbb/0xc9 [mac80211]
  [<ffffffffa02544d6>] ieee80211_tx_skb_tid+0x55/0x5c [mac80211]
  [<ffffffffa023ffc8>] ieee80211_tx_ba_session_handle_start+0x290/0x29f [mac80211]
  [<ffffffffa023f0c6>] ieee80211_ba_session_work+0xf7/0x14f [mac80211]
  [<ffffffffa023efcf>] ? ieee80211_ht_cap_ie_to_sta_ht_cap+0x123/0x123 [mac80211]
  [<ffffffff810496d5>] process_one_work+0x1a6/0x278
  [<ffffffff8104b728>] worker_thread+0x136/0x255
  [<ffffffff8104b5f2>] ? manage_workers+0x190/0x190
  [<ffffffff8104ed29>] kthread+0x84/0x8c
  [<ffffffff81450964>] kernel_thread_helper+0x4/0x10
  [<ffffffff8104eca5>] ? __init_kthread_worker+0x37/0x37
  [<ffffffff81450960>] ? gs_change+0x13/0x13
---[ end trace 7a33d82af0656181 ]---


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


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


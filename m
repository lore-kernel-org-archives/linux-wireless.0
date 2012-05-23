Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51960 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2EWQRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 12:17:53 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q4NGHqAs014301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 09:17:52 -0700
Message-ID: <4FBD0DB0.5000406@candelatech.com> (sfid-20120523_181757_752991_9056DD24)
Date: Wed, 23 May 2012 09:17:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Kernel splats in 3.3.7+, mlme.c
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
ADDRCONF(NETDEV_UP): sta128: link is not ready
WARNING: at /home/greearb/git/linux-3.3.dev.y/net/wireless/mlme.c:310 __cfg80211_auth_remove+0x9b/0xaa [cfg80211]()
Hardware name: To be filled by O.E.M.
Modules linked in: aesni_intel cryptd aes_x86_64 aes_generic 8021q garp stp llc fuse macvlan wanlink(PO) pktgen coretemp hwmon sunrpc ipv6 uinput arc4 ath9k 
snd_hda_codec_realtek mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_seq ath9k_common ath9k_hw snd_seq_device snd_pcm ath snd_timer e1000e cfg80211 snd 
microcode ppdev iTCO_wdt soundcore pcspkr mei(C) serio_raw i2c_i801 snd_page_alloc iTCO_vendor_support parport_pc parport i915 drm_kms_helper drm i2c_algo_bit 
i2c_core video [last unloaded: nf_nat]
Pid: 9598, comm: kworker/u:1 Tainted: P         C O 3.3.6+ #43
Call Trace:
  [<ffffffff81036ef9>] warn_slowpath_common+0x80/0x98
  [<ffffffff81036f26>] warn_slowpath_null+0x15/0x17
  [<ffffffffa01509da>] __cfg80211_auth_remove+0x9b/0xaa [cfg80211]
  [<ffffffffa0151259>] cfg80211_send_auth_timeout+0x8e/0xa5 [cfg80211]
  [<ffffffffa023fb67>] ieee80211_probe_auth_done+0x2f/0xc5 [mac80211]
  [<ffffffff810e0eec>] ? kfree+0x85/0x8a
  [<ffffffffa0242410>] ieee80211_work_work+0xf6f/0xfd9 [mac80211]
  [<ffffffff81448cf6>] ? mutex_unlock+0x9/0xb
  [<ffffffff81057b87>] ? get_parent_ip+0x11/0x41
  [<ffffffff81057b87>] ? get_parent_ip+0x11/0x41
  [<ffffffffa02414a1>] ? free_work+0x14/0x14 [mac80211]
  [<ffffffff810496b5>] process_one_work+0x1a6/0x278
  [<ffffffff8104b708>] worker_thread+0x136/0x255
  [<ffffffff8104b5d2>] ? manage_workers+0x190/0x190
  [<ffffffff8104ed09>] kthread+0x84/0x8c
  [<ffffffff81450924>] kernel_thread_helper+0x4/0x10
  [<ffffffff8104ec85>] ? __init_kthread_worker+0x37/0x37
  [<ffffffff81450920>] ? gs_change+0x13/0x13
---[ end trace d1b4803845952d43 ]---
ADDRCONF(NETDEV_UP): sta302: link is not ready


static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
{
	int i;
	bool done = true;

	ASSERT_WDEV_LOCK(wdev);

	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
		if (wdev->authtry_bsses[i] &&
		    memcmp(wdev->authtry_bsses[i]->pub.bssid,
			   addr, ETH_ALEN) == 0) {
			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
			wdev->authtry_bsses[i] = NULL;
			break;
		}
		else if (wdev->authtry_bsses[i])
			done = false;
	}

	WARN_ON(!done);
}


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


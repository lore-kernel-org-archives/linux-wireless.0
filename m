Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46870 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaCaQ5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 12:57:00 -0400
Message-ID: <53399E42.2090504@candelatech.com> (sfid-20140331_185706_754814_C073AFD1)
Date: Mon, 31 Mar 2014 09:56:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath10k:  ieee80211_restart_work called with hardware scan in progress
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This came from a customer (demo) system.  Firmware is 10.1.389 based, modified
by us.  It has lots of known issues, but I haven't seen the warning
below before, and not sure it is specifically a bug with ath10k or not.

Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
Mar 31 13:49:54 ct521-5332 kernel: ieee80211_restart_work called with hardware scan in progress
Mar 31 13:49:54 ct521-5332 kernel: Modules linked in: nf_nat_ipv4 nf_nat fuse 8021q mrp garp stp llc macvlan pktgen coretemp hwmon sunrpc ipv6 uinput
snd_hda_codec_realtek snd_hda_codec_generic ath10k_pci ath10k_core snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_seq snd_seq_device iTCO_wdt e1000e
microcode ath gpio_ich snd_pcm iTCO_vendor_support ppdev ptp snd_timer parport_pc snd cfg80211 parport serio_raw pps_core soundcore pcspkr i2c_i801 lpc_ich i915
drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: iptable_nat]
Mar 31 13:49:54 ct521-5332 kernel: CPU: 0 PID: 11818 Comm: kworker/0:0 Tainted: G        WC   3.14.0-rc7-wl-ath+ #4
Mar 31 13:49:54 ct521-5332 kernel: Hardware name: To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M., BIOS 4.6.3 09/05/2011
Mar 31 13:49:54 ct521-5332 kernel: Workqueue: events ieee80211_restart_work [mac80211]
Mar 31 13:49:54 ct521-5332 kernel: 0000000000000009 ffff8800bd865d68 ffffffff815ab0a5 ffff88022bc0ec38
Mar 31 13:49:54 ct521-5332 kernel: ffff8800bd865db8 ffff8800bd865da8 ffffffff810c1aa8 ffff8800bd865d88
Mar 31 13:49:54 ct521-5332 kernel: ffffffffa03858ce ffff8802214d5650 ffff8802214d45e0 ffff8802214d5650
Mar 31 13:49:54 ct521-5332 kernel: Call Trace:
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff815ab0a5>] dump_stack+0x4e/0x71
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810c1aa8>] warn_slowpath_common+0x77/0x91
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffffa03858ce>] ? ieee80211_restart_work+0x49/0x68 [mac80211]
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810c1b56>] warn_slowpath_fmt+0x41/0x43
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffffa03858ce>] ieee80211_restart_work+0x49/0x68 [mac80211]
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d52af>] process_one_work+0x162/0x216
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d5724>] worker_thread+0x12f/0x1fd
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d55f5>] ? rescuer_thread+0x268/0x268
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d55f5>] ? rescuer_thread+0x268/0x268
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810da37f>] kthread+0xa0/0xa8
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810da2df>] ? __kthread_parkme+0x5c/0x5c
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff815b5b4c>] ret_from_fork+0x7c/0xb0
Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810da2df>] ? __kthread_parkme+0x5c/0x5c
Mar 31 13:49:54 ct521-5332 kernel: ---[ end trace fd8ccdaa79168e68 ]---

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


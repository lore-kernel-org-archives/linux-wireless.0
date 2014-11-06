Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50743 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaKFO7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 09:59:32 -0500
Received: by mail-ob0-f181.google.com with SMTP id uy5so967040obc.12
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 06:59:31 -0800 (PST)
Message-ID: <545B8CD1.8020208@lwfinger.net> (sfid-20141106_155946_614767_9A31D089)
Date: Thu, 06 Nov 2014 08:59:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: New WARNING from mac80211
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have gotten a new warning while using driver rtl8192se with the mainline 
kernel. The splat is as follows:

[42982.577623] ------------[ cut here ]------------
[42982.577647] WARNING: CPU: 2 PID: 6403 at net/mac80211/agg-tx.c:698 
ieee80211_start_tx_ba_cb+0x184/0x190 [mac80211]()
[42982.577650] Modules linked in: fuse bnep bluetooth ctr ccm nfs fscache 
rtl8192se rtl_pci rtlwifi arc4 iwlmvm af_packet mac80211 snd_hda_codec_generic 
snd_hda_intel snd_hda_controller snd_hda_codec x86_pkg_temp_thermal kvm_intel 
kvm iwlwifi snd_hwdep snd_pcm snd_timer cfg80211 snd e1000e rtsx_pci_sdmmc 
mmc_core rtsx_pci_ms memstick lpc_ich rfkill rtsx_pci xhci_pci xhci_hcd ptp 
pps_core wmi mfd_core serio_raw pcspkr crct10dif_pclmul crc32_pclmul 
crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper 
ablk_helper cryptd soundcore microcode acpi_cpufreq thermal processor battery ac 
dm_mod sr_mod cdrom i915 i2c_algo_bit drm_kms_helper drm video thermal_sys hwmon 
button sg autofs4
[42982.578143] CPU: 2 PID: 6403 Comm: kworker/u16:0 Not tainted 3.18.0-rc3+ #29
[42982.578146] Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.20 
   04/17/2014
[42982.578163] Workqueue: phy1 ieee80211_iface_work [mac80211]
[42982.578167]  0000000000000009 ffff880201367c48 ffffffff816b0b0f 0000000000000000
[42982.578173]  0000000000000000 ffff880201367c88 ffffffff81055c91 ffff8800c465d328
[42982.578180]  0000000000000000 ffff8800c30e8000 ffff8800c30e8580 ffff8800c6560f48
[42982.578186] Call Trace:
[42982.578195]  [<ffffffff816b0b0f>] dump_stack+0x4e/0x71
[42982.578204]  [<ffffffff81055c91>] warn_slowpath_common+0x81/0xa0
[42982.578209]  [<ffffffff81055d6a>] warn_slowpath_null+0x1a/0x20
[42982.578225]  [<ffffffffa0715534>] ieee80211_start_tx_ba_cb+0x184/0x190 [mac80211]
[42982.578240]  [<ffffffffa071c14a>] ieee80211_iface_work+0x26a/0x410 [mac80211]
[42982.578247]  [<ffffffff8106f6a2>] ? process_one_work+0x152/0x550
[42982.578253]  [<ffffffff8106f71f>] process_one_work+0x1cf/0x550
[42982.578258]  [<ffffffff8106f6a2>] ? process_one_work+0x152/0x550
[42982.578264]  [<ffffffff8106fbc1>] worker_thread+0x121/0x490
[42982.578270]  [<ffffffff8106faa0>] ? process_one_work+0x550/0x550
[42982.578275]  [<ffffffff81075004>] kthread+0xe4/0x100
[42982.578280]  [<ffffffff81074f20>] ? kthread_create_on_node+0x220/0x220
[42982.578287]  [<ffffffff816ba06c>] ret_from_fork+0x7c/0xb0
[42982.578291]  [<ffffffff81074f20>] ? kthread_create_on_node+0x220/0x220
[42982.578294] cfg80211: World regulatory domain updated:
[42982.578295] ---[ end trace dd5c167b01ae2d3d ]---

The warning comes from the following fragment in net/mac80211/agg-tx.c:

         if (WARN_ON(!tid_tx)) {
                 ht_dbg(sdata, "addBA was not requested!\n");
                 goto unlock;
         }

Is there something that should be fixed in rtl8192se?

Thanks,

Larry

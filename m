Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:64124 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbZJLDWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 23:22:37 -0400
Received: by bwz6 with SMTP id 6so2845611bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 20:22:00 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 11 Oct 2009 23:22:00 -0400
Message-ID: <cb0375e10910112022jdca836dxc6897855e7b5c007@mail.gmail.com>
Subject: 2.6.32-rc3: wifi warning?
From: Andrew Lutomirski <luto@mit.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not really sure what happened here, but I think I triggered it by
trying to suspend.  This is 36a07902c2134649c4af7f07980413ffb1a56085
from Linus's tree, which is a little bit after 2.6.32-rc3.

--Andy

[  545.919955] usb 2-6: USB disconnect, address 4
[  548.724525] phy0: device now idle
[  548.735689] phy0: Removed STA 00:11:50:64:93:75
[  548.738313] phy0: Destroyed STA 00:11:50:64:93:75
[  548.738318] wlan0: deauthenticating from 00:11:50:64:93:75 by local
choice (reason=3)
[  548.742752] wlan0: deauthenticating from 00:11:50:64:93:75 by local
choice (reason=3)
[  548.742772] phy0: device no longer idle - scanning
[  548.753108] phy0: device now idle
[  548.778800] ------------[ cut here ]------------
[  548.778821] WARNING: at net/wireless/core.c:613
wdev_cleanup_work+0x69/0xec [cfg80211]()
[  548.778824] Hardware name: 7465CTO
[  548.778826] Modules linked in: vfat fat usb_storage fuse tp_smapi
thinkpad_ec bridge stp llc bnep sco l2cap bluetooth ip6t_REJECT
nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand
dm_multipath uinput arc4 ecb thinkpad_acpi hwmon
snd_hda_codec_conexant snd_hda_intel snd_hda_codec iwlagn iwlcore
i2400m_usb snd_hwdep snd_pcm snd_timer mac80211 snd i2400m i2c_i801
iTCO_wdt soundcore cfg80211 snd_page_alloc iTCO_vendor_support xts
gf128mul aes_x86_64 aes_generic dm_crypt i915 drm_kms_helper drm
i2c_algo_bit i2c_core video output [last unloaded: microcode]
[  548.778878] Pid: 10, comm: events/1 Not tainted 2.6.32-rc3 #9
[  548.778881] Call Trace:
[  548.778890]  [<ffffffff810567f3>] warn_slowpath_common+0x8d/0xbb
[  548.778895]  [<ffffffff81056848>] warn_slowpath_null+0x27/0x3d
[  548.778902]  [<ffffffffa00ec65c>] wdev_cleanup_work+0x69/0xec [cfg80211]
[  548.778908]  [<ffffffff81071c4d>] worker_thread+0x1d0/0x270
[  548.778915]  [<ffffffffa00ec5f3>] ? wdev_cleanup_work+0x0/0xec [cfg80211]
[  548.778920]  [<ffffffff81076cdf>] ? autoremove_wake_function+0x0/0x5f
[  548.778925]  [<ffffffff81040379>] ? __spin_unlock_irq+0x23/0x3a
[  548.778928]  [<ffffffff81071a7d>] ? worker_thread+0x0/0x270
[  548.778932]  [<ffffffff8107685d>] kthread+0x8e/0x96
[  548.778936]  [<ffffffff8100cfca>] child_rip+0xa/0x20
[  548.778940]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[  548.778944]  [<ffffffff810767cf>] ? kthread+0x0/0x96
[  548.778947]  [<ffffffff8100cfc0>] ? child_rip+0x0/0x20
[  548.778950] ---[ end trace 6da4e1284e480ee1 ]---

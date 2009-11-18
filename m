Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:21627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbZKRS1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 13:27:17 -0500
Received: by fg-out-1718.google.com with SMTP id d23so2367934fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 10:27:22 -0800 (PST)
Subject: mac80211 breaks suspend to disk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 20:27:16 +0200
Message-ID: <1258568836.4512.13.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I finally managed to track down a rare hang on resume from disk I see
for some prolonged time.
Symptoms are that sometimes on resume, system almost hangs.
This is I can switch VTs and execute SysRQ sequences.
This is typical when oops happens.

I tracked this to BUG_ON in add_timer.
I replaced this with WARN_ON, and here is the backtrace:


  331.334935] WARNING: at /home/maxim/software/kernel/linux-2.6/kernel/timer.c:791 add_timer+0x36/0x40()
[  331.347374] Hardware name: Aspire 5720     
[  331.359725] Modules linked in: nvidia(P)  af_packet usb_storage usb_libusual cpufreq_powersave iwl3945 nfsd snd_hda_codec_realtek cpufreq_conservative exportfs iwlcore cpufreq_userspace uvcvideo snd_hda_intel acpi_cpufreq nfs videodev mac80211 coretemp lockd snd_hda_codec joydev v4l1_compat tg3 nfs_acl ohci1394 v4l2_compat_ioctl32 snd_hwdep uhci_hcd sbp2 cfg80211 psmouse video ehci_hcd auth_rpcgss libphy lirc_ene0100 ieee1394 output snd_pcm usbcore serio_raw rfkill evdev snd_page_alloc sunrpc fuse lzo lzo_decompress lzo_compress
[  331.428619] Pid: 4394, comm: pm-hibernate Tainted: P           2.6.32-rc7-wl #183
[  331.442747] Call Trace:
[  331.456760]  [<ffffffff81043a98>] warn_slowpath_common+0x78/0xb0
[  331.471119]  [<ffffffff81043adf>] warn_slowpath_null+0xf/0x20
[  331.485475]  [<ffffffff8104f996>] add_timer+0x36/0x40
[  331.499814]  [<ffffffffa01fb34c>] ieee80211_sta_restart+0x4c/0x50 [mac80211]
[  331.514314]  [<ffffffffa020c86c>] ieee80211_reconfig+0x36c/0x420 [mac80211]
[  331.528678]  [<ffffffffa020c65c>] ? ieee80211_reconfig+0x15c/0x420 [mac80211]
[  331.543094]  [<ffffffffa0202fa5>] ieee80211_resume+0x15/0x20 [mac80211]
[  331.557525]  [<ffffffffa01527a5>] wiphy_resume+0x75/0x90 [cfg80211]
[  331.572001]  [<ffffffff81273fee>] dpm_resume_end+0x47e/0x4b0
[  331.586325]  [<ffffffff8107d5e9>] hibernation_snapshot+0xc9/0x280
[  331.600377]  [<ffffffff8107d88d>] hibernate+0xed/0x1f0
[  331.613980]  [<ffffffff8107c00c>] state_store+0xec/0x100
[  331.627577]  [<ffffffff811e05f7>] kobj_attr_store+0x17/0x20
[  331.641242]  [<ffffffff811345a4>] sysfs_write_file+0xd4/0x150
[  331.655056]  [<ffffffff810d02f8>] vfs_write+0xb8/0x1a0
[  331.668718]  [<ffffffff810d04bc>] sys_write+0x4c/0x80
[  331.682153]  [<ffffffff8100beeb>] system_call_fastpath+0x16/0x1b
[  331.695613] ---[ end trace 85c754c80d7debe8 ]---
[  331.709557] PM: Image restored successfully.

Now, how the ifmgd->timer could still be pending I have no idea yet, it seems to be explictly
del_timer_sync'ed and timer routine also checks this condition, and doesn't restart itself....

Also note that this was seen happening both on resume, and when the suspend image is written (sort of resume too).

Best regards,
	Maxim Levitsky


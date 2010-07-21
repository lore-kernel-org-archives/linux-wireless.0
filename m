Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:49963 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756708Ab0GUSr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 14:47:28 -0400
Date: Wed, 21 Jul 2010 20:40:41 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: 2.6.35-rc5+ WARNING at net/mac80211/scan.c:262
Message-ID: <20100721184040.GA22968@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

Just saw this in dmesg:

[82970.511341] ------------[ cut here ]------------
[82970.511365] WARNING: at net/mac80211/scan.c:262 ieee80211_scan_completed+0x137/0x1d0()
[82970.511374] Hardware name: SQ45S70S
[82970.511380] Modules linked in: binfmt_misc rfcomm sco bnep l2cap af_packet cpufreq_powersave cpufreq_stats cpufreq_conservative cpufreq_userspace iwl3945 pcmcia iwlcore yenta_socket coretemp ohci1394 sbp2 sg ieee1394 pcmcia_rsrc uvcvideo pcmcia_core btusb joydev evdev
[82970.511470] Pid: 4382, comm: iwl3945 Not tainted 2.6.35-rc5+ #252
[82970.511477] Call Trace:
[82970.511494]  [<ffffffff81073aca>] warn_slowpath_common+0x7a/0xb0
[82970.511505]  [<ffffffff81073b15>] warn_slowpath_null+0x15/0x20
[82970.511516]  [<ffffffff81649ba7>] ieee80211_scan_completed+0x137/0x1d0
[82970.511544]  [<ffffffffa00e2d7e>] iwl_bg_scan_completed+0xbe/0xc0 [iwlcore]
[82970.511565]  [<ffffffffa00e2cc0>] ? iwl_bg_scan_completed+0x0/0xc0 [iwlcore]
[82970.511579]  [<ffffffff810892bc>] worker_thread+0x20c/0x380
[82970.511590]  [<ffffffff8108926a>] ? worker_thread+0x1ba/0x380
[82970.511603]  [<ffffffff8108e130>] ? autoremove_wake_function+0x0/0x40
[82970.511615]  [<ffffffff810890b0>] ? worker_thread+0x0/0x380
[82970.511625]  [<ffffffff8108dc9e>] kthread+0xae/0xc0
[82970.511639]  [<ffffffff8102c864>] kernel_thread_helper+0x4/0x10
[82970.511651]  [<ffffffff81685954>] ? restore_args+0x0/0x30
[82970.511662]  [<ffffffff8108dbf0>] ? kthread+0x0/0xc0
[82970.511671]  [<ffffffff8102c860>] ? kernel_thread_helper+0x0/0x10
[82970.511679] ---[ end trace ba66a6fa61b5510c ]---

Best,
	Dominik

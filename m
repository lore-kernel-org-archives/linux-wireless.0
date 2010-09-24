Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:37098 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab0IXDU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 23:20:27 -0400
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by e24smtp04.br.ibm.com (8.14.4/8.13.1) with ESMTP id o8O3FSDd014389
	for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 00:15:28 -0300
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8O3JjbP2814022
	for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 00:19:45 -0300
Received: from d24av05.br.ibm.com (loopback [127.0.0.1])
	by d24av05.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o8O3KO9g002252
	for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 00:20:24 -0300
Received: from [9.18.198.26] ([9.18.198.26])
	by d24av05.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id o8O3KLKV002200
	for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 00:20:22 -0300
Subject: WARNING: at net/mac80211/scan.c:269
 ieee80211_scan_completed+0x55/0x169 [mac80211]()
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 00:20:17 -0300
Message-ID: <1285298417.2614.27.camel@cafe>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am not a linux-wireless follower, so I am not sure if this bug was
already reported, if so, please discard this message.

I am using kernel 2.6.36-rc4+ on a thinkpad t4000, after 3 days on
uptime I got the following Warning:

------------[ cut here ]------------
WARNING: at net/mac80211/scan.c:266 ieee80211_scan_completed+0x38/0x169
[mac80211]()
Hardware name: 6474D54
Modules linked in: bridge fuse tun rfcomm sco stp llc bnep l2cap
cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 uinput snd_hda_codec_conexant
snd_hda_intel arc4 ecb snd_hda_codec snd_hwdep iwlagn snd_seq
snd_seq_device snd_pcm iwlcore mac80211 thinkpad_acpi snd_timer snd
cfg80211 uvcvideo btusb bluetooth iTCO_wdt wmi e1000e videodev
v4l1_compat soundcore iTCO_vendor_support i2c_i801 rfkill snd_page_alloc
joydev microcode firewire_ohci firewire_core yenta_socket crc_itu_t i915
drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded:
stap_04e9689f51c4f1ebd10b8ec47cf7cdd0_1145]
Pid: 12517, comm: kworker/u:2 Not tainted 2.6.36-rc4+ #1
Call Trace:
 [<c0436f99>] warn_slowpath_common+0x65/0x7a
 [<fa9135b3>] ? ieee80211_scan_completed+0x38/0x169 [mac80211]
 [<c0436fbd>] warn_slowpath_null+0xf/0x13
 [<fa9135b3>] ieee80211_scan_completed+0x38/0x169 [mac80211]
 [<fac9a655>] iwl_bg_scan_completed+0x184/0x18c [iwlcore]
 [<c0448743>] process_one_work+0x15e/0x235
 [<fac9a4d1>] ? iwl_bg_scan_completed+0x0/0x18c [iwlcore]
 [<c0449c7c>] worker_thread+0xfb/0x1bc
 [<c0449b81>] ? worker_thread+0x0/0x1bc
 [<c044c40b>] kthread+0x62/0x67
 [<c044c3a9>] ? kthread+0x0/0x67
 [<c040367e>] kernel_thread_helper+0x6/0x10
---[ end trace 5a067c510f60f136 ]---
------------[ cut here ]------------
WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed+0x55/0x169
[mac80211]()
Hardware name: 6474D54
Modules linked in: bridge fuse tun rfcomm sco stp llc bnep l2cap
cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 uinput snd_hda_codec_conexant
snd_hda_intel arc4 ecb snd_hda_codec snd_hwdep iwlagn snd_seq
snd_seq_device snd_pcm iwlcore mac80211 thinkpad_acpi snd_timer snd
cfg80211 uvcvideo btusb bluetooth iTCO_wdt wmi e1000e videodev
v4l1_compat soundcore iTCO_vendor_support i2c_i801 rfkill snd_page_alloc
joydev microcode firewire_ohci firewire_core yenta_socket crc_itu_t i915
drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded:
stap_04e9689f51c4f1ebd10b8ec47cf7cdd0_1145]
Pid: 12517, comm: kworker/u:2 Tainted: G        W   2.6.36-rc4+ #1
Call Trace:
 [<c0436f99>] warn_slowpath_common+0x65/0x7a
 [<fa9135d0>] ? ieee80211_scan_completed+0x55/0x169 [mac80211]
 [<c0436fbd>] warn_slowpath_null+0xf/0x13
 [<fa9135d0>] ieee80211_scan_completed+0x55/0x169 [mac80211]
 [<fac9a655>] iwl_bg_scan_completed+0x184/0x18c [iwlcore]
 [<c0448743>] process_one_work+0x15e/0x235
 [<fac9a4d1>] ? iwl_bg_scan_completed+0x0/0x18c [iwlcore]
 [<c0449c7c>] worker_thread+0xfb/0x1bc
 [<c0449b81>] ? worker_thread+0x0/0x1bc
 [<c044c40b>] kthread+0x62/0x67
 [<c044c3a9>] ? kthread+0x0/0x67
 [<c040367e>] kernel_thread_helper+0x6/0x10
---[ end trace 5a067c510f60f137 ]---

Well, if you want some other information as the lspci, .config, let me
know.

Thanks
Breno


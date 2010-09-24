Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45618 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab0IXMof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 08:44:35 -0400
Date: Fri, 24 Sep 2010 08:40:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/mac80211/scan.c:269
 ieee80211_scan_completed+0x55/0x169 [mac80211]()
Message-ID: <20100924124057.GA8077@tuxdriver.com>
References: <1285298417.2614.27.camel@cafe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285298417.2614.27.camel@cafe>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 24, 2010 at 12:20:17AM -0300, Breno Leitao wrote:
> Hi,
> 
> I am not a linux-wireless follower, so I am not sure if this bug was
> already reported, if so, please discard this message.
> 
> I am using kernel 2.6.36-rc4+ on a thinkpad t4000, after 3 days on
> uptime I got the following Warning:
> 
> ------------[ cut here ]------------
> WARNING: at net/mac80211/scan.c:266 ieee80211_scan_completed+0x38/0x169
> [mac80211]()
> Hardware name: 6474D54
> Modules linked in: bridge fuse tun rfcomm sco stp llc bnep l2cap
> cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6
> ip6table_filter ip6_tables ipv6 uinput snd_hda_codec_conexant
> snd_hda_intel arc4 ecb snd_hda_codec snd_hwdep iwlagn snd_seq
> snd_seq_device snd_pcm iwlcore mac80211 thinkpad_acpi snd_timer snd
> cfg80211 uvcvideo btusb bluetooth iTCO_wdt wmi e1000e videodev
> v4l1_compat soundcore iTCO_vendor_support i2c_i801 rfkill snd_page_alloc
> joydev microcode firewire_ohci firewire_core yenta_socket crc_itu_t i915
> drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded:
> stap_04e9689f51c4f1ebd10b8ec47cf7cdd0_1145]
> Pid: 12517, comm: kworker/u:2 Not tainted 2.6.36-rc4+ #1
> Call Trace:
>  [<c0436f99>] warn_slowpath_common+0x65/0x7a
>  [<fa9135b3>] ? ieee80211_scan_completed+0x38/0x169 [mac80211]
>  [<c0436fbd>] warn_slowpath_null+0xf/0x13
>  [<fa9135b3>] ieee80211_scan_completed+0x38/0x169 [mac80211]
>  [<fac9a655>] iwl_bg_scan_completed+0x184/0x18c [iwlcore]
>  [<c0448743>] process_one_work+0x15e/0x235
>  [<fac9a4d1>] ? iwl_bg_scan_completed+0x0/0x18c [iwlcore]
>  [<c0449c7c>] worker_thread+0xfb/0x1bc
>  [<c0449b81>] ? worker_thread+0x0/0x1bc
>  [<c044c40b>] kthread+0x62/0x67
>  [<c044c3a9>] ? kthread+0x0/0x67
>  [<c040367e>] kernel_thread_helper+0x6/0x10
> ---[ end trace 5a067c510f60f136 ]---
> ------------[ cut here ]------------
> WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed+0x55/0x169
> [mac80211]()
> Hardware name: 6474D54
> Modules linked in: bridge fuse tun rfcomm sco stp llc bnep l2cap
> cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6
> ip6table_filter ip6_tables ipv6 uinput snd_hda_codec_conexant
> snd_hda_intel arc4 ecb snd_hda_codec snd_hwdep iwlagn snd_seq
> snd_seq_device snd_pcm iwlcore mac80211 thinkpad_acpi snd_timer snd
> cfg80211 uvcvideo btusb bluetooth iTCO_wdt wmi e1000e videodev
> v4l1_compat soundcore iTCO_vendor_support i2c_i801 rfkill snd_page_alloc
> joydev microcode firewire_ohci firewire_core yenta_socket crc_itu_t i915
> drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded:
> stap_04e9689f51c4f1ebd10b8ec47cf7cdd0_1145]
> Pid: 12517, comm: kworker/u:2 Tainted: G        W   2.6.36-rc4+ #1
> Call Trace:
>  [<c0436f99>] warn_slowpath_common+0x65/0x7a
>  [<fa9135d0>] ? ieee80211_scan_completed+0x55/0x169 [mac80211]
>  [<c0436fbd>] warn_slowpath_null+0xf/0x13
>  [<fa9135d0>] ieee80211_scan_completed+0x55/0x169 [mac80211]
>  [<fac9a655>] iwl_bg_scan_completed+0x184/0x18c [iwlcore]
>  [<c0448743>] process_one_work+0x15e/0x235
>  [<fac9a4d1>] ? iwl_bg_scan_completed+0x0/0x18c [iwlcore]
>  [<c0449c7c>] worker_thread+0xfb/0x1bc
>  [<c0449b81>] ? worker_thread+0x0/0x1bc
>  [<c044c40b>] kthread+0x62/0x67
>  [<c044c3a9>] ? kthread+0x0/0x67
>  [<c040367e>] kernel_thread_helper+0x6/0x10
> ---[ end trace 5a067c510f60f137 ]---

https://bugzilla.kernel.org/show_bug.cgi?id=17722

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

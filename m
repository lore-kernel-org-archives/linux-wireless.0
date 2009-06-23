Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1076 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZFWSeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 14:34:23 -0400
Date: Tue, 23 Jun 2009 14:31:26 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: fix todo lock
Message-ID: <20090623183126.GA3337@hash.localnet>
References: <1245751007.4184.17.camel@johannes.local> <1245766038.21314.24.camel@johannes.local> <4A40F856.2010501@openwrt.org> <b6c5339f0906230951v9766914vdc1d76f85eb62feb@mail.gmail.com> <1245776114.21314.41.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1245776114.21314.41.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 23, 2009 at 06:55:14PM +0200, Johannes Berg wrote:
> Strange, but I can't imagine it's due to this patch since it just
> changes locking in one place, which must be harmless (and I also tested
> this patch).

Here's the trace, after the initial warning it proceeded to continually
dump stack with the "workqueue leaked lock" thing.

[  108.984131] ------------[ cut here ]------------
[  108.984200] WARNING: at kernel/mutex.c:312 __mutex_unlock_slowpath+0x47/0xfe()
[  108.984275] Hardware name: MacBook1,1
[  108.984313] Modules linked in: aes_i586 aes_generic ipt_MASQUERADE iptable_nat nf_nat i915 drm af_packet ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ip_tables x_tables acpi_cpufreq binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath dm_mod kvm_intel kvm uinput arc4 ecb ath5k hid_apple mac80211 snd_hda_codec_idt usbhid appletouch snd_hda_intel snd_hda_codec ath cfg80211 snd_pcm snd_timer snd sg ohci1394 snd_page_alloc uhci_hcd joydev rfkill ehci_hcd sky2 battery ieee1394 processor video thermal button backlight ac output sr_mod applesmc evdev cdrom input_polldev unix [last unloaded: scsi_wait_scan]
[  108.984944] Pid: 9, comm: events/0 Not tainted 2.6.30-wl #140
[  108.984972] Call Trace:
[  108.984991]  [<c0124238>] warn_slowpath_common+0x6a/0x81
[  108.985035]  [<c036ebdc>] ? __mutex_unlock_slowpath+0x47/0xfe
[  108.985098]  [<c0124261>] warn_slowpath_null+0x12/0x15
[  108.985174]  [<c036ebdc>] __mutex_unlock_slowpath+0x47/0xfe
[  108.985221]  [<c036eca0>] mutex_unlock+0xd/0xf
[  108.985269]  [<fd65c1d8>] ieee80211_key_todo+0x23/0x25 [mac80211]
[  108.985343]  [<fd65c1e7>] key_todo+0xd/0xf [mac80211]
[  108.985425]  [<c0132267>] worker_thread+0x1aa/0x287
[  108.985474]  [<c0132225>] ? worker_thread+0x168/0x287
[  108.985518]  [<fd65c1da>] ? key_todo+0x0/0xf [mac80211]
[  108.985581]  [<c0135acc>] ? autoremove_wake_function+0x0/0x34
[  108.985658]  [<c01320bd>] ? worker_thread+0x0/0x287
[  108.985750]  [<c01357a7>] kthread+0x4b/0x6f
[  108.985776]  [<c013575c>] ? kthread+0x0/0x6f
[  108.985803]  [<c0103467>] kernel_thread_helper+0x7/0x10
[  108.985833] ---[ end trace cbbb1a87dac383bd ]---
[  108.985862] BUG: workqueue leaked lock or atomic: events/0/0x00000100/9
[  108.985896]     last function: key_todo+0x0/0xf [mac80211]
[  108.985946] INFO: lockdep is turned off.
[  108.985971] Pid: 9, comm: events/0 Tainted: G        W  2.6.30-wl #140
[  108.986014] Call Trace:
[  108.987186]  [<c013230c>] worker_thread+0x24f/0x287
[  108.987206]  [<fd65c1da>] ? key_todo+0x0/0xf [mac80211]
[  108.987212]  [<c0135acc>] ? autoremove_wake_function+0x0/0x34
[  108.987216]  [<c01320bd>] ? worker_thread+0x0/0x287
[  108.987219]  [<c01357a7>] kthread+0x4b/0x6f



-- 
Bob Copeland %% www.bobcopeland.com


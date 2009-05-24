Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:53466
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZEXWtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 18:49:50 -0400
Date: Mon, 25 May 2009 00:20:27 +0200
From: henk <henk@god.dyndns.org>
To: linux-wireless@vger.kernel.org
Subject: ath5k in AP mode works!! (but sometimes with an oops, and a panic)
Message-ID: <20090524222027.GA32198@god.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


First of all great work! AP mode works almost flawlessly.

The only things I encounter:
- At hostapd shutdown the kernel panics frequently, freezing up the system.
- At startup I encounter the trace below.
- In between the WPA2 sessions seem to work flawlessly.

Hope this helps.

- henk

[   37.939157] ------------[ cut here ]------------
[   37.939171] WARNING: at /home/henk/compat-wireless-2009-05-22/drivers/net/wireless/ath/ath5k/base.c:2167 ath5k_beacon_update_timers+0x42/0xcd [ath5k]()
[   37.939185] Hardware name: A9830IMS
[   37.939191] Modules linked in: usbhid snd_hda_codec_realtek iwlagn snd_hda_intel iwlcore snd_hda_codec ath5k ath mac80211 ehci_hcd snd_hwdep uhci_hcd snd_pcm snd_timer usbcore snd soundcore cfg80211 intelfb snd_page_alloc i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect
[   37.939263] Pid: 4191, comm: hostapd Not tainted 2.6.29.4 #1
[   37.939271] Call Trace:
[   37.939293]  [<c02238e1>] warn_slowpath+0x71/0x8d
[   37.939327]  [<fe764375>] ? ath5k_hw_set_fast_div+0xcf/0xd3 [ath5k]
[   37.939359]  [<fe760448>] ? ath5k_hw_set_imr+0x142/0x17a [ath5k]
[   37.939390]  [<fe766297>] ? ath5k_hw_set_sleep_clock+0x30f/0x313 [ath5k]
[   37.939420]  [<fe7672fe>] ? ath5k_hw_reset+0x9d4/0x9de [ath5k]
[   37.939451]  [<fe760ea0>] ? ath5k_hw_reset_tx_queue+0x794/0x79e [ath5k]
[   37.939484]  [<fe769ce9>] ath5k_beacon_update_timers+0x42/0xcd [ath5k]
[   37.939520]  [<fe769e1c>] ath5k_beacon_config+0xa8/0xbe [ath5k]
[   37.939551]  [<fe76a524>] ath5k_reset+0xdd/0xeb [ath5k]
[   37.939581]  [<fe7682ee>] ath5k_chan_set+0x29/0x30 [ath5k]
[   37.939611]  [<fe76a66c>] ath5k_config+0x31/0x75 [ath5k]
[   37.939657]  [<fe733210>] ieee80211_hw_config+0x76/0x7f [mac80211]
[   37.939713]  [<fe740b2d>] ieee80211_set_channel+0x26/0x28 [mac80211]
[   37.939752]  [<f8187159>] nl80211_set_wiphy+0x1e8/0x33b [cfg80211]
[   37.939808]  [<fe745d68>] ? ieee80211_master_start_xmit+0x332/0x346 [mac80211]
[   37.939831]  [<c03c7040>] ? nla_parse+0x67/0xae
[   37.939850]  [<c03c7b2f>] genl_rcv_msg+0x151/0x15d
[   37.939865]  [<c03c79de>] ? genl_rcv_msg+0x0/0x15d
[   37.939877]  [<c03c6bb1>] netlink_rcv_skb+0x38/0x76
[   37.939889]  [<c03c7b57>] genl_rcv+0x1c/0x29
[   37.939904]  [<c03c5b66>] netlink_unicast+0x125/0x184
[   37.939919]  [<c03c6354>] netlink_sendmsg+0x21c/0x22b
[   37.939935]  [<c03a9b4c>] sock_sendmsg+0xb8/0xcf
[   37.939948]  [<c03a9cf6>] ? sock_recvmsg+0xc2/0xda
[   37.939964]  [<c023356b>] ? autoremove_wake_function+0x0/0x33
[   37.939980]  [<c02db1fd>] ? copy_from_user+0x2c/0x4f
[   37.939993]  [<c02db1fd>] ? copy_from_user+0x2c/0x4f
[   37.940050]  [<c03b0ec4>] ? verify_iovec+0x40/0x74
[   37.940070]  [<c03ab04c>] sys_sendmsg+0x175/0x1dc
[   37.940090]  [<c024c94a>] ? find_lock_page+0x13/0x47
[   37.940107]  [<c024d4be>] ? filemap_fault+0x8a/0x299
[   37.940123]  [<c024c739>] ? unlock_page+0x1b/0x1e
[   37.940140]  [<c03b360a>] ? __dev_get_by_name+0x66/0x7a
[   37.940158]  [<c03a9789>] ? sock_destroy_inode+0x10/0x12
[   37.940175]  [<c027ae81>] ? destroy_inode+0x27/0x38
[   37.940192]  [<c027bee0>] ? generic_forget_inode+0x16e/0x175
[   37.940209]  [<c0278ebc>] ? __d_free+0x3c/0x41
[   37.940224]  [<c0278ef3>] ? d_free+0x25/0x37
[   37.940242]  [<c027dd41>] ? mntput_no_expire+0x16/0xdf
[   37.940260]  [<c03ab3a6>] sys_socketcall+0x141/0x16b
[   37.940280]  [<c026ca57>] ? sys_close+0x50/0x82
[   37.940297]  [<c0202d05>] sysenter_do_call+0x12/0x25
[   37.940310] ---[ end trace 1be5347d05de050b ]---
[   38.220995] hostapd used greatest stack depth: 5740 bytes left



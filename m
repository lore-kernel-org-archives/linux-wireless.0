Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4955 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZE1O2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 10:28:49 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, henk@god.dyndns.org, onelektra@gmx.net
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: remove conf->beacon_int usage
Date: Thu, 28 May 2009 10:27:37 -0400
Message-Id: <1243520857-8358-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_conf->beacon_int was deprecated and removed in a cleanup
patch, however it was accidentally added back to ath5k in the change
"ath5k: Allow user/driver to set txpower."  Remove it once more,
fixing the following warning:

[13091.968902] WARNING: at drivers/net/wireless/ath/ath5k/base.c:2167 warn_slowpath_null+0x15/0x1a()
[13091.968906] Hardware name: MacBook1,1
[13091.968909] Modules linked in: usb_storage fuse i915 drm af_packet acpi_cpufreq binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath dm_mod snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_seq_dummy hid_apple arc4 ecb snd_seq_oss snd_seq_midi_event usbhid snd_seq ath5k mac80211 appletouch snd_seq_device snd_pcm_oss snd_mixer_oss sky2 snd_pcm ath processor cfg80211 snd_timer sg ohci1394 snd uhci_hcd bitrev ieee1394 joydev ehci_hcd crc32 snd_page_alloc button ac thermal battery sr_mod applesmc cdrom evdev input_polldev unix [last unloaded: microcode]
[13091.968985] Pid: 2132, comm: phy0 Tainted: G        W  2.6.30-rc5-wl #118
[13091.968988] Call Trace:
[13091.968994]  [<c0125884>] warn_slowpath_fmt+0x77/0xa6
[13091.969003]  [<c03557d8>] ? _spin_unlock+0x2c/0x41
[13091.969008]  [<c0355a56>] ? _spin_lock_irqsave+0x15/0x69
[13091.969012]  [<c0355783>] ? _spin_unlock_irqrestore+0x34/0x5d
[13091.969019]  [<c01445bb>] ? trace_hardirqs_off+0xb/0xd
[13091.969024]  [<c0355783>] ? _spin_unlock_irqrestore+0x34/0x5d
[13091.969029]  [<c01445bb>] ? trace_hardirqs_off+0xb/0xd
[13091.969034]  [<c0355783>] ? _spin_unlock_irqrestore+0x34/0x5d
[13091.969039]  [<c01258c8>] warn_slowpath_null+0x15/0x1a
[13091.969054]  [<f965846d>] ath5k_beacon_update_timers+0x44/0x27f [ath5k]
[13091.969059]  [<c0126370>] ? vprintk+0x2dd/0x312
[13091.969063]  [<c0125e50>] ? release_console_sem+0x1a6/0x1d3
[13091.969076]  [<f96586c5>] ath5k_reset_tsf+0x1d/0x2c [ath5k]
[13091.969095]  [<f93f4426>] __ieee80211_sta_join_ibss+0x35/0x3aa [mac80211]
[13091.969102]  [<c0252793>] ? extract_entropy+0x47/0x8a
[13091.969121]  [<f93f4b21>] ieee80211_sta_find_ibss+0x2de/0x32f [mac80211]
[13091.969126]  [<c035422c>] ? mutex_lock_nested+0x28b/0x2a5
[13091.969145]  [<f93f4b8e>] ? ieee80211_ibss_notify_scan_completed+0x1c/0x6f [mac80211]
[13091.969164]  [<f93f4bc9>] ieee80211_ibss_notify_scan_completed+0x57/0x6f [mac80211]
[13091.969182]  [<f93f26da>] ieee80211_scan_completed+0x31a/0x33f [mac80211]
[13091.969201]  [<f93f27ca>] ieee80211_scan_work+0xcb/0x18b [mac80211]
[13091.969207]  [<c0133a6a>] worker_thread+0x1b1/0x28e
[13091.969212]  [<c0133a25>] ? worker_thread+0x16c/0x28e
[13091.969230]  [<f93f26ff>] ? ieee80211_scan_work+0x0/0x18b [mac80211]
[13091.969237]  [<c013736e>] ? autoremove_wake_function+0x0/0x38
[13091.969242]  [<c01338b9>] ? worker_thread+0x0/0x28e
[13091.969246]  [<c0137031>] kthread+0x4a/0x70
[13091.971460]  [<c0136fe7>] ? kthread+0x0/0x70
[13091.971467]  [<c0103527>] kernel_thread_helper+0x7/0x10
[13091.971470] ---[ end trace 8defaa5d15c50cef ]---

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index fb51937..b6fb15e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2775,8 +2775,6 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&sc->lock);
 
-	sc->bintval = conf->beacon_int;
-
 	ret = ath5k_chan_set(sc, conf->channel);
 	if (ret < 0)
 		return ret;
-- 
1.6.0.6



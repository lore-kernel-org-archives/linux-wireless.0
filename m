Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22754 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaEYMii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 08:38:38 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix virtual monitor interface addition
Date: Sun, 25 May 2014 15:35:41 +0300
Message-Id: <1401021341-26402-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140525_143842_533964_136460E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the commit below, cfg80211_chandef_dfs_required()
will warn if it gets a an NL80211_IFTYPE_UNSPECIFIED iftype
as explicitely written in the commit log.
When an virtual monitor interface is added, its type is set
in ieee80211_sub_if_data.vif.type, but not in
ieee80211_sub_if_data.wdev.iftype which is passed to
cfg80211_chandef_dfs_required() hence resulting in the
following warning:

WARNING: CPU: 1 PID: 21265 at net/wireless/chan.c:376 cfg80211_chandef_dfs_required+0xbc/0x130 [cfg80211]()
Modules linked in: iwlmvm(O) mac80211(O) iwlwifi(O) cfg80211(O) compat(O) arc4 rfcomm bnep intel_powerclamp coretemp kvm_intel i915 kvm snd_hda_codec_hdmi snd_hda_codec_idt crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel snd_hda_codec aesni_intel joydev aes_x86_64 glue_helper lrw uvcvideo gf128mul ablk_helper cryptd i2c_algo_bit snd_hwdep drm_kms_helper videobuf2_vmalloc snd_pcm dell_wmi sparse_keymap videobuf2_memops videobuf2_core videodev dell_laptop btusb drm dcdbas bluetooth snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq psmouse snd_timer serio_raw snd_seq_device microcode snd wmi soundcore intel_ips lpc_ich video parport_pc ppdev lp parport e1000e firewire_ohci firewire_core ahci libahci crc_itu_t sdhci_pci ptp sdhci pps_core [last unloaded: compat]
CPU: 1 PID: 21265 Comm: ifconfig Tainted: G        W  O 3.13.11+ #12
Hardware name: Dell Inc. Latitude E6410/0667CC, BIOS A01 03/05/2010
 0000000000000009 ffff88008f5fdb08 ffffffff817d4219 ffff88008f5fdb50
 ffff88008f5fdb40 ffffffff8106f57d 0000000000000000 0000000000000000
 ffff880081062fb8 ffff8800810604e0 0000000000000001 ffff88008f5fdba0
Call Trace:
 [<ffffffff817d4219>] dump_stack+0x4d/0x66
 [<ffffffff8106f57d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8106f5ec>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffffa04ea4ec>] cfg80211_chandef_dfs_required+0xbc/0x130 [cfg80211]
 [<ffffffffa06b1024>] ieee80211_vif_use_channel+0x94/0x500 [mac80211]
 [<ffffffffa0684e57>] ? ieee80211_add_virtual_monitor+0x197/0x5c0 [mac80211]
 [<ffffffffa0684e6b>] ieee80211_add_virtual_monitor+0x1ab/0x5c0 [mac80211]
 [<ffffffffa0686ae5>] ieee80211_do_open+0xe75/0x1580 [mac80211]
 [<ffffffffa0687259>] ieee80211_open+0x69/0x70 [mac80211]
[snip]

Fixes: 00ec75fc5a64 ("cfg80211: pass the actual iftype when calling cfg80211_chandef_dfs_required()")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2612855..9b9d804 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -399,6 +399,7 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	sdata->vif.type = NL80211_IFTYPE_MONITOR;
 	snprintf(sdata->name, IFNAMSIZ, "%s-monitor",
 		 wiphy_name(local->hw.wiphy));
+	sdata->wdev.iftype = NL80211_IFTYPE_MONITOR;
 
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
 
-- 
1.9.1


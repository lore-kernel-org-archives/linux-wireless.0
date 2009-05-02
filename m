Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50256 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZEBEeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 00:34:18 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH] cfg80211: fix bug while trying to process beacon hints on init
Date: Sat,  2 May 2009 00:34:15 -0400
Message-Id: <1241238855-29306-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During initialization we would not have received any beacons
so skip processing reg beacon hints, also adds a check to
reg_is_world_roaming() for last_request before accessing its
fields.

This should fix this:

BUG: unable to handle kernel NULL pointer dereference at

IP: [<e0171332>] wiphy_update_regulatory+0x20f/0x295

*pdpt = 0000000008bf1001 *pde = 0000000000000000
Oops: 0000 [#1]
last sysfs file: /sys/class/backlight/eeepc/brightness
Modules linked in: ath5k(+) mac80211 led_class cfg80211
go_bit cfbcopyarea cfbimgblt cfbfillrect ipv6
ydev usual_tables(P) snd_hda_codec_realtek snd_hda_intel
nd_hwdep uhci_hcd snd_pcm_oss snd_mixer_oss i2c_i801
e serio_raw i2c_core pcspkr atl2 snd_pcm intel_agp
re agpgart eeepc_laptop snd_page_alloc ac video backlight
rfkill button processor evdev thermal fan ata_generic

Pid: 2909, comm: modprobe Tainted: Pc #112) 701
EIP: 0060:[<e0171332>] EFLAGS: 00010246 CPU: 0
EIP is at wiphy_update_regulatory+0x20f/0x295 [cfg80211]
EAX: 00000000 EBX: c5da0000 ECX: 00000000 EDX: c5da0060
ESI: 0000001a EDI: c5da0060 EBP: df3bdd70 ESP: df3bdd40
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 2909, ti=df3bc000 task=c5d030000)
Stack:
 df3bdd90 c5da0060 c04277e0 00000001 00000044 c04277e402
 00000002 c5da0000 0000001a c5da0060 df3bdda8 e01706a2 02
 00000282 000080d0 00000068 c5d53500 00000080 0000028240
Call Trace:
 [<e01706a2>] ? wiphy_register+0x122/0x1b7 [cfg80211]
 [<e0328e02>] ? ieee80211_register_hw+0xd8/0x346
 [<e06a7c9f>] ? ath5k_hw_set_bssid_mask+0x71/0x78 [ath5k]
 [<e06b0c52>] ? ath5k_pci_probe+0xa5c/0xd0a [ath5k]
 [<c01a6037>] ? sysfs_find_dirent+0x16/0x27
 [<c01fec95>] ? local_pci_probe+0xe/0x10
 [<c01ff526>] ? pci_device_probe+0x48/0x66
 [<c024c9fd>] ? driver_probe_device+0x7f/0xf2
 [<c024cab3>] ? __driver_attach+0x43/0x5f
 [<c024c0af>] ? bus_for_each_dev+0x39/0x5a
 [<c024c8d0>] ? driver_attach+0x14/0x16
 [<c024ca70>] ? __driver_attach+0x0/0x5f
 [<c024c5b3>] ? bus_add_driver+0xd7/0x1e7
 [<c024ccb9>] ? driver_register+0x7b/0xd7
 [<c01ff827>] ? __pci_register_driver+0x32/0x85
 [<e00a8018>] ? init_ath5k_pci+0x18/0x30 [ath5k]
 [<c0101131>] ? _stext+0x49/0x10b
 [<e00a8000>] ? init_ath5k_pci+0x0/0x30 [ath5k]
 [<c012f452>] ? __blocking_notifier_call_chain+0x40/0x4c
 [<c013a714>] ? sys_init_module+0x87/0x18b
 [<c0102804>] ? sysenter_do_call+0x12/0x22
Code: b8 da 17 e0 83 c0 04 e8 92 f9 ff ff 84 c0 75 2a 8b
85 c0 74 0c 83 c0 04 e8 7c f9 ff ff 84 c0 75 14 a1 bc da
4 03 74 66 8b 4d d4 80 79 08 00 74 5d a1 e0 d2 17 e0 48
EIP: [<e0171332>] wiphy_update_regulatory+0x20f/0x295
SP 0068:df3bdd40
CR2: 0000000000000004
---[ end trace 830f2dd2a95fd1a8 ]---

This issue is hard to reproduce, but it was noticed and discussed on
this thread:

http://marc.info/?t=123938022700005&r=1&w=2

Cc: stable@kernel.org
Reported-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 net/wireless/reg.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 11481b4..d68950d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1135,7 +1135,8 @@ static bool reg_is_world_roaming(struct wiphy *wiphy)
 	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
 	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
 		return true;
-	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	if (last_request &&
+	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    wiphy->custom_regulatory)
 		return true;
 	return false;
@@ -1144,6 +1145,12 @@ static bool reg_is_world_roaming(struct wiphy *wiphy)
 /* Reap the advantages of previously found beacons */
 static void reg_process_beacons(struct wiphy *wiphy)
 {
+	/*
+	 * Means we are just firing up cfg80211, so no beacons would
+	 * have been processed yet.
+	 */
+	if (!last_request)
+		return;
 	if (!reg_is_world_roaming(wiphy))
 		return;
 	wiphy_update_beacon_reg(wiphy);
-- 
1.6.0.6


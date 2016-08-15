Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35500 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbcHOPAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 11:00:22 -0400
Received: by mail-wm0-f66.google.com with SMTP id i5so11557337wmg.2
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2016 08:00:21 -0700 (PDT)
From: Ioan-Adrian Ratiu <adi@adirat.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: Fix beacon configuration assertion failure
Date: Mon, 15 Aug 2016 18:00:28 +0300
Message-Id: <20160815150028.7909-1-adi@adirat.com> (sfid-20160815_170055_766002_8B1E53EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit cfda2d8e2314 ("ath9k: Fix beacon configuration for
addition/removal of interfaces") reworked beacon configs to happen at
IF changes and missed cases when NL80211_IFTYPE_STATION has no beacons
with the corresponding values iter_data.primary_beacon_vif == 0 and
iter_data.nbcnvifs == 0 in ath9k_calculate_summary_state(), thus
calling ath9k_beacon_config() with null and giving the below warning.

Fix this by calling beacon config only when a beacon actually exists,
i.e. by checking iter_data.beacons which should be set only inside
ath9k_vif_iter_set_beacon() (the line "iter_data.beacons = true;" in
ath9k_calculate_summary_state() is a bug in above rework commit).

[   16.910537] ------------[ cut here ]------------
[   16.910549] WARNING: CPU: 2 PID: 6 at drivers/net/wireless/ath/ath9k/beacon.c:642 ath9k_beacon_config+0x12c/0x130 [ath9k]
[   16.910551] Modules linked in: intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel hid_generic aesni_intel usbhid hid aes_x86_64 joydev mousedev arc4 lrw ath9k dell_laptop ath9k_common ath9k_hw ath mac80211 gf128mul glue_helper ablk_helper dell_smbios input_leds cryptd led_class snd_hda_codec_hdmi psmouse cfg80211 serio_raw atkbd snd_hda_codec_realtek libps2 rfkill r8169 sr_mod snd_hda_codec_generic dcdbas cdrom mii snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core i8042 snd_pcm snd_timer serio ac xhci_pci xhci_hcd battery i2c_i801 tpm_tis pcspkr tpm_tis_core evdev shpchp lpc_ich i2c_smbus tpm sch_fq_codel ip_tables x_tables
[   16.910620] CPU: 2 PID: 6 Comm: kworker/u16:0 Not tainted 4.8.0-rc1-next-20160815-g118253a #1
[   16.910621] Hardware name: Dell Inc. Inspiron 3521/018DYG, BIOS A14 07/31/2015
[   16.910648] Workqueue: phy0 ieee80211_iface_work [mac80211]
[   16.910652]  0000000000000000 ffff880159f13630 ffffffff813140f0 0000000000000000
[   16.910657]  0000000000000000 ffff880159f13670 ffffffff8106b22b 0000028200000202
[   16.910661]  ffff880156bc1500 0000000000000000 ffff880153cc8018 ffff880153cc8018
[   16.910666] Call Trace:
[   16.910674]  [<ffffffff813140f0>] dump_stack+0x63/0x83
[   16.910678]  [<ffffffff8106b22b>] __warn+0xcb/0xf0
[   16.910682]  [<ffffffff8106b31d>] warn_slowpath_null+0x1d/0x20
[   16.910690]  [<ffffffffa02fceec>] ath9k_beacon_config+0x12c/0x130 [ath9k]
[   16.910696]  [<ffffffffa03010f6>] ath9k_calculate_summary_state+0xf6/0x350 [ath9k]
[   16.910703]  [<ffffffffa0301b46>] ath9k_bss_info_changed+0x186/0x1a0 [ath9k]
[   16.910720]  [<ffffffffa025dd71>] ieee80211_bss_info_change_notify+0xb1/0x200 [mac80211]
[   16.910737]  [<ffffffffa02c088c>] ieee80211_assoc_success+0x677/0xdeb [mac80211]
[   16.910746]  [<ffffffff810adea2>] ? up+0x32/0x50
[   16.910751]  [<ffffffff810bcf3b>] ? wake_up_klogd+0x3b/0x50
[   16.910755]  [<ffffffff810bd489>] ? console_unlock+0x539/0x5f0
[   16.910760]  [<ffffffff810bd794>] ? vprintk_emit+0x254/0x490
[   16.910765]  [<ffffffff810bdb3f>] ? vprintk_default+0x1f/0x30
[   16.910769]  [<ffffffff8114854d>] ? printk+0x48/0x50
[   16.910788]  [<ffffffffa02ad0c2>] ieee80211_rx_mgmt_assoc_resp+0x152/0x4c0 [mac80211]
[   16.910807]  [<ffffffffa02ade3f>] ieee80211_sta_rx_queued_mgmt+0x18f/0x840 [mac80211]
[   16.910813]  [<ffffffff810d0a40>] ? lock_timer_base.isra.2+0x80/0xa0
[   16.910817]  [<ffffffff810ad896>] ? cpuacct_charge+0x86/0xa0
[   16.910822]  [<ffffffff8109d8e7>] ? update_curr+0xb7/0x160
[   16.910827]  [<ffffffff8109e54c>] ? dequeue_entity+0x24c/0xa20
[   16.910831]  [<ffffffff8109f2e3>] ? dequeue_task_fair+0x5c3/0x960
[   16.910848]  [<ffffffffa02735b4>] ? ieee80211_iface_work+0xd4/0x410 [mac80211]
[   16.910865]  [<ffffffffa0273775>] ieee80211_iface_work+0x295/0x410 [mac80211]
[   16.910870]  [<ffffffff81090537>] ? finish_task_switch+0x77/0x1e0
[   16.910875]  [<ffffffff810832d5>] process_one_work+0x1e5/0x470
[   16.910880]  [<ffffffff810835a8>] worker_thread+0x48/0x4e0
[   16.910885]  [<ffffffff81083560>] ? process_one_work+0x470/0x470
[   16.910888]  [<ffffffff81088f09>] kthread+0xc9/0xe0
[   16.910894]  [<ffffffff81028723>] ? __switch_to+0x2c3/0x610
[   16.910899]  [<ffffffff8173a67f>] ret_from_fork+0x1f/0x40
[   16.910902]  [<ffffffff81088e40>] ? kthread_create_on_node+0x40/0x40
[   16.910904] ---[ end trace aa169ad4461f2f18 ]---

Signed-off-by: Ioan-Adrian Ratiu <adi@adirat.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a394622..3c6f413 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1154,7 +1154,6 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 		bool changed = (iter_data.primary_sta != ctx->primary_sta);
 
 		if (iter_data.primary_sta) {
-			iter_data.beacons = true;
 			ath9k_set_assoc_state(sc, iter_data.primary_sta,
 					      changed);
 			ctx->primary_sta = iter_data.primary_sta;
@@ -1166,10 +1165,12 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 			if (ath9k_hw_mci_is_enabled(sc->sc_ah))
 				ath9k_mci_update_wlan_channels(sc, true);
 		}
+	} else if (iter_data.beacons) {
+		sc->nbcnvifs = iter_data.nbcnvifs;
+		ath9k_beacon_config(sc, iter_data.primary_beacon_vif,
+				    iter_data.beacons);
 	}
-	sc->nbcnvifs = iter_data.nbcnvifs;
-	ath9k_beacon_config(sc, iter_data.primary_beacon_vif,
-			    iter_data.beacons);
+
 	ath9k_hw_set_interrupts(ah);
 
 	if (ah->slottime != iter_data.slottime) {
-- 
2.9.2


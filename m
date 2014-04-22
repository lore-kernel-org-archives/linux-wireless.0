Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51862 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaDVX0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 19:26:49 -0400
Received: by mail-pa0-f51.google.com with SMTP id kl14so126096pab.24
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 16:26:48 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org
Cc: stable-review@kernel.org, stable@kernel.org,
	linux-wireless@vger.kernel.org, lkml20140418@newton.leun.net,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH] cfg80211: fix few minor issues in reg_process_hint()
Date: Tue, 22 Apr 2014 16:26:26 -0700
Message-Id: <1398209186-27183-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140423_012654_095015_25F56F67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

commit 772f0389338cfcf96da1c178046dc7e1649ab554 upstream.

Fix the following issues in reg_process_hint():

1. Add verification that wiphy is valid before processing
   NL80211_REGDOMAIN_SET_BY_COUNTRY_IE1649ab554 of invalid initiator.
3. Remove WARN_ON check on reg_request->alpha2 as it is not a
   pointer.

[ mcgrof: Michael Leun reported a null pointer dereference against v3.14.1,
  turns out that there's a fix for this already but it wasn't propagated
  to stable. The upstream fix has been tested by Michael and has been
  confirmed to fix his issue. Below is his reported oops trace and
  original thread that reported the issue.

Micheal's report:

http://marc.info/?l=linux-wireless&m=139787057519525&w=2

Michael's oops trace:

[  116.006227] PM: Syncing filesystems ... done.
[  116.238271] PM: Preparing system for mem sleep
[  116.382917] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  116.384816] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  116.386178] PM: Entering mem sleep
[  116.386855] wlan0: deauthenticating from 90:f6:52:4e:ba:b6 by local choice (reason=3)
[  116.406743] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  116.406926] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[  116.407009] IP:[  116.407022] sd 0:0:0:0: [sda] Stopping disk

[  116.407092]  [<ffffffffa002c1f1>] reg_todo+0xc1/0x4c0 [cfg80211]
[  116.407151] PGD 366ad067 PUD 366ac067 PMD 0
[  116.407212] Oops: 0000 [#1] SMP
[  116.407258] Modules linked in: netconsole configfs bnep bluetooth 6lowpan_iphc ipt_REJECT xt_LOG xt_limit xt_recent iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack xt_tcpudp ip6table_filter ip6_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack ip_tables x_tables ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_pcm snd_seq iTCO_wdt acer_wmi sparse_keymap iTCO_vendor_support ath9k snd_seq_device snd_timer snd_mixer_oss snd atl1c coretemp shpchp lpc_ich pcspkr joydev i2c_i801 hid_multitouch serio_raw mfd_core ac wmi battery acpi_cpufreq soundcore sg sha256_ssse3 sha256_generic cbc linear md_mod af_packet usbhid i915 uhci_hcd i2c_algo_bit drm_kms_helper drm ehci_pci ehci_hcd video usbcore button usb_common scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh dm_mirror dm_region_hash dm_log dm_crypt dm_snap!
 shot dm_bufio dm_mod glue_helper lrw gf128mul ablk_helper cryptd aes_x86_64 arc4 ath9k_common ath9k_hw ath mac80211 cfg80211 rfkill fan processor thermal [last unloaded: ath9k]
[  116.408005] CPU: 1 PID: 3405 Comm: kworker/1:3 Tainted: G          I  3.14.1 #3
[  116.408005] Hardware name: Acer Aspire 1825PTZ/JM12-MS-CAP, BIOS V1.3127 04/23/2010
[  116.408005] Workqueue: events reg_todo [cfg80211]
[  116.408005] task: ffff8801b38225d0 ti: ffff8800370cc000 task.ti: ffff8800370cc000
[  116.408005] RIP: 0010:[<ffffffffa002c1f1>]  [<ffffffffa002c1f1>] reg_todo+0xc1/0x4c0 [cfg80211]
[  116.408005] RSP: 0018:ffff8800370cdde8  EFLAGS: 00010297
[  116.408005] RAX: ffffffffa0075360 RBX: ffff8801b256e530 RCX: 0000000000000003
[  116.408005] RDX: 0000000000000000 RSI: ffff8801bfc92ed8 RDI: 0000000000000000
[  116.408005] RBP: ffff8800370cde20 R08: fffe801d4b000000 R09: 9600000000000000
[  116.408005] R10: 00017fe2550752c0 R11: 0000000000000000 R12: 0000000000000000
[  116.408005] R13: ffff8801b256e51c R14: ffff8801b256e500 R15: 0000000000000040
[  116.408005] FS:  0000000000000000(0000) GS:ffff8801bfc80000(0000) knlGS:0000000000000000
[  116.408005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  116.408005] CR2: 0000000000000038 CR3: 0000000037bb9000 CR4: 00000000000407e0
[  116.408005] Stack:
[  116.408005]  ffff8800370cde20 ffffffffa004aaff ffff8801b2f9f800 ffff8801bfc92ec0
[  116.408005]  ffffffffa00752c0 0000000000000000 0000000000000040 ffff8800370cde68
[  116.408005]  ffffffff81071dd8 00000000b2e45800 ffff8801bfc96a00 ffff8801bfc92ed8
[  116.408005] Call Trace:
[  116.408005]  [<ffffffffa004aaff>] ? disconnect_work+0xbf/0xd0 [cfg80211]
[  116.408005]  [<ffffffff81071dd8>] process_one_work+0x178/0x420
[  116.408005]  [<ffffffff810729f9>] worker_thread+0x119/0x3a0
[  116.408005]  [<ffffffff810728e0>] ? rescuer_thread+0x360/0x360
[  116.408005]  [<ffffffff81078f9d>] kthread+0xcd/0xf0
[  116.408005]  [<ffffffff81078ed0>] ? kthread_create_on_node+0x180/0x180
[  116.408005]  [<ffffffff8159a24c>] ret_from_fork+0x7c/0xb0
[  116.408005]  [<ffffffff81078ed0>] ? kthread_create_on_node+0x180/0x180
[  116.408005] Code: 86 02 00 00 83 f9 01 0f 84 cc 01 00 00 72 4b 83 f9 03 0f 85 a2 01 00 00 48 8b 05 6b 91 04 00 8b 50 14 83 fa 01 0f 84 63 03 00 00 <41> f6 44 24 38 10 0f 85 3e 03 00 00 0f b6 4b ec f6 81 00 5d 64
[  116.408005] RIP  [<ffffffffa002c1f1>] reg_todo+0xc1/0x4c0 [cfg80211]
[  116.408005]  RSP <ffff8800370cdde8>
[  116.408005] CR2: 0000000000000038
[  116.408005] ---[ end trace fab5039fc72cc2f8 ]---
]

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com> [updated commit log for v3.14]
Tested-by: Michael Leun <lkml20140418@newton.leun.net> [on v3.14.1]
---

Greg,

Michael reported of an null pointer dereference that triggers on v3.14.1,
the fix was addressed on upstream commit 772f03893 but this hasn't trickled
down to stable as it was not pegged as such but its needed. This confirms to
fix Michael's issue. I ammended the commit log as I figured might be useful.
Feel free to massage it further if needed though.

 net/wireless/reg.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9b897fc..484facf 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1683,17 +1683,9 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	struct wiphy *wiphy = NULL;
 	enum reg_request_treatment treatment;
 
-	if (WARN_ON(!reg_request->alpha2))
-		return;
-
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
-	if (reg_request->initiator == NL80211_REGDOM_SET_BY_DRIVER && !wiphy) {
-		kfree(reg_request);
-		return;
-	}
-
 	switch (reg_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
 		reg_process_hint_core(reg_request);
@@ -1706,20 +1698,29 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
+		if (!wiphy)
+			goto out_free;
 		treatment = reg_process_hint_driver(wiphy, reg_request);
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		if (!wiphy)
+			goto out_free;
 		treatment = reg_process_hint_country_ie(wiphy, reg_request);
 		break;
 	default:
 		WARN(1, "invalid initiator %d\n", reg_request->initiator);
-		return;
+		goto out_free;
 	}
 
 	/* This is required so that the orig_* parameters are saved */
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
 	    wiphy->regulatory_flags & REGULATORY_STRICT_REG)
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
+
+	return;
+
+out_free:
+	kfree(reg_request);
 }
 
 /*
-- 
1.9.0


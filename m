Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52026 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3BOPTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 10:19:10 -0500
Received: by mail-ie0-f169.google.com with SMTP id 13so4954522iea.28
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 07:19:09 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>,
	Bob Copeland <bob@cozybit.com>
Subject: [PATCH] mac80211: enable vif.cab_queue for mesh
Date: Fri, 15 Feb 2013 10:18:34 -0500
Message-Id: <1360941514-9579-1-git-send-email-me@bobcopeland.com> (sfid-20130215_161914_949004_23B43390)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since mesh powersaving was added, pending bcast/mcast frames may go out the
CAB queue now.  Unfortunately, the queue was only set up for AP mode, so we
would try to tx on the IEEE80211_INVAL_HW_QUEUE.  Allow cab_queue for mesh
interfaces as well.

Fixes the following warning (or crash without MAC80211_VERBOSE_DEBUG):

[ 1888.975315] ------------[ cut here ]------------
[ 1888.975390] WARNING: at net/mac80211/tx.c:1223 __ieee80211_tx+0x162/0x35f [mac80211]()
[ 1888.975397] Hardware name: 3443CTO
[ 1888.975401] Modules linked in: mac80211_hwsim mac80211 cfg80211 vfat fat parport_pc ppdev lp parport rfcomm bnep binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc loop snd_hda_codec_hdmi iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek btusb bluetooth joydev arc4 cdc_ncm coretemp usbnet kvm_intel mii cdc_acm cdc_wdm kvm evdev snd_hda_intel psmouse snd_hda_codec pcspkr serio_raw snd_hwdep snd_pcm thinkpad_acpi snd_page_alloc nvram snd_seq snd_seq_device lpc_ich snd_timer mfd_core i2c_i801 snd i915 ac battery rfkill tpm_tis tpm soundcore tpm_bios ehci_pci ehci_hcd acpi_cpufreq mperf i2c_algo_bit drm_kms_helper drm video wmi button i2c_core processor ext4 crc16 jbd2 mbcache dm_crypt dm_mod sg sd_mod crc_t10dif crc32c_intel ghash_clmulni_intel ahci libahci libata aesni_intel xts aes_x86_64 lrw gf128mul ablk_helper scsi_mod cryptd sdhci_pci sdhci mmc_core xhci_hcd usbcore usb_common thermal thermal_sys [last unloaded: cfg80211]
[ 1888.975671] Pid: 3085, comm: avahi-daemon Tainted: G        W    3.8.0-rc1+ #377
[ 1888.975677] Call Trace:
[ 1888.975701]  [<ffffffff81045c20>] warn_slowpath_common+0x83/0x9c
[ 1888.975715]  [<ffffffff81045c53>] warn_slowpath_null+0x1a/0x1c
[ 1888.975771]  [<ffffffffa083aef0>] __ieee80211_tx+0x162/0x35f [mac80211]
[ 1888.975820]  [<ffffffffa083cb1d>] ieee80211_tx+0xd3/0xf9 [mac80211]
[ 1888.975868]  [<ffffffffa083cc0f>] ieee80211_xmit+0xcc/0xd5 [mac80211]
[ 1888.975914]  [<ffffffffa083db59>] ieee80211_subif_start_xmit+0xc53/0xcd8 [mac80211]
[ 1888.975933]  [<ffffffff81319acd>] dev_hard_start_xmit+0x259/0x3ce
[ 1888.975951]  [<ffffffff81333d6b>] sch_direct_xmit+0x74/0x17d
[ 1888.975967]  [<ffffffff81313759>] ? spin_lock+0x9/0xb
[ 1888.975980]  [<ffffffff8131a0b1>] dev_queue_xmit+0x230/0x414
[ 1888.975995]  [<ffffffff8134877a>] ip_finish_output2+0x348/0x3aa
[ 1888.976008]  [<ffffffff81349029>] ip_finish_output+0x6c/0x71
[ 1888.976020]  [<ffffffff81349046>] NF_HOOK_COND.constprop.44+0x18/0x58
[ 1888.976036]  [<ffffffff8130d2f6>] ? skb_clone+0x8b/0x90
[ 1888.976048]  [<ffffffff8134a03a>] ip_mc_output+0x134/0x13c
[ 1888.976060]  [<ffffffff8134835a>] dst_output+0x18/0x1c
[ 1888.976072]  [<ffffffff81349a24>] ip_local_out+0x20/0x24
[ 1888.976084]  [<ffffffff8134a8cf>] ip_send_skb+0x16/0x3c
[ 1888.976098]  [<ffffffff8136bfba>] udp_send_skb+0x254/0x2b9
[ 1888.976112]  [<ffffffff8136c85e>] udp_sendmsg+0x5a8/0x7d4
[ 1888.976126]  [<ffffffff813483c3>] ? skb_dst_copy.isra.29+0x25/0x25
[ 1888.976139]  [<ffffffff81373e00>] ? rcu_read_unlock+0x44/0x5d
[ 1888.976157]  [<ffffffff81092ef9>] ? lock_release+0x1ab/0x200
[ 1888.976170]  [<ffffffff81373fbf>] inet_sendmsg+0x3f/0x68
[ 1888.976184]  [<ffffffff813022c6>] __sock_sendmsg_nosec+0x25/0x27
[ 1888.976196]  [<ffffffff813049f5>] sock_sendmsg+0x5f/0x80
[ 1888.976211]  [<ffffffff81304c2b>] __sys_sendmsg+0x215/0x2b6
[ 1888.976226]  [<ffffffff8106a423>] ? __srcu_read_unlock+0x4a/0x68
[ 1888.976259]  [<ffffffff8116e2f7>] ? fsnotify+0x499/0x4e4
[ 1888.976283]  [<ffffffff8116deeb>] ? fsnotify+0x8d/0x4e4
[ 1888.976318]  [<ffffffff811507f6>] ? fcheck_files+0x85/0xea
[ 1888.976332]  [<ffffffff81150ebb>] ? fget_light+0x38/0x99
[ 1888.976346]  [<ffffffff81305e20>] sys_sendmsg+0x42/0x60
[ 1888.976364]  [<ffffffff813f4c99>] system_call_fastpath+0x16/0x1b
[ 1888.976373] ---[ end trace 1a356222b0c6ad6a ]---

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/iface.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 40ff030..16ece80 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -294,7 +294,8 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
-	if ((sdata->vif.type != NL80211_IFTYPE_AP) ||
+	if ((sdata->vif.type != NL80211_IFTYPE_AP &&
+	     sdata->vif.type != NL80211_IFTYPE_MESH_POINT) ||
 	    !(sdata->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)) {
 		sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 		return 0;
-- 
1.7.10.4


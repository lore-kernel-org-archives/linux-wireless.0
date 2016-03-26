Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34767 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbcCZP1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2016 11:27:32 -0400
Received: by mail-qk0-f193.google.com with SMTP id u128so6684593qkh.1
        for <linux-wireless@vger.kernel.org>; Sat, 26 Mar 2016 08:27:32 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/2] mac80211: mesh: fix cleanup for mesh pathtable
Date: Sat, 26 Mar 2016 11:27:18 -0400
Message-Id: <1459006039-4493-1-git-send-email-me@bobcopeland.com> (sfid-20160326_162739_760635_E9E7DD25)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh path table needs to be around for the entire time the
interface is in mesh mode, as users can perform an mpath dump
at any time.  The existing path table lifetime is instead tied
to the mesh BSS which can cause crashes when different MBSSes
are joined in the context of a single interface, or when the
path table is dumped when no MBSS is joined.

Introduce a new function to perform the final teardown of the
interface and perform path table cleanup there.  We already
free the individual path elements when the leaving the mesh
so no additional cleanup is needed there.  This fixes the
following crash:

[   47.753026] BUG: unable to handle kernel paging request at fffffff0
[   47.753026] IP: [<c0239765>] kthread_data+0xa/0xe
[   47.753026] *pde = 00741067 *pte = 00000000
[   47.753026] Oops: 0000 [#4] PREEMPT
[   47.753026] Modules linked in: ppp_generic slhc 8021q garp mrp sch_fq_codel iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip_tables ath9k_htc ath5k 8139too ath10k_pci ath10k_core arc4 ath9k ath9k_common ath9k_hw mac80211 ath cfg80211 cpufreq_powersave br_netfilter bridge stp llc ipw usb_wwan sierra_net usbnet af_alg natsemi via_rhine mii iTCO_wdt iTCO_vendor_support gpio_ich sierra coretemp pcspkr i2c_i801 lpc_ich ata_generic ata_piix libata ide_pci_generic piix e1000e igb i2c_algo_bit ptp pps_core [last unloaded: 8139too]
[   47.753026] CPU: 0 PID: 12 Comm: kworker/u2:1 Tainted: G      D W       4.5.0-wt-V3 #6
[   47.753026] Hardware name: To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080016  11/07/2014
[   47.753026] task: f645a0c0 ti: f6462000 task.ti: f6462000
[   47.753026] EIP: 0060:[<c0239765>] EFLAGS: 00010002 CPU: 0
[   47.753026] EIP is at kthread_data+0xa/0xe
[   47.753026] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[   47.753026] ESI: f645a0c0 EDI: f645a2fc EBP: f6463a80 ESP: f6463a78
[   47.753026]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   47.753026] CR0: 8005003b CR2: 00000014 CR3: 353e5000 CR4: 00000690
[   47.753026] Stack:
[   47.753026]  c0236866 00000000 f6463aac c05768b4 00000009 f6463ba8 f6463ab0 c0247010
[   47.753026]  00000000 f645a0c0 f6464000 00000009 f6463ba8 f6463ab8 c0576eb2 f645a0c0
[   47.753026]  f6463aec c0228be4 c06335a4 f6463adc f6463ad0 c06c06d4 f6463ae4 c02471b0
[   47.753026] Call Trace:
[   47.753026]  [<c0236866>] ? wq_worker_sleeping+0xb/0x78
[   47.753026]  [<c05768b4>] __schedule+0xda/0x587
[   47.753026]  [<c0247010>] ? vprintk_default+0x12/0x14
[   47.753026]  [<c0576eb2>] schedule+0x72/0x89
[   47.753026]  [<c0228be4>] do_exit+0xb8/0x71d
[   47.753026]  [<c02471b0>] ? kmsg_dump+0xa9/0xae
[   47.753026]  [<c0203576>] oops_end+0x69/0x70
[   47.753026]  [<c021dcdb>] no_context+0x1bb/0x1c5
[   47.753026]  [<c021de1b>] __bad_area_nosemaphore+0x136/0x140
[   47.753026]  [<c021e2ef>] ? vmalloc_sync_all+0x19a/0x19a
[   47.753026]  [<c021de32>] bad_area_nosemaphore+0xd/0x10
[   47.753026]  [<c021e0a1>] __do_page_fault+0x26c/0x320
[   47.753026]  [<c021e2ef>] ? vmalloc_sync_all+0x19a/0x19a
[   47.753026]  [<c021e2fa>] do_page_fault+0xb/0xd
[   47.753026]  [<c05798f8>] error_code+0x58/0x60
[   47.753026]  [<c021e2ef>] ? vmalloc_sync_all+0x19a/0x19a
[   47.753026]  [<c0239765>] ? kthread_data+0xa/0xe
[   47.753026]  [<c0236866>] ? wq_worker_sleeping+0xb/0x78
[   47.753026]  [<c05768b4>] __schedule+0xda/0x587
[   47.753026]  [<c0247010>] ? vprintk_default+0x12/0x14
[   47.753026]  [<c0576eb2>] schedule+0x72/0x89
[   47.753026]  [<c0228be4>] do_exit+0xb8/0x71d
[   47.753026]  [<c02471b0>] ? kmsg_dump+0xa9/0xae
[   47.753026]  [<c0203576>] oops_end+0x69/0x70
[   47.753026]  [<c021dcdb>] no_context+0x1bb/0x1c5
[   47.753026]  [<c021de1b>] __bad_area_nosemaphore+0x136/0x140
[   47.753026]  [<c021e2ef>] ? vmalloc_sync_all+0x19a/0x19a
[   47.753026]  [<c021de32>] bad_area_nosemaphore+0xd/0x10
[   47.753026]  [<c021e0a1>] __do_page_fault+0x26c/0x320
[   47.753026]  [<c021e2ef>] ? vmalloc_sync_all+0x19a/0x19a
[   47.753026]  [<c021e2fa>] do_page_fault+0xb/0xd
[   47.753026]  [<c05798f8>] error_code+0x58/0x60
[   47.753026]  [<c021e2ef>] ? vmalloc_sync_all+0x19a/0x19a
[   47.753026]  [<c0239765>] ? kthread_data+0xa/0xe
[   47.753026]  [<c0236866>] ? wq_worker_sleeping+0xb/0x78
[   47.753026]  [<c05768b4>] __schedule+0xda/0x587
[   47.753026]  [<c0391e32>] ? put_io_context_active+0x6d/0x95
[   47.753026]  [<c0576eb2>] schedule+0x72/0x89
[   47.753026]  [<c02291f8>] do_exit+0x6cc/0x71d
[   47.753026]  [<c0203576>] oops_end+0x69/0x70
[   47.753026]  [<c021dcdb>] no_context+0x1bb/0x1c5
[   47.753026]  [<c021de1b>] __bad_area_nosemaphore+0x136/0x140
[   47.753026]  [<c021e2ef>] ? vmalloc_sync_all+0x19a/0x19a
[   47.753026]  [<c021de32>] bad_area_nosemaphore+0xd/0x10
[   47.753026]  [<c021e0a1>] __do_page_fault+0x26c/0x320
[   47.753026]  [<c03b9160>] ? debug_smp_processor_id+0x12/0x16
[   47.753026]  [<c02015e2>] ? __switch_to+0x24/0x40e
[   47.753026]  [<c021e2ef>] ? vmalloc_sync_all+0x19a/0x19a
[   47.753026]  [<c021e2fa>] do_page_fault+0xb/0xd
[   47.753026]  [<c05798f8>] error_code+0x58/0x60
[   47.753026]  [<c021e2ef>] ? vmalloc_sync_all+0x19a/0x19a
[   47.753026]  [<c03b59d2>] ? rhashtable_walk_init+0x5c/0x93
[   47.753026]  [<f9843221>] mesh_path_tbl_expire.isra.24+0x19/0x82 [mac80211]
[   47.753026]  [<f984408b>] mesh_path_expire+0x11/0x1f [mac80211]
[   47.753026]  [<f9842bb7>] ieee80211_mesh_work+0x73/0x1a9 [mac80211]
[   47.753026]  [<f98207d1>] ieee80211_iface_work+0x2ff/0x311 [mac80211]
[   47.753026]  [<c0235fa3>] process_one_work+0x14b/0x24e
[   47.753026]  [<c0236313>] worker_thread+0x249/0x343
[   47.753026]  [<c02360ca>] ? process_scheduled_works+0x24/0x24
[   47.753026]  [<c0239359>] kthread+0x9e/0xa3
[   47.753026]  [<c0578e50>] ret_from_kernel_thread+0x20/0x40
[   47.753026]  [<c02392bb>] ? kthread_parkme+0x18/0x18
[   47.753026] Code: 6b c0 85 c0 75 05 e8 fb 74 fc ff 89 f8 84 c0 75 08 8d 45 e8 e8 34 dd 33 00 83 c4 28 5b 5e 5f 5d c3 55 8b 80 10 02 00 00 89 e5 5d <8b> 40 f0 c3 55 b9 04 00 00 00 89 e5 52 8b 90 10 02 00 00 8d 45
[   47.753026] EIP: [<c0239765>] kthread_data+0xa/0xe SS:ESP 0068:f6463a78
[   47.753026] CR2: 00000000fffffff0
[   47.753026] ---[ end trace 867ca0bdd0767790 ]---

Fixes: 3b302ada7f0a ("mac80211: mesh: move path tables into if_mesh")
Reported-by: Fred Veldini <fred.veldini@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
Just to try to make it somewhat clear, there are a total of three outstanding
patches to fix bugs in my half-baked rhashtable conversion: these two, and
also "mac80211: mesh: fix crash in mesh_path_timer".

The other series of 5 patches, starting with:
"[PATCH 1/5] mac80211: mesh: handle failed alloc for rmc cache" -- are less
critical, with the possible exception of 1/5, but I've never seen that one
actually happen in the wild.

I don't believe these patchsets will conflict with each other, but do let me
know if I need to respin for something, or if we should drop the whole thing
and I should resend with patches applied.

 net/mac80211/iface.c | 2 +-
 net/mac80211/mesh.c  | 7 ++++++-
 net/mac80211/mesh.h  | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 453b4e741780..097ece8b5c02 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1093,7 +1093,7 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 	sdata->fragment_next = 0;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
-		mesh_rmc_free(sdata);
+		ieee80211_mesh_teardown_sdata(sdata);
 }
 
 static void ieee80211_uninit(struct net_device *dev)
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1a2aaf461e98..dcc1facc807c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -905,7 +905,6 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata);
 	mesh_path_flush_by_iface(sdata);
-	mesh_pathtbl_unregister(sdata);
 
 	/* free all potentially still buffered group-addressed frames */
 	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
@@ -1403,3 +1402,9 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 
 	sdata->vif.bss_conf.bssid = zero_addr;
 }
+
+void ieee80211_mesh_teardown_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	mesh_rmc_free(sdata);
+	mesh_pathtbl_unregister(sdata);
+}
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index f298987228c9..26b9ccbe1fce 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -219,6 +219,7 @@ void ieee80211s_init(void);
 void ieee80211s_update_metric(struct ieee80211_local *local,
 			      struct sta_info *sta, struct sk_buff *skb);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mesh_teardown_sdata(struct ieee80211_sub_if_data *sdata);
 int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
-- 
2.6.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50903 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3EHWIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 18:08:51 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Disable spectral scan code to fix crash on rmmod.
Date: Wed,  8 May 2013 15:08:28 -0700
Message-Id: <1368050908-7554-1-git-send-email-greearb@candelatech.com> (sfid-20130509_000856_487273_94F6DF62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

With CONFIG_ATH9K_DEBUGFS enabled, and slub memory poisoning
enabled, I see this crash on rmmod of ath9k.  I'm not sure how
to fix this properly, but in the meantime, this patch to disable
the spectral scan code works around the problem for me.

With memory poisoning and the verify_mem_not_deleted code
below added, the crash looks as follows...  The dentry
is not *always* freed at this point, probably because rcu
callbacks haven't completed.  You still get a crash soon
after, however.

Problem appears to be introduced by commit:

commit e93d083f42a126b5ad8137b5f0e8d6f900b332b8
Author: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Date:   Tue Jan 8 14:48:58 2013 +0100

    ath9k: add spectral scan feature

    Adds the spectral scan feature for ath9k. AR92xx and AR93xx chips
    are supported for now. The spectral scan is triggered by configuring
    a mode through a debugfs control file. Samples can be gathered via
    another relay debugfs file.

static int remove_buf_file_handler(struct dentry *dentry)
{
    printk("dentry: %p\n", dentry);
    verify_mem_not_deleted(dentry);
    debugfs_remove(dentry);

    return 0;
}

lec2010-ath9k-1 login: [   64.320480] rfs_chan_spec_scan: f7318000
[   64.325371] dentry: f2fbb8f8
[   64.328627] =============================================================================
[   64.329412] BUG dentry (Tainted: G         C  ): Object is on free-list
[   64.329412] -----------------------------------------------------------------------------
[   64.329412]
[   64.329412] Disabling lock debugging due to kernel taint
[   64.329412] INFO: Allocated in __d_alloc+0x22/0x140 age=42489 cpu=1 pid=337
[   64.329412]  __slab_alloc.clone.3+0x64e/0x6e0
[   64.329412]  kmem_cache_alloc+0x13a/0x150
[   64.329412]  __d_alloc+0x22/0x140
[   64.329412]  d_alloc+0x20/0x80
[   64.329412]  lookup_dcache+0x79/0xa0
[   64.383501]  __lookup_hash+0x22/0x40
[   64.383501]  lookup_one_len+0xe1/0x130
[   64.383501]  __create_file+0x6b/0x280
[   64.383501]  debugfs_create_file+0x2e/0x40
[   64.383501]  create_buf_file_handler+0x26/0x40 [ath9k]
[   64.383501]  relay_create_buf_file+0x89/0xb0
[   64.383501]  relay_open_buf+0x171/0x250
[   64.383501]  relay_open+0x142/0x230
[   64.383501]  ath9k_init_debug+0x34c/0x4b0 [ath9k]
[   64.383501]  ath9k_init_device+0x67e/0x9e0 [ath9k]
[   64.383501]  ath_pci_probe+0x1ff/0x2f0 [ath9k]
[   64.383501] INFO: Freed in __d_free+0x34/0x50 age=129 cpu=1 pid=2065
[   64.383501]  __slab_free+0x2eb/0x460
[   64.383501]  kmem_cache_free+0x1a4/0x1b0
[   64.383501]  __d_free+0x34/0x50
[   64.383501]  rcu_process_callbacks+0x1e6/0x5f0
[   64.383501]  __do_softirq+0xba/0x250
[   64.383501]  irq_exit+0xb5/0xc0
[   64.383501]  smp_apic_timer_interrupt+0x59/0x88
[   64.383501]  apic_timer_interrupt+0x39/0x40
[   64.383501]  __slab_free+0x2cd/0x460
[   64.383501]  kmem_cache_free+0x1a4/0x1b0
[   64.383501]  unlink_anon_vmas+0xf3/0x160
[   64.383501]  free_pgtables+0x89/0xf0
[   64.383501]  exit_mmap+0x84/0x130
[   64.383501]  mmput+0x57/0x100
[   64.383501]  flush_old_exec+0x2d4/0x690
[   64.383501]  load_elf_binary+0x24b/0x1620
[   64.383501] INFO: Slab 0xf6634760 objects=12 used=1 fp=0xf2fbb000 flags=0x40000081
[   64.383501] INFO: Object 0xf2fbb8f8 @offset=2296 fp=0xf2fbb7b0
[   64.383501]
[   64.383501] Bytes b4 f2fbb8e8: 01 00 00 00 11 08 00 00 20 67 fc ff 5a 5a 5a 5a  ........ g..ZZZZ
[   64.383501] Object f2fbb8f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   64.383501] Object f2fbb908: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   64.383501] Object f2fbb918: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   64.383501] Object f2fbb928: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   64.383501] Object f2fbb938: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   64.383501] Object f2fbb948: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   64.383501] Object f2fbb958: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   64.383501] Object f2fbb968: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   64.383501] Object f2fbb978: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   64.383501] Object f2fbb988: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5              kkkkkkkkkkk.
[   64.383501] Redzone f2fbb994: bb bb bb bb                                      ....
[   64.383501] Padding f2fbba3c: 5a 5a 5a 5a                                      ZZZZ
[   64.383501] Pid: 2064, comm: rmmod Tainted: G    B    C   3.9.1+ #6
[   64.383501] Call Trace:
[   64.383501]  [<c055549d>] print_trailer+0xdd/0x130
[   64.383501]  [<c055552c>] object_err+0x3c/0x50
[   64.383501]  [<c0556ffd>] verify_mem_not_deleted+0xed/0x160
[   64.383501]  [<f875c995>] remove_buf_file_handler+0x25/0x40 [ath9k]
[   64.383501]  [<c04e3088>] relay_remove_buf+0x18/0x30
[   64.383501]  [<c04e30fe>] relay_close_buf+0x2e/0x40
[   64.383501]  [<c04e3187>] relay_close+0x77/0xf0
[   64.383501]  [<f8749684>] ath9k_deinit_softc+0xb4/0xc0 [ath9k]
[   64.383501]  [<f87496d8>] ath9k_deinit_device+0x48/0x60 [ath9k]
[   64.383501]  [<f8759811>] ath_pci_remove+0x31/0x50 [ath9k]
[   64.383501]  [<c06dbff8>] pci_device_remove+0x38/0xc0
[   64.383501]  [<c079daa4>] __device_release_driver+0x64/0xc0
[   64.383501]  [<c079db97>] driver_detach+0x97/0xa0
[   64.383501]  [<c079cacc>] bus_remove_driver+0x6c/0xe0
[   64.383501]  [<c079c197>] ? bus_put+0x17/0x20
[   64.383501]  [<c079cae3>] ? bus_remove_driver+0x83/0xe0
[   64.383501]  [<c079e709>] driver_unregister+0x49/0x80
[   64.383501]  [<c06dc138>] pci_unregister_driver+0x18/0x80
[   64.383501]  [<f8759622>] ath_pci_exit+0x12/0x20 [ath9k]
[   64.383501]  [<f8762d30>] ath9k_exit+0x17/0x2e7 [ath9k]
[   64.383501]  [<c09e537d>] ? mutex_unlock+0xd/0x10
[   64.383501]  [<c04bd36c>] sys_delete_module+0x17c/0x250
[   64.383501]  [<c0540dc4>] ? do_munmap+0x244/0x2d0
[   64.383501]  [<c0540e96>] ? vm_munmap+0x46/0x60
[   64.383501]  [<c09e8dc4>] ? restore_all+0xf/0xf
[   64.383501]  [<c09ebf50>] ? __do_page_fault+0x4c0/0x4c0
[   64.383501]  [<c04b18e4>] ? trace_hardirqs_on_caller+0xf4/0x180
[   64.383501]  [<c09ef28d>] sysenter_do_call+0x12/0x38
[   64.889940] BUG: unable to handle kernel paging request at 6b6b6b8b
[   64.890530] IP: [<c063d0d6>] debugfs_remove+0x26/0x80
[   64.890530] *pdpt = 000000002f1dc001 *pde = 0000000000000000
[   64.890530] Oops: 0000 [#1] PREEMPT SMP
[   64.890530] Modules linked in: fuse macvlan pktgen nfsv3 nfs_acl nfsv4 auth_rpcgss nfs fscache lockdo
[   64.890530] Pid: 2064, comm: rmmod Tainted: G    B    C   3.9.1+ #6 To Be Filled By O.E.M. To Be Fil.
[   64.890530] EIP: 0060:[<c063d0d6>] EFLAGS: 00010202 CPU: 0
[   64.890530] EIP is at debugfs_remove+0x26/0x80
[   64.890530] EAX: f2fbb8f8 EBX: f2fbb8f8 ECX: 00000000 EDX: 00000000
[   64.890530] ESI: 6b6b6b6b EDI: 00000001 EBP: ef255e00 ESP: ef255df8
[   64.890530]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   64.890530] CR0: 8005003b CR2: 6b6b6b8b CR3: 2f238000 CR4: 000007e0
[   64.890530] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   64.890530] DR6: ffff0ff0 DR7: 00000400
[   64.890530] Process rmmod (pid: 2064, ti=ef254000 task=efa192b0 task.ti=ef254000)
[   64.890530] Stack:
[   64.890530]  f2fbb8f8 0000000a ef255e14 f875c99c f87695e4 f2fbb8f8 f11a0170 ef255e20
[   64.890530]  c04e3088 f11a0170 ef255e2c c04e30fe f7318000 ef255e4c c04e3187 00000286
[   64.890530]  00000004 00000286 f24d1e20 0000000a 00000001 ef255e68 f8749684 f87689d4
[   64.890530] Call Trace:
[   64.890530]  [<f875c99c>] remove_buf_file_handler+0x2c/0x40 [ath9k]
[   64.890530]  [<c04e3088>] relay_remove_buf+0x18/0x30
[   64.890530]  [<c04e30fe>] relay_close_buf+0x2e/0x40
[   64.890530]  [<c04e3187>] relay_close+0x77/0xf0
[   64.890530]  [<f8749684>] ath9k_deinit_softc+0xb4/0xc0 [ath9k]
[   64.890530]  [<f87496d8>] ath9k_deinit_device+0x48/0x60 [ath9k]
[   64.890530]  [<f8759811>] ath_pci_remove+0x31/0x50 [ath9k]
[   64.890530]  [<c06dbff8>] pci_device_remove+0x38/0xc0
[   64.890530]  [<c079daa4>] __device_release_driver+0x64/0xc0
[   64.890530]  [<c079db97>] driver_detach+0x97/0xa0
[   64.890530]  [<c079cacc>] bus_remove_driver+0x6c/0xe0
[   64.890530]  [<c079c197>] ? bus_put+0x17/0x20
[   64.890530]  [<c079cae3>] ? bus_remove_driver+0x83/0xe0
[   64.890530]  [<c079e709>] driver_unregister+0x49/0x80
[   64.890530]  [<c06dc138>] pci_unregister_driver+0x18/0x80
[   64.890530]  [<f8759622>] ath_pci_exit+0x12/0x20 [ath9k]
[   64.890530]  [<f8762d30>] ath9k_exit+0x17/0x2e7 [ath9k]
[   64.890530]  [<c09e537d>] ? mutex_unlock+0xd/0x10
[   64.890530]  [<c04bd36c>] sys_delete_module+0x17c/0x250
[   64.890530]  [<c0540dc4>] ? do_munmap+0x244/0x2d0
[   64.890530]  [<c0540e96>] ? vm_munmap+0x46/0x60
[   64.890530]  [<c09e8dc4>] ? restore_all+0xf/0xf
[   64.890530]  [<c09ebf50>] ? __do_page_fault+0x4c0/0x4c0
[   64.890530]  [<c04b18e4>] ? trace_hardirqs_on_caller+0xf4/0x180
[   64.890530]  [<c09ef28d>] sysenter_do_call+0x12/0x38
[   64.890530] Code: 90 8d 74 26 00 55 89 e5 83 ec 08 89 1c 24 89 74 24 04 3e 8d 74 26 00 85 c0 89 c3 72
[   64.890530] EIP: [<c063d0d6>] debugfs_remove+0x26/0x80 SS:ESP 0068:ef255df8
[   64.890530] CR2: 000000006b6b6b8b
[   65.403974] ---[ end trace 5de288532140fead ]---

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 ff3812c... b8f94fe... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 ee156e5... bf15c86... M	drivers/net/wireless/ath/ath9k/recv.c
 drivers/net/wireless/ath/ath9k/debug.c |    5 ++++-
 drivers/net/wireless/ath/ath9k/recv.c  |    4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index ff3812c..b8f94fe 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -970,6 +970,7 @@ static const struct file_operations fops_recv = {
 	.llseek = default_llseek,
 };
 
+#if 0
 static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
@@ -1252,7 +1253,7 @@ static struct rchan_callbacks rfs_spec_scan_cb = {
 	.create_buf_file = create_buf_file_handler,
 	.remove_buf_file = remove_buf_file_handler,
 };
-
+#endif
 
 static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
                                 size_t count, loff_t *ppos)
@@ -2071,6 +2072,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_base_eeprom);
 	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_modal_eeprom);
+#if 0
 	sc->rfs_chan_spec_scan = relay_open("spectral_scan",
 					    sc->debug.debugfs_phy,
 					    262144, 4, &rfs_spec_scan_cb,
@@ -2088,6 +2090,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("spectral_fft_period", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc,
 			    &fops_spectral_fft_period);
+#endif
 
 #ifdef CONFIG_ATH9K_MAC_DEBUG
 	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ee156e5..bf15c86 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1016,7 +1016,7 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 		rxs->flag &= ~RX_FLAG_DECRYPTED;
 }
 
-#ifdef CONFIG_ATH9K_DEBUGFS
+#if 0 /*def CONFIG_ATH9K_DEBUGFS */
 static s8 fix_rssi_inv_only(u8 rssi_val)
 {
 	if (rssi_val == 128)
@@ -1029,7 +1029,7 @@ static s8 fix_rssi_inv_only(u8 rssi_val)
 static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 			   struct ath_rx_status *rs, u64 tsf)
 {
-#ifdef CONFIG_ATH9K_DEBUGFS
+#if 0 /*def CONFIG_ATH9K_DEBUGFS*/
 	struct ath_hw *ah = sc->sc_ah;
 	u8 bins[SPECTRAL_HT20_NUM_BINS];
 	u8 *vdata = (u8 *)hdr;
-- 
1.7.3.4


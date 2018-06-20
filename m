Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41314 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754002AbeFTO42 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 10:56:28 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        kvalo@codeaurora.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Don't allow tx logic when state is not ON.
Date: Wed, 20 Jun 2018 07:56:23 -0700
Message-Id: <1529506583-20204-1-git-send-email-greearb@candelatech.com> (sfid-20180620_165637_764467_371699EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This is against the 4.16 kernel, likely applies to later kernels
as well.  Firmware is beta ath10k-ct firmware for 9984 NIC.  The
patch is not firmware or chipset specific.

When firmware crashes, packets can still be sent from the
mac80211 stack, and that can cause crashes in the ath10k
tx path.

After adding this patch, I saw cases where the tx path was
called in state ATH10K_STATE_RESTARTED.

I have not tested the tx_64 path, but assume it has similar
issues, so same patch was added to it.

Here is example of crash without the patch:

The line that crashes decodes as:

(gdb) l *(ath10k_htt_tx_32+0x18ba)
0x74a9a is in ath10k_htt_tx_32 (/home/greearb/git/linux-4.16.dev.y/drivers/net/wireless/ath/ath10k/htt_tx.c:1257).
1252				       sizeof(struct htt_msdu_ext_desc));
1253				frags = (struct htt_data_tx_desc_frag *)
1254					&ext_desc_t[msdu_id].frags;
1255				ext_desc = &ext_desc_t[msdu_id];
1256				frags[0].tword_addr.paddr_lo =
1257					__cpu_to_le32(skb_cb->paddr);
1258				frags[0].tword_addr.paddr_hi = 0;
1259				frags[0].tword_addr.len_16 = __cpu_to_le16(msdu->len);
1260
1261				frags_paddr =  htt->frag_desc.paddr +

ath10k_pci 0000:04:00.0: ATH10K_END
ath10k_pci 0000:04:00.0: firmware crashed! (guid 033040e0-a2e0-499c-b2a2-3e06832c649e)
ath10k_pci 0000:04:00.0: firmware register dump:
ath10k_pci 0000:04:00.0: [00]: 0x0000000A 0x00000000 0x00000000 0x00000000
... [snipped rest of crash dump for brevity] ...

ath10k_pci 0000:04:00.0: wmi unified ready event not received
ath10k_pci 0000:04:00.0: Could not init core: -110
==================================================================
BUG: KASAN: null-ptr-deref in ath10k_htt_tx_32+0x18ba/0x2b00 [ath10k_core]
Write of size 64 at addr 0000000000000000 by task kworker/u8:2/5115
==================================================================
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: memset_erms+0x9/0x10
PGD 0 P4D 0
Oops: 0002 [#1] PREEMPT SMP KASAN PTI
Modules linked in: ath10k_pci ath10k_core rpcsec_gss_krb5 nfsv4 nfs fscache nf_conntrack_netlink nf_conntrack nfnetlink nf_defrag_ipv4 libcrc32c vrf 8021q garp mrp stp llc fuse macvlan pktgen lm78 hwmon_vid iTCO_wdt iTCO_vendor_support coretemp intel_rapl x86_pkg_temp_thermal intel_powerclamp kvm_intel ath snd_hda_codec_hdmi kvm snd_hda_intel irqbypass mac80211 snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device cfg80211 snd_pcm i2c_i801 snd_timer snd shpchp soundcore mei_wdt intel_pch_thermal acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc sch_fq_codel serio_raw e1000e i915 igb hwmon dca i2c_algo_bit drm_kms_helper drm i2c_core video ipv6 crc_ccitt [last unloaded: ath10k_core]
CPU: 0 PID: 5115 Comm: kworker/u8:2 Tainted: G    B   W        4.16.15+ #19
Hardware name: _ _/, BIOS 5.11 08/26/2016
Workqueue: phy3 ieee80211_beacon_connection_loss_work [mac80211]
RIP: 0010:memset_erms+0x9/0x10
RSP: 0018:ffff8801489af828 EFLAGS: 00010292
RAX: ffff880146920000 RBX: ffff88014a08d040 RCX: 0000000000000040
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8801121f4fa8 R08: 0000000000000000 R09: 0000000000000000
R10: ffff8801489af630 R11: 1ffff10029135e88 R12: ffff8801121f44a0
R13: 0000000000000000 R14: 0000000000000000 R15: 00000000ffec0000
FS:  0000000000000000(0000) GS:ffff88014de00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000003a14005 CR4: 00000000003606f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ath10k_htt_tx_32+0x18ba/0x2b00 [ath10k_core]
 ? ath10k_htt_tx_free_msdu_id+0xc0/0xc0 [ath10k_core]
 ? invoke_tx_handlers_late+0x2340/0x2340 [mac80211]
 ath10k_mac_tx+0xd7c/0x1680 [ath10k_core]
 ath10k_mac_tx_push_txq+0x1a2/0x3e0 [ath10k_core]
 ath10k_mac_op_wake_tx_queue+0x2fa/0x4e0 [ath10k_core]
 ieee80211_queue_skb+0x7cf/0xfa0 [mac80211]
 ieee80211_tx+0x259/0x330 [mac80211]
 ? ieee80211_tx_prepare_skb+0x3f0/0x3f0 [mac80211]
 ? ieee80211_xmit+0x26b/0x520 [mac80211]
 __ieee80211_tx_skb_tid_band+0x1e6/0x290 [mac80211]
 ieee80211_send_nullfunc+0x223/0x3f0 [mac80211]
 ieee80211_mgd_probe_ap_send+0x1af/0x4b0 [mac80211]
 ieee80211_mgd_probe_ap.part.22+0x28d/0x380 [mac80211]
 process_one_work+0x5f7/0x14d0
 ? pwq_dec_nr_in_flight+0x2b0/0x2b0
 ? _raw_spin_unlock_irq+0x24/0x40
 worker_thread+0xdc/0x12d0
 ? rescuer_thread+0x12b0/0x12b0
 kthread+0x2cf/0x3c0
 ? kthread_delayed_work_timer_fn+0x1e0/0x1e0
 ret_from_fork+0x24/0x30
ce 48 b8 01 01 01 01 01
RIP: memset_erms+0x9/0x10 RSP: ffff8801489af828
CR2: 0000000000000000
---[ end trace 5e24737a5c492997 ]---
Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index fa134f4..709bb1d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1173,6 +1173,18 @@ static int ath10k_htt_tx_32(struct ath10k_htt *htt,
 	struct htt_msdu_ext_desc *ext_desc_t = NULL;
 	u32 peer_id = HTT_INVALID_PEERID;
 
+	if (ar->state != ATH10K_STATE_ON) {
+		static bool done_once = 0;
+		if (!done_once) {
+			done_once = true;
+			ath10k_err(ar, "Invalid state: %d in ath10k_htt_tx_32, warning will not be repeated.\n",
+				   ar->state);
+			WARN_ON(1);
+		}
+		res = -ENODEV;
+		goto err;
+	}
+
 	if (unlikely(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN))
 		freq = ar->scan.roc_freq;
 
@@ -1409,6 +1421,18 @@ static int ath10k_htt_tx_64(struct ath10k_htt *htt,
 	struct htt_msdu_ext_desc_64 *ext_desc = NULL;
 	struct htt_msdu_ext_desc_64 *ext_desc_t = NULL;
 
+	if (ar->state != ATH10K_STATE_ON) {
+		static bool done_once = 0;
+		if (!done_once) {
+			done_once = true;
+			ath10k_err(ar, "Invalid state: %d in ath10k_htt_tx_64, warning will not be repeated.\n",
+				   ar->state);
+			WARN_ON(1);
+		}
+		res = -ENODEV;
+		goto err;
+	}
+
 	spin_lock_bh(&htt->tx_lock);
 	res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
 	spin_unlock_bh(&htt->tx_lock);
-- 
2.4.11

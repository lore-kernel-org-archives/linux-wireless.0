Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40701 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbcFOSYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 14:24:39 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  ensure info->control.vif is set for queued pkts.
Date: Wed, 15 Jun 2016 11:24:33 -0700
Message-Id: <1466015073-8418-1-git-send-email-greearb@candelatech.com> (sfid-20160615_202444_211642_F3AD199A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When driving ath10k with a modified pktgen, we see excessive amounts
of these warnings:

Jun  6 13:47:53 localhost kernel: WARNING: CPU: 1 PID: 1186 at /home/greearb/git/linux-4.4.dev.y/net/mac80211/tx.c:3
125 ieee80211_tx_pending+0x9d/0x19e [mac80211]()
Jun  6 13:47:53 localhost kernel: Modules linked in: nf_conntrack_netlink nfnetlink nf_conntrack_ipv4 iptable_raw xt
_CT nf_conntrack nf_defrag_ipv4 8021q garp mrp stp llc bnep bluetooth fuse macvlan wanlink(O) pktgen ip6table_filter
 ip6_tables ebtable_nat ebtables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ath10k_pci ath10k_co
re snd_hda_intel snd_hda_codec coretemp hwmon intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp kvm_intel sn
d_hda_core ath iTCO_wdt iTCO_vendor_support mac80211 kvm cfg80211 snd_hwdep e1000e snd_seq cdc_acm snd_seq_device sn
d_pcm irqbypass serio_raw pcspkr ptp i2c_i801 pps_core snd_timer snd soundcore 8250_fintek shpchp fjes lpc_ich tpm_t
is tpm uinput ipv6 i915 i2c_algo_bit drm_kms_helper drm i2c_core video [last unloaded: nfnetlink]
Jun  6 13:47:53 localhost kernel: CPU: 1 PID: 1186 Comm: kpktgend_1 Tainted: G        W  O    4.4.11+ #50
Jun  6 13:47:53 localhost kernel: Hardware name: To be filled by O.E.M. To be filled by O.E.M./ChiefRiver, BIOS 4.6.
5 06/07/2013
Jun  6 13:47:53 localhost kernel: 0000000000000000 ffff88021e243e68 ffffffff81340d35 0000000000000000
Jun  6 13:47:53 localhost kernel: 0000000000000009 ffff88021e243ea0 ffffffff810e
a46e ffffffffa0b1cb0e
Jun  6 13:47:53 localhost kernel: ffff880213a41600 ffff880213a406e0 ffff8800c8ac1700 ffff88021e243ed8
Jun  6 13:47:53 localhost kernel: Call Trace:
Jun  6 13:47:53 localhost kernel: <IRQ> [<ffffffff81340d35>] dump_stack+0x63/0x7f
Jun  6 13:47:53 localhost kernel: [<ffffffff810ea46e>] warn_slowpath_common+0x94/0xad
Jun  6 13:47:53 localhost kernel: [<ffffffffa0b1cb0e>] ? ieee80211_tx_pending+0x9d/0x19e [mac80211]
Jun  6 13:47:53 localhost kernel: [<ffffffff810ea52b>] warn_slowpath_null+0x15/0x17
Jun  6 13:47:53 localhost kernel: [<ffffffffa0b1cb0e>] ieee80211_tx_pending+0x9d/0x19e [mac80211]
Jun  6 13:47:53 localhost kernel: [<ffffffff810edf42>] tasklet_action+0xae/0xbf
Jun  6 13:47:53 localhost kernel: [<ffffffff810ed833>] __do_softirq+0x109/0x26d
Jun  6 13:47:53 localhost kernel: [<ffffffff811370ec>] ? rcu_irq_exit+0x3d/0x40
Jun  6 13:47:53 localhost kernel: [<ffffffff816a826c>] do_softirq_own_stack+0x1c/0x30
Jun  6 13:47:53 localhost kernel: <EOI> [<ffffffff810ed9fc>] do_softirq+0x30/0x3b
Jun  6 13:47:53 localhost kernel: [<ffffffff810eda70>] __local_bh_enable_ip+0x69/0x83
Jun  6 13:47:53 localhost kernel: [<ffffffffa123bd24>] pktgen_thread_worker+0x1399/0x1f26 [pktgen]
Jun  6 13:47:53 localhost kernel: [<ffffffff816a37a6>] ? __schedule+0x3c1/0x585
Jun  6 13:47:53 localhost kernel: [<ffffffff8111b55e>] ? finish_wait+0x5d/0x5d
Jun  6 13:47:53 localhost kernel: [<ffffffffa123a98b>] ? pktgen_rem_all_ifs+0x6a/0x6a [pktgen]
Jun  6 13:47:53 localhost kernel: [<ffffffff81102428>] kthread+0xa0/0xa8
Jun  6 13:47:53 localhost kernel: [<ffffffff81102388>] ? kthread_parkme+0x1f/0x1f
Jun  6 13:47:53 localhost kernel: [<ffffffff816a68cf>] ret_from_fork+0x3f/0x70
Jun  6 13:47:53 localhost kernel: [<ffffffff81102388>] ? kthread_parkme+0x1f/0x1f
Jun  6 13:47:53 localhost kernel: ---[ end trace a5fa4429cf1b918b ]---
Jun  6 13:47:53 localhost kernel: ------------[ cut here ]------------

I think the problem is that the logic that inserts the packet into the pending
queue is not setting the vif in the skb info struct.  This patch appears to
fix the problem.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Please review this well, looks like this code has been this way for a long time,
and this was reproduced and tested on a kernel with a lot of wifi, pktgen, and ath10k
patches.

 net/mac80211/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4309aff..f4231ab 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1368,6 +1368,8 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		}
 #endif
 
+		info->control.vif = vif;
+
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		if (local->queue_stop_reasons[q] ||
 		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
@@ -1432,8 +1434,6 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		}
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
-		info->control.vif = vif;
-
 		__skb_unlink(skb, skbs);
 		ieee80211_drv_tx(local, vif, sta, skb);
 	}
-- 
2.4.3


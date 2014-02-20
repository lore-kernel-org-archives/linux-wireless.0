Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31080 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbaBTHYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:24:25 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mac80211: check if the ps_buf skb queue hasn't been drained
Date: Thu, 20 Feb 2014 09:22:11 +0200
Message-Id: <1392880931-18468-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140220_082437_533484_950527F1)
In-Reply-To: <1392877117-17869-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1392877117-17869-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a race between the Tx path and the STA wake up
flow.
If a station is asleep, mac80211 buffers frames. When the
station wakes up, mac80211 will go over the buffered frames
list and send them.
Since these two flows can run concurrently, we can get to a
situation where the buffered frame list is emptied after the
Tx path already checked the PS state of the station: Tx path
thinks the STA is sleeping and adds the frame to the PS
buffer list while the list has already been emptied and
its buffers have been queued for transmission.
As a result, the newly added frame will not be send anytime
soon. Worse, it'll be sent out of order the next time the
station goes to sleep and wakes up.
In an extreme case, this could lead to a crash whose output
is pasted below.

Fix all this by syncing both path with sta_info->lock.
Both path are not fastpath since they handle PS situations.

This fixes:

BUG: unable to handle kernel
NULL pointer dereference at 000000b0
IP: [<ff6f1791>] ieee80211_report_used_skb+0x11/0x3e0 [mac80211]
*pde = 00000000
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
EIP: 0060:[<ff6f1791>] EFLAGS: 00210282 CPU: 1
EIP is at ieee80211_report_used_skb+0x11/0x3e0 [mac80211]
EAX: e5900da0 EBX: 00000000 ECX: 00000001 EDX: 00000000
ESI: e41d00c0 EDI: e5900da0 EBP: ebe458e4 ESP: ebe458b0
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 000000b0 CR3: 25a78000 CR4: 000407d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process iperf (pid: 3934, ti=ebe44000 task=e757c0b0 task.ti=ebe44000)
iwlwifi 0000:02:00.0: I iwl_pcie_enqueue_hcmd Sending command LQ_CMD (#4e), seq: 0x0903, 92 bytes at 3[3]:9
Stack:
 e403b32c ebe458c4 00200002 00200286 e403b338 ebe458cc c10960bb e5900da0
 ff76a6ec ebe458d8 00000000 e41d00c0 e5900da0 ebe458f0 ff6f1b75 e403b210
 ebe4598c ff723dc1 00000000 ff76a6ec e597c978 e403b758 00000002 00000002
Call Trace:
 [<c10960bb>] ? trace_hardirqs_on+0xb/0x10
 [<ff6f1b75>] ieee80211_free_txskb+0x15/0x20 [mac80211]
 [<ff723dc1>] invoke_tx_handlers+0x1661/0x1780 [mac80211]
 [<ff7243c7>] ? ieee80211_tx_prepare+0x4e7/0x550 [mac80211]
 [<ff7248a5>] ieee80211_tx+0x75/0x100 [mac80211]
 [<ff7249bf>] ieee80211_xmit+0x8f/0xc0 [mac80211]
 [<ff72550e>] ieee80211_subif_start_xmit+0x4fe/0xe20 [mac80211]
 [<ff725044>] ? ieee80211_subif_start_xmit+0x34/0xe20 [mac80211]
 [<c149ef70>] dev_hard_start_xmit+0x450/0x950
 [<c14b9a8a>] ? sch_direct_xmit+0x8a/0x250
 [<c14b9a8a>] ? sch_direct_xmit+0x8a/0x250
 [<c15afa5c>] ? _raw_spin_lock+0x6c/0x80
 [<c14b9aa9>] sch_direct_xmit+0xa9/0x250
 [<c149f5ab>] ? dev_queue_xmit+0x13b/0xca0
 [<c149f5ab>] ? dev_queue_xmit+0x13b/0xca0
 [<c14b9c9b>] __qdisc_run+0x4b/0x150
 [<c149f732>] dev_queue_xmit+0x2c2/0xca0

[snip]

Code: e8 65 56 bc fe 83 c4 04 5b 5d c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 57 56 53 83 ec 28 66 66 66 66 90 89 45 e8 <8b> 82 b0 00 00 00 84 c9 89 d3 89 ce c6 45 ef 00 89 45 e4 8b 42
EIP: [<ff6f1791>] ieee80211_report_used_skb+0x11/0x3e0 [mac80211] SS:ESP 0068:ebe458b0
CR2: 00000000000000b0

Change-Id: Ice239972e6aefc987b868ba6af2e275bcd15b48e
Cc: stable@vger.kernel.org
Reported-by: Yaara Rozenblum <yaara.rozenblum@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v2: rewrite commit message
    unlock only after the packet has been added to the ps_tx_buf list in Tx 
---
 net/mac80211/sta_info.c |  3 +++
 net/mac80211/tx.c       | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f9ce6ff..281ec1f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1099,6 +1099,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	skb_queue_head_init(&pending);
 
+	/* sync with ieee80211_tx_h_unicast_ps_buf */
+	spin_lock(&sta->lock);
 	/* Send all buffered frames to the station */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		int count = skb_queue_len(&pending), tmp;
@@ -1118,6 +1120,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	}
 
 	ieee80211_add_pending_skbs_fn(local, &pending, clear_sta_ps_flags, sta);
+	spin_unlock(&sta->lock);
 
 	/* This station just woke up and isn't aware of our SMPS state */
 	if (!ieee80211_smps_is_restrictive(sta->known_smps_mode,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 94e0102..8511821 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -478,6 +478,19 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		       sta->sta.addr, sta->sta.aid, ac);
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
 			purge_old_ps_buffers(tx->local);
+
+		/* sync with ieee80211_sta_ps_deliver_wakeup */
+		spin_lock(&sta->lock);
+		/*
+		 * STA woke up the meantime and all the frames on ps_tx_buf have
+		 * been queued to pending queue. No reordering can happen, go
+		 * ahead and Tx the packet.
+		 */
+		if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
+			spin_unlock(&sta->lock);
+			return TX_CONTINUE;
+		}
+
 		if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
 			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
 			ps_dbg(tx->sdata,
@@ -492,6 +505,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 		info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
 		skb_queue_tail(&sta->ps_tx_buf[ac], tx->skb);
+		spin_unlock(&sta->lock);
 
 		if (!timer_pending(&local->sta_cleanup))
 			mod_timer(&local->sta_cleanup,
-- 
1.8.3.2


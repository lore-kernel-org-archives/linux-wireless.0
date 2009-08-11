Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44313 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbZHKUKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 16:10:33 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 13:10:35 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	<jords@shadowservices.biz>, <jackelectronics@hotmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>
Subject: [PATCH v2] mac80211: fix panic when splicing unprepared TIDs
Date: Tue, 11 Aug 2009 13:10:33 -0700
Message-ID: <1250021433-10153-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We splice skbs from the pending queue for a TID
onto the local pending queue when tearing down a
block ack request. This is not necessary unless we
actually have received a request to start a block ack
request (rate control, for example). If we never received
that request we should not be splicing the tid pending
queue as it would be null, causing a panic.

Not sure yet how exactly we allowed through a call when the
tid state does not have at least HT_ADDBA_REQUESTED_MSK set,
that will require some further review as it is not quite
obvious.

For more information see the bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=13922

This fixes this oops:

BUG: unable to handle kernel NULL pointer dereference at 00000030
IP: [<f8806c70>] ieee80211_agg_splice_packets+0x40/0xc0 [mac80211]
*pdpt = 0000000002d1e001 *pde = 0000000000000000
Thread overran stack, or stack corrupted
Oops: 0000 [#1] SMP
last sysfs file: /sys/module/aes_generic/initstate
Modules linked in: <bleh>

Pid: 0, comm: swapper Not tainted (2.6.31-rc5-wl #2) Dell DV051
EIP: 0060:[<f8806c70>] EFLAGS: 00010292 CPU: 0
EIP is at ieee80211_agg_splice_packets+0x40/0xc0 [mac80211]
EAX: 00000030 EBX: 0000004c ECX: 00000003 EDX: 00000000
ESI: c1c98000 EDI: f745a1c0 EBP: c076be58 ESP: c076be38
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c076a000 task=c0709160 task.ti=c076a000)
Stack: <bleh2>
Call Trace:
 [<f8806edb>] ? ieee80211_stop_tx_ba_cb+0xab/0x150 [mac80211]
 [<f8802f1e>] ? ieee80211_tasklet_handler+0xce/0x110 [mac80211]
 [<c04862ff>] ? net_rx_action+0xef/0x1d0
 [<c0149378>] ? tasklet_action+0x58/0xc0
 [<c014a0f2>] ? __do_softirq+0xc2/0x190
 [<c018eb48>] ? handle_IRQ_event+0x58/0x140
 [<c01205fe>] ? ack_apic_level+0x7e/0x270
 [<c014a1fd>] ? do_softirq+0x3d/0x40
 [<c014a345>] ? irq_exit+0x65/0x90
 [<c010a6af>] ? do_IRQ+0x4f/0xc0
 [<c014a35d>] ? irq_exit+0x7d/0x90
 [<c011d547>] ? smp_apic_timer_interrupt+0x57/0x90
 [<c01094a9>] ? common_interrupt+0x29/0x30
 [<c010fd9e>] ? mwait_idle+0xbe/0x100
 [<c0107e42>] ? cpu_idle+0x52/0x90
 [<c054b1a5>] ? rest_init+0x55/0x60
 [<c077492d>] ? start_kernel+0x315/0x37d
 [<c07743ce>] ? unknown_bootoption+0x0/0x1f9
 [<c0774099>] ? i386_start_kernel+0x79/0x81
Code: <bleh3>
EIP: [<f8806c70>] ieee80211_agg_splice_packets+0x40/0xc0 [mac80211] SS:ESP 0068:c076be38
CR2: 0000000000000030

Cc: stable@kernel.org
Testedy-by: Jack Lau <jackelectronics@hotmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

v2 adds the URL to the bugzilla entry.

 net/mac80211/agg-tx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 1958c7c..bd765f3 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -381,6 +381,14 @@ static void ieee80211_agg_splice_packets(struct ieee80211_local *local,
 		&local->hw, queue,
 		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
 
+	if (!(sta->ampdu_mlme.tid_state_tx[tid] & HT_ADDBA_REQUESTED_MSK))
+		return;
+
+	if (WARN(!sta->ampdu_mlme.tid_tx[tid],
+		 "TID %d gone but expected when splicing aggregates from"
+		 "the pending queue\n", tid))
+		return;
+
 	if (!skb_queue_empty(&sta->ampdu_mlme.tid_tx[tid]->pending)) {
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		/* copy over remaining packets */
-- 
1.6.3.3


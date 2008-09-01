Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39364 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYIAO21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2008 10:28:27 -0400
Date: Mon, 1 Sep 2008 19:58:20 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: [PATCH] ath9: Fix ath_rx_flush_tid() for IRQs disabled kernel
	warning message.
Message-ID: <20080901142820.GA6121@senthil-lnx.users.atheros.com> (sfid-20080901_162831_289084_6D2C560B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses an issue with the locking order. ath_rx_flush_tid()
uses spin_lock/unlock_bh when IRQs are disabled in sta_notify by mac80211.

As node clean up is still pending with ath9k and this problematic portion
of the code is expected to change anyway, thinking of a proper fix may not
be worthwhile. So having this interim fix helps the users to get rid of the
kernel warning message.

Pasted the kernel warning message for reference.

kernel: ath0: No ProbeResp from current AP 00:1b:11:60:7a:3d - assume out of range
kernel: ------------[ cut here ]------------
kernel: WARNING: at kernel/softirq.c:136 local_bh_enable+0x3c/0xab()
kernel: Pid: 1029, comm: ath9k Not tainted 2.6.27-rc4-wt-w1fi-wl
kernel:
kernel: Call Trace:
kernel:  [<ffffffff802278d8>] warn_on_slowpath+0x51/0x77
kernel:  [<ffffffff80224c51>] check_preempt_wakeup+0xf3/0x123
kernel:  [<ffffffff80239658>] autoremove_wake_function+0x9/0x2e
kernel:  [<ffffffff8022c281>] local_bh_enable+0x3c/0xab
kernel:  [<ffffffffa01ab75a>] ath_rx_node_cleanup+0x38/0x6e [ath9k]
kernel:  [<ffffffffa01b2280>] ath_node_detach+0x3b/0xb6 [ath9k]
kernel:  [<ffffffffa01ab09f>] ath9k_sta_notify+0x12b/0x165 [ath9k]
kernel:  [<ffffffff802366cf>] queue_work+0x1d/0x49
kernel:  [<ffffffffa018c3fc>] add_todo+0x70/0x99 [mac80211]
kernel:  [<ffffffffa017de76>] __sta_info_unlink+0x16b/0x19e [mac80211]
kernel:  [<ffffffffa017e6ed>] sta_info_unlink+0x18/0x43 [mac80211]
kernel:  [<ffffffffa0182732>] ieee80211_associated+0xaa/0x16d [mac80211]
kernel:  [<ffffffffa0184a1a>] ieee80211_sta_work+0x4fb/0x6b4 [mac80211]
kernel:  [<ffffffff80469c58>] thread_return+0x30/0xa9
kernel:  [<ffffffffa018451f>] ieee80211_sta_work+0x0/0x6b4 [mac80211]
kernel:  [<ffffffff802362c2>] run_workqueue+0xb1/0x17a
kernel:  [<ffffffff80236be9>] worker_thread+0xd0/0xdb
kernel:  [<ffffffff8023964f>] autoremove_wake_function+0x0/0x2e
kernel:  [<ffffffff80236b19>] worker_thread+0x0/0xdb
kernel:  [<ffffffff8023954a>] kthread+0x47/0x75
kernel:  [<ffffffff80223121>] schedule_tail+0x18/0x50
kernel:  [<ffffffff8020bc49>] child_rip+0xa/0x11
kernel:  [<ffffffff80239503>] kthread+0x0/0x75
kernel:  [<ffffffff8020bc3f>] child_rip+0x0/0x11
kernel:
kernel: ---[ end trace e9bb5da661055827 ]---

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 6e13c63..4982563 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -360,8 +360,9 @@ static void ath_rx_flush_tid(struct ath_softc *sc,
 	struct ath_arx_tid *rxtid, int drop)
 {
 	struct ath_rxbuf *rxbuf;
+	unsigned long flag;
 
-	spin_lock_bh(&rxtid->tidlock);
+	spin_lock_irqsave(&rxtid->tidlock, flag);
 	while (rxtid->baw_head != rxtid->baw_tail) {
 		rxbuf = rxtid->rxbuf + rxtid->baw_head;
 		if (!rxbuf->rx_wbuf) {
@@ -382,7 +383,7 @@ static void ath_rx_flush_tid(struct ath_softc *sc,
 		INCR(rxtid->baw_head, ATH_TID_MAX_BUFS);
 		INCR(rxtid->seq_next, IEEE80211_SEQ_MAX);
 	}
-	spin_unlock_bh(&rxtid->tidlock);
+	spin_unlock_irqrestore(&rxtid->tidlock, flag);
 }
 
 static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc,
-- 
1.5.5


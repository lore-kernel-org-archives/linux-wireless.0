Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56619 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZGYArf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 20:47:35 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: cancel xmit poll work at stop() callback
Date: Fri, 24 Jul 2009 20:47:33 -0400
Message-Id: <1248482853-17032-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
References: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We forgot to cancel this work at the stop() callback.

------------[ cut here ]------------
WARNING: at net/mac80211/util.c:511 ieee80211_queue_delayed_work+0x3a/0x40 [mac80211]()
Hardware name: 6460DWU
queueing ieee80211 work while going to suspend
Modules linked in: <-- snip -->
Pid: 5124, comm: phy0 Tainted: G        W  2.6.31-rc3-wl #4
Call Trace:
 [<ffffffffa03adcda>] ? ieee80211_queue_delayed_work+0x3a/0x40 [mac80211]
 [<ffffffff810552b8>] warn_slowpath_common+0x78/0xd0
 [<ffffffff81055394>] warn_slowpath_fmt+0x64/0x70
 [<ffffffff814ed2c9>] ? thread_return+0x3e/0x635
 [<ffffffffa03adcda>] ieee80211_queue_delayed_work+0x3a/0x40 [mac80211]
 [<ffffffffa0297690>] ath_tx_complete_poll_work+0xc0/0x100 [ath9k]
 [<ffffffffa02975d0>] ? ath_tx_complete_poll_work+0x0/0x100 [ath9k]
 [<ffffffff81069b68>] worker_thread+0x178/0x260
 [<ffffffff8106ecc0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff810699f0>] ? worker_thread+0x0/0x260
 [<ffffffff8106e89e>] kthread+0x9e/0xb0
 [<ffffffff8101302a>] child_rip+0xa/0x20
 [<ffffffff8106e800>] ? kthread+0x0/0xb0
 [<ffffffff81013020>] ? child_rip+0x0/0x20

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3eb3032..fff89cc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2100,6 +2100,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&sc->mutex);
 
+	cancel_delayed_work_sync(&sc->tx_complete_work);
+
 	if (ath9k_wiphy_started(sc)) {
 		mutex_unlock(&sc->mutex);
 		return; /* another wiphy still in use */
-- 
1.6.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:11988 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab1EFPNV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 11:13:21 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 08:12:53 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Vasanth.Thiagarajan@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: Fix a warning due to a queued work during S3 state
Date: Fri, 6 May 2011 20:43:11 +0530
Message-ID: <1304694791-4238-1-git-send-email-mshajakhan@atheros.com> (sfid-20110506_171328_434243_C3B36171)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

during suspend/S3 state drv_flush is called from mac80211 irrespective of
interface count. In ath9k we queue a work in ath9k_flush which we expect
to be cancelled in the drv_stop call back. during suspend process mac80211
calls drv_stop only when the interface count(local->count) is non-zero.
unfortunately when the network manager is enabled, drv_flush is called
while drv_stop is not called as local->count reaches '0'.
	So fix this by simply checking for the device presence in the
drv_flush call back in the driver before queueing work or anything else.
this patch fixes the following WARNING

	Call Trace:
	[<c014c6e2>] warn_slowpath_common+0x72/0xa0
	[<fc133f99>] ? ieee80211_can_queue_work+0x39/0x50 [mac80211]
	[<fc133f99>] ? ieee80211_can_queue_work+0x39/0x50 [mac80211]
	[<c014c75b>] warn_slowpath_fmt+0x2b/0x30
	[<fc133f99>] ieee80211_can_queue_work+0x39/0x50 [mac80211]
	[<fc134ed1>] ieee80211_queue_delayed_work+0x21/0x50 [mac80211]
	[<fc1e5b22>] ath_tx_complete_poll_work+0xb2/0x100 [ath9k]
	[<c016399e>] run_workqueue+0x8e/0x150
	[<fc1e5a70>] ? ath_tx_complete_poll_work+0x0/0x100 [ath9k]
	[<c0163ae4>] worker_thread+0x84/0xe0
	[<c0167a60>] ? autoremove_wake_function+0x0/0x50
	[<c0163a60>] ? worker_thread+0x0/0xe0
	[<c01677d4>] kthread+0x74/0x80
	[<c0167760>] ? kthread+0x0/0x80
	[<c0104087>] kernel_thread_helper+0x7/0x10
---[ end trace 2aff81010df9215b ]---

Cc: stable@kernel.org [2.6.39+]
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3de115d..4691bf3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2256,6 +2256,8 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	int timeout = 200; /* ms */
 	int i, j;
 	bool drain_txq;
@@ -2263,6 +2265,12 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 	mutex_lock(&sc->mutex);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 
+	if (sc->sc_flags & SC_OP_INVALID) {
+		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
+		mutex_unlock(&sc->mutex);
+		return;
+	}
+
 	if (drop)
 		timeout = 1;
 
-- 
1.7.0.4


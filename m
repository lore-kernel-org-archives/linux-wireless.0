Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:63878 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaBJLrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:47:45 -0500
Received: by mail-we0-f169.google.com with SMTP id t61so4185799wes.14
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:47:44 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/18] wlcore: cancel Tx watchdog on suspend and rearm on first Tx after
Date: Mon, 10 Feb 2014 13:47:18 +0200
Message-Id: <1392032854-28126-3-git-send-email-eliad@wizery.com> (sfid-20140210_124750_897284_424ED6D5)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Sometimes a tx_flush during suspend fails, but the FW manages to flush
out the packets during the time when the host is supsended. Cancel
the Tx-watchdog on suspend to not cause a spurious recovery on resume
for that case. Set a flag to reinit the watchdog on the first Tx after
resume, so we'll still recover if the FW is not empty and there's
indeed a problem.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c     | 13 +++++++++++++
 drivers/net/wireless/ti/wlcore/tx.c       |  9 +++++++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index da268e8..1e19196 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1767,6 +1767,12 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	flush_work(&wl->tx_work);
 	flush_delayed_work(&wl->elp_work);
 
+	/*
+	 * Cancel the watchdog even if above tx_flush failed. We will detect
+	 * it on resume anyway.
+	 */
+	cancel_delayed_work(&wl->tx_watchdog_work);
+
 	return 0;
 }
 
@@ -1824,6 +1830,13 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 
 out:
 	wl->wow_enabled = false;
+
+	/*
+	 * Set a flag to re-init the watchdog on the first Tx after resume.
+	 * That way we avoid possible conditions where Tx-complete interrupts
+	 * fail to arrive and we perform a spurious recovery.
+	 */
+	set_bit(WL1271_FLAG_REINIT_TX_WDOG, &wl->flags);
 	mutex_unlock(&wl->mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 87cd707..ca886ef 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -234,8 +234,13 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		wl->tx_blocks_available -= total_blocks;
 		wl->tx_allocated_blocks += total_blocks;
 
-		/* If the FW was empty before, arm the Tx watchdog */
-		if (wl->tx_allocated_blocks == total_blocks)
+		/*
+		 * If the FW was empty before, arm the Tx watchdog. Also do
+		 * this on the first Tx after resume, as we always cancel the
+		 * watchdog on suspend.
+		 */
+		if (wl->tx_allocated_blocks == total_blocks ||
+		    test_and_clear_bit(WL1271_FLAG_REINIT_TX_WDOG, &wl->flags))
 			wl12xx_rearm_tx_watchdog_locked(wl);
 
 		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index ce7261c..3815332 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -240,6 +240,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_VIF_CHANGE_IN_PROGRESS,
 	WL1271_FLAG_INTENDED_FW_RECOVERY,
 	WL1271_FLAG_IO_FAILED,
+	WL1271_FLAG_REINIT_TX_WDOG,
 };
 
 enum wl12xx_vif_flags {
-- 
1.8.5.2.229.g4448466.dirty


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57608 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762164Ab0J2Xfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 19:35:41 -0400
Received: by bwz11 with SMTP id 11so3037813bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 16:35:40 -0700 (PDT)
Message-Id: <3034db80d4c40e6f77e3b106ae3c4964bea12eb8.1288393804.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1288393804.git.chunkeey@googlemail.com>
References: <cover.1288393804.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 29 Oct 2010 23:26:13 +0200
Subject: [PATCH 4/6] carl9170: fix spurious restart due to high latency
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX Stress tests of unidirectional bulk traffic with
bitrates of up to 220Mbit/s have revealed that the
fatal-event recovery logic [which was solely triggered
by an out-of-rx-buffer situation] is too aggressive.

The new method now "pings" the device and then
decides - based on the response - whenever
a restart is needed or not.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    3 ++-
 drivers/net/wireless/ath/carl9170/main.c     |   17 +++++++++++++++++
 drivers/net/wireless/ath/carl9170/usb.c      |    2 +-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 6cf0c9e..f1212ba 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -215,7 +215,7 @@ enum carl9170_restart_reasons {
 	CARL9170_RR_TOO_MANY_FIRMWARE_ERRORS,
 	CARL9170_RR_WATCHDOG,
 	CARL9170_RR_STUCK_TX,
-	CARL9170_RR_SLOW_SYSTEM,
+	CARL9170_RR_UNRESPONSIVE_DEVICE,
 	CARL9170_RR_COMMAND_TIMEOUT,
 	CARL9170_RR_TOO_MANY_PHY_ERRORS,
 	CARL9170_RR_LOST_RSP,
@@ -287,6 +287,7 @@ struct ar9170 {
 
 	/* reset / stuck frames/queue detection */
 	struct work_struct restart_work;
+	struct work_struct ping_work;
 	unsigned int restart_counter;
 	unsigned long queue_stop_timeout[__AR9170_NUM_TXQ];
 	unsigned long max_queue_stop_timeout[__AR9170_NUM_TXQ];
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index d56f440..b997844 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -428,6 +428,7 @@ static void carl9170_cancel_worker(struct ar9170 *ar)
 	cancel_delayed_work_sync(&ar->led_work);
 #endif /* CONFIG_CARL9170_LEDS */
 	cancel_work_sync(&ar->ps_work);
+	cancel_work_sync(&ar->ping_work);
 	cancel_work_sync(&ar->ampdu_work);
 }
 
@@ -533,6 +534,21 @@ void carl9170_restart(struct ar9170 *ar, const enum carl9170_restart_reasons r)
 	 */
 }
 
+static void carl9170_ping_work(struct work_struct *work)
+{
+	struct ar9170 *ar = container_of(work, struct ar9170, ping_work);
+	int err;
+
+	if (!IS_STARTED(ar))
+		return;
+
+	mutex_lock(&ar->mutex);
+	err = carl9170_echo_test(ar, 0xdeadbeef);
+	if (err)
+		carl9170_restart(ar, CARL9170_RR_UNRESPONSIVE_DEVICE);
+	mutex_unlock(&ar->mutex);
+}
+
 static int carl9170_init_interface(struct ar9170 *ar,
 				   struct ieee80211_vif *vif)
 {
@@ -1614,6 +1630,7 @@ void *carl9170_alloc(size_t priv_size)
 		skb_queue_head_init(&ar->tx_pending[i]);
 	}
 	INIT_WORK(&ar->ps_work, carl9170_ps_work);
+	INIT_WORK(&ar->ping_work, carl9170_ping_work);
 	INIT_WORK(&ar->restart_work, carl9170_restart_work);
 	INIT_WORK(&ar->ampdu_work, carl9170_ampdu_work);
 	INIT_DELAYED_WORK(&ar->tx_janitor, carl9170_tx_janitor);
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index d8607f4..ddf5373 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -431,7 +431,7 @@ static void carl9170_usb_rx_complete(struct urb *urb)
 			 * device.
 			 */
 
-			carl9170_restart(ar, CARL9170_RR_SLOW_SYSTEM);
+			ieee80211_queue_work(ar->hw, &ar->ping_work);
 		}
 	} else {
 		/*
-- 
1.7.2.3


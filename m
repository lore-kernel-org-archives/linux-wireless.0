Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:37749 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab2I0Kiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:46 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 31/31] wlcore: protect wlcore_op_set_key with mutex
Date: Thu, 27 Sep 2012 13:38:09 +0300
Message-Id: <1348742289-6587-32-git-send-email-luca@coelho.fi> (sfid-20120927_123913_384458_5389CB71)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

wlcore_op_set_key() calls wl18xx_set_key(),
which in turn executes some of his function
calls without acquiring wl->mutex and making
sure the fw is awake.

Adding mutex_lock()/ps_elp_wakeup() calls is
not enough, as wl18xx_set_key() calls
wl1271_tx_flush() which can't be called while
the mutex is taken.

Add the required calls to wlcore_op_set_key,
but limit the queues_stop and flushing
to the only encryption types in which
a spare block might be needed (GEM and TKIP).

[Arik - move state != ON check]

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl18xx/main.c |    8 ----
 drivers/net/wireless/ti/wlcore/main.c |   68 +++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 9e3e10a..a39682a 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1252,13 +1252,6 @@ static int wl18xx_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 	if (!change_spare)
 		return wlcore_set_key(wl, cmd, vif, sta, key_conf);
 
-	/*
-	 * stop the queues and flush to ensure the next packets are
-	 * in sync with FW spare block accounting
-	 */
-	wlcore_stop_queues(wl, WLCORE_QUEUE_STOP_REASON_SPARE_BLK);
-	wl1271_tx_flush(wl);
-
 	ret = wlcore_set_key(wl, cmd, vif, sta, key_conf);
 	if (ret < 0)
 		goto out;
@@ -1281,7 +1274,6 @@ static int wl18xx_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 	}
 
 out:
-	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_SPARE_BLK);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6ada018..25530c8 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3063,8 +3063,45 @@ static int wlcore_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			     struct ieee80211_key_conf *key_conf)
 {
 	struct wl1271 *wl = hw->priv;
+	int ret;
+	bool might_change_spare =
+		key_conf->cipher == WL1271_CIPHER_SUITE_GEM ||
+		key_conf->cipher == WLAN_CIPHER_SUITE_TKIP;
+
+	if (might_change_spare) {
+		/*
+		 * stop the queues and flush to ensure the next packets are
+		 * in sync with FW spare block accounting
+		 */
+		mutex_lock(&wl->mutex);
+		wlcore_stop_queues(wl, WLCORE_QUEUE_STOP_REASON_SPARE_BLK);
+		mutex_unlock(&wl->mutex);
+
+		wl1271_tx_flush(wl);
+	}
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+		ret = -EAGAIN;
+		goto out_wake_queues;
+	}
 
-	return wlcore_hw_set_key(wl, cmd, vif, sta, key_conf);
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_wake_queues;
+
+	ret = wlcore_hw_set_key(wl, cmd, vif, sta, key_conf);
+
+	wl1271_ps_elp_sleep(wl);
+
+out_wake_queues:
+	if (might_change_spare)
+		wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_SPARE_BLK);
+
+	mutex_unlock(&wl->mutex);
+
+	return ret;
 }
 
 int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
@@ -3086,17 +3123,6 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 		     key_conf->keylen, key_conf->flags);
 	wl1271_dump(DEBUG_CRYPT, "KEY: ", key_conf->key, key_conf->keylen);
 
-	mutex_lock(&wl->mutex);
-
-	if (unlikely(wl->state != WLCORE_STATE_ON)) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out_unlock;
-
 	switch (key_conf->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
@@ -3126,8 +3152,7 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 	default:
 		wl1271_error("Unknown key algo 0x%x", key_conf->cipher);
 
-		ret = -EOPNOTSUPP;
-		goto out_sleep;
+		return -EOPNOTSUPP;
 	}
 
 	switch (cmd) {
@@ -3138,7 +3163,7 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 				 tx_seq_32, tx_seq_16, sta);
 		if (ret < 0) {
 			wl1271_error("Could not add or replace key");
-			goto out_sleep;
+			return ret;
 		}
 
 		/*
@@ -3152,7 +3177,7 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 			ret = wl1271_cmd_build_arp_rsp(wl, wlvif);
 			if (ret < 0) {
 				wl1271_warning("build arp rsp failed: %d", ret);
-				goto out_sleep;
+				return ret;
 			}
 		}
 		break;
@@ -3164,22 +3189,15 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 				     0, 0, sta);
 		if (ret < 0) {
 			wl1271_error("Could not remove key");
-			goto out_sleep;
+			return ret;
 		}
 		break;
 
 	default:
 		wl1271_error("Unsupported key cmd 0x%x", cmd);
-		ret = -EOPNOTSUPP;
-		break;
+		return -EOPNOTSUPP;
 	}
 
-out_sleep:
-	wl1271_ps_elp_sleep(wl);
-
-out_unlock:
-	mutex_unlock(&wl->mutex);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(wlcore_set_key);
-- 
1.7.10.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33045 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab0DIIIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 04:08:01 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 4/5] wl1271: Go to ELP in idle
Date: Fri,  9 Apr 2010 11:07:29 +0300
Message-Id: <1270800450-8167-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
References: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Allow the wl1271 go to ELP mode also in idle. This will reduce current
consumption remarkably in idle mode (~12mA -> ~0.2mA)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 +++-
 drivers/net/wireless/wl12xx/wl1271_ps.c   |    6 ++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index a29969e..7894600 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -374,6 +374,7 @@ struct wl1271 {
 #define WL1271_FLAG_PSM_REQUESTED      (8)
 #define WL1271_FLAG_IRQ_PENDING        (9)
 #define WL1271_FLAG_IRQ_RUNNING       (10)
+#define WL1271_FLAG_IDLE              (11)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 4adc516..5517141 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1272,7 +1272,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl1271_acx_keep_alive_config(
 				wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
 				ACX_KEEP_ALIVE_TPL_INVALID);
-		}
+			set_bit(WL1271_FLAG_IDLE, &wl->flags);
+		} else
+			clear_bit(WL1271_FLAG_IDLE, &wl->flags);
 	}
 
 	if (conf->flags & IEEE80211_CONF_PS &&
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index 5a04482..a5e60e0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -40,7 +40,8 @@ void wl1271_elp_work(struct work_struct *work)
 	mutex_lock(&wl->mutex);
 
 	if (test_bit(WL1271_FLAG_IN_ELP, &wl->flags) ||
-	    !test_bit(WL1271_FLAG_PSM, &wl->flags))
+	    (!test_bit(WL1271_FLAG_PSM, &wl->flags) &&
+	     !test_bit(WL1271_FLAG_IDLE, &wl->flags)))
 		goto out;
 
 	wl1271_debug(DEBUG_PSM, "chip to elp");
@@ -56,7 +57,8 @@ out:
 /* Routines to toggle sleep mode while in ELP */
 void wl1271_ps_elp_sleep(struct wl1271 *wl)
 {
-	if (test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+	if (test_bit(WL1271_FLAG_PSM, &wl->flags) ||
+	    test_bit(WL1271_FLAG_IDLE, &wl->flags)) {
 		cancel_delayed_work(&wl->elp_work);
 		ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
 					msecs_to_jiffies(ELP_ENTRY_DELAY));
-- 
1.6.3.3


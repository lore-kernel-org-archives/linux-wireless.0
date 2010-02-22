Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22558 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab0BVGlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:32 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/22] wl1271: Update TX packet life time handling with higher resolution time
Date: Mon, 22 Feb 2010 08:38:38 +0200
Message-Id: <1266820722-20202-19-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses a higher precision timer to synchronize with the firmware
clock. Improved precision is needed as on some platforms a jiffy may be up to
tens of milliseconds, and the required precision is closer to TU's.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 ++++--
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    7 +++++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 457ce72..41de47c 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -404,7 +404,7 @@ struct wl1271 {
 	u32 tx_packets_count;
 
 	/* Time-offset between host and chipset clocks */
-	int time_offset;
+	s64 time_offset;
 
 	/* Session counter for the chipset */
 	int session_counter;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 9f74168..4c4d22a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -374,6 +374,7 @@ static void wl1271_power_on(struct wl1271 *wl)
 static void wl1271_fw_status(struct wl1271 *wl,
 			     struct wl1271_fw_status *status)
 {
+	struct timespec ts;
 	u32 total = 0;
 	int i;
 
@@ -402,8 +403,9 @@ static void wl1271_fw_status(struct wl1271 *wl,
 		ieee80211_queue_work(wl->hw, &wl->tx_work);
 
 	/* update the host-chipset time offset */
-	wl->time_offset = jiffies_to_usecs(jiffies) -
-		le32_to_cpu(status->fw_localtime);
+	getnstimeofday(&ts);
+	wl->time_offset = (timespec_to_ns(&ts) >> 10) -
+		(s64)le32_to_cpu(status->fw_localtime);
 }
 
 #define WL1271_IRQ_MAX_LOOPS 10
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 7926471..a32d301 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -86,8 +86,10 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra)
 static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 			      u32 extra, struct ieee80211_tx_info *control)
 {
+	struct timespec ts;
 	struct wl1271_tx_hw_descr *desc;
 	int pad, ac;
+	s64 hosttime;
 	u16 tx_attr;
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
@@ -101,8 +103,9 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	}
 
 	/* configure packet life time */
-	desc->start_time = cpu_to_le32(jiffies_to_usecs(jiffies) -
-				       wl->time_offset);
+	getnstimeofday(&ts);
+	hosttime = (timespec_to_ns(&ts) >> 10);
+	desc->start_time = cpu_to_le32(hosttime - wl->time_offset);
 	desc->life_time = cpu_to_le16(TX_HW_MGMT_PKT_LIFETIME_TU);
 
 	/* configure the tx attributes */
-- 
1.6.3.3


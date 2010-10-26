Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:39274 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab0JZLYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 07:24:54 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9QBOYtu012409
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 14:24:52 +0300
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wl1271: Check interface state in op_* functions
Date: Tue, 26 Oct 2010 14:24:39 +0300
Message-Id: <1288092279-31272-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Check the state of the interface on op_* function so we don't try to access
the hardware in when its off.

The mac80211 may call these in some corner cases related, for instance, to
the hardware recovery procedure. These accesses cause a kernel crash on at
least some SDIO devices, because the bus is not properly claimed in that
scenario.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 20027f4..8d56ae9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1344,8 +1344,10 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+		ret = -EAGAIN;
 		goto out;
+	}
 
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
@@ -1568,6 +1570,11 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&wl->mutex);
 
+	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out_unlock;
@@ -1708,8 +1715,10 @@ static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
+	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+		ret = -EAGAIN;
 		goto out;
+	}
 
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
@@ -1760,6 +1769,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
@@ -2040,6 +2052,11 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 conf tx %d", queue);
 
+	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
@@ -2083,6 +2100,9 @@ static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw)
 
 	mutex_lock(&wl->mutex);
 
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34759 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab1DZUfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 16:35:47 -0400
Received: by wwk4 with SMTP id 4so2668338wwk.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 13:35:46 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] wl12xx: implement the tx_frames_pending mac80211 callback
Date: Tue, 26 Apr 2011 23:35:39 +0300
Message-Id: <1303850140-11230-1-git-send-email-arik@wizery.com> (sfid-20110426_223609_896873_1AC0A638)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames are considered pending when they reside in the driver TX queue or
already queued in the FW.

This notion of "pending" is appropriate for power save considerations in
STA mode, but not necessarily in other modes (for instance P2P-GO).

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dad81f6..3dc89f7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3140,6 +3140,28 @@ out:
 	return ret;
 }
 
+bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
+{
+	struct wl1271 *wl = hw->priv;
+	bool ret = false;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	/* packets are considered pending if in the TX queue or the FW */
+	ret = (wl->tx_queue_count > 0) || (wl->tx_frames_cnt > 0);
+
+	/* the above is appropriate for STA mode for PS purposes */
+	WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_rate wl1271_rates[] = {
 	{ .bitrate = 10,
@@ -3391,6 +3413,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.sta_add = wl1271_op_sta_add,
 	.sta_remove = wl1271_op_sta_remove,
 	.ampdu_action = wl1271_op_ampdu_action,
+	.tx_frames_pending = wl1271_tx_frames_pending,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-- 
1.7.1


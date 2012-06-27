Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:47654 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756709Ab2F0QKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 12:10:05 -0400
Received: by lbok6 with SMTP id k6so365140lbo.4
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 09:09:56 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, Eliad Peller <eliad@wizery.com>
Subject: [PATCH] wlcore: implement .flush callback
Date: Wed, 27 Jun 2012 19:09:47 +0300
Message-Id: <1340813387-18407-1-git-send-email-coelho@ti.com> (sfid-20120627_181017_400526_4AB5896E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

implement the .flush() callback by simply calling wl1271_tx_flush().

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 709f6dd..6ac3323 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4637,6 +4637,13 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
+static void wlcore_op_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct wl1271 *wl = hw->priv;
+
+	wl1271_tx_flush(wl);
+}
+
 static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
@@ -4827,6 +4834,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.tx_frames_pending = wl1271_tx_frames_pending,
 	.set_bitrate_mask = wl12xx_set_bitrate_mask,
 	.channel_switch = wl12xx_op_channel_switch,
+	.flush = wlcore_op_flush,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-- 
1.7.10


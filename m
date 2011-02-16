Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43077 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab1BPSnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 13:43:14 -0500
Received: by fxm20 with SMTP id 20so1707894fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 10:43:13 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: implement flush callback
Date: Wed, 16 Feb 2011 19:43:06 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201102161943.07076.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index d176afa..a3171e3 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -524,6 +524,48 @@ static int p54_get_survey(struct ieee80211_hw *dev, int idx,
 	return 0;
 }
 
+static unsigned int p54_flush_count(struct p54_common *priv)
+{
+	unsigned int total = 0, i;
+
+	BUILD_BUG_ON(P54_QUEUE_NUM > ARRAY_SIZE(priv->tx_stats));
+
+	/*
+	 * Because the firmware has the sole control over any frames
+	 * in the P54_QUEUE_BEACON or P54_QUEUE_SCAN queues, they
+	 * don't really count as pending or active.
+	 */
+	for (i = P54_QUEUE_MGMT; i < P54_QUEUE_NUM; i++)
+		total += priv->tx_stats[i].len;
+	return total;
+}
+
+static void p54_flush(struct ieee80211_hw *dev, bool drop)
+{
+	struct p54_common *priv = dev->priv;
+	unsigned int total, i;
+
+	/*
+	 * Currently, it wouldn't really matter if we wait for one second
+	 * or 15 minutes. But once someone gets around and completes the
+	 * TODOs [ancel stuck frames / reset device] in p54_work, it will
+	 * suddenly make sense to wait that long.
+	 */
+	i = P54_STATISTICS_UPDATE * 2 / 20;
+
+	/*
+	 * In this case no locking is required because as we speak the
+	 * queues have already been stopped and no new frames can sneak
+	 * up from behind.
+	 */
+	while ((total = p54_flush_count(priv) && i--)) {
+		/* waste time */
+		msleep(20);
+	}
+
+	WARN(total, "tx flush timeout, unresponsive firmware");
+}
+
 static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx_80211,
 	.start			= p54_start,
@@ -536,6 +578,7 @@ static const struct ieee80211_ops p54_ops = {
 	.sta_remove		= p54_sta_add_remove,
 	.set_key		= p54_set_key,
 	.config			= p54_config,
+	.flush			= p54_flush,
 	.bss_info_changed	= p54_bss_info_changed,
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,

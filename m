Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033939AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 3/9] rt2x00: save conf settings before reset tuner
Date: Fri,  6 Jan 2017 14:05:12 +0100
Message-Id: <1483707918-31480-4-git-send-email-sgruszka@redhat.com> (sfid-20170106_141127_487606_A2A45205)
In-Reply-To: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reset tuner use curr_band value, make sure it is updated.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00config.c | 32 +++++++++++------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c b/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
index 6a1f508..3505074 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
@@ -249,6 +249,22 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00dev->ops->lib->config(rt2x00dev, &libconf, ieee80211_flags);
 
+	if (conf->flags & IEEE80211_CONF_PS)
+		set_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
+	else
+		clear_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
+
+	if (conf->flags & IEEE80211_CONF_MONITOR)
+		set_bit(CONFIG_MONITORING, &rt2x00dev->flags);
+	else
+		clear_bit(CONFIG_MONITORING, &rt2x00dev->flags);
+
+	rt2x00dev->curr_band = conf->chandef.chan->band;
+	rt2x00dev->curr_freq = conf->chandef.chan->center_freq;
+	rt2x00dev->tx_power = conf->power_level;
+	rt2x00dev->short_retry = conf->short_frame_max_tx_count;
+	rt2x00dev->long_retry = conf->long_frame_max_tx_count;
+
 	/*
 	 * Some configuration changes affect the link quality
 	 * which means we need to reset the link tuner.
@@ -271,20 +287,4 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 				   &rt2x00dev->autowakeup_work,
 				   autowake_timeout - 15);
 	}
-
-	if (conf->flags & IEEE80211_CONF_PS)
-		set_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
-	else
-		clear_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
-
-	if (conf->flags & IEEE80211_CONF_MONITOR)
-		set_bit(CONFIG_MONITORING, &rt2x00dev->flags);
-	else
-		clear_bit(CONFIG_MONITORING, &rt2x00dev->flags);
-
-	rt2x00dev->curr_band = conf->chandef.chan->band;
-	rt2x00dev->curr_freq = conf->chandef.chan->center_freq;
-	rt2x00dev->tx_power = conf->power_level;
-	rt2x00dev->short_retry = conf->short_frame_max_tx_count;
-	rt2x00dev->long_retry = conf->long_frame_max_tx_count;
 }
-- 
2.7.4

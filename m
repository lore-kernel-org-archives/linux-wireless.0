Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694AbXJFMEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:12 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605537ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:11 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/16] rt2x00: Pass dev_state to rt2x00lib_toggle_rx
Date: Sat, 6 Oct 2007 14:16:09 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061416.10268.IvDoorn@gmail.com> (sfid-20071006_131648_819133_40B68814)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Directly pass a value from the enum dev_state with rt2x00lib_toggle_rx,
this will save us a ? : statement, and it is clearer then passing a 1 0
argument.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   13 ++++++-------
 drivers/net/wireless/rt2x00/rt2x00lib.h |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c |    4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 6dc4f63..e141048 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -120,7 +120,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable RX.
 	 */
-	rt2x00lib_toggle_rx(rt2x00dev, 1);
+	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
 
 	/*
 	 * Start the TX queues.
@@ -151,7 +151,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Disable RX.
 	 */
-	rt2x00lib_toggle_rx(rt2x00dev, 0);
+	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 
 	/*
 	 * Disable radio.
@@ -159,14 +159,12 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_OFF);
 }
 
-void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
+void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 {
-	enum dev_state state = enable ? STATE_RADIO_RX_ON : STATE_RADIO_RX_OFF;
-
 	/*
 	 * When we are disabling the RX, we should also stop the link tuner.
 	 */
-	if (!enable)
+	if (state == STATE_RADIO_RX_OFF)
 		rt2x00lib_stop_link_tuner(rt2x00dev);
 
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
@@ -174,7 +172,8 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
 	/*
 	 * When we are enabling the RX, we should also start the link tuner.
 	 */
-	if (enable && is_interface_present(&rt2x00dev->interface))
+	if (state == STATE_RADIO_RX_ON &&
+	    is_interface_present(&rt2x00dev->interface))
 		rt2x00lib_start_link_tuner(rt2x00dev);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 29ca932..298faa9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -38,7 +38,7 @@
  */
 int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev);
-void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable);
+void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state);
 void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev);
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index e98d013..f519d73 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -272,7 +272,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 		if (!conf->radio_enabled)
 			rt2x00lib_disable_radio(rt2x00dev);
 		else
-			rt2x00lib_toggle_rx(rt2x00dev, 0);
+			rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 	}
 
 	rt2x00lib_config(rt2x00dev, conf, 0);
@@ -281,7 +281,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	 * Reenable RX only if the radio should be on.
 	 */
 	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00lib_toggle_rx(rt2x00dev, 1);
+		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
 	else if (conf->radio_enabled)
 		return rt2x00lib_enable_radio(rt2x00dev);
 
-- 
1.5.3.4


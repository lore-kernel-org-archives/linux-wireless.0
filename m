Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:21799 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927AbYBYWRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:17:07 -0500
Received: by ug-out-1314.google.com with SMTP id z38so996346ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:17:06 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 3/4] rt2x00: Don't switch to antenna with low rssi
Date: Mon, 25 Feb 2008 23:15:08 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802252315.08992.IvDoorn@gmail.com> (sfid-20080225_221710_012236_932A8BB4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rssi_a > rssi_b is true and the current antenna
was already antenna A, then rt2x00 incorrectly jumped
to antenna B.

Also don't configure the antenna when there has been
no change in the antenna setup.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 ++++
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   18 +++++-------------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 0d57d7f..07adc57 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -97,6 +97,10 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	libconf.ant.rx = rx;
 	libconf.ant.tx = tx;
 
+	if (rx == rt2x00dev->link.ant.active.rx &&
+	    tx == rt2x00dev->link.ant.active.tx)
+		return;
+
 	/*
 	 * Antenna setup changes require the RX to be disabled,
 	 * else the changes will be ignored by the device.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 00f5f0d..7294c75 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -260,19 +260,11 @@ static void rt2x00lib_evaluate_antenna_sample(struct rt2x00_dev *rt2x00dev)
 	if (sample_a == sample_b)
 		return;
 
-	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) {
-		if (sample_a > sample_b && rx == ANTENNA_B)
-			rx = ANTENNA_A;
-		else if (rx == ANTENNA_A)
-			rx = ANTENNA_B;
-	}
+	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY)
+		rx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
 
-	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY) {
-		if (sample_a > sample_b && tx == ANTENNA_B)
-			tx = ANTENNA_A;
-		else if (tx == ANTENNA_A)
-			tx = ANTENNA_B;
-	}
+	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)
+		tx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
 
 	rt2x00lib_config_antenna(rt2x00dev, rx, tx);
 }
@@ -327,7 +319,7 @@ static void rt2x00lib_evaluate_antenna(struct rt2x00_dev *rt2x00dev)
 
 	if (!(rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) &&
 	    !(rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)) {
-		rt2x00dev->link.ant.flags &= ~ANTENNA_MODE_SAMPLE;
+		rt2x00dev->link.ant.flags = 0;
 		return;
 	}
 
-- 
1.5.3.2


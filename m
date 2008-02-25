Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:38127 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632AbYBYWYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:24:21 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1503896fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:24:19 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 4/6] rt2x00: Don't switch to antenna with low rssi
Date: Mon, 25 Feb 2008 23:21:38 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802252320.11809.IvDoorn@gmail.com>
In-Reply-To: <200802252320.11809.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802252321.38439.IvDoorn@gmail.com> (sfid-20080225_222423_432388_D9A282A3)
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
index a1d8e33..6995912 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -122,6 +122,10 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
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
index 65a512f..1df1687 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -190,19 +190,11 @@ static void rt2x00lib_evaluate_antenna_sample(struct rt2x00_dev *rt2x00dev)
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
@@ -257,7 +249,7 @@ static void rt2x00lib_evaluate_antenna(struct rt2x00_dev *rt2x00dev)
 
 	if (!(rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) &&
 	    !(rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)) {
-		rt2x00dev->link.ant.flags &= ~ANTENNA_MODE_SAMPLE;
+		rt2x00dev->link.ant.flags = 0;
 		return;
 	}
 
-- 
1.5.3.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:44617 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbYLBRXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 12:23:16 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1328697eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 09:23:14 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/5] rt2x00: Remove duplicate code
Date: Tue, 2 Dec 2008 18:20:22 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200812021819.23756.IvDoorn@gmail.com> <200812021819.48603.IvDoorn@gmail.com> <200812021820.05124.IvDoorn@gmail.com>
In-Reply-To: <200812021820.05124.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812021820.22750.IvDoorn@gmail.com> (sfid-20081202_182327_620368_97C4AD52)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify rt2x00lib_config_antenna() by moving
duplicate code into a seperate static inlined
function.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |   37 ++++++++++++++-------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index b3bc8b4..e66fb31 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -108,33 +108,34 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp);
 }
 
+static inline
+enum antenna rt2x00lib_config_antenna_check(enum antenna current_ant,
+					    enum antenna default_ant)
+{
+	if (current_ant != ANTENNA_SW_DIVERSITY)
+		return current_ant;
+	return (default_ant != ANTENNA_SW_DIVERSITY) ? default_ant : ANTENNA_B;
+}
+
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 			      struct antenna_setup *ant)
 {
+	struct antenna_setup *def = &rt2x00dev->default_ant;
+	struct antenna_setup *active = &rt2x00dev->link.ant.active;
+
 	/*
 	 * Failsafe: Make sure we are not sending the
 	 * ANTENNA_SW_DIVERSITY state to the driver.
 	 * If that happes fallback to hardware default,
 	 * or our own default.
+	 * The calls to rt2x00lib_config_antenna_check()
+	 * might have caused that we restore back to the already
+	 * active setting. If that has happened we can quit.
 	 */
-	if (ant->rx == ANTENNA_SW_DIVERSITY) {
-		if (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
-			ant->rx = ANTENNA_B;
-		else
-			ant->rx = rt2x00dev->default_ant.rx;
-	}
-	if (ant->tx == ANTENNA_SW_DIVERSITY) {
-		if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
-			ant->tx = ANTENNA_B;
-		else
-			ant->tx = rt2x00dev->default_ant.tx;
-	}
+	ant->rx = rt2x00lib_config_antenna_check(ant->rx, def->rx);
+	ant->tx = rt2x00lib_config_antenna_check(ant->tx, def->tx);
 
-	/*
-	 * Only reconfigure when something has changed.
-	 */
-	if (ant->rx == rt2x00dev->link.ant.active.rx &&
-	    ant->tx == rt2x00dev->link.ant.active.tx)
+	if (ant->rx == active->rx && ant->tx == active->tx)
 		return;
 
 	/*
@@ -154,7 +155,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	rt2x00lib_reset_link_tuner(rt2x00dev);
 	rt2x00_reset_link_ant_rssi(&rt2x00dev->link);
 
-	memcpy(&rt2x00dev->link.ant.active, ant, sizeof(*ant));
+	memcpy(active, ant, sizeof(*ant));
 
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
-- 
1.5.6.1


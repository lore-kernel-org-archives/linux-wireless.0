Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:41851 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbYBYWYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:24:11 -0500
Received: by ug-out-1314.google.com with SMTP id z38so998790ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:24:10 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 2/6] rt2x00: Fix antenna diversity
Date: Mon, 25 Feb 2008 23:20:54 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802252320.11809.IvDoorn@gmail.com>
In-Reply-To: <200802252320.11809.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802252320.55082.IvDoorn@gmail.com> (sfid-20080225_222415_272142_12E28246)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 2 issues in antenna diversity selection.

1) the following statement will always return true.
	if ((rssi_curr - rssi_old) > -5 || (rssi_curr - rssi_old) < 5)
It is cleaner to check if the absolute value is smaller then 5.

2) Only enable software diversity when default antenna setup
indicates support for it. Don't select it when the hardware
does not indicate support for it...

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 015738a..65a512f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -223,7 +223,7 @@ static void rt2x00lib_evaluate_antenna_eval(struct rt2x00_dev *rt2x00dev)
 	 * sample the rssi from the other antenna to make a valid
 	 * comparison between the 2 antennas.
 	 */
-	if ((rssi_curr - rssi_old) > -5 || (rssi_curr - rssi_old) < 5)
+	if (abs(rssi_curr - rssi_old) < 5)
 		return;
 
 	rt2x00dev->link.ant.flags |= ANTENNA_MODE_SAMPLE;
@@ -249,10 +249,10 @@ static void rt2x00lib_evaluate_antenna(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->link.ant.flags &= ~ANTENNA_TX_DIVERSITY;
 
 	if (rt2x00dev->hw->conf.antenna_sel_rx == 0 &&
-	    rt2x00dev->default_ant.rx != ANTENNA_SW_DIVERSITY)
+	    rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
 		rt2x00dev->link.ant.flags |= ANTENNA_RX_DIVERSITY;
 	if (rt2x00dev->hw->conf.antenna_sel_tx == 0 &&
-	    rt2x00dev->default_ant.tx != ANTENNA_SW_DIVERSITY)
+	    rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
 		rt2x00dev->link.ant.flags |= ANTENNA_TX_DIVERSITY;
 
 	if (!(rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) &&
-- 
1.5.3.2


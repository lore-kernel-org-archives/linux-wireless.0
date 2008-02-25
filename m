Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:3257 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYBYWRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:17:01 -0500
Received: by fk-out-0910.google.com with SMTP id z23so2482368fkz.5
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:17:00 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 1/4] rt2x00: Fix antenna diversity
Date: Mon, 25 Feb 2008 23:15:01 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802252315.01632.IvDoorn@gmail.com> (sfid-20080225_221707_042102_09FE5A60)
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
index c4be2ac..00f5f0d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -293,7 +293,7 @@ static void rt2x00lib_evaluate_antenna_eval(struct rt2x00_dev *rt2x00dev)
 	 * sample the rssi from the other antenna to make a valid
 	 * comparison between the 2 antennas.
 	 */
-	if ((rssi_curr - rssi_old) > -5 || (rssi_curr - rssi_old) < 5)
+	if (abs(rssi_curr - rssi_old) < 5)
 		return;
 
 	rt2x00dev->link.ant.flags |= ANTENNA_MODE_SAMPLE;
@@ -319,10 +319,10 @@ static void rt2x00lib_evaluate_antenna(struct rt2x00_dev *rt2x00dev)
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


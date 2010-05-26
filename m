Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60708 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab0EZRpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:45:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ivdoorn@gmail.com, gwingerde@gmail.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] rt2x00: do not shortcut rt2x00lib_config_antenna
Date: Wed, 26 May 2010 13:33:31 -0400
Message-Id: <1274895211-11438-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function was exiting early if the existing diversity settings
were unchanged.  Unfortunately, in some cases the antenna configuration
is not initialized at all.

https://bugzilla.kernel.org/show_bug.cgi?id=14751

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 098315a..14a817d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -124,11 +124,6 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * ANTENNA_SW_DIVERSITY state to the driver.
 	 * If that happens, fallback to hardware defaults,
 	 * or our own default.
-	 * If diversity handling is active for a particular antenna,
-	 * we shouldn't overwrite that antenna.
-	 * The calls to rt2x00lib_config_antenna_check()
-	 * might have caused that we restore back to the already
-	 * active setting. If that has happened we can quit.
 	 */
 	if (!(ant->flags & ANTENNA_RX_DIVERSITY))
 		config.rx = rt2x00lib_config_antenna_check(config.rx, def->rx);
@@ -140,9 +135,6 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	else
 		config.tx = active->tx;
 
-	if (config.rx == active->rx && config.tx == active->tx)
-		return;
-
 	/*
 	 * Antenna setup changes require the RX to be disabled,
 	 * else the changes will be ignored by the device.
-- 
1.6.6.1


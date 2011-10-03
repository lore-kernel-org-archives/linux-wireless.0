Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:51325 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab1JCKaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:30:11 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kgiori@qca.qualcomm.com, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC 2/6] ath9k: add DFS debug flag
Date: Mon,  3 Oct 2011 12:29:14 +0200
Message-Id: <1317637758-11907-3-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111003_123018_938205_22F13D05)
In-Reply-To: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath.h |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 6d56532..34d4da1 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -211,6 +211,7 @@ ath_printk(const char *level, struct ath_common *common, const char *fmt, ...);
  * @ATH_DBG_HWTIMER: hardware timer handling
  * @ATH_DBG_BTCOEX: bluetooth coexistance
  * @ATH_DBG_BSTUCK: stuck beacons
+ * @ATH_DBG_DFS: radar datection
  * @ATH_DBG_ANY: enable all debugging
  *
  * The debug level is used to control the amount and type of debugging output
@@ -220,22 +221,23 @@ ath_printk(const char *level, struct ath_common *common, const char *fmt, ...);
  * entry.
  */
 enum ATH_DEBUG {
-	ATH_DBG_RESET		= 0x00000001,
-	ATH_DBG_QUEUE		= 0x00000002,
-	ATH_DBG_EEPROM		= 0x00000004,
-	ATH_DBG_CALIBRATE	= 0x00000008,
-	ATH_DBG_INTERRUPT	= 0x00000010,
-	ATH_DBG_REGULATORY	= 0x00000020,
-	ATH_DBG_ANI		= 0x00000040,
-	ATH_DBG_XMIT		= 0x00000080,
-	ATH_DBG_BEACON		= 0x00000100,
-	ATH_DBG_CONFIG		= 0x00000200,
-	ATH_DBG_FATAL		= 0x00000400,
-	ATH_DBG_PS		= 0x00000800,
-	ATH_DBG_HWTIMER		= 0x00001000,
-	ATH_DBG_BTCOEX		= 0x00002000,
-	ATH_DBG_WMI		= 0x00004000,
-	ATH_DBG_BSTUCK		= 0x00008000,
+	ATH_DBG_RESET		= BIT(0),
+	ATH_DBG_QUEUE		= BIT(1),
+	ATH_DBG_EEPROM		= BIT(2),
+	ATH_DBG_CALIBRATE	= BIT(3),
+	ATH_DBG_INTERRUPT	= BIT(4),
+	ATH_DBG_REGULATORY	= BIT(5),
+	ATH_DBG_ANI		= BIT(6),
+	ATH_DBG_XMIT		= BIT(7),
+	ATH_DBG_BEACON		= BIT(8),
+	ATH_DBG_CONFIG		= BIT(9),
+	ATH_DBG_FATAL		= BIT(10),
+	ATH_DBG_PS		= BIT(11),
+	ATH_DBG_HWTIMER		= BIT(12),
+	ATH_DBG_BTCOEX		= BIT(13),
+	ATH_DBG_WMI		= BIT(14),
+	ATH_DBG_BSTUCK		= BIT(15),
+	ATH_DBG_DFS		= BIT(16),
 	ATH_DBG_ANY		= 0xffffffff
 };
 
-- 
1.7.4.1


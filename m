Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14322 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZBPH67 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 02:58:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 23:58:59 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18841.7130.956050.285308@gargle.gargle.HOWL> (sfid-20090216_085902_460730_FDCCB0A2)
Date: Mon, 16 Feb 2009 13:25:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/4] ath9k: Fix endiannes of EEPROM header
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an endian-related issue when
reading the EEPROM header.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.h |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 2cfea5d..d14429b 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -303,10 +303,23 @@ struct modal_eep_header {
 	u8 xatten2Margin[AR5416_MAX_CHAINS];
 	u8 ob_ch1;
 	u8 db_ch1;
+#ifdef __BIG_ENDIAN
 	u8 useAnt1:1,
-	    force_xpaon:1,
-	    local_bias:1,
-	    femBandSelectUsed:1, xlnabufin:1, xlnaisel:2, xlnabufmode:1;
+		force_xpaon:1,
+		local_bias:1,
+		femBandSelectUsed:1,
+		xlnabufin:1,
+		xlnaisel:2,
+		xlnabufmode:1;
+#else
+	u8 xlnabufmode:1,
+		xlnaisel:2,
+		xlnabufin:1,
+		femBandSelectUsed:1,
+		local_bias:1,
+		force_xpaon:1,
+		useAnt1:1;
+#endif
 	u8 miscBits;
 	u16 xpaBiasLvlFreq[3];
 	u8 futureModal[6];
-- 
1.6.1


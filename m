Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:20969 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750921AbXIXWNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 18:13:18 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/6] adm8211: kill interrupt loop
Date: Mon, 24 Sep 2007 18:10:25 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

Looping in the interrupt handler is unnecessary.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |   84 +++++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 49a6b9e..0893d0d 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -458,51 +458,45 @@ do {									   \
 
 	struct ieee80211_hw *dev = dev_id;
 	struct adm8211_priv *priv = dev->priv;
-	unsigned int count = 0;
-	u32 stsr;
-
-	do {
-		stsr = ADM8211_CSR_READ(STSR);
-		ADM8211_CSR_WRITE(STSR, stsr);
-		if (stsr == 0xffffffff)
-			return IRQ_HANDLED;
-
-		if (!(stsr & (ADM8211_STSR_NISS | ADM8211_STSR_AISS)))
-			break;
-
-		if (stsr & ADM8211_STSR_RCI)
-			adm8211_interrupt_rci(dev);
-		if (stsr & ADM8211_STSR_TCI)
-			adm8211_interrupt_tci(dev);
-
-		/*ADM8211_INT(LinkOn);*/
-		/*ADM8211_INT(LinkOff);*/
-
-		ADM8211_INT(PCF);
-		ADM8211_INT(BCNTC);
-		ADM8211_INT(GPINT);
-		ADM8211_INT(ATIMTC);
-		ADM8211_INT(TSFTF);
-		ADM8211_INT(TSCZ);
-		ADM8211_INT(SQL);
-		ADM8211_INT(WEPTD);
-		ADM8211_INT(ATIME);
-		/*ADM8211_INT(TBTT);*/
-		ADM8211_INT(TEIS);
-		ADM8211_INT(FBE);
-		ADM8211_INT(REIS);
-		ADM8211_INT(GPTT);
-		ADM8211_INT(RPS);
-		ADM8211_INT(RDU);
-		ADM8211_INT(TUF);
-		/*ADM8211_INT(TRT);*/
-		/*ADM8211_INT(TLT);*/
-		/*ADM8211_INT(TDU);*/
-		ADM8211_INT(TPS);
-
-	} while (count++ < 20);
-
-	return IRQ_RETVAL(count);
+	u32 stsr = ADM8211_CSR_READ(STSR);
+	ADM8211_CSR_WRITE(STSR, stsr);
+	if (stsr == 0xffffffff)
+		return IRQ_HANDLED;
+
+	if (!(stsr & (ADM8211_STSR_NISS | ADM8211_STSR_AISS)))
+		return IRQ_HANDLED;
+
+	if (stsr & ADM8211_STSR_RCI)
+		adm8211_interrupt_rci(dev);
+	if (stsr & ADM8211_STSR_TCI)
+		adm8211_interrupt_tci(dev);
+
+	/*ADM8211_INT(LinkOn);*/
+	/*ADM8211_INT(LinkOff);*/
+
+	ADM8211_INT(PCF);
+	ADM8211_INT(BCNTC);
+	ADM8211_INT(GPINT);
+	ADM8211_INT(ATIMTC);
+	ADM8211_INT(TSFTF);
+	ADM8211_INT(TSCZ);
+	ADM8211_INT(SQL);
+	ADM8211_INT(WEPTD);
+	ADM8211_INT(ATIME);
+	/*ADM8211_INT(TBTT);*/
+	ADM8211_INT(TEIS);
+	ADM8211_INT(FBE);
+	ADM8211_INT(REIS);
+	ADM8211_INT(GPTT);
+	ADM8211_INT(RPS);
+	ADM8211_INT(RDU);
+	ADM8211_INT(TUF);
+	/*ADM8211_INT(TRT);*/
+	/*ADM8211_INT(TLT);*/
+	/*ADM8211_INT(TDU);*/
+	ADM8211_INT(TPS);
+
+	return IRQ_HANDLED;
 
 #undef ADM8211_INT
 }


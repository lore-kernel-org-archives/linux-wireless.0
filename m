Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:58290 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZFATle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 15:41:34 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RESEND][PATCH 2/4] ar9170: update hardware definitions
Date: Mon, 1 Jun 2009 21:41:36 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
References: <200905120108.27730.chunkeey@web.de>
In-Reply-To: <200905120108.27730.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200906012141.36922.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch only contains a few uncritical updates for the
hardware definition header.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
index 3293e0f..3c8004f 100644
--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -207,7 +207,8 @@ enum ar9170_cmd {
 #define AR9170_MAC_REG_AC1_AC0_TXOP		(AR9170_MAC_REG_BASE + 0xB44)
 #define AR9170_MAC_REG_AC3_AC2_TXOP		(AR9170_MAC_REG_BASE + 0xB48)
 
-#define AR9170_MAC_REG_AMPDU_SET		(AR9170_MAC_REG_BASE + 0xba0)
+#define AR9170_MAC_REG_AMPDU_FACTOR		(AR9170_MAC_REG_BASE + 0xB9C)
+#define AR9170_MAC_REG_AMPDU_DENSITY		(AR9170_MAC_REG_BASE + 0xBA0)
 
 #define AR9170_MAC_REG_ACK_TABLE		(AR9170_MAC_REG_BASE + 0xC00)
 #define AR9170_MAC_REG_AMPDU_RX_THRESH		(AR9170_MAC_REG_BASE + 0xC50)
@@ -376,7 +377,6 @@ static inline u8 ar9170_get_decrypt_type(struct ar9170_rx_macstatus *t)
 #define AR9170_RX_ERROR_FATAL			0x80
 
 struct ar9170_cmd_tx_status {
-	__le16 unkn;
 	u8 dst[ETH_ALEN];
 	__le32 rate;
 	__le16 status;
@@ -394,6 +394,7 @@ struct ar9170_cmd_ba_failed_count {
 struct ar9170_cmd_response {
 	u8 flag;
 	u8 type;
+	__le16 padding;
 
 	union {
 		struct ar9170_cmd_tx_status		tx_status;
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index 72c7b5d..706262f 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -84,7 +84,7 @@ static int ar9170_set_ampdu_density(struct ar9170 *ar, u8 mpdudensity)
 	val = 0x140a00 | (mpdudensity ? (mpdudensity + 1) : 0);
 
 	ar9170_regwrite_begin(ar);
-	ar9170_regwrite(AR9170_MAC_REG_AMPDU_SET, val);
+	ar9170_regwrite(AR9170_MAC_REG_AMPDU_DENSITY, val);
 	ar9170_regwrite_finish();
 
 	return ar9170_regwrite_result();


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 03/18] rtl8xxxu: Set TX page boundaries for 8192eu
Date: Thu,  7 Apr 2016 14:19:18 -0400
Message-Id: <1460053173-8494-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_201945_655191_83DBE998)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8192eu also has it's own TRXFF boundary value to set.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 7 ++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a4662a0..13e8d60 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6495,7 +6495,10 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		/*
 		 * Set TX buffer boundary
 		 */
-		val8 = TX_TOTAL_PAGE_NUM + 1;
+		if (priv->rtl_chip == RTL8192E)
+			val8 = TX_TOTAL_PAGE_NUM_8192E + 1;
+		else
+			val8 = TX_TOTAL_PAGE_NUM + 1;
 
 		if (priv->rtl_chip == RTL8723B)
 			val8 -= 1;
@@ -6532,6 +6535,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	 */
 	if (priv->rtl_chip == RTL8723B)
 		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3f7f);
+	else if (priv->rtl_chip == RTL8192E)
+		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3cff);
 	else
 		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
 	/*
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 94fc217..63d7268 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -42,6 +42,7 @@
 #define REALTEK_USB_CMD_IDX		0x00
 
 #define TX_TOTAL_PAGE_NUM		0xf8
+#define TX_TOTAL_PAGE_NUM_8192E		0xf3
 /* (HPQ + LPQ + NPQ + PUBQ) = TX_TOTAL_PAGE_NUM */
 #define TX_PAGE_NUM_PUBQ		0xe7
 #define TX_PAGE_NUM_HI_PQ		0x0c
-- 
2.5.5


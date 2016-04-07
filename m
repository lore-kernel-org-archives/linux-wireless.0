Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 12/18] rtl8xxxu: Set correct interrupt masking registers on 8192eu
Date: Thu,  7 Apr 2016 14:19:27 -0400
Message-Id: <1460053173-8494-13-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_202000_327326_20CE1BBF)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Set HIMR[01] on 8192eu instead of HISR/HIMR. It's not obvious this
really matters for USB devices, but this matches the register writes
performed by the vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3c732ed..eac2a54 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6883,11 +6883,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write8(priv, 0xfe42, 0x80);
 	}
 
-	if (priv->rtl_chip == RTL8192E) {
-		rtl8xxxu_write32(priv, REG_HIMR0, 0x00);
-		rtl8xxxu_write32(priv, REG_HIMR1, 0x00);
-	}
-
 	if (priv->fops->phy_init_antenna_selection)
 		priv->fops->phy_init_antenna_selection(priv);
 
@@ -7053,11 +7048,16 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	 */
 	rtl8xxxu_write8(priv, REG_RX_DRVINFO_SZ, 4);
 
-	/*
-	 * Enable all interrupts - not obvious USB needs to do this
-	 */
-	rtl8xxxu_write32(priv, REG_HISR, 0xffffffff);
-	rtl8xxxu_write32(priv, REG_HIMR, 0xffffffff);
+	if (priv->rtl_chip == RTL8192E) {
+		rtl8xxxu_write32(priv, REG_HIMR0, 0x00);
+		rtl8xxxu_write32(priv, REG_HIMR1, 0x00);
+	} else {
+		/*
+		 * Enable all interrupts - not obvious USB needs to do this
+		 */
+		rtl8xxxu_write32(priv, REG_HISR, 0xffffffff);
+		rtl8xxxu_write32(priv, REG_HIMR, 0xffffffff);
+	}
 
 	rtl8xxxu_set_mac(priv);
 	rtl8xxxu_set_linktype(priv, NL80211_IFTYPE_STATION);
-- 
2.5.5


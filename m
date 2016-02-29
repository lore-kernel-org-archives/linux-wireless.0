Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 076/113] rtl8xxxu: Use name for REG_RFE_BUFFER rather than hard coded value
Date: Mon, 29 Feb 2016 17:05:14 -0500
Message-Id: <1456783551-28315-77-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_866134_7E397005)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Register 0x0944 is REG_RFE_BUFFER. Use the name rather than hard coded
value when accessing it.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 690e31d..25a8ca5b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2946,9 +2946,9 @@ static void rtl8723bu_phy_init_antenna_selection(struct rtl8xxxu_priv *priv)
 	val32 &= ~BIT(23);
 	rtl8xxxu_write32(priv, REG_LEDCFG0, val32);
 
-	val32 = rtl8xxxu_read32(priv, 0x0944);
+	val32 = rtl8xxxu_read32(priv, REG_RFE_BUFFER);
 	val32 |= (BIT(0) | BIT(1));
-	rtl8xxxu_write32(priv, 0x0944, val32);
+	rtl8xxxu_write32(priv, REG_RFE_BUFFER, val32);
 
 	val32 = rtl8xxxu_read32(priv, 0x0930);
 	val32 &= 0xffffff00;
@@ -5912,9 +5912,9 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 	 */
 	rtl8xxxu_write8(priv, 0x0974, 0xff);
 
-	val32 = rtl8xxxu_read32(priv, 0x0944);
+	val32 = rtl8xxxu_read32(priv, REG_RFE_BUFFER);
 	val32 |= (BIT(0) | BIT(1));
-	rtl8xxxu_write32(priv, 0x0944, val32);
+	rtl8xxxu_write32(priv, REG_RFE_BUFFER, val32);
 
 	rtl8xxxu_write8(priv, REG_RFE_CTRL_ANTA_SRC, 0x77);
 
-- 
2.5.0


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965914AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jakub Sitnicki <jsitnicki@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 15/28] rtl8xxxu: Use REG_EFUSE_TEST register only on multifunctional devices
Date: Wed,  3 Feb 2016 13:39:49 -0500
Message-Id: <1454524802-26763-16-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194801_236370_926A45D3)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Sitnicki <jsitnicki@gmail.com>

rtl8192cu driver doesn't read/write the REG_EFUSE_TEST register.
Neither does the rtl8188eu driver.  Do it only for multifunc devices
RTL8723AU/RTL8723BU.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 9 ++++++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 4a6939f..94d3d84 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1704,6 +1704,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 			priv->has_bluetooth = 1;
 		if (val32 & MULTI_GPS_FUNC_EN)
 			priv->has_gps = 1;
+		priv->is_multi_func = 1;
 	} else if (val32 & SYS_CFG_TYPE_ID) {
 		bonding = rtl8xxxu_read32(priv, REG_HPON_FSM);
 		bonding &= HPON_FSM_BONDING_MASK;
@@ -1938,9 +1939,11 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 	if (val16 & EEPROM_BOOT)
 		priv->boot_eeprom = 1;
 
-	val32 = rtl8xxxu_read32(priv, REG_EFUSE_TEST);
-	val32 = (val32 & ~EFUSE_SELECT_MASK) | EFUSE_WIFI_SELECT;
-	rtl8xxxu_write32(priv, REG_EFUSE_TEST, val32);
+	if (priv->is_multi_func) {
+		val32 = rtl8xxxu_read32(priv, REG_EFUSE_TEST);
+		val32 = (val32 & ~EFUSE_SELECT_MASK) | EFUSE_WIFI_SELECT;
+		rtl8xxxu_write32(priv, REG_EFUSE_TEST, val32);
+	}
 
 	dev_dbg(dev, "Booting from %s\n",
 		priv->boot_eeprom ? "EEPROM" : "EFUSE");
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index f71fb8d..bbd0f6b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -597,6 +597,7 @@ struct rtl8xxxu_priv {
 	struct rtl8723au_idx ht20_max_power_offset[3];
 	u32 chip_cut:4;
 	u32 rom_rev:4;
+	u32 is_multi_func:1;
 	u32 has_wifi:1;
 	u32 has_bluetooth:1;
 	u32 enable_bluetooth:1;
-- 
2.5.0


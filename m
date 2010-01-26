Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45903 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0AZVae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 16:30:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: implement get_tsf op for mac80211
Date: Tue, 26 Jan 2010 16:22:20 -0500
Message-Id: <1264540940-30813-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 5a2b719..8dbb504 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -761,6 +761,20 @@ static void rtl8180_configure_filter(struct ieee80211_hw *dev,
 	rtl818x_iowrite32(priv, &priv->map->RX_CONF, priv->rx_conf);
 }
 
+static u64 rtl8180_get_tsf(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u32 tsftl;
+	u64 tsft;
+
+	tsftl = rtl818x_ioread32(priv, &priv->map->TSFT[0]);
+	tsft = rtl818x_ioread32(priv, &priv->map->TSFT[1]);
+	tsft <<= 32;
+	tsft |= tsftl;
+
+	return tsft;
+}
+
 static const struct ieee80211_ops rtl8180_ops = {
 	.tx			= rtl8180_tx,
 	.start			= rtl8180_start,
@@ -771,6 +785,7 @@ static const struct ieee80211_ops rtl8180_ops = {
 	.bss_info_changed	= rtl8180_bss_info_changed,
 	.prepare_multicast	= rtl8180_prepare_multicast,
 	.configure_filter	= rtl8180_configure_filter,
+	.get_tsf		= rtl8180_get_tsf,
 };
 
 static void rtl8180_eeprom_register_read(struct eeprom_93cx6 *eeprom)
-- 
1.6.2.5


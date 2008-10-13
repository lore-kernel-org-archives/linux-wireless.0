Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:54969 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548AbYJMSKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 14:10:54 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 2/3] rtl8187: add short slot handling for 8187B
Date: Mon, 13 Oct 2008 18:11:00 +0000
Message-Id: <1223921460-26419-3-git-send-email-herton@mandriva.com.br> (sfid-20081013_201108_658191_1241EC6D)
In-Reply-To: <1223921460-26419-1-git-send-email-herton@mandriva.com.br>
References: <1223921460-26419-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change adds short slot handling for 8187B variant of rtl8187 chips.
Some things to note about changes done:
* Values used are chosen to met 802.11-2007 spec. This raised a question
  about SIFS value used with 8187L: 0x22 (34) doesn't match any spec
  value. For now just don't change 8187L, but is something to be
  looked at.
* On 8187B, the location of EIFS register is at the same place as BRSR+1
  of struct rtl818x_csr. Unfortunately there is no clean way to
  accomodate 8187B differences currently, just use address of BRSR+1 and
  comment about it. The same thing happens for Ack timeout register,
  that is on CARRIER_SENSE_COUNTER location of 8187L. The eifs and ack
  timeout values are in units of 4us. All these registers information
  was gathered from references being the vendor gpl driver and 8180
  datasheet, unfortunately there is no information about this on 8187B
  datasheet. Also the ack timeout value was inspired by the same
  calculation as done on rt2x00.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl8187_dev.c     |   45 +++++++++++++++++++++++++++++---
 drivers/net/wireless/rtl8187_rtl8225.c |    8 -----
 2 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 6244461..609272f 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -909,9 +909,45 @@ static int rtl8187_config_interface(struct ieee80211_hw *dev,
 	return 0;
 }
 
-static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot)
+static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
+			     bool use_short_preamble)
 {
-	if (!priv->is_rtl8187b) {
+	if (priv->is_rtl8187b) {
+		u8 difs, eifs, slot_time;
+		u16 ack_timeout;
+
+		if (use_short_slot) {
+			slot_time = 0x9;
+			difs = 0x1c;
+			eifs = 0x53;
+		} else {
+			slot_time = 0x14;
+			difs = 0x32;
+			eifs = 0x5b;
+		}
+		rtl818x_iowrite8(priv, &priv->map->SIFS, 0xa);
+		rtl818x_iowrite8(priv, &priv->map->SLOT, slot_time);
+		rtl818x_iowrite8(priv, &priv->map->DIFS, difs);
+
+		/*
+		 * BRSR+1 on 8187B is in fact EIFS register
+		 * Value in units of 4 us
+		 */
+		rtl818x_iowrite8(priv, (u8 *)&priv->map->BRSR + 1, eifs);
+
+		/*
+		 * For 8187B, CARRIER_SENSE_COUNTER is in fact ack timeout
+		 * register. In units of 4 us like eifs register
+		 * ack_timeout = ack duration + plcp + difs + preamble
+		 */
+		ack_timeout = 112 + 48 + difs;
+		if (use_short_preamble)
+			ack_timeout += 72;
+		else
+			ack_timeout += 144;
+		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER,
+				 DIV_ROUND_UP(ack_timeout, 4));
+	} else {
 		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 		if (use_short_slot) {
 			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
@@ -934,8 +970,9 @@ static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	if (changed & BSS_CHANGED_ERP_SLOT)
-		rtl8187_conf_erp(priv, info->use_short_slot);
+	if (changed & (BSS_CHANGED_ERP_SLOT | BSS_CHANGED_ERP_PREAMBLE))
+		rtl8187_conf_erp(priv, info->use_short_slot,
+				 info->use_short_preamble);
 }
 
 static void rtl8187_configure_filter(struct ieee80211_hw *dev,
diff --git a/drivers/net/wireless/rtl8187_rtl8225.c b/drivers/net/wireless/rtl8187_rtl8225.c
index 1bae899..b999f87 100644
--- a/drivers/net/wireless/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl8187_rtl8225.c
@@ -885,14 +885,6 @@ static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
 	for (i = 0; i < ARRAY_SIZE(rtl8225z2_ofdm); i++)
 		rtl8225_write_phy_ofdm(dev, i, rtl8225z2_ofdm[i]);
 
-	rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
-	rtl818x_iowrite8(priv, &priv->map->SLOT, 9);
-	rtl818x_iowrite8(priv, (u8 *)0xFFF0, 28);
-	rtl818x_iowrite8(priv, (u8 *)0xFFF4, 28);
-	rtl818x_iowrite8(priv, (u8 *)0xFFF8, 28);
-	rtl818x_iowrite8(priv, (u8 *)0xFFFC, 28);
-	rtl818x_iowrite8(priv, (u8 *)0xFF2D, 0x5B);
-	rtl818x_iowrite8(priv, (u8 *)0xFF79, 0x5B);
 	rtl818x_iowrite32(priv, (__le32 *)0xFFF0, (7 << 12) | (3 << 8) | 28);
 	rtl818x_iowrite32(priv, (__le32 *)0xFFF4, (7 << 12) | (3 << 8) | 28);
 	rtl818x_iowrite32(priv, (__le32 *)0xFFF8, (7 << 12) | (3 << 8) | 28);
-- 
1.6.0.2


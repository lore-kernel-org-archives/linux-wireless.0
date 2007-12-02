Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:16101 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbXLBWLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 17:11:13 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/8] rtl8187: fix tx power reading
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Sun, 02 Dec 2007 17:17:51 -0500
Message-ID: <20071202221751.7347.54891.stgit@tetra.sourmilk.net> (sfid-20071202_221118_018794_0591B8C5)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

CCK and OFDM power levels are stored in adjacent bytes, not nibbles.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
---

 drivers/net/wireless/rtl8187_rtl8225.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_rtl8225.c b/drivers/net/wireless/rtl8187_rtl8225.c
index efc4120..eade81f 100644
--- a/drivers/net/wireless/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl8187_rtl8225.c
@@ -283,8 +283,8 @@ static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 	u32 reg;
 	int i;
 
-	cck_power = priv->channels[channel - 1].val & 0xF;
-	ofdm_power = priv->channels[channel - 1].val >> 4;
+	cck_power = priv->channels[channel - 1].val & 0xFF;
+	ofdm_power = priv->channels[channel - 1].val >> 8;
 
 	cck_power = min(cck_power, (u8)11);
 	ofdm_power = min(ofdm_power, (u8)35);
@@ -500,8 +500,8 @@ static void rtl8225z2_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 	u32 reg;
 	int i;
 
-	cck_power = priv->channels[channel - 1].val & 0xF;
-	ofdm_power = priv->channels[channel - 1].val >> 4;
+	cck_power = priv->channels[channel - 1].val & 0xFF;
+	ofdm_power = priv->channels[channel - 1].val >> 8;
 
 	cck_power = min(cck_power, (u8)15);
 	cck_power += priv->txpwr_base & 0xF;



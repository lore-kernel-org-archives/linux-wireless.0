Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:55090 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaINVJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 17:09:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] b43: update some transmit header constants
Date: Sun, 14 Sep 2014 23:09:11 +0200
Message-Id: <1410728952-25779-4-git-send-email-hauke@hauke-m.de> (sfid-20140914_230928_311667_4BB62890)
In-Reply-To: <1410728952-25779-1-git-send-email-hauke@hauke-m.de>
References: <1410728952-25779-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some constants were missing and are added now.
The rate mode was renamed, at least the ucode in brcsmac uses 2 for HT
rates (iee80211n) and the more recent ucodes are using 3 for VHT
(ieee80211ac).

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/xmit.h | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index 98d9074..ba61153 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -97,9 +97,13 @@ struct b43_tx_legacy_rate_phy_ctl_entry {
 };
 
 /* MAC TX control */
+#define B43_TXH_MAC_RTS_FB_SHORTPRMBL	0x80000000 /* RTS fallback preamble */
+#define B43_TXH_MAC_RTS_SHORTPRMBL	0x40000000 /* RTS main rate preamble */
+#define B43_TXH_MAC_FB_SHORTPRMBL	0x20000000 /* Main fallback preamble */
 #define B43_TXH_MAC_USEFBR		0x10000000 /* Use fallback rate for this AMPDU */
 #define B43_TXH_MAC_KEYIDX		0x0FF00000 /* Security key index */
 #define B43_TXH_MAC_KEYIDX_SHIFT	20
+#define B43_TXH_MAC_ALT_TXPWR		0x00080000 /* Use alternate txpwr defined at loc. M_ALT_TXPWR_IDX */
 #define B43_TXH_MAC_KEYALG		0x00070000 /* Security key algorithm */
 #define B43_TXH_MAC_KEYALG_SHIFT	16
 #define B43_TXH_MAC_AMIC		0x00008000 /* AMIC */
@@ -126,25 +130,25 @@ struct b43_tx_legacy_rate_phy_ctl_entry {
 #define B43_TXH_EFT_FB			0x03 /* Data frame fallback encoding */
 #define  B43_TXH_EFT_FB_CCK		0x00 /* CCK */
 #define  B43_TXH_EFT_FB_OFDM		0x01 /* OFDM */
-#define  B43_TXH_EFT_FB_EWC		0x02 /* EWC */
-#define  B43_TXH_EFT_FB_N		0x03 /* N */
+#define  B43_TXH_EFT_FB_HT		0x02 /* HT */
+#define  B43_TXH_EFT_FB_VHT		0x03 /* VHT */
 #define B43_TXH_EFT_RTS			0x0C /* RTS/CTS encoding */
 #define  B43_TXH_EFT_RTS_CCK		0x00 /* CCK */
 #define  B43_TXH_EFT_RTS_OFDM		0x04 /* OFDM */
-#define  B43_TXH_EFT_RTS_EWC		0x08 /* EWC */
-#define  B43_TXH_EFT_RTS_N		0x0C /* N */
+#define  B43_TXH_EFT_RTS_HT		0x08 /* HT */
+#define  B43_TXH_EFT_RTS_VHT		0x0C /* VHT */
 #define B43_TXH_EFT_RTSFB		0x30 /* RTS/CTS fallback encoding */
 #define  B43_TXH_EFT_RTSFB_CCK		0x00 /* CCK */
 #define  B43_TXH_EFT_RTSFB_OFDM		0x10 /* OFDM */
-#define  B43_TXH_EFT_RTSFB_EWC		0x20 /* EWC */
-#define  B43_TXH_EFT_RTSFB_N		0x30 /* N */
+#define  B43_TXH_EFT_RTSFB_HT		0x20 /* HT */
+#define  B43_TXH_EFT_RTSFB_VHT		0x30 /* VHT */
 
 /* PHY TX control word */
 #define B43_TXH_PHY_ENC			0x0003 /* Data frame encoding */
 #define  B43_TXH_PHY_ENC_CCK		0x0000 /* CCK */
 #define  B43_TXH_PHY_ENC_OFDM		0x0001 /* OFDM */
-#define  B43_TXH_PHY_ENC_EWC		0x0002 /* EWC */
-#define  B43_TXH_PHY_ENC_N		0x0003 /* N */
+#define  B43_TXH_PHY_ENC_HT		0x0002 /* HT */
+#define  B43_TXH_PHY_ENC_VHT		0x0003 /* VHT */
 #define B43_TXH_PHY_SHORTPRMBL		0x0010 /* Use short preamble */
 #define B43_TXH_PHY_ANT			0x03C0 /* Antenna selection */
 #define  B43_TXH_PHY_ANT0		0x0000 /* Use antenna 0 */
@@ -162,7 +166,7 @@ struct b43_tx_legacy_rate_phy_ctl_entry {
 #define  B43_TXH_PHY1_BW_20		0x0002 /* 20 MHz */
 #define  B43_TXH_PHY1_BW_20U		0x0003 /* 20 MHz upper */
 #define  B43_TXH_PHY1_BW_40		0x0004 /* 40 MHz */
-#define  B43_TXH_PHY1_BW_40DUP		0x0005 /* 50 MHz duplicate */
+#define  B43_TXH_PHY1_BW_40DUP		0x0005 /* 40 MHz duplicate */
 #define B43_TXH_PHY1_MODE		0x0038 /* Mode */
 #define  B43_TXH_PHY1_MODE_SISO		0x0000 /* SISO */
 #define  B43_TXH_PHY1_MODE_CDD		0x0008 /* CDD */
-- 
1.9.1


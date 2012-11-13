Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42671 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2KMR2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:28:53 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so10386eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:28:52 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 02/17] staging: rtl8187se: Removed legacy rtl8225_rf_set_chan()
Date: Tue, 13 Nov 2012 19:28:08 +0200
Message-Id: <1352827703-4659-3-git-send-email-maxtram95@gmail.com> (sfid-20121113_182858_681563_BBCA2302)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed rtl8225_rf_set_chan() and corresponding arrays, changed its
usage to rtl8225z2_rf_set_chan()

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c      |   41 -------
 drivers/staging/rtl8187se/r8180_rtl8225z2.c |  160 +--------------------------
 2 files changed, 3 insertions(+), 198 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 8ed94d1..1a76cc9 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -444,24 +444,6 @@ void buffer_free(struct net_device *dev, struct buffer **buffer, int len, short
 	*buffer = NULL;
 }
 
-void print_buffer(u32 *buffer, int len)
-{
-	int i;
-	u8 *buf = (u8 *)buffer;
-
-	printk("ASCII BUFFER DUMP (len: %x):\n", len);
-
-	for (i = 0; i < len; i++)
-		printk("%c", buf[i]);
-
-	printk("\nBINARY BUFFER DUMP (len: %x):\n", len);
-
-	for (i = 0; i < len; i++)
-		printk("%02x", buf[i]);
-
-	printk("\n");
-}
-
 int get_curr_tx_free_desc(struct net_device *dev, int priority)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
@@ -2970,29 +2952,6 @@ void write_phy_cck(struct net_device *dev, u8 adr, u32 data)
 	rtl8185_write_phy(dev, adr, data | 0x10000);
 }
 
-void rtl8185_set_rate(struct net_device *dev)
-{
-	int i;
-	u16 word;
-	int basic_rate, min_rr_rate, max_rr_rate;
-
-	basic_rate = ieeerate2rtlrate(240);
-	min_rr_rate = ieeerate2rtlrate(60);
-	max_rr_rate = ieeerate2rtlrate(240);
-
-	write_nic_byte(dev, RESP_RATE,
-		       max_rr_rate<<MAX_RESP_RATE_SHIFT |
-		       min_rr_rate<<MIN_RESP_RATE_SHIFT);
-
-	word  = read_nic_word(dev, BRSR);
-	word &= ~BRSR_MBR_8185;
-
-	for (i = 0; i <= basic_rate; i++)
-		word |= (1<<i);
-
-	write_nic_word(dev, BRSR, word);
-}
-
 /*
  * This configures registers for beacon tx and enables it via
  * rtl8180_beacon_tx_enable(). rtl8180_beacon_tx_disable() might
diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index a369a3d..315eece 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -111,118 +111,12 @@ static const u8 rtl8225_agc[] = {
 	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
 };
 
-static const u8 rtl8225_gain[] = {
-	0x23, 0x88, 0x7c, 0xa5,	/* -82dBm */
-	0x23, 0x88, 0x7c, 0xb5,	/* -82dBm */
-	0x23, 0x88, 0x7c, 0xc5,	/* -82dBm */
-	0x33, 0x80, 0x79, 0xc5,	/* -78dBm */
-	0x43, 0x78, 0x76, 0xc5,	/* -74dBm */
-	0x53, 0x60, 0x73, 0xc5,	/* -70dBm */
-	0x63, 0x58, 0x70, 0xc5,	/* -66dBm */
-};
-
-static const u8 rtl8225_tx_gain_cck_ofdm[] = {
-	0x02, 0x06, 0x0e, 0x1e, 0x3e, 0x7e
-};
-
-static const u8 rtl8225_tx_power_cck[] = {
-	0x18, 0x17, 0x15, 0x11, 0x0c, 0x08, 0x04, 0x02,
-	0x1b, 0x1a, 0x17, 0x13, 0x0e, 0x09, 0x04, 0x02,
-	0x1f, 0x1e, 0x1a, 0x15, 0x10, 0x0a, 0x05, 0x02,
-	0x22, 0x21, 0x1d, 0x18, 0x11, 0x0b, 0x06, 0x02,
-	0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03,
-	0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03
-};
-
-static const u8 rtl8225_tx_power_cck_ch14[] = {
-	0x18, 0x17, 0x15, 0x0c, 0x00, 0x00, 0x00, 0x00,
-	0x1b, 0x1a, 0x17, 0x0e, 0x00, 0x00, 0x00, 0x00,
-	0x1f, 0x1e, 0x1a, 0x0f, 0x00, 0x00, 0x00, 0x00,
-	0x22, 0x21, 0x1d, 0x11, 0x00, 0x00, 0x00, 0x00,
-	0x26, 0x25, 0x21, 0x13, 0x00, 0x00, 0x00, 0x00,
-	0x2b, 0x2a, 0x25, 0x15, 0x00, 0x00, 0x00, 0x00
-};
-
-static const u8 rtl8225_tx_power_ofdm[] = {
-	0x80, 0x90, 0xa2, 0xb5, 0xcb, 0xe4
-};
-
 static const u32 rtl8225_chan[] = {
 	0,
 	0x0080, 0x0100, 0x0180, 0x0200, 0x0280, 0x0300, 0x0380,
 	0x0400, 0x0480, 0x0500, 0x0580, 0x0600, 0x0680, 0x074A,
 };
 
-static void rtl8225_SetTXPowerLevel(struct net_device *dev, short ch)
-{
-	struct r8180_priv *priv = ieee80211_priv(dev);
-	int GainIdx;
-	int GainSetting;
-	int i;
-	u8 power;
-	const u8 *cck_power_table;
-	u8 max_cck_power_level;
-	u8 max_ofdm_power_level;
-	u8 min_ofdm_power_level;
-	u8 cck_power_level = 0xff & priv->chtxpwr[ch];
-	u8 ofdm_power_level = 0xff & priv->chtxpwr_ofdm[ch];
-
-	max_cck_power_level = 35;
-	max_ofdm_power_level = 35;
-	min_ofdm_power_level = 0;
-
-	if (cck_power_level > max_cck_power_level)
-		cck_power_level = max_cck_power_level;
-
-	GainIdx = cck_power_level % 6;
-	GainSetting = cck_power_level / 6;
-
-	if (ch == 14)
-		cck_power_table = rtl8225_tx_power_cck_ch14;
-	else
-		cck_power_table = rtl8225_tx_power_cck;
-
-	write_nic_byte(dev, TX_GAIN_CCK,
-		       rtl8225_tx_gain_cck_ofdm[GainSetting] >> 1);
-
-	for (i = 0; i < 8; i++) {
-		power = cck_power_table[GainIdx * 8 + i];
-		write_phy_cck(dev, 0x44 + i, power);
-	}
-
-	/* FIXME Is this delay really needed ? */
-	force_pci_posting(dev);
-	mdelay(1);
-
-	if (ofdm_power_level > (max_ofdm_power_level - min_ofdm_power_level))
-		ofdm_power_level = max_ofdm_power_level;
-	else
-		ofdm_power_level += min_ofdm_power_level;
-
-	if (ofdm_power_level > 35)
-		ofdm_power_level = 35;
-
-	GainIdx = ofdm_power_level % 6;
-	GainSetting = ofdm_power_level / 6;
-
-	rtl8185_set_anaparam2(dev, RTL8225_ANAPARAM2_ON);
-
-	write_phy_ofdm(dev, 2, 0x42);
-	write_phy_ofdm(dev, 6, 0x00);
-	write_phy_ofdm(dev, 8, 0x00);
-
-	write_nic_byte(dev, TX_GAIN_OFDM,
-		       rtl8225_tx_gain_cck_ofdm[GainSetting] >> 1);
-
-	power = rtl8225_tx_power_ofdm[GainIdx];
-
-	write_phy_ofdm(dev, 5, power);
-	write_phy_ofdm(dev, 7, power);
-
-	force_pci_posting(dev);
-	mdelay(1);
-}
-
 static const u8 rtl8225z2_threshold[] = {
 	0x8d, 0x8d, 0x8d, 0x8d, 0x9d, 0xad, 0xbd,
 };
@@ -263,15 +157,6 @@ static const u16 rtl8225z2_rxgain[] = {
 
 };
 
-static const u8 ZEBRA2_CCK_OFDM_GAIN_SETTING[] = {
-	0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
-	0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
-	0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11,
-	0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
-	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d,
-	0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23,
-};
-
 static const u8 rtl8225z2_tx_power_ofdm[] = {
 	0x42, 0x00, 0x40, 0x00, 0x40
 };
@@ -508,8 +393,7 @@ void rtl8225z2_SetTXPowerLevel(struct net_device *dev, short ch)
 	if (cck_power_level > 35)
 		cck_power_level = 35;
 
-	write_nic_byte(dev, CCK_TXAGC,
-		       (ZEBRA2_CCK_OFDM_GAIN_SETTING[(u8)cck_power_level]));
+	write_nic_byte(dev, CCK_TXAGC, cck_power_level);
 	force_pci_posting(dev);
 	mdelay(1);
 
@@ -524,8 +408,7 @@ void rtl8225z2_SetTXPowerLevel(struct net_device *dev, short ch)
 		write_phy_ofdm(dev, 8, 0x40);
 	}
 
-	write_nic_byte(dev, OFDM_TXAGC,
-		       ZEBRA2_CCK_OFDM_GAIN_SETTING[(u8)ofdm_power_level]);
+	write_nic_byte(dev, OFDM_TXAGC, ofdm_power_level);
 
 	if (ofdm_power_level <= 11) {
 		write_phy_ofdm(dev, 0x07, 0x5c);
@@ -576,43 +459,6 @@ static void rtl8225_host_pci_init(struct net_device *dev)
 	write_nic_word(dev, GP_ENABLE, 0xff & (~(1 << 6)));
 }
 
-static void rtl8225_rf_set_chan(struct net_device *dev, short ch)
-{
-	struct r8180_priv *priv = ieee80211_priv(dev);
-	short gset = (priv->ieee80211->state == IEEE80211_LINKED &&
-		ieee80211_is_54g(&priv->ieee80211->current_network)) ||
-		priv->ieee80211->iw_mode == IW_MODE_MONITOR;
-
-	rtl8225_SetTXPowerLevel(dev, ch);
-
-	write_rtl8225(dev, 0x7, rtl8225_chan[ch]);
-
-	force_pci_posting(dev);
-	mdelay(10);
-
-	if (gset) {
-		write_nic_byte(dev, SIFS, 0x22);
-		write_nic_byte(dev, DIFS, 0x14);
-	} else {
-		write_nic_byte(dev, SIFS, 0x44);
-		write_nic_byte(dev, DIFS, 0x24);
-	}
-
-	if (priv->ieee80211->state == IEEE80211_LINKED &&
-	    ieee80211_is_shortslot(&priv->ieee80211->current_network))
-		write_nic_byte(dev, SLOT, 0x9);
-	else
-		write_nic_byte(dev, SLOT, 0x14);
-
-	if (gset) {
-		write_nic_byte(dev, EIFS, 81);
-		write_nic_byte(dev, CW_VAL, 0x73);
-	} else {
-		write_nic_byte(dev, EIFS, 81);
-		write_nic_byte(dev, CW_VAL, 0xa5);
-	}
-}
-
 void rtl8225z2_rf_init(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
@@ -792,7 +638,7 @@ void rtl8225z2_rf_init(struct net_device *dev)
 	write_nic_dword(dev, 0x94, 0x15c00002);
 	rtl8185_rf_pins_enable(dev);
 
-	rtl8225_rf_set_chan(dev, priv->chan);
+	rtl8225z2_rf_set_chan(dev, priv->chan);
 }
 
 void rtl8225z2_rf_set_mode(struct net_device *dev)
-- 
1.7.10.4


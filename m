Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42671 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab2KMR3P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:29:15 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so10386eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:29:14 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 14/17] staging: rtl8187se: Removed unneeded reads from EEPROM
Date: Tue, 13 Nov 2012 19:28:20 +0200
Message-Id: <1352827703-4659-15-git-send-email-maxtram95@gmail.com> (sfid-20121113_182945_666034_02F1E360)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed unneeded reads from EEPROM and some unnecessary conditions

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180.h      |    4 ----
 drivers/staging/rtl8187se/r8180_core.c |   36 ++++++++------------------------
 2 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index db7974a..a819b01 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -365,8 +365,6 @@ typedef struct r8180_priv
 	short digphy;
 	short antb;
 	short diversity;
-	u8 cs_treshold;
-	short rcr_csense;
 	u32 key0[4];
 	short (*rf_set_sens)(struct net_device *dev,short sens);
 	void (*rf_set_chan)(struct net_device *dev,short ch);
@@ -623,8 +621,6 @@ typedef struct r8180_priv
 
 	u8 PowerProfile;
 	u32 CSMethod;
-	u8 cck_txpwr_base;
-	u8 ofdm_txpwr_base;
 	u8 dma_poll_stop_mask;
 
 	//u8 RegThreeWireMode;
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 642508e..e55b93c 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2376,8 +2376,7 @@ short rtl8180_init(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u16 word;
-	u16 version;
-	u32 usValue;
+	u16 usValue;
 	u16 tmpu16;
 	int i, j;
 	struct eeprom_93cx6 eeprom;
@@ -2614,36 +2613,31 @@ short rtl8180_init(struct net_device *dev)
 	/* just for sync 85 */
 	priv->enable_gpio0 = 0;
 
-	eeprom_93cx6_read(&eeprom, EEPROM_SW_REVD_OFFSET, &eeprom_val);
-	usValue = eeprom_val;
-	DMESG("usValue is 0x%x\n", usValue);
+	eeprom_93cx6_read(&eeprom, EEPROM_SW_REVD_OFFSET, &usValue);
+	DMESG("usValue is %#hx\n", usValue);
 	/* 3Read AntennaDiversity */
 
 	/* SW Antenna Diversity. */
-	if ((usValue & EEPROM_SW_AD_MASK) != EEPROM_SW_AD_ENABLE)
-		priv->EEPROMSwAntennaDiversity = false;
-	else
-		priv->EEPROMSwAntennaDiversity = true;
+	priv->EEPROMSwAntennaDiversity = (usValue & EEPROM_SW_AD_MASK) ==
+		EEPROM_SW_AD_ENABLE;
 
 	/* Default Antenna to use. */
-	if ((usValue & EEPROM_DEF_ANT_MASK) != EEPROM_DEF_ANT_1)
-		priv->EEPROMDefaultAntenna1 = false;
-	else
-		priv->EEPROMDefaultAntenna1 = true;
+	priv->EEPROMDefaultAntenna1 = (usValue & EEPROM_DEF_ANT_MASK) ==
+		EEPROM_DEF_ANT_1;
 
 	if (priv->RegSwAntennaDiversityMechanism == 0) /* Auto */
 		/* 0: default from EEPROM. */
 		priv->bSwAntennaDiverity = priv->EEPROMSwAntennaDiversity;
 	else
 		/* 1:disable antenna diversity, 2: enable antenna diversity. */
-		priv->bSwAntennaDiverity = ((priv->RegSwAntennaDiversityMechanism == 1) ? false : true);
+		priv->bSwAntennaDiverity = priv->RegSwAntennaDiversityMechanism == 2;
 
 	if (priv->RegDefaultAntenna == 0)
 		/* 0: default from EEPROM. */
 		priv->bDefaultAntenna1 = priv->EEPROMDefaultAntenna1;
 	else
 		/* 1: main, 2: aux. */
-		priv->bDefaultAntenna1 = ((priv->RegDefaultAntenna == 2) ? true : false);
+		priv->bDefaultAntenna1 = priv->RegDefaultAntenna == 2;
 
 	/* rtl8185 can calc plcp len in HW. */
 	priv->hw_plcp_len = 1;
@@ -2683,18 +2677,6 @@ short rtl8180_init(struct net_device *dev)
 	if ((tmpu16 & EEPROM_THERMAL_METER_ENABLE) >> 13)
 		priv->bTxPowerTrack = true;
 
-	eeprom_93cx6_read(&eeprom, EPROM_TXPW_BASE, &word);
-	priv->cck_txpwr_base = word & 0xf;
-	priv->ofdm_txpwr_base = (word>>4) & 0xf;
-
-	eeprom_93cx6_read(&eeprom, EPROM_VERSION, &version);
-	DMESG("EEPROM version %x", version);
-	priv->rcr_csense = 3;
-
-	eeprom_93cx6_read(&eeprom, ENERGY_TRESHOLD, &eeprom_val);
-	priv->cs_treshold = (eeprom_val & 0xff00) >> 8;
-
-	eeprom_93cx6_read(&eeprom, RFCHIPID, &eeprom_val);
 	priv->rf_sleep = rtl8225z4_rf_sleep;
 	priv->rf_wakeup = rtl8225z4_rf_wakeup;
 	DMESGW("**PLEASE** REPORT SUCCESSFUL/UNSUCCESSFUL TO Realtek!");
-- 
1.7.10.4


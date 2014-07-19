Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:51058 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaGSLbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:04 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so5601930wes.30
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/16] staging: vt6656: struct vnt_private replace byRFType with rf_type
Date: Sat, 19 Jul 2014 12:30:07 +0100
Message-Id: <1405769418-2815-5-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133117_255385_D9150284)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 24 ++++++++++++------------
 drivers/staging/vt6656/card.c     | 12 ++++++------
 drivers/staging/vt6656/channel.c  |  2 +-
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/main_usb.c |  4 ++--
 drivers/staging/vt6656/rf.c       | 10 +++++-----
 6 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 91c24a3..b08d1ea 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -396,14 +396,14 @@ int vnt_vt3184_init(struct vnt_private *priv)
 
 	priv->byZoneType = priv->abyEEPROM[EEP_OFS_ZONETYPE];
 
-	priv->byRFType = priv->abyEEPROM[EEP_OFS_RFTYPE];
+	priv->rf_type = priv->abyEEPROM[EEP_OFS_RFTYPE];
 
 	dev_dbg(&priv->usb->dev, "Zone Type %x\n", priv->byZoneType);
 
-	dev_dbg(&priv->usb->dev, "RF Type %d\n", priv->byRFType);
+	dev_dbg(&priv->usb->dev, "RF Type %d\n", priv->rf_type);
 
-	if ((priv->byRFType == RF_AL2230) ||
-				(priv->byRFType == RF_AL2230S)) {
+	if ((priv->rf_type == RF_AL2230) ||
+				(priv->rf_type == RF_AL2230S)) {
 		priv->byBBRxConf = vnt_vt3184_al2230[10];
 		length = sizeof(vnt_vt3184_al2230);
 		addr = vnt_vt3184_al2230;
@@ -418,7 +418,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		priv->ldBmThreshold[1] = -48;
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
-	} else if (priv->byRFType == RF_AIROHA7230) {
+	} else if (priv->rf_type == RF_AIROHA7230) {
 		priv->byBBRxConf = vnt_vt3184_al2230[10];
 		length = sizeof(vnt_vt3184_al2230);
 		addr = vnt_vt3184_al2230;
@@ -435,8 +435,8 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		priv->ldBmThreshold[1] = -48;
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
-	} else if ((priv->byRFType == RF_VT3226) ||
-			(priv->byRFType == RF_VT3226D0)) {
+	} else if ((priv->rf_type == RF_VT3226) ||
+			(priv->rf_type == RF_VT3226D0)) {
 		priv->byBBRxConf = vnt_vt3184_vt3226d0[10];
 		length = sizeof(vnt_vt3184_vt3226d0);
 		addr = vnt_vt3184_vt3226d0;
@@ -454,7 +454,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		/* Fix VT3226 DFC system timing issue */
 		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
 				    SOFTPWRCTL_RFLEOPT);
-	} else if (priv->byRFType == RF_VT3342A0) {
+	} else if (priv->rf_type == RF_VT3342A0) {
 		priv->byBBRxConf = vnt_vt3184_vt3226d0[10];
 		length = sizeof(vnt_vt3184_vt3226d0);
 		addr = vnt_vt3184_vt3226d0;
@@ -486,12 +486,12 @@ int vnt_vt3184_init(struct vnt_private *priv)
 	vnt_control_out(priv, MESSAGE_TYPE_WRITE, 0,
 		MESSAGE_REQUEST_BBAGC, length_agc, array);
 
-	if ((priv->byRFType == RF_VT3226) ||
-		(priv->byRFType == RF_VT3342A0)) {
+	if ((priv->rf_type == RF_VT3226) ||
+		(priv->rf_type == RF_VT3342A0)) {
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG,
 						MAC_REG_ITRTMSET, 0x23);
 		vnt_mac_reg_bits_on(priv, MAC_REG_PAPEDELAY, 0x01);
-	} else if (priv->byRFType == RF_VT3226D0) {
+	} else if (priv->rf_type == RF_VT3226D0) {
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG,
 						MAC_REG_ITRTMSET, 0x11);
 		vnt_mac_reg_bits_on(priv, MAC_REG_PAPEDELAY, 0x01);
@@ -586,7 +586,7 @@ void vnt_update_pre_ed_threshold(struct vnt_private *priv, int scanning)
 	u8 cr_201 = 0x0, cr_206 = 0x0;
 	u8 ed_inx = priv->byBBPreEDIndex;
 
-	switch (priv->byRFType) {
+	switch (priv->rf_type) {
 	case RF_AL2230:
 	case RF_AL2230S:
 	case RF_AIROHA7230:
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 19a7931..3b49ee9 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -409,7 +409,7 @@ void vnt_update_ifs(struct vnt_private *priv)
 	priv->uCwMax = C_CWMAX;
 	priv->uEIFS = C_EIFS;
 
-	switch (priv->byRFType) {
+	switch (priv->rf_type) {
 	case RF_VT3226D0:
 		if (priv->byBBType != BB_TYPE_11B) {
 			priv->uSIFS -= 1;
@@ -734,7 +734,7 @@ int vnt_radio_power_off(struct vnt_private *priv)
 {
 	int ret = true;
 
-	switch (priv->byRFType) {
+	switch (priv->rf_type) {
 	case RF_AL2230:
 	case RF_AL2230S:
 	case RF_AIROHA7230:
@@ -775,7 +775,7 @@ int vnt_radio_power_on(struct vnt_private *priv)
 
 	vnt_mac_reg_bits_on(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
 
-	switch (priv->byRFType) {
+	switch (priv->rf_type) {
 	case RF_AL2230:
 	case RF_AL2230S:
 	case RF_AIROHA7230:
@@ -794,7 +794,7 @@ int vnt_radio_power_on(struct vnt_private *priv)
 
 void vnt_set_bss_mode(struct vnt_private *priv)
 {
-	if (priv->byRFType == RF_AIROHA7230 && priv->byBBType == BB_TYPE_11A)
+	if (priv->rf_type == RF_AIROHA7230 && priv->byBBType == BB_TYPE_11A)
 		vnt_mac_set_bb_type(priv, BB_TYPE_11G);
 	else
 		vnt_mac_set_bb_type(priv, priv->byBBType);
@@ -812,7 +812,7 @@ void vnt_set_bss_mode(struct vnt_private *priv)
 	vnt_set_rspinf(priv, (u8)priv->byBBType);
 
 	if (priv->byBBType == BB_TYPE_11A) {
-		if (priv->byRFType == RF_AIROHA7230) {
+		if (priv->rf_type == RF_AIROHA7230) {
 			priv->abyBBVGA[0] = 0x20;
 
 			vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG,
@@ -822,7 +822,7 @@ void vnt_set_bss_mode(struct vnt_private *priv)
 		priv->abyBBVGA[2] = 0x10;
 		priv->abyBBVGA[3] = 0x10;
 	} else {
-		if (priv->byRFType == RF_AIROHA7230) {
+		if (priv->rf_type == RF_AIROHA7230) {
 			priv->abyBBVGA[0] = 0x1c;
 
 			vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG,
diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 4a53f1a..8412d05 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -146,7 +146,7 @@ void vnt_init_bands(struct vnt_private *priv)
 	struct ieee80211_channel *ch;
 	int i;
 
-	switch (priv->byRFType) {
+	switch (priv->rf_type) {
 	case RF_AIROHA7230:
 	case RF_VT3342A0:
 	default:
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index c1d0551..8b5793b 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -301,7 +301,7 @@ struct vnt_private {
 	/* Version control */
 	u16 firmware_version;
 	u8 local_id;
-	u8 byRFType;
+	u8 rf_type;
 	u8 byBBRxConf;
 
 	u8 byZoneType;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 9974bab..c8b4914 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -290,10 +290,10 @@ static int device_init_registers(struct vnt_private *priv)
 	priv->byBBType = BB_TYPE_11G;
 
 	/* get RFType */
-	priv->byRFType = init_rsp->rf_type;
+	priv->rf_type = init_rsp->rf_type;
 
 	/* load vt3266 calibration parameters in EEPROM */
-	if (priv->byRFType == RF_VT3226D0) {
+	if (priv->rf_type == RF_VT3226D0) {
 		if ((priv->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
 		    (priv->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
 
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 28e64b4..c98cf60 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -665,7 +665,7 @@ static u8 vnt_rf_addpower(struct vnt_private *priv)
 	if (!rssi)
 		return 7;
 
-	if (priv->byRFType == RF_VT3226D0) {
+	if (priv->rf_type == RF_VT3226D0) {
 		if (rssi < -70)
 			return 9;
 		else if (rssi < -65)
@@ -699,7 +699,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 
 	priv->byCurPwr = power;
 
-	switch (priv->byRFType) {
+	switch (priv->rf_type) {
 	case RF_AL2230:
 		if (power >= AL2230_PWR_IDX_LEN)
 			return false;
@@ -811,7 +811,7 @@ void vnt_rf_rssi_to_dbm(struct vnt_private *priv, u8 rssi, long *dbm)
 	long a = 0;
 	u8 airoharf[4] = {0, 18, 0, 40};
 
-	switch (priv->byRFType) {
+	switch (priv->rf_type) {
 	case RF_AL2230:
 	case RF_AL2230S:
 	case RF_AIROHA7230:
@@ -834,7 +834,7 @@ void vnt_rf_table_download(struct vnt_private *priv)
 	u16 length, value;
 	u8 array[256];
 
-	switch (priv->byRFType) {
+	switch (priv->rf_type) {
 	case RF_AL2230:
 	case RF_AL2230S:
 		length1 = CB_AL2230_INIT_SEQ * 3;
@@ -920,7 +920,7 @@ void vnt_rf_table_download(struct vnt_private *priv)
 		addr3 += length;
 	}
 
-	if (priv->byRFType == RF_AIROHA7230) {
+	if (priv->rf_type == RF_AIROHA7230) {
 		length1 = CB_AL7230_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL * 3;
 		addr1 = &(al7230_init_table_amode[0][0]);
-- 
2.0.1


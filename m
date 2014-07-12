Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59593 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaGLKan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 06:30:43 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so398013wib.12
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 03:30:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/4] staging: vt6656: rf.c cleanup comments
Date: Sat, 12 Jul 2014 11:30:03 +0100
Message-Id: <1405161003-2914-4-git-send-email-tvboxspy@gmail.com> (sfid-20140712_123056_773086_2E09AA0A)
In-Reply-To: <1405161003-2914-1-git-send-email-tvboxspy@gmail.com>
References: <1405161003-2914-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

named comments are already referenced in revision history
in high-level comment.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 65 +++------------------------------------------
 1 file changed, 4 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 1c3b3fa..28e64b4 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -46,15 +46,11 @@
 #define CB_AL7230_INIT_SEQ    16
 #define AL7230_PWR_IDX_LEN    64
 
-//{{RobertYu:20051111
 #define CB_VT3226_INIT_SEQ    11
 #define VT3226_PWR_IDX_LEN    64
-//}}
 
-//{{RobertYu:20060609
 #define CB_VT3342_INIT_SEQ    13
 #define VT3342_PWR_IDX_LEN    64
-//}}
 
 static u8 al2230_init_table[CB_AL2230_INIT_SEQ][3] = {
 	{0x03, 0xf7, 0x90},
@@ -536,12 +532,7 @@ static u8 vt3342_channel_table1[CB_MAX_CHANNEL][3] = {
 	{0x03, 0x00, 0x04}
 };
 
-/*+
- *
- * Power Table
- *
--*/
-
+/* Power Table */
 static const u32 al2230_power_table[AL2230_PWR_IDX_LEN] = {
 	0x04040900,
 	0x04041900,
@@ -611,15 +602,6 @@ static const u32 al2230_power_table[AL2230_PWR_IDX_LEN] = {
 
 /*
  * Description: Write to IF/RF, by embedded programming
- *
- * Parameters:
- *  In:
- *      dwData      - data to write
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
  */
 int vnt_rf_write_embedded(struct vnt_private *priv, u32 data)
 {
@@ -638,19 +620,7 @@ int vnt_rf_write_embedded(struct vnt_private *priv, u32 data)
 	return true;
 }
 
-/*
- * Description: Set Tx power
- *
- * Parameters:
- *  In:
- *      dwIoBase       - I/O base address
- *      dwRFPowerTable - RF Tx Power Setting
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
+/* Set Tx power by rate and channel number */
 int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 {
 	int ret = true;
@@ -714,20 +684,7 @@ static u8 vnt_rf_addpower(struct vnt_private *priv)
 	return 0;
 }
 
-/*
- * Description: Set Tx power
- *
- * Parameters:
- *  In:
- *      dwIoBase       - I/O base address
- *      dwRFPowerTable - RF Tx Power Setting
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
+/* Set Tx power by power level and rate */
 int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 {
 	u32 power_setting = 0;
@@ -846,21 +803,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 	return ret;
 }
 
-/*+
- *
- * Routine Description:
- *     Translate RSSI to dBm
- *
- * Parameters:
- *  In:
- *      pDevice         - The adapter to be translated
- *      byCurrRSSI      - RSSI to be translated
- *  Out:
- *      pdwdbm          - Translated dbm number
- *
- * Return Value: none
- *
--*/
+/* Convert rssi to dbm */
 void vnt_rf_rssi_to_dbm(struct vnt_private *priv, u8 rssi, long *dbm)
 {
 	u8 idx = (((rssi & 0xc0) >> 6) & 0x03);
-- 
1.9.1


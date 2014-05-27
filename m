Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:46752 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaE0UGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:22 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so9896691wes.7
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/10] staging: vt6656: rf.c replace DBG_PRT debug messages
Date: Tue, 27 May 2014 21:05:26 +0100
Message-Id: <1401221126-4219-10-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220646_914266_A3AD9AA7)
In-Reply-To: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
References: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace with dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index d509839..3f54ae3 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -41,8 +41,6 @@
 #include "usbpipe.h"
 #include "datarate.h"
 
-static int          msglevel                =MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 #define BY_AL2230_REG_LEN     23 //24bit
 #define CB_AL2230_INIT_SEQ    15
 #define AL2230_PWR_IDX_LEN    64
@@ -902,14 +900,14 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 
 			if (priv->vnt_mgmt.eScanState != WMAC_NO_SCANNING) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				dev_dbg(&priv->usb->dev,
 				"vnt_rf_set_txpower> 11B mode uCurrChannel[%d]\n",
 						priv->vnt_mgmt.uScanChannel);
 				ret &= vnt_rf_write_embedded(priv,
 					vt3226d0_lo_current_table[priv->
 						vnt_mgmt.uScanChannel - 1]);
 			} else {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				dev_dbg(&priv->usb->dev,
 				"vnt_rf_set_txpower> 11B mode uCurrChannel[%d]\n",
 						priv->vnt_mgmt.uCurrChannel);
 				ret &= vnt_rf_write_embedded(priv,
@@ -920,7 +918,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 			ret &= vnt_rf_write_embedded(priv, 0x015C0800 +
 				(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 		} else {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			dev_dbg(&priv->usb->dev,
 					"@@@@ vnt_rf_set_txpower> 11G mode\n");
 
 			power_setting = ((0x3f-priv->byCurPwr) << 20) |
-- 
1.9.1


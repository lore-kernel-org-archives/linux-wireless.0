Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32862 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbaGSLbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:07 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so1991555wiv.17
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/16] staging: vt6656: remove variable byZoneType
Date: Sat, 19 Jul 2014 12:30:09 +0100
Message-Id: <1405769418-2815-7-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133122_731314_DE623A14)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zone types are nolonger handled by driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 4 ----
 drivers/staging/vt6656/device.h   | 2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 71226c7..6af9fcb 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -394,12 +394,8 @@ int vnt_vt3184_init(struct vnt_private *priv)
 	if (status != STATUS_SUCCESS)
 		return false;
 
-	priv->byZoneType = priv->abyEEPROM[EEP_OFS_ZONETYPE];
-
 	priv->rf_type = priv->abyEEPROM[EEP_OFS_RFTYPE];
 
-	dev_dbg(&priv->usb->dev, "Zone Type %x\n", priv->byZoneType);
-
 	dev_dbg(&priv->usb->dev, "RF Type %d\n", priv->rf_type);
 
 	if ((priv->rf_type == RF_AL2230) ||
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 3152f93..183d9c9 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -304,8 +304,6 @@ struct vnt_private {
 	u8 rf_type;
 	u8 bb_rx_conf;
 
-	u8 byZoneType;
-
 	struct vnt_cmd_card_init init_command;
 	struct vnt_rsp_card_init init_response;
 	u8 abyCurrentNetAddr[ETH_ALEN];
-- 
2.0.1


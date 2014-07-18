Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62730 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038AbaGRWBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 18:01:46 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so1500478wib.14
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 15:01:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/5] staging: vt6656: struct vnt_private remove unused variable bRadioOff
Date: Fri, 18 Jul 2014 23:00:53 +0100
Message-Id: <1405720856-2737-2-git-send-email-tvboxspy@gmail.com> (sfid-20140719_000149_233870_C74B1EE2)
In-Reply-To: <1405720856-2737-1-git-send-email-tvboxspy@gmail.com>
References: <1405720856-2737-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable flips from true to false but does nothing

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c   | 4 ----
 drivers/staging/vt6656/device.h | 2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index ddf7385..ca77a19 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -734,8 +734,6 @@ int vnt_radio_power_off(struct vnt_private *priv)
 {
 	int ret = true;
 
-	priv->bRadioOff = true;
-
 	switch (priv->byRFType) {
 	case RF_AL2230:
 	case RF_AL2230S:
@@ -774,8 +772,6 @@ int vnt_radio_power_on(struct vnt_private *priv)
 	if (priv->bHWRadioOff == true)
 		return false;
 
-	priv->bRadioOff = false;
-
 	vnt_exit_deep_sleep(priv);
 
 	vnt_mac_reg_bits_on(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 358c620..69cac95 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -368,8 +368,6 @@ struct vnt_private {
 	int bShortSlotTime;
 	int bBarkerPreambleMd;
 
-	int bRadioOff;
-
 	/* Power save */
 	u16 current_aid;
 
-- 
2.0.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34232 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760509AbaGSLbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:10 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so4452756wgg.12
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/16] staging: vt6656: rename abyPermanentNetAddr to permanent_net_addr
Date: Sat, 19 Jul 2014 12:30:11 +0100
Message-Id: <1405769418-2815-9-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133125_296908_1B8A0865)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing prefix and camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/main_usb.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 9287948..0c18e26 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -307,7 +307,7 @@ struct vnt_private {
 	struct vnt_cmd_card_init init_command;
 	struct vnt_rsp_card_init init_response;
 	u8 current_net_addr[ETH_ALEN];
-	u8 abyPermanentNetAddr[ETH_ALEN];
+	u8 permanent_net_addr[ETH_ALEN];
 
 	int bExistSWNetAddr;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e8e4de5..0bf207c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -334,9 +334,8 @@ static int device_init_registers(struct vnt_private *priv)
 	}
 
 	/* get permanent network address */
-	memcpy(priv->abyPermanentNetAddr, init_rsp->net_addr, 6);
-	memcpy(priv->current_net_addr,
-				priv->abyPermanentNetAddr, ETH_ALEN);
+	memcpy(priv->permanent_net_addr, init_rsp->net_addr, 6);
+	memcpy(priv->current_net_addr, priv->permanent_net_addr, ETH_ALEN);
 
 	/* if exist SW network address, use it */
 	dev_dbg(&priv->usb->dev, "Network address = %pM\n",
@@ -970,7 +969,7 @@ int vnt_init(struct vnt_private *priv)
 	if (!(device_init_registers(priv)))
 		return -EAGAIN;
 
-	SET_IEEE80211_PERM_ADDR(priv->hw, priv->abyPermanentNetAddr);
+	SET_IEEE80211_PERM_ADDR(priv->hw, priv->permanent_net_addr);
 
 	vnt_init_bands(priv);
 
-- 
2.0.1


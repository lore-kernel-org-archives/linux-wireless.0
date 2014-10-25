Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52527 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaJYTZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:25:42 -0400
Received: by mail-wg0-f48.google.com with SMTP id m15so1211373wgh.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:25:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 24/31] staging: vt6655: vt6655_probe remove management pointers
Date: Sat, 25 Oct 2014 09:20:34 +0100
Message-Id: <1414225241-5480-25-git-send-email-tvboxspy@gmail.com> (sfid-20141025_212547_102574_8EFEAC17)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All these pointers are now dead.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 0bd2ca8..d7dd002 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3266,8 +3266,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	/* Enable the chip specified capabilities */
 	priv->flags = priv->sOpts.flags | (pChip_info->flags & 0xff000000UL);
 	priv->tx_80211 = device_dma0_tx_80211;
-	priv->sMgmtObj.pAdapter = (void *)priv;
-	priv->pMgmt = &(priv->sMgmtObj);
 
 	wiphy = priv->hw->wiphy;
 
-- 
1.9.1


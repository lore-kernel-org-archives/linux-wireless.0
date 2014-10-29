Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56556 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbaJ2Rpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:53 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so2403358wiv.10
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 24/34] staging: vt6655: vt6655_probe remove management pointers
Date: Wed, 29 Oct 2014 17:43:59 +0000
Message-Id: <1414604649-9105-25-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184908_727677_00A3D822)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
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
2.1.0


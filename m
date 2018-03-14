Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39117 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbeCNMpe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 08:45:34 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com
Cc: hariprasath.elango@gmail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: wilc1000: use kmemdup instead of kmalloc and memcpy
Date: Wed, 14 Mar 2018 18:15:01 +0530
Message-Id: <eb6f1bd272febe81ba4d632e377f4e3a6ca27cf4.1521030891.git.hariprasath.elango@gmail.com> (sfid-20180314_134545_035164_401D699A)
In-Reply-To: <cover.1521030891.git.hariprasath.elango@gmail.com>
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
In-Reply-To: <cover.1521030891.git.hariprasath.elango@gmail.com>
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

Kmalloc followed by memcpy can be replaced by kmemdup.

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index f93f411..c6fd6b3 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -146,7 +146,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	if (!mgmt_tx)
 		return -ENOMEM;
 
-	mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
+	mgmt_tx->buff = kmemdup(buf, len, GFP_ATOMIC);
 	if (!mgmt_tx->buff) {
 		kfree(mgmt_tx);
 		return -ENOMEM;
@@ -154,7 +154,6 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 
 	mgmt_tx->size = len;
 
-	memcpy(mgmt_tx->buff, buf, len);
 	wilc_wlan_txq_add_mgmt_pkt(dev, mgmt_tx, mgmt_tx->buff, mgmt_tx->size,
 				   mgmt_tx_complete);
 
-- 
2.10.0.GIT

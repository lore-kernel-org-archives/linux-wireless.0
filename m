Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:37193 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbeCMGVP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 02:21:15 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com
Cc: hariprasath.elango@gmail.com, vbabu3@visteon.com,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: use kmemdup instead of kmalloc and memcpy
Date: Tue, 13 Mar 2018 11:50:48 +0530
Message-Id: <20180313062049.6200-1-hariprasath.elango@gmail.com> (sfid-20180313_072130_052534_504BACC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

Kmalloc followed by memcpy can be replaced by kmemdup.

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
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

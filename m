Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29395 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaHDIWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 04:22:45 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 12/14] wil6210: fix free'd memory access in wil_if_free()
Date: Mon, 4 Aug 2014 11:20:52 +0300
Message-ID: <1407140454-31639-13-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140804_102907_327393_DC065A0D)
In-Reply-To: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

In the wil_priv_deinit(), wdev->netdev is accessed, so free_netdev()
should not be called before mentioned call.

Set wdev->netdev to NULL Make sure no more attempts to use it.
It is used for debug printk if not NULL.

This fix kernel panic on module unload and in case error on probe;
if memory allocation debugging enabled.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 8ee0862..59fd550 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -168,11 +168,15 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 void wil_if_free(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
+
 	if (!ndev)
 		return;
 
-	free_netdev(ndev);
 	wil_priv_deinit(wil);
+
+	wil_to_ndev(wil) = NULL;
+	free_netdev(ndev);
+
 	wil_wdev_free(wil);
 }
 
-- 
1.8.5.2


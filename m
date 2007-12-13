Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55906 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762699AbXLMG7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:25 -0500
Subject: [PATCH 63/48] libertas: move removal of lbs_rtap file to lbs_stop_card()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2i-0005s3-SZ@shinybook.infradead.org> (sfid-20071213_065943_561300_0F3C1952)
Date: Thu, 13 Dec 2007 01:59:36 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 12:54:43 -0500

This prevents us from trying to remove it when it didn't exist, in the
error case.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 9f6c119..212cce3 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1089,7 +1089,6 @@ int lbs_remove_card(struct lbs_private *priv)
 	lbs_remove_rtap(priv);
 
 	dev = priv->dev;
-	device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
 
 	cancel_delayed_work(&priv->scan_work);
 	cancel_delayed_work(&priv->assoc_work);
@@ -1167,6 +1166,7 @@ int lbs_stop_card(struct lbs_private *priv)
 	netif_carrier_off(priv->dev);
 
 	lbs_debugfs_remove_one(priv);
+	device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
 
 	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
-- 
1.5.3.4


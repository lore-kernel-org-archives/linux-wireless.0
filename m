Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42499 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316AbZJFVQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 17:16:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/4] orinoco: support ETHTOOL_GPERMADDR
Date: Tue,  6 Oct 2009 17:07:19 -0400
Message-Id: <1254863240-14780-3-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1254863240-14780-1-git-send-email-linville@tuxdriver.com>
References: <1254863240-14780-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/orinoco/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 7a32bcb..5fdc59c 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -2225,6 +2225,7 @@ int orinoco_if_add(struct orinoco_private *priv,
 	netif_carrier_off(dev);
 
 	memcpy(dev->dev_addr, wiphy->perm_addr, ETH_ALEN);
+	memcpy(dev->perm_addr, wiphy->perm_addr, ETH_ALEN);
 
 	dev->base_addr = base_addr;
 	dev->irq = irq;
-- 
1.6.2.5


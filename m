Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39531 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZG0OqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 10:46:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ettl.martin@gmx.de, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ray_cs: avoid potential null dereference in ray_get_wireless_stats
Date: Mon, 27 Jul 2009 10:34:42 -0400
Message-Id: <1248705282-9951-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13854

Reported-by: Martin Ettl <ettl.martin@gmx.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ray_cs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 698b11b..a4308a6 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -1508,11 +1508,13 @@ static int ray_commit(struct net_device *dev, struct iw_request_info *info,	/* N
 static iw_stats *ray_get_wireless_stats(struct net_device *dev)
 {
 	ray_dev_t *local = netdev_priv(dev);
-	struct pcmcia_device *link = local->finder;
-	struct status __iomem *p = local->sram + STATUS_BASE;
+	struct pcmcia_device *link;
+	struct status __iomem *p;
 
 	if (local == (ray_dev_t *) NULL)
 		return (iw_stats *) NULL;
+	link = local->finder;
+	p = local->sram + STATUS_BASE;
 
 	local->wstats.status = local->card_status;
 #ifdef WIRELESS_SPY
-- 
1.6.2.5


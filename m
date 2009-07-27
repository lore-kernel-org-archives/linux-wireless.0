Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51482 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZG0PEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 11:04:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ettl.martin@gmx.de, johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ray_cs: remove bocus NULL check at head of ray_get_wireless_stats
Date: Mon, 27 Jul 2009 11:02:49 -0400
Message-Id: <1248706969-10435-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1248705282-9951-1-git-send-email-linville@tuxdriver.com>
References: <1248705282-9951-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Martin Ettl <ettl.martin@gmx.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Johannes points-out that the NULL check is mostly bogus given how
netdev_priv is computed and how get_wireless_stats gets called...

 drivers/net/wireless/ray_cs.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 698b11b..8fdea7f 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -1511,9 +1511,6 @@ static iw_stats *ray_get_wireless_stats(struct net_device *dev)
 	struct pcmcia_device *link = local->finder;
 	struct status __iomem *p = local->sram + STATUS_BASE;
 
-	if (local == (ray_dev_t *) NULL)
-		return (iw_stats *) NULL;
-
 	local->wstats.status = local->card_status;
 #ifdef WIRELESS_SPY
 	if ((local->spy_data.spy_number > 0)
-- 
1.6.2.5


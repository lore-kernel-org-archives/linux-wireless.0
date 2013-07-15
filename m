Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55267 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab3GOLP3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:15:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] bcma: return correct error code when bus scan failed
Date: Mon, 15 Jul 2013 13:15:07 +0200
Message-Id: <1373886908-4460-5-git-send-email-hauke@hauke-m.de> (sfid-20130715_131533_415374_90A23DDE)
In-Reply-To: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
References: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is better to return the actual error code than just -1.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 0067422..90ee350 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -237,7 +237,7 @@ int bcma_bus_register(struct bcma_bus *bus)
 	err = bcma_bus_scan(bus);
 	if (err) {
 		bcma_err(bus, "Failed to scan: %d\n", err);
-		return -1;
+		return err;
 	}
 
 	/* Early init CC core */
-- 
1.7.10.4


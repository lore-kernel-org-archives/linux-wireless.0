Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60696 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbbGWGbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 02:31:52 -0400
Received: from potku.com (a88-115-185-251.elisa-laajakaista.fi [88.115.185.251])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kvalo@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id CD4DB140A76
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 06:31:50 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] bcma: fix linking problem with of_default_bus_match_table
Date: Thu, 23 Jul 2015 09:31:44 +0300
Message-Id: <1437633104-23373-1-git-send-email-kvalo@codeaurora.org> (sfid-20150723_083157_157561_C9E329A0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen reported a build problem caused by commit cae761b5a6bd ("bcma: populate
bus DT subnodes as platform_device-s"):

ERROR: "of_default_bus_match_table" [drivers/bcma/bcma.ko] undefined!

Rafał Miłecki suggested as a quick fix to use IS_BUILTIN() to workaround the
issue. The downside is that this won't work when BCMA is compiled as a module,
but we can live with that for now just to unblock the breakage.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: cae761b5a6bd ("bcma: populate bus DT subnodes as platform_device-s")
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/bcma/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 59128478a90f..6b7d54622058 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -410,7 +410,7 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_pci_early_init(&bus->drv_pci[0]);
 	}
 
-	if (bus->host_pdev) {
+	if (IS_BUILTIN(CONFIG_BCMA) && bus->host_pdev) {
 		struct device *dev = &bus->host_pdev->dev;
 
 		of_platform_populate(dev->of_node, of_default_bus_match_table,
-- 
1.7.9.5


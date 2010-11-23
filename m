Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:59397 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753777Ab0KWQKS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 11:10:18 -0500
Date: Tue, 23 Nov 2010 17:10:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-wireless@vger.kernel.org
cc: Stefano Brivio <stefano.brivio@polimi.it>
Subject: [PATCH] wireless: b43: fix error path in SDIO
Message-ID: <Pine.LNX.4.64.1011231709380.25676@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix unbalanced call to sdio_release_host() on the error path.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/net/wireless/b43/sdio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/sdio.c b/drivers/net/wireless/b43/sdio.c
index 9a55338..09e2dfd 100644
--- a/drivers/net/wireless/b43/sdio.c
+++ b/drivers/net/wireless/b43/sdio.c
@@ -163,6 +163,7 @@ static int b43_sdio_probe(struct sdio_func *func,
 err_free_ssb:
 	kfree(sdio);
 err_disable_func:
+	sdio_claim_host(func);
 	sdio_disable_func(func);
 err_release_host:
 	sdio_release_host(func);
-- 
1.7.2.3


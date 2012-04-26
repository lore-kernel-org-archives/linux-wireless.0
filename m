Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s23.blu0.hotmail.com ([65.55.111.98]:52228 "EHLO
	blu0-omc2-s23.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab2DZEYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 00:24:34 -0400
Message-ID: <BLU0-SMTP458C69159D873B590212AF5AC240@phx.gbl> (sfid-20120426_062438_847876_9890051E)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH v2 6/6] bcma: Add flush for BCMA_RESET_CTL write
Date: Wed, 25 Apr 2012 21:23:54 -0700
In-Reply-To: <1335414234-11424-1-git-send-email-nlhintz@hotmail.com>
References: <1335414234-11424-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 drivers/bcma/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index 893f6e0..c4e6deb 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -30,6 +30,7 @@ void bcma_core_disable(struct bcma_device *core, u32 flags)
 	udelay(10);
 
 	bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
+	bcma_aread32(core, BCMA_RESET_CTL);
 	udelay(1);
 }
 EXPORT_SYMBOL_GPL(bcma_core_disable);
-- 
1.7.7.6


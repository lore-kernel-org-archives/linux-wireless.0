Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s2.blu0.hotmail.com ([65.55.111.77]:11638 "EHLO
	blu0-omc2-s2.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758075Ab2DYGPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:15:51 -0400
Message-ID: <BLU0-SMTP82EF695554B950971BFA98AC270@phx.gbl> (sfid-20120425_081554_198921_9D60677D)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 6/6] bcma: Add flush for BCMA_RESET_CTL write
Date: Tue, 24 Apr 2012 23:15:19 -0700
In-Reply-To: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
References: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s22.blu0.hotmail.com ([65.55.111.97]:18653 "EHLO
	blu0-omc2-s22.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739Ab2EEFDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 01:03:38 -0400
Message-ID: <BLU0-SMTP198AA334D9A1CD0C329E1A5AC2D0@phx.gbl> (sfid-20120505_070342_520876_F9737A4E)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH v3 6/6] bcma: Add flush for BCMA_RESET_CTL write
Date: Fri, 4 May 2012 21:56:36 -0700
In-Reply-To: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
References: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds a missing read to flush the previous write (per the Broadcom SDK).

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


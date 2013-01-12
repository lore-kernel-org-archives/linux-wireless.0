Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s15.blu0.hotmail.com ([65.55.111.90]:17598 "EHLO
	blu0-omc2-s15.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab3ALKrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 05:47:06 -0500
Message-ID: <BLU0-SMTP98CC9B048B90AD9E8ECA82AC280@phx.gbl> (sfid-20130112_114713_051755_556C5E21)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 1/5] bcma: delete duplicate readl
Date: Sat, 12 Jan 2013 02:46:13 -0800
In-Reply-To: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'val' has already been read by the prior call to 'mips_busprobe32';
this 'readl' is unnecessary.

Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 drivers/bcma/driver_pci_host.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 536d353..56073a5 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -122,8 +122,6 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
 			val = 0xffffffff;
 			goto unmap;
 		}
-
-		val = readl(mmio);
 	}
 	val >>= (8 * (off & 3));
 
-- 
1.7.7.6


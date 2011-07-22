Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35427 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab1GVUcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 16:32:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] bcma: fix 'SSB_PCICORE_BFL_NOPCI' undeclared build breakage
Date: Fri, 22 Jul 2011 16:27:16 -0400
Message-Id: <1311366436-25791-1-git-send-email-linville@tuxdriver.com> (sfid-20110722_223239_076260_9C13AF9B)
In-Reply-To: <20110722090414.4e3d80a5.rdunlap@xenotime.net>
References: <20110722090414.4e3d80a5.rdunlap@xenotime.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux-next-20110722/drivers/bcma/driver_pci.c:175: error: 'SSB_PCICORE_BFL_NOPCI' undeclared (first use in this function)

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/bcma/driver_pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index dc6f34a..745d264 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -172,8 +172,10 @@ static bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
 	    chipid_top != 0x5300)
 		return false;
 
+#ifdef CONFIG_SSB_DRIVER_PCICORE
 	if (bus->sprom.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
 		return false;
+#endif /* CONFIG_SSB_DRIVER_PCICORE */
 
 #if 0
 	/* TODO: on BCMA we use address from EROM instead of magic formula */
-- 
1.7.4.4


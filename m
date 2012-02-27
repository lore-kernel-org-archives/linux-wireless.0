Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52285 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab2B0X5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:57:54 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 06/11] bcma: export bcma_find_core
Date: Tue, 28 Feb 2012 00:56:09 +0100
Message-Id: <1330386974-4056-7-git-send-email-hauke@hauke-m.de> (sfid-20120228_005757_548401_1A3178A1)
In-Reply-To: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
References: <1330386974-4056-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is needed by the bcm47xx arch code to get the number of
the ieee80211 core.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c       |    3 ++-
 include/linux/bcma/bcma.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index b8379b9..7e138ec 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -61,7 +61,7 @@ static struct bus_type bcma_bus_type = {
 	.dev_attrs	= bcma_device_attrs,
 };
 
-static struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid)
+struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid)
 {
 	struct bcma_device *core;
 
@@ -71,6 +71,7 @@ static struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(bcma_find_core);
 
 static void bcma_release_core_dev(struct device *dev)
 {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index b9f65fb..46bbd08 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -284,6 +284,7 @@ static inline void bcma_maskset16(struct bcma_device *cc,
 	bcma_write16(cc, offset, (bcma_read16(cc, offset) & mask) | set);
 }
 
+extern struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid);
 extern bool bcma_core_is_enabled(struct bcma_device *core);
 extern void bcma_core_disable(struct bcma_device *core, u32 flags);
 extern int bcma_core_enable(struct bcma_device *core, u32 flags);
-- 
1.7.5.4


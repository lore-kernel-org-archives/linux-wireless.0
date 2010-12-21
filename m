Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50640 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189Ab0LUBCN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 20:02:13 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 3/7] ssb: Use pci_is_pcie()
Date: Tue, 21 Dec 2010 02:01:52 +0100
Message-Id: <1292893316-26694-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use function pci_is_pcie() instead of accessing struct member directly.

CC: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index ee079ab..5a0985d 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -405,10 +405,10 @@ int ssb_bus_scan(struct ssb_bus *bus,
 				/* Ignore PCI cores on PCI-E cards.
 				 * Ignore PCI-E cores on PCI cards. */
 				if (dev->id.coreid == SSB_DEV_PCI) {
-					if (bus->host_pci->is_pcie)
+					if (pci_is_pcie(bus->host_pci))
 						continue;
 				} else {
-					if (!bus->host_pci->is_pcie)
+					if (!pci_is_pcie(bus->host_pci))
 						continue;
 				}
 			}
-- 
1.7.1


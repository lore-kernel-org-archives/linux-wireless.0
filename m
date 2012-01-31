Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39638 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab2AaXOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 18:14:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, m@bues.ch, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] ssb: log the id, rev and pkg of the chip found
Date: Wed,  1 Feb 2012 00:13:55 +0100
Message-Id: <1328051636-15449-4-git-send-email-hauke@hauke-m.de> (sfid-20120201_001415_452674_21D8B417)
In-Reply-To: <1328051636-15449-1-git-send-email-hauke@hauke-m.de>
References: <1328051636-15449-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes us see what type of hardware someone uses by the dmesg
output.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/scan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index 3e84487..266c7c5 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -318,6 +318,9 @@ int ssb_bus_scan(struct ssb_bus *bus,
 			bus->chip_package = 0;
 		}
 	}
+	ssb_printk(KERN_INFO PFX "Found chip with id 0x%04X, rev 0x%02X and "
+		   "package 0x%02X\n", bus->chip_id, bus->chip_rev,
+		   bus->chip_package);
 	if (!bus->nr_devices)
 		bus->nr_devices = chipid_to_nrcores(bus->chip_id);
 	if (bus->nr_devices > ARRAY_SIZE(bus->devices)) {
-- 
1.7.5.4


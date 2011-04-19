Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49256 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1DSUDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 16:03:01 -0400
Received: by eyx24 with SMTP id 24so15753eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 13:02:59 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] ssb: pci: trivial: correct amount of maximum retries
Date: Tue, 19 Apr 2011 22:40:22 +0200
Message-Id: <1303245624-3057-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_pcicore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 1ba9f0e..dbda168 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -522,7 +522,7 @@ static u16 ssb_pcie_mdio_read(struct ssb_pcicore *pc, u8 device, u8 address)
 	pcicore_write32(pc, mdio_data, v);
 	/* Wait for the device to complete the transaction */
 	udelay(10);
-	for (i = 0; i < 200; i++) {
+	for (i = 0; i < max_retries; i++) {
 		v = pcicore_read32(pc, mdio_control);
 		if (v & 0x100 /* Trans complete */) {
 			udelay(10);
-- 
1.7.3.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52709 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab1LLT5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 14:57:45 -0500
Received: by eaaj10 with SMTP id j10so827594eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 11:57:44 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: N-PHY: workaround broken auto-increment on BCM43224
Date: Mon, 12 Dec 2011 21:38:36 +0100
Message-Id: <1323722316-4265-2-git-send-email-zajec5@gmail.com> (sfid-20111212_205748_518052_9114B88A)
In-Reply-To: <1323722316-4265-1-git-send-email-zajec5@gmail.com>
References: <1323722316-4265-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_nphy.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index e1fc337..3252560 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2905,6 +2905,12 @@ void b43_ntab_read_bulk(struct b43_wldev *dev, u32 offset,
 	b43_phy_write(dev, B43_NPHY_TABLE_ADDR, offset);
 
 	for (i = 0; i < nr_elements; i++) {
+		/* Auto increment broken + caching issue on BCM43224? */
+		if (dev->dev->chip_id == 43224 && dev->dev->chip_rev == 1) {
+			b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, offset + i);
+		}
+
 		switch (type) {
 		case B43_NTAB_8BIT:
 			*data = b43_phy_read(dev, B43_NPHY_TABLE_DATALO) & 0xFF;
-- 
1.7.3.4


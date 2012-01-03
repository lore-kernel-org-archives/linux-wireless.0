Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47276 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab2ACVIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 16:08:05 -0500
Received: by eekc4 with SMTP id c4so16211531eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 13:08:04 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/5] b43: N-PHY: fix typos in RF control
Date: Tue,  3 Jan 2012 22:49:18 +0100
Message-Id: <1325627361-3394-2-git-send-email-zajec5@gmail.com> (sfid-20120103_220811_764231_F7BFAA35)
In-Reply-To: <1325627361-3394-1-git-send-email-zajec5@gmail.com>
References: <1325627361-3394-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       |    6 +++---
 drivers/net/wireless/b43/tables_nphy.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 20394d8..1e499f0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -211,7 +211,7 @@ static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 
 		reg = (i == 0) ?
 			B43_NPHY_RFCTL_INTC1 : B43_NPHY_RFCTL_INTC2;
-		b43_phy_mask(dev, reg, 0xFBFF);
+		b43_phy_set(dev, reg, 0x400);
 
 		switch (field) {
 		case 0:
@@ -227,7 +227,7 @@ static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 				b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
 						B43_NPHY_RFCTL_CMD_START);
 				for (j = 0; j < 100; j++) {
-					if (b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_START) {
+					if (!(b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_START)) {
 						j = 0;
 						break;
 					}
@@ -246,7 +246,7 @@ static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 				b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
 						B43_NPHY_RFCTL_CMD_RXTX);
 				for (j = 0; j < 100; j++) {
-					if (b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_RXTX) {
+					if (!(b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_RXTX)) {
 						j = 0;
 						break;
 					}
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 645bc34..dc52249 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2739,11 +2739,11 @@ const struct nphy_rf_control_override_rev3 tbl_rf_control_override_rev3[] = {
 	{ 0x0001,  0, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0002 (fls 2) */
 	{ 0x0002,  1, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0004 (fls 3) */
 	{ 0x0004,  2, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0008 (fls 4) */
-	{ 0x0016,  4, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0010 (fls 5) */
+	{ 0x0010,  4, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0010 (fls 5) */
 	{ 0x0020,  5, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0020 (fls 6) */
 	{ 0x0040,  6, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0040 (fls 7) */
-	{ 0x0080,  6, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0080 (fls 8) */
-	{ 0x0100,  7, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0100 (fls 9) */
+	{ 0x0080,  7, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0080 (fls 8) */
+	{ 0x0100,  8, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0100 (fls 9) */
 	{ 0x0007,  0, 0xE7, 0xF8, 0xEC, 0xFA }, /* field == 0x0200 (fls 10) */
 	{ 0x0070,  4, 0xE7, 0xF8, 0xEC, 0xFA }, /* field == 0x0400 (fls 11) */
 	{ 0xE000, 13, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0800 (fls 12) */
-- 
1.7.3.4


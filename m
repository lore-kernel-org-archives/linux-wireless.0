Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:39343 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0C1WxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 18:53:13 -0400
Received: by fxm23 with SMTP id 23so424568fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 15:53:11 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/5] b43: N-PHY: some dummy PHY rev 3 calls
Date: Mon, 29 Mar 2010 00:53:12 +0200
Message-Id: <1269816796-26820-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6fd140a..0586667 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -254,6 +254,16 @@ static void b43_radio_init2055(struct b43_wldev *dev)
 }
 
 /*
+ * Initialize a Broadcom 2056 N-radio
+ * http://bcm-v4.sipsolutions.net/802.11/Radio/2056/Init
+ */
+static void b43_radio_init2056(struct b43_wldev *dev)
+{
+	/* TODO */
+}
+
+
+/*
  * Upload the N-PHY tables.
  * http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables
  */
@@ -3473,6 +3483,8 @@ static void b43_nphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 					bool blocked)
 {
+	struct b43_phy_n *nphy = dev->phy.n;
+
 	if (b43_read32(dev, B43_MMIO_MACCTL) & B43_MACCTL_ENABLED)
 		b43err(dev->wl, "MAC not suspended\n");
 
@@ -3498,8 +3510,8 @@ static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 		}
 	} else {
 		if (dev->phy.rev >= 3) {
-			/* TODO: b43_radio_init2056(dev); */
-			/* TODO: PHY Set Channel Spec (dev, radio_chanspec) */
+			b43_radio_init2056(dev);
+			b43_nphy_set_chanspec(dev, nphy->radio_chanspec);
 		} else {
 			b43_radio_init2055(dev);
 		}
-- 
1.6.4.2


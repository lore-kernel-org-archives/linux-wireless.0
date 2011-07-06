Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52007 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1GFRtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 13:49:04 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so308521fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 10:49:03 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: read radio ID on new cores
Date: Wed,  6 Jul 2011 20:27:25 +0200
Message-Id: <1309976845-19588-2-git-send-email-zajec5@gmail.com> (sfid-20110706_194907_881887_85A693E5)
In-Reply-To: <1309976845-19588-1-git-send-email-zajec5@gmail.com>
References: <1309976845-19588-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 074765a..bff0870 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4219,7 +4219,19 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 
 	/* Get RADIO versioning */
 	if (dev->dev->core_rev >= 24) {
-		/* TODO */
+		u16 radio24[3];
+
+		for (tmp = 0; tmp < 3; tmp++) {
+			b43_write16(dev, B43_MMIO_RADIO24_CONTROL, tmp);
+			radio24[tmp] = b43_read16(dev, B43_MMIO_RADIO24_DATA);
+		}
+
+		/* Broadcom uses "id" for our "ver" and has separated "ver" */
+		/* radio_ver = (radio24[0] & 0xF0) >> 4; */
+
+		radio_manuf = 0x17F;
+		radio_ver = (radio24[2] << 8) | radio24[1];
+		radio_rev = (radio24[0] & 0xF);
 	} else {
 		if (dev->dev->chip_id == 0x4317) {
 			if (dev->dev->chip_rev == 0)
-- 
1.7.3.4


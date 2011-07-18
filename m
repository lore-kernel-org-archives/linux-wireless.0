Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:41224 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab1GQXXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 19:23:04 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so5569858fxd.11
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 16:23:03 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: bcma: read info about supported bands
Date: Mon, 18 Jul 2011 02:01:30 +0200
Message-Id: <1310947290-3099-3-git-send-email-zajec5@gmail.com> (sfid-20110718_012308_692915_E2522392)
In-Reply-To: <1310947290-3099-1-git-send-email-zajec5@gmail.com>
References: <1310947290-3099-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 549555e..9afb4eb 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4948,6 +4948,7 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	struct b43_wl *wl = dev->wl;
 	struct pci_dev *pdev = NULL;
 	int err;
+	u32 tmp;
 	bool have_2ghz_phy = 0, have_5ghz_phy = 0;
 
 	/* Do NOT do any device initialization here.
@@ -4973,17 +4974,17 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		/* FIXME */
-		have_2ghz_phy = 1;
-		have_5ghz_phy = 0;
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOST);
+		have_2ghz_phy = !!(tmp & B43_BCMA_IOST_2G_PHY);
+		have_5ghz_phy = !!(tmp & B43_BCMA_IOST_5G_PHY);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		if (dev->dev->core_rev >= 5) {
-			u32 tmshigh = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
-			have_2ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY);
-			have_5ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_5GHZ_PHY);
+			tmp = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
+			have_2ghz_phy = !!(tmp & B43_TMSHIGH_HAVE_2GHZ_PHY);
+			have_5ghz_phy = !!(tmp & B43_TMSHIGH_HAVE_5GHZ_PHY);
 		} else
 			B43_WARN_ON(1);
 		break;
-- 
1.7.3.4


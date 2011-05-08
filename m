Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55075 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab1EHQby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 12:31:54 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so1350122eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 09:31:54 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43legacy: drop ssb-duplicated workaround for dangling cores
Date: Sun,  8 May 2011 19:09:24 +0200
Message-Id: <1304874564-6426-4-git-send-email-zajec5@gmail.com> (sfid-20110508_183158_658801_C24CBAAC)
In-Reply-To: <1304874564-6426-1-git-send-email-zajec5@gmail.com>
References: <1304874564-6426-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43legacy/main.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 2162663..f6d5446 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3696,26 +3696,8 @@ static int b43legacy_one_core_attach(struct ssb_device *dev,
 				     struct b43legacy_wl *wl)
 {
 	struct b43legacy_wldev *wldev;
-	struct pci_dev *pdev;
 	int err = -ENOMEM;
 
-	if (!list_empty(&wl->devlist)) {
-		/* We are not the first core on this chip. */
-		pdev = (dev->bus->bustype == SSB_BUSTYPE_PCI) ? dev->bus->host_pci : NULL;
-		/* Only special chips support more than one wireless
-		 * core, although some of the other chips have more than
-		 * one wireless core as well. Check for this and
-		 * bail out early.
-		 */
-		if (!pdev ||
-		    ((pdev->device != 0x4321) &&
-		     (pdev->device != 0x4313) &&
-		     (pdev->device != 0x431A))) {
-			b43legacydbg(wl, "Ignoring unconnected 802.11 core\n");
-			return -ENODEV;
-		}
-	}
-
 	wldev = kzalloc(sizeof(*wldev), GFP_KERNEL);
 	if (!wldev)
 		goto out;
-- 
1.7.3.4


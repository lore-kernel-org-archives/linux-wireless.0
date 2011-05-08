Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43401 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab1EHRw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 13:52:58 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so1358556eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 10:52:58 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 2/3] b43: drop ssb-duplicated workaround for dangling cores
Date: Sun,  8 May 2011 20:30:32 +0200
Message-Id: <1304879433-7096-3-git-send-email-zajec5@gmail.com> (sfid-20110508_195302_091115_4A90D14E)
In-Reply-To: <1304879433-7096-1-git-send-email-zajec5@gmail.com>
References: <1304879433-7096-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the code to detect inactive 802.11 cores, as that function is now done
in ssb.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index f907df0..b02fbab 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4837,25 +4837,8 @@ static void b43_one_core_detach(struct ssb_device *dev)
 static int b43_one_core_attach(struct ssb_device *dev, struct b43_wl *wl)
 {
 	struct b43_wldev *wldev;
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
-		     (pdev->device != 0x4313) && (pdev->device != 0x431A))) {
-			b43dbg(wl, "Ignoring unconnected 802.11 core\n");
-			return -ENODEV;
-		}
-	}
-
 	wldev = kzalloc(sizeof(*wldev), GFP_KERNEL);
 	if (!wldev)
 		goto out;
-- 
1.7.3.4


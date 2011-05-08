Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57588 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab1EHQbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 12:31:52 -0400
Received: by ewy4 with SMTP id 4so1351591ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 09:31:51 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: drop ssb-duplicated workaround for dangling cores
Date: Sun,  8 May 2011 19:09:23 +0200
Message-Id: <1304874564-6426-3-git-send-email-zajec5@gmail.com> (sfid-20110508_183156_991710_241EA64C)
In-Reply-To: <1304874564-6426-1-git-send-email-zajec5@gmail.com>
References: <1304874564-6426-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


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


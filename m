Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:56387 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1GVKcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 06:32:32 -0400
Received: by fxd18 with SMTP id 18so5086698fxd.11
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2011 03:32:31 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2 3.1] b43: bus: fix memory corruption when setting driver's data
Date: Fri, 22 Jul 2011 13:11:04 +0200
Message-Id: <1311333065-12561-1-git-send-email-zajec5@gmail.com> (sfid-20110722_123234_253091_9C69331B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes bug described in:
https://bugzilla.kernel.org/show_bug.cgi?id=39172

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: this is trivial and fixes quite ugly memory (linked list exactly)
corruption. I believe this fix should be taken for 3.1.
---
 drivers/net/wireless/b43/bus.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 64c3f65..05f6c7b 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -244,10 +244,12 @@ void b43_bus_set_wldev(struct b43_bus_dev *dev, void *wldev)
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
 		bcma_set_drvdata(dev->bdev, wldev);
+		break;
 #endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		ssb_set_drvdata(dev->sdev, wldev);
+		break;
 #endif
 	}
 }
-- 
1.7.3.4


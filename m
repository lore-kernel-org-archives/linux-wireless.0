Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45431 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbZIBXez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 19:34:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 16:34:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: propagate ieee80211_alloc_hw() failure
Date: Wed, 2 Sep 2009 16:34:57 -0700
Message-ID: <1251934497-15769-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The -ENOMEM was never being passed on failure.
While at it use dev_err() as ahb does upon failure.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 685a8ce..17862cc 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -160,8 +160,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hw = ieee80211_alloc_hw(sizeof(struct ath_wiphy) +
 				sizeof(struct ath_softc), &ath9k_ops);
-	if (hw == NULL) {
-		printk(KERN_ERR "ath_pci: no memory for ieee80211_hw\n");
+	if (!hw) {
+		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
+		ret = -ENOMEM;
 		goto bad2;
 	}
 
-- 
1.6.3.3


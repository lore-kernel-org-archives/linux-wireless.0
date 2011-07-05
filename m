Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:59159 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1GEVPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 17:15:42 -0400
Received: by fxd18 with SMTP id 18so6553855fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 14:15:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: make b43_wireless_init bus generic
Date: Tue,  5 Jul 2011 23:54:07 +0200
Message-Id: <1309902848-3141-1-git-send-email-zajec5@gmail.com> (sfid-20110705_231546_525939_C3FE58AD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 834df5a..410b77f 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4959,9 +4959,9 @@ static void b43_wireless_exit(struct b43_bus_dev *dev, struct b43_wl *wl)
 	ieee80211_free_hw(hw);
 }
 
-static struct b43_wl *b43_wireless_init(struct ssb_device *dev)
+static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 {
-	struct ssb_sprom *sprom = &dev->bus->sprom;
+	struct ssb_sprom *sprom = dev->bus_sprom;
 	struct ieee80211_hw *hw;
 	struct b43_wl *wl;
 
@@ -5003,7 +5003,7 @@ static struct b43_wl *b43_wireless_init(struct ssb_device *dev)
 	skb_queue_head_init(&wl->tx_queue);
 
 	b43info(wl, "Broadcom %04X WLAN found (core revision %u)\n",
-		dev->bus->chip_id, dev->id.revision);
+		dev->chip_id, dev->core_rev);
 	return wl;
 }
 
@@ -5045,7 +5045,7 @@ int b43_ssb_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
 		/* Probing the first core. Must setup common struct b43_wl */
 		first = 1;
 		b43_sprom_fixup(sdev->bus);
-		wl = b43_wireless_init(sdev);
+		wl = b43_wireless_init(dev);
 		if (IS_ERR(wl)) {
 			err = PTR_ERR(wl);
 			goto out;
-- 
1.7.3.4


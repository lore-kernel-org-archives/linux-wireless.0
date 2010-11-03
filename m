Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51670 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0KCW33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 18:29:29 -0400
Received: by wwe15 with SMTP id 15so1307211wwe.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 15:29:28 -0700 (PDT)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?utf-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: return -ENOMEM on alloc fail (instead of CRC check's result)
Date: Wed,  3 Nov 2010 23:28:45 +0100
Message-Id: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: it's for 2.6.38.
---
 drivers/ssb/pci.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 3226832..b5343ac 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -619,7 +619,7 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
 			     struct ssb_sprom *sprom)
 {
 	const struct ssb_sprom *fallback;
-	int err = -ENOMEM;
+	int err;
 	u16 *buf;
 
 	if (!ssb_is_sprom_available(bus)) {
@@ -646,7 +646,7 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
 
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
-		goto out;
+		return -ENOMEM;
 	bus->sprom_size = SSB_SPROMSIZE_WORDS_R123;
 	sprom_do_read(bus, buf);
 	err = sprom_check_crc(buf, bus->sprom_size);
@@ -656,7 +656,7 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
 		buf = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
 			      GFP_KERNEL);
 		if (!buf)
-			goto out;
+			return -ENOMEM;
 		bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
 		sprom_do_read(bus, buf);
 		err = sprom_check_crc(buf, bus->sprom_size);
@@ -678,7 +678,6 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
 
 out_free:
 	kfree(buf);
-out:
 	return err;
 }
 
-- 
1.6.0.4


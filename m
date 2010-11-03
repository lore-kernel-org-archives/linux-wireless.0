Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57788 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab0KCUgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 16:36:55 -0400
Received: by wwe15 with SMTP id 15so1147379wwe.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 13:36:54 -0700 (PDT)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43legacy: rfkill: use status register based on core revision (not PHY's)
Date: Wed,  3 Nov 2010 21:36:12 +0100
Message-Id: <1288816572-12743-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
With this patch we follow specs. I hope this will fix bug where radio was
magically auto-turning on/off. Unfortunately I didn't get answer from reporter
of that issue.

John: I suggest taking it for 2.6.38
---
 drivers/net/wireless/b43legacy/rfkill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/rfkill.c b/drivers/net/wireless/b43legacy/rfkill.c
index d579df7..b90f223 100644
--- a/drivers/net/wireless/b43legacy/rfkill.c
+++ b/drivers/net/wireless/b43legacy/rfkill.c
@@ -29,7 +29,7 @@
 /* Returns TRUE, if the radio is enabled in hardware. */
 bool b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev)
 {
-	if (dev->phy.rev >= 3) {
+	if (dev->dev->id.revision >= 3) {
 		if (!(b43legacy_read32(dev, B43legacy_MMIO_RADIO_HWENABLED_HI)
 		      & B43legacy_MMIO_RADIO_HWENABLED_HI_MASK))
 			return 1;
-- 
1.6.0.4


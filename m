Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55074 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab0JVUXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 16:23:33 -0400
Received: by ewy7 with SMTP id 7so1720018ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 13:23:32 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: rfkill: use status register based on core revision not (PHY's)
Date: Fri, 22 Oct 2010 22:24:05 +0200
Message-Id: <1287779045-20257-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This makes my N-PHY radio at least running (no scanning results so far). The
same register is used by wl on this device.
---
 drivers/net/wireless/b43/rfkill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index 78016ae..d2734c9 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -28,7 +28,7 @@
 /* Returns TRUE, if the radio is enabled in hardware. */
 bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 {
-	if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
+	if (dev->dev->id.revision >= 3) {
 		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
 		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
 			return 1;
-- 
1.7.1


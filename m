Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:56601 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZHLUjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 16:39:45 -0400
Received: by fxm28 with SMTP id 28so245352fxm.17
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 13:39:45 -0700 (PDT)
Message-ID: <4A832890.9010408@gmail.com>
Date: Wed, 12 Aug 2009 22:39:44 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: Update dummy transmission to match V4 specs
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The V4 dummy transmission function has two extra bools in its
prototype, so add a wrapper function for callers that expect the
V3 version.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/main.c |   60 ++++++++++++++++++++++++++++-----------
 drivers/net/wireless/b43/main.h |    1 +
 2 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index cb4a871..80bc962 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -683,11 +683,29 @@ static void b43_synchronize_irq(struct b43_wldev *dev)
 	tasklet_kill(&dev->isr_tasklet);
 }
 
-/* DummyTransmission function, as documented on
- * http://bcm-specs.sipsolutions.net/DummyTransmission
+/* Wrapper for callers of the old V3 dummy transmission function
+ * Please don't use this in new code, call the v4 routine directly instead.
  */
 void b43_dummy_transmission(struct b43_wldev *dev)
 {
+	switch (dev->phy.type) {
+	case B43_PHYTYPE_A:
+		b43_dummy_transmission_v4(dev, true, true);
+		break;
+	case B43_PHYTYPE_B:
+	case B43_PHYTYPE_G:
+		b43_dummy_transmission_v4(dev, false, true);
+		break;
+	default:
+		B43_WARN_ON(1);
+	}
+}
+
+/* DummyTransmission function, as documented on
+ * http://bcm-v4.sipsolutions.net/802.11/DummyTransmission
+ */
+void b43_dummy_transmission_v4(struct b43_wldev *dev, bool ofdm, bool pa_on)
+{
 	struct b43_wl *wl = dev->wl;
 	struct b43_phy *phy = &dev->phy;
 	unsigned int i, max_loop;
@@ -700,19 +718,12 @@ void b43_dummy_transmission(struct b43_wldev *dev)
 		0x00000000,
 	};
 
-	switch (phy->type) {
-	case B43_PHYTYPE_A:
+	if (ofdm) {
 		max_loop = 0x1E;
 		buffer[0] = 0x000201CC;
-		break;
-	case B43_PHYTYPE_B:
-	case B43_PHYTYPE_G:
+	} else {
 		max_loop = 0xFA;
 		buffer[0] = 0x000B846E;
-		break;
-	default:
-		B43_WARN_ON(1);
-		return;
 	}
 
 	spin_lock_irq(&wl->irq_lock);
@@ -721,20 +732,35 @@ void b43_dummy_transmission(struct b43_wldev *dev)
 	for (i = 0; i < 5; i++)
 		b43_ram_write(dev, i * 4, buffer[i]);
 
-	/* Commit writes */
-	b43_read32(dev, B43_MMIO_MACCTL);
-
 	b43_write16(dev, 0x0568, 0x0000);
-	b43_write16(dev, 0x07C0, 0x0000);
-	value = ((phy->type == B43_PHYTYPE_A) ? 1 : 0);
+	if (dev->dev->id.revision < 11)
+		b43_write16(dev, 0x07C0, 0x0000);
+	else
+		b43_write16(dev, 0x07C0, 0x0100);
+	value = (ofdm ? 0x41 : 0x40);
 	b43_write16(dev, 0x050C, value);
+	if ((phy->type == B43_PHYTYPE_N) || (phy->type == B43_PHYTYPE_LP))
+		b43_write16(dev, 0x0514, 0x1A02);
 	b43_write16(dev, 0x0508, 0x0000);
 	b43_write16(dev, 0x050A, 0x0000);
 	b43_write16(dev, 0x054C, 0x0000);
 	b43_write16(dev, 0x056A, 0x0014);
 	b43_write16(dev, 0x0568, 0x0826);
 	b43_write16(dev, 0x0500, 0x0000);
-	b43_write16(dev, 0x0502, 0x0030);
+	if (!pa_on && (phy->type == B43_PHYTYPE_N)) {
+		//SPEC TODO
+	}
+
+	switch (phy->type) {
+	case B43_PHYTYPE_N:
+		b43_write16(dev, 0x0502, 0x00D0);
+		break;
+	case B43_PHYTYPE_LP:
+		b43_write16(dev, 0x0502, 0x0050);
+		break;
+	default:
+		b43_write16(dev, 0x0502, 0x0030);
+	}
 
 	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
 		b43_radio_write16(dev, 0x0051, 0x0017);
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index 40abcf5..7f26fd9 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -125,6 +125,7 @@ u64 b43_hf_read(struct b43_wldev *dev);
 void b43_hf_write(struct b43_wldev *dev, u64 value);
 
 void b43_dummy_transmission(struct b43_wldev *dev);
+void b43_dummy_transmission_v4(struct b43_wldev *dev, bool ofdm, bool pa_on);
 
 void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags);
 
-- 
1.6.2.4




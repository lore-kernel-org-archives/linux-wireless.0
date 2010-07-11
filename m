Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41261 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab0GKKcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:02 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so426224eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:01 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/17] rt2x00: Fix vgc_level_reg handling
Date: Sun, 11 Jul 2010 12:25:17 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111224.23529.IvDoorn@gmail.com> <201007111224.48247.IvDoorn@gmail.com>
In-Reply-To: <201007111224.48247.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111225.18986.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently vgc_level_reg and vgc_level are equal to eachother,
while the purpose of vgc_level_reg is the value last written
to the register and is remembered through link tuning resets.
The vgc_level is the currently active level, which is
reset during link tuning resets.

The usage of these variables depends on the drivers, some drivers
need both, while others need only one of the two.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c  |    8 +++++---
 drivers/net/wireless/rt2x00/rt2500pci.c  |    8 +++-----
 drivers/net/wireless/rt2x00/rt2x00link.c |    8 ++++++++
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index d5f1fab..25e9dcf 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -586,9 +586,11 @@ static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev,
 static inline void rt2400pci_set_vgc(struct rt2x00_dev *rt2x00dev,
 				     struct link_qual *qual, u8 vgc_level)
 {
-	rt2400pci_bbp_write(rt2x00dev, 13, vgc_level);
-	qual->vgc_level = vgc_level;
-	qual->vgc_level_reg = vgc_level;
+	if (qual->vgc_level_reg != vgc_level) {
+		rt2400pci_bbp_write(rt2x00dev, 13, vgc_level);
+		qual->vgc_level = vgc_level;
+		qual->vgc_level_reg = vgc_level;
+	}
 }
 
 static void rt2400pci_reset_tuner(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 096d6db..faa804c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -626,6 +626,7 @@ static inline void rt2500pci_set_vgc(struct rt2x00_dev *rt2x00dev,
 {
 	if (qual->vgc_level_reg != vgc_level) {
 		rt2500pci_bbp_write(rt2x00dev, 17, vgc_level);
+		qual->vgc_level = vgc_level;
 		qual->vgc_level_reg = vgc_level;
 	}
 }
@@ -700,13 +701,10 @@ dynamic_cca_tune:
 	 * R17 is inside the dynamic tuning range,
 	 * start tuning the link based on the false cca counter.
 	 */
-	if (qual->false_cca > 512 && qual->vgc_level_reg < 0x40) {
+	if (qual->false_cca > 512 && qual->vgc_level_reg < 0x40)
 		rt2500pci_set_vgc(rt2x00dev, qual, ++qual->vgc_level_reg);
-		qual->vgc_level = qual->vgc_level_reg;
-	} else if (qual->false_cca < 100 && qual->vgc_level_reg > 0x32) {
+	else if (qual->false_cca < 100 && qual->vgc_level_reg > 0x32)
 		rt2500pci_set_vgc(rt2x00dev, qual, --qual->vgc_level_reg);
-		qual->vgc_level = qual->vgc_level_reg;
-	}
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 14f1d51..9acfc5c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -302,6 +302,7 @@ void rt2x00link_stop_tuner(struct rt2x00_dev *rt2x00dev)
 void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna)
 {
 	struct link_qual *qual = &rt2x00dev->link.qual;
+	u8 vgc_level = qual->vgc_level_reg;
 
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return;
@@ -318,6 +319,13 @@ void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna)
 	memset(qual, 0, sizeof(*qual));
 
 	/*
+	 * Restore the VGC level as stored in the registers,
+	 * the driver can use this to determine if the register
+	 * must be updated during reset or not.
+	 */
+	qual->vgc_level_reg = vgc_level;
+
+	/*
 	 * Reset the link tuner.
 	 */
 	rt2x00dev->ops->lib->reset_tuner(rt2x00dev, qual);
-- 
1.7.1.1


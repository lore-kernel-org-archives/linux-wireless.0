Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:50091 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab3JCSAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 14:00:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/4] rt2x00: rt2800lib: fix VGC adjustment for RT5592
Date: Thu,  3 Oct 2013 20:00:40 +0200
Message-Id: <1380823243-11149-1-git-send-email-juhosg@openwrt.org> (sfid-20131003_200058_978127_D28FCB88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 3d81535ea5940446510a8a5cee1c6ad23c90c753
(rt2800: 5592: add chip specific vgc calculations)
the rt2800_link_tuner function has been modified to
adjust VGC level for the RT5592 chipset.

On the RT5592 chipset, the VGC level must be adjusted
only if rssi is greater than -65. However the current
code adjusts the VGC value by 0x10 regardless of the
actual chipset if the rssi value is between -80 and
-65.

Fix the broken behaviour by reordering the if-else
statements.

Cc: stable@vger.kernel.org
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f414978..2690081 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4469,10 +4469,13 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 
 	vgc = rt2800_get_default_vgc(rt2x00dev);
 
-	if (rt2x00_rt(rt2x00dev, RT5592) && qual->rssi > -65)
-		vgc += 0x20;
-	else if (qual->rssi > -80)
-		vgc += 0x10;
+	if (rt2x00_rt(rt2x00dev, RT5592)) {
+		if (qual->rssi > -65)
+			vgc += 0x20;
+	} else {
+		if (qual->rssi > -80)
+			vgc += 0x10;
+	}
 
 	rt2800_set_vgc(rt2x00dev, qual, vgc);
 }
-- 
1.7.10

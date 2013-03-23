Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54813 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab3CWRHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 13:07:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] b43: use constants
Date: Sat, 23 Mar 2013 18:07:02 +0100
Message-Id: <1364058422-20813-1-git-send-email-hauke@hauke-m.de> (sfid-20130323_180730_911984_28013557)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of defining the magic values in the code use constants.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/b43.h  |    2 ++
 drivers/net/wireless/b43/main.c |   16 +++++++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index fe4a77e..f5e8401 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -285,7 +285,9 @@ enum {
 #define B43_SHM_SH_DTIMPER		0x0012	/* DTIM period */
 #define B43_SHM_SH_NOSLPZNATDTIM	0x004C	/* NOSLPZNAT DTIM */
 /* SHM_SHARED beacon/AP variables */
+#define B43_SHM_SH_BT_BASE0		0x0068	/* Beacon template base 0 */
 #define B43_SHM_SH_BTL0			0x0018	/* Beacon template length 0 */
+#define B43_SHM_SH_BT_BASE1		0x0468	/* Beacon template base 1 */
 #define B43_SHM_SH_BTL1			0x001A	/* Beacon template length 1 */
 #define B43_SHM_SH_BTSFOFF		0x001C	/* Beacon TSF offset */
 #define B43_SHM_SH_TIMBPOS		0x001E	/* TIM B position in beacon */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index ae4eeb3..4ac73d2 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1310,17 +1310,19 @@ static u32 b43_jssi_read(struct b43_wldev *dev)
 {
 	u32 val = 0;
 
-	val = b43_shm_read16(dev, B43_SHM_SHARED, 0x08A);
+	val = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_JSSI1);
 	val <<= 16;
-	val |= b43_shm_read16(dev, B43_SHM_SHARED, 0x088);
+	val |= b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_JSSI0);
 
 	return val;
 }
 
 static void b43_jssi_write(struct b43_wldev *dev, u32 jssi)
 {
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x088, (jssi & 0x0000FFFF));
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x08A, (jssi & 0xFFFF0000) >> 16);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_JSSI0,
+			(jssi & 0x0000FFFF));
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_JSSI1,
+			(jssi & 0xFFFF0000) >> 16);
 }
 
 static void b43_generate_noise_sample(struct b43_wldev *dev)
@@ -1623,7 +1625,7 @@ static void b43_upload_beacon0(struct b43_wldev *dev)
 
 	if (wl->beacon0_uploaded)
 		return;
-	b43_write_beacon_template(dev, 0x68, 0x18);
+	b43_write_beacon_template(dev, B43_SHM_SH_BT_BASE0, B43_SHM_SH_BTL0);
 	wl->beacon0_uploaded = true;
 }
 
@@ -1633,7 +1635,7 @@ static void b43_upload_beacon1(struct b43_wldev *dev)
 
 	if (wl->beacon1_uploaded)
 		return;
-	b43_write_beacon_template(dev, 0x468, 0x1A);
+	b43_write_beacon_template(dev, B43_SHM_SH_BT_BASE1, B43_SHM_SH_BTL1);
 	wl->beacon1_uploaded = true;
 }
 
@@ -3113,7 +3115,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 
 	/* Probe Response Timeout value */
 	/* FIXME: Default to 0, has to be set by ioctl probably... :-/ */
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x0074, 0x0000);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRMAXTIME, 0);
 
 	/* Initially set the wireless operation mode. */
 	b43_adjust_opmode(dev);
-- 
1.7.10.4


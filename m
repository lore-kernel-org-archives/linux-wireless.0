Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63183 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1BQAqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 19:46:08 -0500
Received: by eye27 with SMTP id 27so1161194eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 16:46:07 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: when needed, reject IM input while disabling device
Date: Thu, 17 Feb 2011 01:50:50 +0100
Message-Id: <1297903851-5499-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1297903851-5499-1-git-send-email-zajec5@gmail.com>
References: <1297903851-5499-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/main.c           |   16 +++++++++++++++-
 include/linux/ssb/ssb_regs.h |    2 ++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 08fed55..5b6160a 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1220,7 +1220,7 @@ static int ssb_wait_bits(struct ssb_device *dev, u16 reg, u32 bitmask,
 
 void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags)
 {
-	u32 reject;
+	u32 reject, val;
 
 	if (ssb_read32(dev, SSB_TMSLOW) & SSB_TMSLOW_RESET)
 		return;
@@ -1229,12 +1229,26 @@ void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags)
 	ssb_write32(dev, SSB_TMSLOW, reject | SSB_TMSLOW_CLOCK);
 	ssb_wait_bits(dev, SSB_TMSLOW, reject, 1000, 1);
 	ssb_wait_bits(dev, SSB_TMSHIGH, SSB_TMSHIGH_BUSY, 1000, 0);
+
+	if (ssb_read32(dev, SSB_IDLOW) & SSB_IDLOW_INITIATOR) {
+		val = ssb_read32(dev, SSB_IMSTATE);
+		val |= SSB_IMSTATE_REJECT;
+		ssb_write32(dev, SSB_IMSTATE, val);
+		ssb_wait_bits(dev, SSB_IMSTATE, SSB_IMSTATE_BUSY, 1000, 0);
+	}
+
 	ssb_write32(dev, SSB_TMSLOW,
 		    SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 		    reject | SSB_TMSLOW_RESET |
 		    core_specific_flags);
 	ssb_flush_tmslow(dev);
 
+	if (ssb_read32(dev, SSB_IDLOW) & SSB_IDLOW_INITIATOR) {
+		val = ssb_read32(dev, SSB_IMSTATE);
+		val &= ~SSB_IMSTATE_REJECT;
+		ssb_write32(dev, SSB_IMSTATE, val);
+	}
+
 	ssb_write32(dev, SSB_TMSLOW,
 		    reject | SSB_TMSLOW_RESET |
 		    core_specific_flags);
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 489f7b6..8ac6346 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -85,6 +85,8 @@
 #define  SSB_IMSTATE_AP_RSV	0x00000030 /* Reserved */
 #define  SSB_IMSTATE_IBE	0x00020000 /* In Band Error */
 #define  SSB_IMSTATE_TO		0x00040000 /* Timeout */
+#define  SSB_IMSTATE_BUSY	0x01800000 /* Busy (Backplane rev >= 2.3 only) */
+#define  SSB_IMSTATE_REJECT	0x02000000 /* Reject (Backplane rev >= 2.3 only) */
 #define SSB_INTVEC		0x0F94     /* SB Interrupt Mask */
 #define  SSB_INTVEC_PCI		0x00000001 /* Enable interrupts for PCI */
 #define  SSB_INTVEC_ENET0	0x00000002 /* Enable interrupts for enet 0 */
-- 
1.7.3.4


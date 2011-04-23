Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63182 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1DWQxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Apr 2011 12:53:13 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so920863bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Apr 2011 09:53:12 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] ssb: update reject bit for Target State Low
Date: Sat, 23 Apr 2011 19:30:29 +0200
Message-Id: <1303579829-2478-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1303579829-2478-1-git-send-email-zajec5@gmail.com>
References: <1303579829-2478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My 14e4:4315 is SSB_IDLOW_SSBREV_26:
read32 0xfaafcff8 -> 0x600422d5
My 14e4:4328 is SSB_IDLOW_SSBREV_24:
read32 0xfaafcff8 -> 0x400422c5
My 14e4:432b is SSB_IDLOW_SSBREV_26 again:
read32 0xfaafcff8 -> 0x600422d5

For all of them wl driver is using 0x2 reject bit:
write32(0xf98) <- 0x00010002
So it seems SSB 2.3 is the exception using another bit.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/main.c           |   15 +++++++--------
 include/linux/ssb/ssb_regs.h |    2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 74aa2cc..ad3da93 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1117,23 +1117,22 @@ static u32 ssb_tmslow_reject_bitmask(struct ssb_device *dev)
 {
 	u32 rev = ssb_read32(dev, SSB_IDLOW) & SSB_IDLOW_SSBREV;
 
-	/* The REJECT bit changed position in TMSLOW between
-	 * Backplane revisions. */
+	/* The REJECT bit seems to be different for Backplane rev 2.3 */
 	switch (rev) {
 	case SSB_IDLOW_SSBREV_22:
-		return SSB_TMSLOW_REJECT_22;
+	case SSB_IDLOW_SSBREV_24:
+	case SSB_IDLOW_SSBREV_26:
+		return SSB_TMSLOW_REJECT;
 	case SSB_IDLOW_SSBREV_23:
 		return SSB_TMSLOW_REJECT_23;
-	case SSB_IDLOW_SSBREV_24:     /* TODO - find the proper REJECT bits */
-	case SSB_IDLOW_SSBREV_25:     /* same here */
-	case SSB_IDLOW_SSBREV_26:     /* same here */
+	case SSB_IDLOW_SSBREV_25:     /* TODO - find the proper REJECT bit */
 	case SSB_IDLOW_SSBREV_27:     /* same here */
-		return SSB_TMSLOW_REJECT_23;	/* this is a guess */
+		return SSB_TMSLOW_REJECT;	/* this is a guess */
 	default:
 		printk(KERN_INFO "ssb: Backplane Revision 0x%.8X\n", rev);
 		WARN_ON(1);
 	}
-	return (SSB_TMSLOW_REJECT_22 | SSB_TMSLOW_REJECT_23);
+	return (SSB_TMSLOW_REJECT | SSB_TMSLOW_REJECT_23);
 }
 
 int ssb_device_is_enabled(struct ssb_device *dev)
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 402955a..efbf459 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -97,7 +97,7 @@
 #define  SSB_INTVEC_ENET1	0x00000040 /* Enable interrupts for enet 1 */
 #define SSB_TMSLOW		0x0F98     /* SB Target State Low */
 #define  SSB_TMSLOW_RESET	0x00000001 /* Reset */
-#define  SSB_TMSLOW_REJECT_22	0x00000002 /* Reject (Backplane rev 2.2) */
+#define  SSB_TMSLOW_REJECT	0x00000002 /* Reject (Standard Backplane) */
 #define  SSB_TMSLOW_REJECT_23	0x00000004 /* Reject (Backplane rev 2.3) */
 #define  SSB_TMSLOW_CLOCK	0x00010000 /* Clock Enable */
 #define  SSB_TMSLOW_FGC		0x00020000 /* Force Gated Clocks On */
-- 
1.7.3.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49474 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab2EaUie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 16:38:34 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] ssb: recognize ARM Cortex M3
Date: Thu, 31 May 2012 22:38:22 +0200
Message-Id: <1338496702-16324-1-git-send-email-hauke@hauke-m.de> (sfid-20120531_223838_443027_32131B0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found this core on a BCM4322, a PCI card in the Linksys WRT610N V1.
This core is not used by the driver, this patch just makes ssb show the
correct name.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/scan.c      |    2 ++
 include/linux/ssb/ssb.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index 266c7c5..ab4627c 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -90,6 +90,8 @@ const char *ssb_core_name(u16 coreid)
 		return "ARM 1176";
 	case SSB_DEV_ARM_7TDMI:
 		return "ARM 7TDMI";
+	case SSB_DEV_ARM_CM3:
+		return "ARM Cortex M3";
 	}
 	return "UNKNOWN";
 }
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index bc14bd7..bb674c0 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -243,6 +243,7 @@ struct ssb_bus_ops {
 #define SSB_DEV_MINI_MACPHY	0x823
 #define SSB_DEV_ARM_1176	0x824
 #define SSB_DEV_ARM_7TDMI	0x825
+#define SSB_DEV_ARM_CM3		0x82A
 
 /* Vendor-ID values */
 #define SSB_VENDOR_BROADCOM	0x4243
-- 
1.7.9.5


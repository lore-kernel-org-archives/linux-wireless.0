Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2698 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1FISHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 14:07:41 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: "Arend van Spriel" <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, "Rafal Milecki" <zajec5@gmail.com>
Subject: [PATCH] drivers: bcma: export bcma_core_disable() function
Date: Thu, 9 Jun 2011 20:07:20 +0200
Message-ID: <1307642840-3043-1-git-send-email-arend@broadcom.com> (sfid-20110609_200744_317564_E86095B8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the brcm80211 driver we disable the 80211 core when the driver is
'down'. The bcma_core_disable() function exactly does the same as
our implementation so exporting this function makes sense.

Cc: linux-wireless@vger.kernel.org
Cc: Rafal Milecki <zajec5@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/bcma/core.c       |    3 ++-
 include/linux/bcma/bcma.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index ced379f..1ec7d45 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -19,7 +19,7 @@ bool bcma_core_is_enabled(struct bcma_device *core)
 }
 EXPORT_SYMBOL_GPL(bcma_core_is_enabled);
 
-static void bcma_core_disable(struct bcma_device *core, u32 flags)
+void bcma_core_disable(struct bcma_device *core, u32 flags)
 {
 	if (bcma_aread32(core, BCMA_RESET_CTL) & BCMA_RESET_CTL_RESET)
 		return;
@@ -31,6 +31,7 @@ static void bcma_core_disable(struct bcma_device *core, u32 flags)
 	bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
 	udelay(1);
 }
+EXPORT_SYMBOL_GPL(bcma_core_disable);
 
 int bcma_core_enable(struct bcma_device *core, u32 flags)
 {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 6ff080e..3895aeb 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -244,6 +244,7 @@ void bcma_awrite32(struct bcma_device *core, u16 offset, u32 value)
 }
 
 extern bool bcma_core_is_enabled(struct bcma_device *core);
+extern void bcma_core_disable(struct bcma_device *core, u32 flags);
 extern int bcma_core_enable(struct bcma_device *core, u32 flags);
 
 #endif /* LINUX_BCMA_H_ */
-- 
1.7.4.1



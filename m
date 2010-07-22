Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54820 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0GVSaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 14:30:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFT] airo: silence sparse warnings
Date: Thu, 22 Jul 2010 14:23:59 -0400
Message-Id: <1279823039-21116-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/airo.c
drivers/net/wireless/airo.c:2053:24: warning: incorrect type in assignment (different base types)
drivers/net/wireless/airo.c:2053:24:    expected restricted __le16 [usertype] status
drivers/net/wireless/airo.c:2053:24:    got unsigned short [unsigned] [usertype] status
drivers/net/wireless/airo.c:3247:18: warning: cast to restricted __le16

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
My airo cards seem to have died...or maybe airo is just broken?

 drivers/net/wireless/airo.c |   50 +++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 053f90c..154554c 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1042,43 +1042,43 @@ typedef struct {
 } HostRidDesc;
 
 typedef struct {
-	u16 sw0;
-	u16 sw1;
-	u16 status;
-	u16 len;
-#define HOST_SET (1 << 0)
-#define HOST_INT_TX (1 << 1) /* Interrupt on successful TX */
-#define HOST_INT_TXERR (1 << 2) /* Interrupt on unseccessful TX */
-#define HOST_LCC_PAYLOAD (1 << 4) /* LLC payload, 0 = Ethertype */
-#define HOST_DONT_RLSE (1 << 5) /* Don't release buffer when done */
-#define HOST_DONT_RETRY (1 << 6) /* Don't retry trasmit */
-#define HOST_CLR_AID (1 << 7) /* clear AID failure */
-#define HOST_RTS (1 << 9) /* Force RTS use */
-#define HOST_SHORT (1 << 10) /* Do short preamble */
-	u16 ctl;
-	u16 aid;
-	u16 retries;
-	u16 fill;
+	__le16 sw0;
+	__le16 sw1;
+	__le16 status;
+	__le16 len;
+#define HOST_SET cpu_to_le16(1 << 0)
+#define HOST_INT_TX cpu_to_le16(1 << 1) /* Interrupt on successful TX */
+#define HOST_INT_TXERR cpu_to_le16(1 << 2) /* Interrupt on unseccessful TX */
+#define HOST_LCC_PAYLOAD cpu_to_le16(1 << 4) /* LLC payload, 0 = Ethertype */
+#define HOST_DONT_RLSE cpu_to_le16(1 << 5) /* Don't release buffer when done */
+#define HOST_DONT_RETRY cpu_to_le16(1 << 6) /* Don't retry trasmit */
+#define HOST_CLR_AID cpu_to_le16(1 << 7) /* clear AID failure */
+#define HOST_RTS cpu_to_le16(1 << 9) /* Force RTS use */
+#define HOST_SHORT cpu_to_le16(1 << 10) /* Do short preamble */
+	__le16 ctl;
+	__le16 aid;
+	__le16 retries;
+	__le16 fill;
 } TxCtlHdr;
 
 typedef struct {
-        u16 ctl;
-        u16 duration;
+        __le16 ctl;
+        __le16 duration;
         char addr1[6];
         char addr2[6];
         char addr3[6];
-        u16 seq;
+        __le16 seq;
         char addr4[6];
 } WifiHdr;
 
 
 typedef struct {
 	TxCtlHdr ctlhdr;
-	u16 fill1;
-	u16 fill2;
+	__le16 fill1;
+	__le16 fill2;
 	WifiHdr wifihdr;
-	u16 gaplen;
-	u16 status;
+	__le16 gaplen;
+	__le16 status;
 } WifiCtlHdr;
 
 static WifiCtlHdr wifictlhdr8023 = {
@@ -3244,7 +3244,7 @@ static void airo_handle_link(struct airo_info *ai)
 	u16 status;
 
 	/* Get new status and acknowledge the link change */
-	status = le16_to_cpu(IN4500(ai, LINKSTAT));
+	status = IN4500(ai, LINKSTAT);
 	OUT4500(ai, EVACK, EV_LINK);
 
 	if ((status == STAT_FORCELOSS) && (ai->scan_timeout > 0))
-- 
1.7.1.1


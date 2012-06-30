Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53886 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab2F3NR7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:17:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 14/18] brcmsmac: extend xmtfifo_sz array
Date: Sat, 30 Jun 2012 15:16:17 +0200
Message-Id: <1341062181-28071-15-git-send-email-hauke@hauke-m.de> (sfid-20120630_151805_437237_2926B56D)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The xmtfifo_sz array contains the queue sizes for the different core
revs. This array missed the sizes for the core rev 17 and 28. This
patch extends the array to also include these sizes and adds a warning
if no queue size is stored in the array for the given core rev.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 547ae5b..46d7646 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -269,7 +269,7 @@ struct brcms_c_bit_desc {
  */
 
 /* Starting corerev for the fifo size table */
-#define XMTFIFOTBL_STARTREV	20
+#define XMTFIFOTBL_STARTREV	17
 
 struct d11init {
 	__le16 addr;
@@ -333,6 +333,12 @@ const u8 wlc_prio2prec_map[] = {
 };
 
 static const u16 xmtfifo_sz[][NFIFO] = {
+	/* corerev 17: 5120, 49152, 49152, 5376, 4352, 1280 */
+	{20, 192, 192, 21, 17, 5},
+	/* corerev 18: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 19: */
+	{0, 0, 0, 0, 0, 0},
 	/* corerev 20: 5120, 49152, 49152, 5376, 4352, 1280 */
 	{20, 192, 192, 21, 17, 5},
 	/* corerev 21: 2304, 14848, 5632, 3584, 3584, 1280 */
@@ -343,6 +349,18 @@ static const u16 xmtfifo_sz[][NFIFO] = {
 	{20, 192, 192, 21, 17, 5},
 	/* corerev 24: 2304, 14848, 5632, 3584, 3584, 1280 */
 	{9, 58, 22, 14, 14, 5},
+	/* corerev 25: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 26: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 27: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 28: 2304, 14848, 5632, 3584, 3584, 1280 */
+	{9, 58, 22, 14, 14, 5},
+	/* corerev 29: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 30: */
+	{0, 0, 0, 0, 0, 0},
 };
 
 #ifdef DEBUG
@@ -4596,8 +4614,12 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 		wlc_hw->machwcap_backup = wlc_hw->machwcap;
 
 		/* init tx fifo size */
+		WARN_ON((wlc_hw->corerev - XMTFIFOTBL_STARTREV) < 0 ||
+			(wlc_hw->corerev - XMTFIFOTBL_STARTREV) >
+				ARRAY_SIZE(xmtfifo_sz));
 		wlc_hw->xmtfifo_sz =
 		    xmtfifo_sz[(wlc_hw->corerev - XMTFIFOTBL_STARTREV)];
+		WARN_ON(!wlc_hw->xmtfifo_sz[0]);
 
 		/* Get a phy for this band */
 		wlc_hw->band->pi =
-- 
1.7.9.5


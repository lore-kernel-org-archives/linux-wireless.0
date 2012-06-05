Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36277 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab2FEXIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:39 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 14/18] brcmsmac: extend xmtfifo_sz array
Date: Wed,  6 Jun 2012 01:07:17 +0200
Message-Id: <1338937641-8519-15-git-send-email-hauke@hauke-m.de> (sfid-20120606_012943_423211_D983DD4B)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The xmtfifo_sz array contains the queue sizes for the different chip
revs. This array missed the sizes for the core rev 17 and 28. This
patch extends the array to also include these sizes and adds a warning
if no queue size is stored in the array for the given core rev.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   38 +++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9aa14e2..35a3db9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -268,7 +268,7 @@ struct brcms_c_bit_desc {
  */
 
 /* Starting corerev for the fifo size table */
-#define XMTFIFOTBL_STARTREV	20
+#define XMTFIFOTBL_STARTREV	10
 
 struct d11init {
 	__le16 addr;
@@ -332,6 +332,26 @@ const u8 wlc_prio2prec_map[] = {
 };
 
 static const u16 xmtfifo_sz[][NFIFO] = {
+	/* corerev 10: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 11: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 12: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 13: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 14: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 15: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 16: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 17: 5120, 49152, 49152, 5376, 4352, 1280 */
+	{20, 192, 192, 21, 17, 5},
+	/* corerev 18: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 19: */
+	{0, 0, 0, 0, 0, 0},
 	/* corerev 20: 5120, 49152, 49152, 5376, 4352, 1280 */
 	{20, 192, 192, 21, 17, 5},
 	/* corerev 21: 2304, 14848, 5632, 3584, 3584, 1280 */
@@ -342,6 +362,18 @@ static const u16 xmtfifo_sz[][NFIFO] = {
 	{20, 192, 192, 21, 17, 5},
 	/* corerev 24: 2304, 14848, 5632, 3584, 3584, 1280 */
 	{9, 58, 22, 14, 14, 5},
+	/* corerev 25: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 26: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 27: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 28: 5120, 49152, 49152, 5376, 4352, 1280 */
+	{20, 192, 192, 21, 17, 5},
+	/* corerev 29: */
+	{0, 0, 0, 0, 0, 0},
+	/* corerev 30: */
+	{0, 0, 0, 0, 0, 0},
 };
 
 #ifdef DEBUG
@@ -4609,8 +4641,12 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
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


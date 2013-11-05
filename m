Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:50869 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755159Ab3KEUkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 15:40:01 -0500
Message-ID: <1383684000.4387.42.camel@joe-AO722> (sfid-20131105_214007_103736_EC729554)
Subject: [PATCH] wcn36xx: Fix logging macro with unnecessary semicolon
From: Joe Perches <joe@perches.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Nov 2013 12:40:00 -0800
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wcn36xx_err macro should not end in a semicolon as
there are 2 consecutive semicolons in the preprocessed
output.

Remove it.

Neaten the logging macros to use a more common style.
Convert to use pr_debug to enable dynamic debug.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 58b6383..d157bb7 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -53,22 +53,20 @@ enum wcn36xx_debug_mask {
 	WCN36XX_DBG_ANY		= 0xffffffff,
 };
 
-#define wcn36xx_err(fmt, arg...)				\
-	printk(KERN_ERR pr_fmt("ERROR " fmt), ##arg);
-
-#define wcn36xx_warn(fmt, arg...)				\
-	printk(KERN_WARNING pr_fmt("WARNING " fmt), ##arg)
-
-#define wcn36xx_info(fmt, arg...)		\
-	printk(KERN_INFO pr_fmt(fmt), ##arg)
-
-#define wcn36xx_dbg(mask, fmt, arg...) do {			\
-	if (wcn36xx_dbg_mask & mask)					\
-		printk(KERN_DEBUG pr_fmt(fmt), ##arg);	\
+#define wcn36xx_err(fmt, ...)					\
+	pr_err("ERROR " fmt, ##__VA_ARGS__)
+#define wcn36xx_warn(fmt, ...)					\
+	pr_warn("WARNING " fmt, ##__VA_ARGS__)
+#define wcn36xx_info(fmt, ...)					\
+	pr_info(fmt, ##__VA_ARGS__)
+#define wcn36xx_dbg(mask, fmt, ...)				\
+do {								\
+	if (wcn36xx_dbg_mask & mask)				\
+		pr_debug(fmt, ##__VA_ARGS__);			\
 } while (0)
-
-#define wcn36xx_dbg_dump(mask, prefix_str, buf, len) do {	\
-	if (wcn36xx_dbg_mask & mask)					\
+#define wcn36xx_dbg_dump(mask, prefix_str, buf, len)		\
+do {								\
+	if (wcn36xx_dbg_mask & mask)				\
 		print_hex_dump(KERN_DEBUG, pr_fmt(prefix_str),	\
 			       DUMP_PREFIX_OFFSET, 32, 1,	\
 			       buf, len, false);		\


